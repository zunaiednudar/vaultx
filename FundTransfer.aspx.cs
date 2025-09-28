using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using vaultx.cls;

namespace vaultx
{
    public partial class FundTransfer : Page
    {
        private long selectedAccountId = 0;
        private int currentUserId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            var userId = Session["UserId"] ?? Session["UID"];
            if (userId == null)
            {
                Response.Redirect("Login.aspx?returnUrl=" + Request.Url.AbsolutePath);
                return;
            }

            currentUserId = Convert.ToInt32(userId);

            if (!IsPostBack)
            {
                // Load user information and initialize page
                LoadAccountHolderName(currentUserId);
                ResetAllPanels();
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

        private void LoadAccountHolderName(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT FirstName, LastName FROM Users WHERE UID = @UID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", userId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string firstName = reader["FirstName"].ToString();
                        string lastName = reader["LastName"].ToString();
                        lblAccountHolderName.Text = $"{firstName} {lastName}";
                    }
                    else
                    {
                        lblAccountHolderName.Text = "Unknown User";
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                lblAccountHolderName.Text = "Error loading user information";
                System.Diagnostics.Debug.WriteLine($"LoadAccountHolderName error: {ex.Message}");
            }
        }

        protected void btnAccountType_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string accountType = btn.CommandArgument;

            CheckAccountByTypeAndProceed(currentUserId, accountType);
        }

        private void CheckAccountByTypeAndProceed(int userId, string accountType)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 AID, AccountType, Balance 
                                   FROM Accounts 
                                   WHERE UID = @UID AND AccountType = @AccountType 
                                   ORDER BY CreatedAt DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", userId);
                    cmd.Parameters.AddWithValue("@AccountType", accountType);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Account found - proceed to transfer form
                        selectedAccountId = Convert.ToInt64(reader["AID"]);
                        ViewState["SelectedAccountId"] = selectedAccountId;

                        string accountTypeText = reader["AccountType"].ToString();
                        string accountNumber = reader["AID"].ToString();
                        decimal balance = Convert.ToDecimal(reader["Balance"]);

                        // Set the from account details in transfer form
                        lblFromAccountType.Text = accountTypeText;
                        lblFromAccountNumber.Text = accountNumber;
                        lblFromAccountBalance.Text = balance.ToString("N2");

                        // Show transfer form and hide success panel
                        pnlTransferForm.Visible = true;
                        pnlSuccess.Visible = false;
                    }
                    else
                    {
                        // No account found - show popup
                        ViewState["SelectedAccountId"] = null;
                        string script = $"showNoAccountModal('{accountType}');";
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowNoAccountModal", script, true);
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowErrorModal($"Error checking account: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"CheckAccountByTypeAndProceed error: {ex.Message}");
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                // Basic form validation
                if (ViewState["SelectedAccountId"] == null)
                {
                    ShowErrorModal("Please select an account first.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtAccountNo.Text) ||
                    string.IsNullOrWhiteSpace(txtAmount.Text) ||
                    string.IsNullOrWhiteSpace(txtPassword.Text) ||
                    !chkTerms.Checked)
                {
                    ShowErrorModal("Please fill all required fields and accept terms.");
                    return;
                }

                selectedAccountId = (long)ViewState["SelectedAccountId"];

                // Validate amount
                if (!decimal.TryParse(txtAmount.Text, out decimal amount) || amount <= 0)
                {
                    ShowErrorModal("Please enter a valid amount greater than zero.");
                    return;
                }

                // Validate account number
                if (!long.TryParse(txtAccountNo.Text, out long toAccountId))
                {
                    ShowErrorModal("Please enter a valid account number.");
                    return;
                }

                // Cannot transfer to same account
                if (selectedAccountId == toAccountId)
                {
                    ShowErrorModal("Cannot transfer to the same account.");
                    return;
                }

                // CRITICAL VALIDATIONS

                // 1. Validate password
                if (!ValidateUserPassword(currentUserId, txtPassword.Text))
                {
                    ShowErrorModal("Password mismatch. Please enter your correct password.");
                    return;
                }

                // 2. Check if receiver account exists
                if (!AccountExists(toAccountId))
                {
                    ShowErrorModal("Receiver account not found. Please check the account number.");
                    return;
                }

                // 3. Check balance and minimum balance requirement
                decimal currentBalance = GetAccountBalance(selectedAccountId);
                decimal remainingBalance = currentBalance - amount;

                if (remainingBalance < 500)
                {
                    decimal maxTransferAmount = currentBalance - 500;
                    if (maxTransferAmount <= 0)
                    {
                        ShowErrorModal("Insufficient balance. You need to maintain a minimum balance of ৳500.");
                    }
                    else
                    {
                        ShowErrorModal($"Amount exceeds available balance. Maximum transfer amount: ৳{maxTransferAmount:N2} (Minimum balance of ৳500 must be maintained).");
                    }
                    return;
                }

                // ALL VALIDATIONS PASSED - Process transfer
                ProcessTransferWithRetry(selectedAccountId, toAccountId, amount, txtReference.Text?.Trim());
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"btnSend_Click error: {ex.Message}");
                ShowErrorModal("An unexpected error occurred. Please try again.");
            }
        }

        private void ProcessTransferWithRetry(long fromAccountId, long toAccountId, decimal amount, string reference)
        {
            const int maxRetries = 3;
            int retryCount = 0;
            TransferResult result = null;

            while (retryCount < maxRetries && (result == null || !result.Success))
            {
                retryCount++;
                result = ProcessFundTransfer(fromAccountId, toAccountId, amount, reference);

                if (result != null && !result.Success && retryCount < maxRetries)
                {
                    System.Threading.Thread.Sleep(500);
                }
            }

            if (result != null && result.Success)
            {
                // SUCCESS - Show success panel with the updated balance from database
                ShowSuccess(result.TransactionId, amount, toAccountId, reference, result.NewSenderBalance);
                ClearForm();

                // Refresh the balance display in the form for next transfer
                RefreshCompleteAccountInfo(fromAccountId);
            }
            else
            {
                // Transfer failed after all retries
                string errorMessage = result?.ErrorMessage ?? "Transfer could not be completed. Please try again later.";
                ShowErrorModal(errorMessage);
            }
        }

        // Enhanced ProcessFundTransfer with proper database transaction handling
        private TransferResult ProcessFundTransfer(long fromAccountId, long toAccountId, decimal amount, string reference)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            // Step 1: Generate 12-digit TID
                            string newTID = GenerateTransactionId(conn, transaction);

                            // Step 2: Deduct amount from sender (with verification)
                            string debitQuery = @"UPDATE Accounts 
                                                SET Balance = Balance - @Amount 
                                                WHERE AID = @AID AND Balance - @Amount >= 500";

                            SqlCommand debitCmd = new SqlCommand(debitQuery, conn, transaction);
                            debitCmd.Parameters.AddWithValue("@Amount", amount);
                            debitCmd.Parameters.AddWithValue("@AID", fromAccountId);

                            int debitResult = debitCmd.ExecuteNonQuery();
                            if (debitResult == 0)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Insufficient balance or account not found."
                                };
                            }

                            // Step 3: Add amount to receiver
                            string creditQuery = "UPDATE Accounts SET Balance = Balance + @Amount WHERE AID = @AID";
                            SqlCommand creditCmd = new SqlCommand(creditQuery, conn, transaction);
                            creditCmd.Parameters.AddWithValue("@Amount", amount);
                            creditCmd.Parameters.AddWithValue("@AID", toAccountId);

                            int creditResult = creditCmd.ExecuteNonQuery();
                            if (creditResult == 0)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Receiver account not found."
                                };
                            }

                            // Step 4: Insert transaction record
                            string insertQuery = @"INSERT INTO Transactions (TID, FromAID, ToAID, Amount, Reference, Date) 
                                                 VALUES (@TID, @FromAID, @ToAID, @Amount, @Reference, @Date)";

                            SqlCommand insertCmd = new SqlCommand(insertQuery, conn, transaction);
                            insertCmd.Parameters.AddWithValue("@TID", Convert.ToInt64(newTID));
                            insertCmd.Parameters.AddWithValue("@FromAID", fromAccountId);
                            insertCmd.Parameters.AddWithValue("@ToAID", toAccountId);
                            insertCmd.Parameters.AddWithValue("@Amount", amount);
                            insertCmd.Parameters.AddWithValue("@Reference", reference ?? "");
                            insertCmd.Parameters.AddWithValue("@Date", DateTime.Now);

                            int insertResult = insertCmd.ExecuteNonQuery();
                            if (insertResult == 0)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Failed to record transaction."
                                };
                            }

                            // Step 5: Get updated sender balance from database
                            string balanceQuery = "SELECT Balance FROM Accounts WHERE AID = @AID";
                            SqlCommand balanceCmd = new SqlCommand(balanceQuery, conn, transaction);
                            balanceCmd.Parameters.AddWithValue("@AID", fromAccountId);

                            var newBalanceObj = balanceCmd.ExecuteScalar();
                            if (newBalanceObj == null)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Failed to retrieve updated balance."
                                };
                            }

                            decimal newSenderBalance = Convert.ToDecimal(newBalanceObj);

                            // Step 6: All operations successful - commit transaction
                            transaction.Commit();

                            return new TransferResult
                            {
                                Success = true,
                                TransactionId = newTID,
                                NewSenderBalance = newSenderBalance
                            };
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine($"ProcessFundTransfer transaction error: {ex.Message}");
                            return new TransferResult
                            {
                                Success = false,
                                ErrorMessage = "Database transaction failed."
                            };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ProcessFundTransfer connection error: {ex.Message}");
                return new TransferResult
                {
                    Success = false,
                    ErrorMessage = "Database connection failed."
                };
            }
        }

        // Helper class for transfer results
        private class TransferResult
        {
            public bool Success { get; set; }
            public string TransactionId { get; set; }
            public decimal NewSenderBalance { get; set; }
            public string ErrorMessage { get; set; }
        }

        private void RefreshCompleteAccountInfo(long accountId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT AID, AccountType, Balance FROM Accounts WHERE AID = @AID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AID", accountId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string accountTypeText = reader["AccountType"].ToString();
                        string accountNumber = reader["AID"].ToString();
                        decimal balance = Convert.ToDecimal(reader["Balance"]);

                        // Update all account details with fresh data from database
                        lblFromAccountType.Text = accountTypeText;
                        lblFromAccountNumber.Text = accountNumber;
                        lblFromAccountBalance.Text = balance.ToString("N2");
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"RefreshCompleteAccountInfo error: {ex.Message}");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
            ResetAllPanels();
        }

        protected void btnNewTransfer_Click(object sender, EventArgs e)
        {
            ClearForm();

            // If we have a previously selected account, refresh its information and show the form again
            if (ViewState["SelectedAccountId"] != null)
            {
                selectedAccountId = (long)ViewState["SelectedAccountId"];

                // Refresh the complete account information with updated balance from database
                RefreshCompleteAccountInfo(selectedAccountId);

                // Keep the transfer form visible with updated information
                pnlTransferForm.Visible = true;
                pnlSuccess.Visible = false;
            }
            else
            {
                // If no account was previously selected, reset everything
                ResetAllPanels();
            }
        }

        private bool ValidateUserPassword(int userId, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT Password FROM Users WHERE UID = @UID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", userId);

                    conn.Open();
                    var result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        string storedHash = result.ToString();

                        // Check if password is already hashed
                        if (storedHash.Length == 88 && IsBase64String(storedHash))
                        {
                            return PasswordHelper.VerifyPassword(password, storedHash);
                        }
                        else
                        {
                            // Legacy plain text comparison
                            return storedHash == password;
                        }
                    }

                    return false;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ValidateUserPassword error: {ex.Message}");
                return false;
            }
        }

        private bool IsBase64String(string s)
        {
            try
            {
                Convert.FromBase64String(s);
                return true;
            }
            catch
            {
                return false;
            }
        }

        private bool AccountExists(long accountId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Accounts WHERE AID = @AID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AID", accountId);

                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"AccountExists error: {ex.Message}");
                return false;
            }
        }

        private decimal GetAccountBalance(long accountId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            try
            {
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
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"GetAccountBalance error: {ex.Message}");
                return 0;
            }
        }

        private string GenerateTransactionId(SqlConnection conn, SqlTransaction transaction)
        {
            try
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
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"GenerateTransactionId error: {ex.Message}");
                // If TID generation fails, create one based on timestamp
                return DateTime.Now.ToString("yyyyMMddHHmmss");
            }
        }

        private void ResetAllPanels()
        {
            pnlTransferForm.Visible = false;
            pnlSuccess.Visible = false;
            ViewState["SelectedAccountId"] = null;
        }

        private void ShowErrorModal(string message)
        {
            string escapedMessage = message.Replace("'", "\\'").Replace("\"", "\\\"")
                                         .Replace("\r\n", "\\n").Replace("\r", "\\n").Replace("\n", "\\n");
            string script = $"showTransferErrorModal('{escapedMessage}');";
            ClientScript.RegisterStartupScript(this.GetType(), "ShowErrorModal", script, true);
        }

        private void ShowSuccess(string transactionId, decimal amount, long toAccount, string reference, decimal newBalance)
        {
            pnlTransferForm.Visible = false;
            pnlSuccess.Visible = true;

            // Display all success information with updated balance from database
            lblSuccessTID.Text = transactionId;
            lblSuccessAmount.Text = amount.ToString("N2");
            lblSuccessAccount.Text = toAccount.ToString();
            lblSuccessReference.Text = string.IsNullOrEmpty(reference) ? "N/A" : reference;
            lblSuccessNewBalance.Text = newBalance.ToString("N2"); // This is fetched from DB after transaction commit
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