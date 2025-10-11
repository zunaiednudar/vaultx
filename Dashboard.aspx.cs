using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace vaultx
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAccounts();
                BindTransactions();
                int uid = Convert.ToInt32(Session["UID"]); // get session uid
                BindAccountTypes(uid);
            }
        }
        private void BindAccounts()
        {
            var accounts = new List<dynamic>();
            HelperZunaied.IAccountRepository accountRepository = HelperZunaied.RepositoryFactory.CreateAccountRepository();
            accounts = accountRepository.BindAccountsFunction(Convert.ToInt32(Session["UID"]));
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
            HelperZunaied.IAccountRepository accountRepository = HelperZunaied.RepositoryFactory.CreateAccountRepository();
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
        private void BindTransactions()
        {
            var transactions = new List<dynamic>();
            HelperZunaied.ITransactionRepository transactionRepository = HelperZunaied.RepositoryFactory.CreateTransactionRepository();
            transactions = transactionRepository.BindTransactionsFunction(Convert.ToInt32(Session["UID"]));
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
            int uid = Convert.ToInt32(Session["UID"]);
            HelperZunaied.IAccountRepository accountRepository = HelperZunaied.RepositoryFactory.CreateAccountRepository();
            DataTable userAccounts = accountRepository.GetUserAccounts(uid);
            if (userAccounts.AsEnumerable().Any(r => r.Field<string>("AccountType") == selectedType))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", "alert('You can only create one account of this type');", true);
                return;
            }

            // Get the last AccountNumber and increment
            int lastAid = accountRepository.GetLastAccountNumber();
            int newAid = lastAid + 1;
            // Create the account with nominee info
            accountRepository.CreateAccount(newAid, selectedType, uid, nomineeName, nomineeNID, nomineeImage);
            BindAccounts();
            BindAccountTypes(uid);
            // Close modal using JavaScript
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal", "closeModal();", true);
            // Avoid duplicate SaveAs on refresh
            Response.Redirect(Request.RawUrl, false);
            Context.ApplicationInstance.CompleteRequest();
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