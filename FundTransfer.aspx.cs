using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace vaultx
{
    public partial class FundTransfer : Page
    {
        private long selectedAccountId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                var userId = Session["UserId"];
                if (userId == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadUserAccounts((int)userId);
            }
            else
            {
                // Restore selected account from ViewState
                if (ViewState["SelectedAccountId"] != null)
                {
                    selectedAccountId = (long)ViewState["SelectedAccountId"];
                }
            }
        }

        private void LoadUserAccounts(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT AID, AccountType, Balance 
                                   FROM Accounts 
                                   WHERE UID = @UID 
                                   ORDER BY CreatedAt";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", userId);

                    conn.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    rptUserAccounts.DataSource = dt;
                    rptUserAccounts.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading accounts: {ex.Message}");
            }
        }

        protected void rptUserAccounts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectAccount")
            {
                selectedAccountId = Convert.ToInt64(e.CommandArgument);
                ViewState["SelectedAccountId"] = selectedAccountId;

                LoadSelectedAccountInfo();
                pnlSelectedAccount.Visible = true;
                pnlTransferForm.Visible = true;
            }
        }

        private void LoadSelectedAccountInfo()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT AID, AccountType, Balance 
                                   FROM Accounts 
                                   WHERE AID = @AID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AID", selectedAccountId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        lblSelectedAccountType.Text = reader["AccountType"].ToString();
                        lblSelectedAccountNumber.Text = reader["AID"].ToString();
                        lblSelectedBalance.Text = Convert.ToDecimal(reader["Balance"]).ToString("N2");
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading selected account: {ex.Message}");
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                var userId = Session["UserId"];
                if (userId == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Validate selected account
                if (ViewState["SelectedAccountId"] == null)
                {
                    ShowError("Please select an account first.");
                    return;
                }

                selectedAccountId = (long)ViewState["SelectedAccountId"];

                // Validate inputs
                if (string.IsNullOrWhiteSpace(txtAccountNo.Text) ||
                    string.IsNullOrWhiteSpace(txtAmount.Text) ||
                    string.IsNullOrWhiteSpace(txtPassword.Text) ||
                    !chkTerms.Checked)
                {
                    ShowError("Please fill all required fields and accept terms.");
                    return;
                }

                if (!decimal.TryParse(txtAmount.Text, out decimal amount) || amount <= 0)
                {
                    ShowError("Please enter a valid amount.");
                    return;
                }

                if (!long.TryParse(txtAccountNo.Text, out long toAccountId))
                {
                    ShowError("Please enter a valid account number.");
                    return;
                }

                // Validate password
                if (!ValidateUserPassword((int)userId, txtPassword.Text))
                {
                    ShowError("Invalid password.");
                    return;
                }

                // Check if receiver account exists
                if (!AccountExists(toAccountId))
                {
                    ShowError("Receiver account does not exist.");
                    return;
                }

                // Check balance and minimum balance requirement
                decimal currentBalance = GetAccountBalance(selectedAccountId);
                decimal remainingBalance = currentBalance - amount;

                if (remainingBalance < 500)
                {
                    ShowError("Insufficient balance. Minimum balance of ৳500 must be maintained.");
                    return;
                }

                // Cannot transfer to same account
                if (selectedAccountId == toAccountId)
                {
                    ShowError("Cannot transfer to the same account.");
                    return;
                }

                // Process transfer
                string transactionId = ProcessFundTransfer(selectedAccountId, toAccountId, amount, txtReference.Text?.Trim());

                if (!string.IsNullOrEmpty(transactionId))
                {
                    ShowSuccess(transactionId, amount, toAccountId, txtReference.Text?.Trim());
                    ClearForm();

                    // Refresh account info
                    LoadUserAccounts((int)userId);
                    LoadSelectedAccountInfo();
                }
                else
                {
                    ShowError("Transfer failed. Please try again.");
                }
            }
            catch (Exception ex)
            {
                ShowError($"An error occurred: {ex.Message}");
            }
        }

        private bool ValidateUserPassword(int userId, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE UID = @UID AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UID", userId);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        private bool AccountExists(long accountId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Accounts WHERE AID = @AID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AID", accountId);

                conn.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        private decimal GetAccountBalance(long accountId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Balance FROM Accounts WHERE AID = @AID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AID", accountId);

                conn.Open();
                var result = cmd.ExecuteScalar();
                return result != null ? Convert.ToDecimal(result) : 0;
            }
        }

        private string ProcessFundTransfer(long fromAccountId, long toAccountId, decimal amount, string reference)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        // Generate 12-digit TID
                        string newTID = GenerateTransactionId(conn, transaction);

                        // Insert transaction record
                        string insertQuery = @"INSERT INTO Transactions (TID, FromAID, ToAID, Amount, Reference, Date) 
                                             VALUES (@TID, @FromAID, @ToAID, @Amount, @Reference, @Date)";

                        SqlCommand insertCmd = new SqlCommand(insertQuery, conn, transaction);
                        insertCmd.Parameters.AddWithValue("@TID", Convert.ToInt64(newTID));
                        insertCmd.Parameters.AddWithValue("@FromAID", fromAccountId);
                        insertCmd.Parameters.AddWithValue("@ToAID", toAccountId);
                        insertCmd.Parameters.AddWithValue("@Amount", amount);
                        insertCmd.Parameters.AddWithValue("@Reference", reference ?? "");
                        insertCmd.Parameters.AddWithValue("@Date", DateTime.Now);
                        insertCmd.ExecuteNonQuery();

                        // Update sender's balance
                        string debitQuery = "UPDATE Accounts SET Balance = Balance - @Amount WHERE AID = @AID";
                        SqlCommand debitCmd = new SqlCommand(debitQuery, conn, transaction);
                        debitCmd.Parameters.AddWithValue("@Amount", amount);
                        debitCmd.Parameters.AddWithValue("@AID", fromAccountId);
                        debitCmd.ExecuteNonQuery();

                        // Update receiver's balance
                        string creditQuery = "UPDATE Accounts SET Balance = Balance + @Amount WHERE AID = @AID";
                        SqlCommand creditCmd = new SqlCommand(creditQuery, conn, transaction);
                        creditCmd.Parameters.AddWithValue("@Amount", amount);
                        creditCmd.Parameters.AddWithValue("@AID", toAccountId);
                        creditCmd.ExecuteNonQuery();

                        transaction.Commit();
                        return newTID;
                    }
                    catch (Exception)
                    {
                        transaction.Rollback();
                        return null;
                    }
                }
            }
        }

        private string GenerateTransactionId(SqlConnection conn, SqlTransaction transaction)
        {
            // Get the latest TID
            string query = "SELECT ISNULL(MAX(TID), 100000000000) FROM Transactions";
            SqlCommand cmd = new SqlCommand(query, conn, transaction);
            var lastTID = cmd.ExecuteScalar();

            long nextTID = Convert.ToInt64(lastTID) + 1;

            // Ensure it's 12 digits
            if (nextTID < 100000000000) // Less than 12 digits
            {
                nextTID = 100000000001; // Start from first 12-digit number
            }

            return nextTID.ToString();
        }

        protected void btnNewTransfer_Click(object sender, EventArgs e)
        {
            ClearForm();
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
            pnlSelectedAccount.Visible = false;
            pnlTransferForm.Visible = false;
            ViewState["SelectedAccountId"] = null;

            var userId = Session["UserId"];
            if (userId != null)
            {
                LoadUserAccounts((int)userId);
            }
        }

        protected void btnTryAgain_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;

            if (ViewState["SelectedAccountId"] != null)
            {
                pnlSelectedAccount.Visible = true;
                pnlTransferForm.Visible = true;
            }
        }

        private void ShowError(string message)
        {
            pnlTransferForm.Visible = false;
            pnlSuccess.Visible = false;
            pnlSelectedAccount.Visible = false;
            pnlError.Visible = true;
            lblErrorMessage.Text = message;
        }

        private void ShowSuccess(string transactionId, decimal amount, long toAccount, string reference)
        {
            pnlTransferForm.Visible = false;
            pnlError.Visible = false;
            pnlSelectedAccount.Visible = false;
            pnlSuccess.Visible = true;

            lblSuccessTID.Text = transactionId;
            lblSuccessAmount.Text = amount.ToString("N2");
            lblSuccessAccount.Text = toAccount.ToString();
            lblSuccessReference.Text = string.IsNullOrEmpty(reference) ? "N/A" : reference;
        }

        private void ClearForm()
        {
            txtAccountNo.Text = "";
            txtAmount.Text = "";
            txtReference.Text = "";
            txtPassword.Text = "";
            chkTerms.Checked = false;
        }
    }
}
