using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using vaultx.support_zunaied;

namespace vaultx
{
    public partial class Dashboard : System.Web.UI.Page
    {
        // private string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAccounts();
                BindTransactions();
                // int uid = 1; // later replace with Session["UID"]
                int uid = Convert.ToInt32(Session["UID"]);
                BindAccountTypes(uid);
            }
        }

        private void BindAccounts()
        {
            var accounts = new List<dynamic>();

            // IAccountRepository accountRepository = RepositoryFactory.CreateAccountRepository();
            IAccountRepository accountRepository = new AccountRepository();
            accounts = accountRepository.BindAccountsFunction(Convert.ToInt32(Session["UID"]));

            //using (SqlConnection connection = new SqlConnection(connectionString))
            //{
            //    string query = @"
            //                    SELECT AID, AccountType, Balance, CreatedAt
            //                    FROM Accounts
            //                    WHERE UID = @UID
            //                    ORDER BY CreatedAt ASC
            //                    ";

            //    using (SqlCommand command = new SqlCommand(query, connection))
            //    {
            //        command.Parameters.AddWithValue("@UID", Session["UID"]);
            //        // command.Parameters.AddWithValue("@UID", 1);
            //        connection.Open();

            //        using (SqlDataReader reader = command.ExecuteReader())
            //        {
            //            while (reader.Read())
            //            {
            //                accounts.Add(new
            //                {
            //                    AccountNumber = reader["AID"].ToString(),
            //                    Balance = Convert.ToDecimal(reader["Balance"]),
            //                    AccountType = reader["AccountType"].ToString()
            //                });
            //            }
            //        }
            //    }
            //}

            rptAccounts.DataSource = accounts;
            rptAccounts.DataBind();

            // Show + if less than 3 accounts
            phAddAccount.Visible = (accounts.Count < 3);
        }

        private void BindAccountTypes(int uid)
        {
            // All possible account types
            List<string> allTypes = new List<string> { "Current", "Savings", "Student" };

            // Fetch user’s existing accounts
            // DataTable userAccounts = GetUserAccounts(uid);
            // IAccountRepository accountRepository = RepositoryFactory.CreateAccountRepository();
            IAccountRepository accountRepository = new AccountRepository();
            DataTable userAccounts = accountRepository.GetUserAccounts(uid);
            List<string> userTypes = userAccounts.AsEnumerable()
                                                 .Select(r => r.Field<string>("AccountType"))
                                                 .ToList();

            // Filter out types already present
            var availableTypes = allTypes.Except(userTypes).ToList();

            // Bind to dropdown
            ddlAccountType.Items.Clear();
            ddlAccountType.Items.Add(new ListItem("Select Type", "")); // default option

            foreach (var type in availableTypes)
            {
                ddlAccountType.Items.Add(new ListItem(type, type));
            }
        }


        //private DataTable GetUserAccounts(int uid)
        //{
        //    using (SqlConnection connection = new SqlConnection(connectionString))
        //    {
        //        string query = "SELECT AID, AccountType, Balance, CreatedAt FROM Accounts WHERE UID = @UID";

        //        using (SqlCommand command = new SqlCommand(query, connection))
        //        {
        //            command.Parameters.AddWithValue("@UID", uid);
        //            SqlDataAdapter dataAdapter = new SqlDataAdapter(command);
        //            DataTable dataTable = new DataTable();
        //            dataAdapter.Fill(dataTable);
        //            return dataTable;
        //        }
        //    }
        //}

        private void BindTransactions()
        {
            var transactions = new List<dynamic>();

            // ITransactionRepository transactionRepository = RepositoryFactory.CreateTransactionRepository();
            ITransactionRepository transactionRepository = new TransactionRepository();
            transactions = transactionRepository.BindTransactionsFunction(Convert.ToInt32(Session["UID"]));

            //using (SqlConnection connection = new SqlConnection(connectionString))
            //{
            //    string query = @"
            //                    SELECT TOP 10 T.TID, T.FromAID, T.ToAID, T.Amount, T.Reference, T.Date, A.AID, A.AccountType
            //                    FROM Transactions T INNER JOIN Accounts A ON T.FromAID = A.AID OR T.ToAID = A.AID
            //                    WHERE A.UID = @UID
            //                    ORDER BY T.Date DESC
            //                    ";

            //    using (SqlCommand command = new SqlCommand(query, connection))
            //    {
            //        command.Parameters.AddWithValue("@UID", Session["UID"]);
            //        // command.Parameters.AddWithValue("@UID", 1);
            //        connection.Open();

            //        using (SqlDataReader reader = command.ExecuteReader())
            //        {
            //            while (reader.Read())
            //            {
            //                transactions.Add(new
            //                {
            //                    FromAccountNumber = reader["FromAID"].ToString(),
            //                    ToAccountNumber = reader["ToAID"].ToString(),
            //                    TransactionType = (reader["FromAID"].ToString() == reader["AID"].ToString()) ? "Debit" : "Credit",
            //                    Amount = Convert.ToDecimal(reader["Amount"]),
            //                    Reference = reader["Reference"].ToString(),
            //                    Date = Convert.ToDateTime(reader["Date"])
            //                });
            //            }
            //        }
            //    }
            //}

            rptTransactions.DataSource = transactions;
            rptTransactions.DataBind();
        }

        protected void btnCreateAccount_Click(object sender, EventArgs e)
        {
            string selectedType = ddlAccountType.SelectedValue;
            string nomineeName = txtNomineeName.Text.Trim();
            string nomineeNID = txtNomineeNID.Text.Trim();
            string nomineeImage = "";

            if (string.IsNullOrEmpty(selectedType))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('Please select an account type');", true);
                return;
            }

            if (string.IsNullOrEmpty(nomineeName) || string.IsNullOrEmpty(nomineeNID))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('Please enter nominee details');", true);
                return;
            }

            // Handle Nominee Image upload
            if (fuNomineeImage.HasFile && string.IsNullOrEmpty(nomineeImage))
            {
                string fileName = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fuNomineeImage.FileName);
                string savePath = Server.MapPath("~/images/nominees/") + fileName;

                if (!System.IO.File.Exists(savePath))  // prevent overwriting
                {
                    fuNomineeImage.SaveAs(savePath);
                }

                nomineeImage = "~/images/nominees/" + fileName;
            }


            // Check if the account type already exists
            // int uid = 1; // Replace with Session UID if needed
            int uid = Convert.ToInt32(Session["UID"]);
            // DataTable userAccounts = GetUserAccounts(uid);
            // IAccountRepository accountRepository = RepositoryFactory.CreateAccountRepository();
            IAccountRepository accountRepository = new AccountRepository();
            DataTable userAccounts = accountRepository.GetUserAccounts(uid);
            if (userAccounts.AsEnumerable().Any(r => r.Field<string>("AccountType") == selectedType))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('You can only create one account of this type');", true);
                return;
            }

            // Get the last AccountNumber and increment
            // int lastAid = GetLastAccountNumber();
            int lastAid = accountRepository.GetLastAccountNumber();
            int newAid = lastAid + 1;

            // Create the account with nominee info
            // CreateAccount(newAid, selectedType, uid, nomineeName, nomineeNID, nomineeImage);
            accountRepository.CreateAccount(newAid, selectedType, uid, nomineeName, nomineeNID, nomineeImage);

            BindAccounts();
            BindAccountTypes(uid);


            // Close modal using JavaScript
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal", "closeModal();", true);

            // Avoid duplicate SaveAs on refresh
            Response.Redirect(Request.RawUrl, false);
            Context.ApplicationInstance.CompleteRequest();
        }


        //private int GetLastAccountNumber()
        //{
        //    using (SqlConnection connection = new SqlConnection(connectionString))
        //    {
        //        string query = "SELECT ISNULL(MAX(CAST(AID AS INT)), 100000) FROM Accounts";

        //        using (SqlCommand command = new SqlCommand(query, connection))
        //        {
        //            connection.Open();
        //            int maxAid = (int)command.ExecuteScalar();
        //            return maxAid;
        //        }
        //    }
        //}

        // Updated CreateAccount to include nominee info
        //private void CreateAccount(int aid, string type, int uid, string nomineeName, string nomineeNID, string nomineeImage)
        //{
        //    using (SqlConnection connection = new SqlConnection(connectionString))
        //    {
        //        string query = @"
        //    INSERT INTO Accounts (AID, AccountType, Balance, UID, NomineeName, NomineeNID, NomineeImage)
        //    VALUES (@AID, @AccountType, @Balance, @UID, @NomineeName, @NomineeNID, @NomineeImage)
        //";

        //        using (SqlCommand command = new SqlCommand(query, connection))
        //        {
        //            command.Parameters.AddWithValue("@AID", aid.ToString());
        //            command.Parameters.AddWithValue("@AccountType", type);
        //            command.Parameters.AddWithValue("@Balance", 0.00m);
        //            command.Parameters.AddWithValue("@UID", uid);
        //            command.Parameters.AddWithValue("@NomineeName", nomineeName);
        //            command.Parameters.AddWithValue("@NomineeNID", nomineeNID);
        //            command.Parameters.AddWithValue("@NomineeImage", nomineeImage);
        //            connection.Open();
        //            command.ExecuteNonQuery();
        //        }
        //    }
        //}

        // Account class
        [Serializable]
        public class Account
        {
            public string AccountNumber { get; set; }
            public string AccountType { get; set; }
            public decimal Balance { get; set; }
        }
    }
}