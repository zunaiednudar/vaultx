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

namespace vaultx
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAccounts();
                BindTransactions();
            }
        }

        private void BindAccounts()
        {
            var accounts = new List<dynamic>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                                SELECT AID, AccountType, Balance, CreatedAt
                                FROM Accounts
                                WHERE UID = @UID
                                ORDER BY CreatedAt ASC
                                ";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // command.Parameters.AddWithValue("@UID", Session["UID"]);
                    command.Parameters.AddWithValue("@UID", 1);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            accounts.Add(new
                            {
                                AccountNumber = reader["AID"].ToString(),
                                Balance = Convert.ToDecimal(reader["Balance"]),
                                AccountType = reader["AccountType"].ToString()
                            });
                        }
                    }
                }
            }

            rptAccounts.DataSource = accounts;
            rptAccounts.DataBind();

            // Show + if less than 3 accounts
            phAddAccount.Visible = (accounts.Count < 3);
        }

        private DataTable GetUserAccounts(int uid)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT AID, AccountType, Balance, CreatedAt FROM Accounts WHERE UID = @UID";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UID", uid);
                    SqlDataAdapter dataAdapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    dataAdapter.Fill(dataTable);
                    return dataTable;
                }
            }
        }

        private void BindTransactions()
        {
            var transactions = new List<dynamic>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                                SELECT TOP 10 T.TID, T.FromAID, T.ToAID, T.Amount, T.Reference, T.Date, A.AID, A.AccountType
                                FROM Transactions T INNER JOIN Accounts A ON T.FromAID = A.AID OR T.ToAID = A.AID
                                WHERE A.UID = @UID
                                ORDER BY T.Date DESC
                                ";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // command.Parameters.AddWithValue("@UID", Session["UID"]);
                    command.Parameters.AddWithValue("@UID", 1);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            transactions.Add(new
                            {
                                FromAccountNumber = (reader["FromAID"].ToString() == reader["AID"].ToString()) ? (reader["AccountType"].ToString() + "<br>Account") : reader["FromAID"].ToString(),
                                ToAccountNumber = (reader["ToAID"].ToString() == reader["AID"].ToString()) ? (reader["AccountType"].ToString() + "<br>Account") : reader["ToAID"].ToString(),
                                TransactionType = (reader["FromAID"].ToString() == reader["AID"].ToString()) ? "Debit" : "Credit",
                                Amount = Convert.ToDecimal(reader["Amount"]),
                                Reference = reader["Reference"].ToString(),
                                Date = Convert.ToDateTime(reader["Date"])
                            });
                        }
                    }
                }
            }

            rptTransactions.DataSource = transactions;
            rptTransactions.DataBind();
        }

        protected void btnCreateAccount_Click(object sender, EventArgs e)
        {
            string selectedType = ddlAccountType.SelectedValue;

            if (string.IsNullOrEmpty(selectedType))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('Please select an account type');", true);
                return;
            }

            // Check if the account type already exists
            int uid = 1; // Replace with Session UID if needed
            DataTable userAccounts = GetUserAccounts(uid);
            if (userAccounts.AsEnumerable().Any(r => r.Field<string>("AType") == selectedType))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('You can only create one account of this type');", true);
                return;
            }

            // Get the last AccountNumber and increment
            int lastAid = GetLastAccountNumber();
            int newAid = lastAid + 1;

            CreateAccount(newAid, selectedType, uid);

            BindAccounts();

            // Close modal using JavaScript
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal", "closeModal();", true);
        }


        private int GetLastAccountNumber()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT ISNULL(MAX(CAST(AID AS INT)), 100000) FROM Accounts";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    int maxAid = (int)command.ExecuteScalar();
                    return maxAid;
                }
            }
        }

        private void CreateAccount(int aid, string type, int uid)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                                INSERT INTO Accounts (AID, AccountType, Balance, UID)
                                VALUES (@AID, @AccountType, @Balance, @UID)
                                ";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@AID", aid.ToString());
                    command.Parameters.AddWithValue("@AccountType", type);
                    command.Parameters.AddWithValue("@Balance", 0.00m);
                    command.Parameters.AddWithValue("@UID", uid);
                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

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