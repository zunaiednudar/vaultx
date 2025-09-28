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
                // Add debug to ensure CSS classes are clean
                System.Diagnostics.Debug.WriteLine("Page_Load - Initial state set");
            }
            else
            {
                // Restore selected account from ViewState
                if (ViewState["SelectedAccountId"] != null)
                {
                    selectedAccountId = (long)ViewState["SelectedAccountId"];
                }

                // IMPORTANT: Always restore button selection state on postback
                RestoreButtonSelection();
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

            string currentSelectedType = ViewState["SelectedAccountType"] as string;

            System.Diagnostics.Debug.WriteLine($"Button clicked: {accountType}, Current: {currentSelectedType}");

            // FIXED TOGGLE LOGIC: Check if clicking the same button (toggle off)
            if (currentSelectedType == accountType)
            {
                System.Diagnostics.Debug.WriteLine("Toggling OFF - Same button clicked");

                // Toggle off - clear selection and hide form but preserve form data
                ViewState["SelectedAccountType"] = null;
                ViewState["SelectedAccountId"] = null;

                // Reset all button visual states
                ResetAllButtonStates();

                // Hide form panels but keep form data intact
                pnlTransferForm.Visible = false;
                pnlSuccess.Visible = false;

                // Clear only account details, not form fields
                ClearAccountDetails();

                // Add visual feedback for toggle off
                ShowToggleOffFeedback();
                return;
            }

            System.Diagnostics.Debug.WriteLine("Switching account type or first selection");

            // Different button clicked or first selection - switch account type
            ViewState["SelectedAccountType"] = accountType;

            // Update button visual states
            UpdateButtonSelection(accountType);

            // Check account and update form details (preserve form data)
            CheckAccountAndUpdateForm(currentUserId, accountType);
        }

        private void UpdateButtonSelection(string selectedAccountType)
        {
            System.Diagnostics.Debug.WriteLine($"UpdateButtonSelection: {selectedAccountType}");

            // Reset all buttons to default state first
            ResetAllButtonStates();

            // Add selected class to the clicked button
            switch (selectedAccountType)
            {
                case "Savings":
                    btnSavings.CssClass = "account-type-btn selected";
                    System.Diagnostics.Debug.WriteLine("Savings button selected");
                    break;
                case "Current":
                    btnCurrent.CssClass = "account-type-btn selected";
                    System.Diagnostics.Debug.WriteLine("Current button selected");
                    break;
                case "Fixed Deposit":
                    btnFixedDeposit.CssClass = "account-type-btn selected";
                    System.Diagnostics.Debug.WriteLine("Fixed Deposit button selected");
                    break;
            }
        }

        private void ResetAllButtonStates()
        {
            btnSavings.CssClass = "account-type-btn";
            btnCurrent.CssClass = "account-type-btn";
            btnFixedDeposit.CssClass = "account-type-btn";
            System.Diagnostics.Debug.WriteLine("All button states reset");
        }

        private void RestoreButtonSelection()
        {
            string selectedAccountType = ViewState["SelectedAccountType"] as string;
            System.Diagnostics.Debug.WriteLine($"RestoreButtonSelection: {selectedAccountType}");

            if (!string.IsNullOrEmpty(selectedAccountType))
            {
                UpdateButtonSelection(selectedAccountType);
            }
            else
            {
                ResetAllButtonStates();
            }
        }

        private void ClearAccountDetails()
        {
            lblFromAccountType.Text = "";
            lblFromAccountNumber.Text = "";
            lblFromAccountBalance.Text = "";
        }

        private void ShowToggleOffFeedback()
        {
            string script = @"
                const accountTypes = document.querySelectorAll('.account-type-btn');
                accountTypes.forEach(btn => {
                    btn.style.transition = 'all 0.3s ease';
                    btn.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        btn.style.transform = '';
                    }, 200);
                });
                
                const accountSelection = document.querySelector('.account-selection-section');
                if (accountSelection) {
                    accountSelection.style.transition = 'all 0.3s ease';
                    accountSelection.style.backgroundColor = '#f0f8ff';
                    setTimeout(() => {
                        accountSelection.style.backgroundColor = '';
                    }, 800);
                }";
            ClientScript.RegisterStartupScript(this.GetType(), "ToggleOffFeedback", script, true);
        }

        private void CheckAccountAndUpdateForm(int userId, string accountType)
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
                        // Account found - update form with new account details
                        selectedAccountId = Convert.ToInt64(reader["AID"]);
                        ViewState["SelectedAccountId"] = selectedAccountId;

                        string accountTypeText = reader["AccountType"].ToString();
                        string accountNumber = reader["AID"].ToString();
                        decimal balance = Convert.ToDecimal(reader["Balance"]);

                        // Update ONLY the account details (preserve form data)
                        lblFromAccountType.Text = accountTypeText;
                        lblFromAccountNumber.Text = accountNumber;
                        lblFromAccountBalance.Text = balance.ToString("N2");

                        // Show transfer form
                        pnlTransferForm.Visible = true;
                        pnlSuccess.Visible = false;

                        // Visual feedback for account switch
                        ShowAccountSwitchFeedback();
                    }
                    else
                    {
                        // No account found - reset selection and show modal
                        ViewState["SelectedAccountId"] = null;
                        ViewState["SelectedAccountType"] = null;
                        ResetAllButtonStates();

                        string script = $"showNoAccountModal('{accountType}');";
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowNoAccountModal", script, true);

                        // Clear account details and hide form
                        ClearAccountDetails();
                        pnlTransferForm.Visible = false;
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowErrorModal($"Error checking account: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"CheckAccountAndUpdateForm error: {ex.Message}");
            }
        }

        private void ShowAccountSwitchFeedback()
        {
            string script = @"
                const accountSummary = document.querySelector('.selected-account-summary');
                if (accountSummary) {
                    accountSummary.style.transition = 'all 0.3s ease';
                    accountSummary.style.backgroundColor = '#e8f5e8';
                    accountSummary.style.borderLeft = '4px solid #4ECDC4';
                    setTimeout(() => {
                        accountSummary.style.backgroundColor = '#f8f9fa';
                        accountSummary.style.borderLeft = 'none';
                    }, 1200);
                }";
            ClientScript.RegisterStartupScript(this.GetType(), "AccountSwitchFeedback", script, true);
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
                            // Step 1: Generate TID (using INT instead of BIGINT for compatibility)
                            int newTID = GenerateTransactionIdInt(conn, transaction);

                            // Step 2: Verify sender account and balance before update
                            string verifyQuery = "SELECT Balance FROM Accounts WHERE AID = @AID";
                            SqlCommand verifyCmd = new SqlCommand(verifyQuery, conn, transaction);
                            verifyCmd.Parameters.Add("@AID", SqlDbType.BigInt).Value = fromAccountId;

                            var currentBalanceObj = verifyCmd.ExecuteScalar();
                            if (currentBalanceObj == null)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Sender account not found."
                                };
                            }

                            decimal currentBalance = Convert.ToDecimal(currentBalanceObj);
                            if (currentBalance - amount < 500)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Insufficient balance. Minimum balance of ৳500 must be maintained."
                                };
                            }

                            // Step 3: Verify receiver account exists
                            string receiverQuery = "SELECT COUNT(*) FROM Accounts WHERE AID = @AID";
                            SqlCommand receiverCmd = new SqlCommand(receiverQuery, conn, transaction);
                            receiverCmd.Parameters.Add("@AID", SqlDbType.BigInt).Value = toAccountId;

                            int receiverCount = (int)receiverCmd.ExecuteScalar();
                            if (receiverCount == 0)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Receiver account not found."
                                };
                            }

                            // Step 4: Deduct amount from sender
                            string debitQuery = "UPDATE Accounts SET Balance = Balance - @Amount WHERE AID = @AID";
                            SqlCommand debitCmd = new SqlCommand(debitQuery, conn, transaction);
                            debitCmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = amount;
                            debitCmd.Parameters.Add("@AID", SqlDbType.BigInt).Value = fromAccountId;

                            int debitResult = debitCmd.ExecuteNonQuery();
                            if (debitResult == 0)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Failed to debit sender account."
                                };
                            }

                            // Step 5: Add amount to receiver
                            string creditQuery = "UPDATE Accounts SET Balance = Balance + @Amount WHERE AID = @AID";
                            SqlCommand creditCmd = new SqlCommand(creditQuery, conn, transaction);
                            creditCmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = amount;
                            creditCmd.Parameters.Add("@AID", SqlDbType.BigInt).Value = toAccountId;

                            int creditResult = creditCmd.ExecuteNonQuery();
                            if (creditResult == 0)
                            {
                                transaction.Rollback();
                                return new TransferResult
                                {
                                    Success = false,
                                    ErrorMessage = "Failed to credit receiver account."
                                };
                            }

                            // Step 6: Insert transaction record with proper data types
                            string insertQuery = @"INSERT INTO Transactions (TID, FromAID, ToAID, Amount, Reference, Date) 
                                                 VALUES (@TID, @FromAID, @ToAID, @Amount, @Reference, @Date)";

                            SqlCommand insertCmd = new SqlCommand(insertQuery, conn, transaction);
                            insertCmd.Parameters.Add("@TID", SqlDbType.Int).Value = newTID;
                            insertCmd.Parameters.Add("@FromAID", SqlDbType.Int).Value = (int)fromAccountId;
                            insertCmd.Parameters.Add("@ToAID", SqlDbType.Int).Value = (int)toAccountId;
                            insertCmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = amount;
                            insertCmd.Parameters.Add("@Reference", SqlDbType.VarChar, 255).Value = reference ?? "";
                            insertCmd.Parameters.Add("@Date", SqlDbType.DateTime).Value = DateTime.Now;

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

                            // Step 7: Get updated sender balance from database
                            string balanceQuery = "SELECT Balance FROM Accounts WHERE AID = @AID";
                            SqlCommand balanceCmd = new SqlCommand(balanceQuery, conn, transaction);
                            balanceCmd.Parameters.Add("@AID", SqlDbType.BigInt).Value = fromAccountId;

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

                            // Step 8: All operations successful - commit transaction
                            transaction.Commit();

                            return new TransferResult
                            {
                                Success = true,
                                TransactionId = newTID.ToString(),
                                NewSenderBalance = newSenderBalance
                            };
                        }
                        catch (SqlException sqlEx)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine($"SQL Error in ProcessFundTransfer: {sqlEx.Message}");
                            return new TransferResult
                            {
                                Success = false,
                                ErrorMessage = $"Database error: {sqlEx.Message}"
                            };
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine($"ProcessFundTransfer transaction error: {ex.Message}");
                            return new TransferResult
                            {
                                Success = false,
                                ErrorMessage = $"Transaction failed: {ex.Message}"
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

        private int GenerateTransactionIdInt(SqlConnection conn, SqlTransaction transaction)
        {
            try
            {
                string query = "SELECT ISNULL(MAX(TID), 1000000) FROM Transactions";
                SqlCommand cmd = new SqlCommand(query, conn, transaction);
                var lastTID = cmd.ExecuteScalar();

                int nextTID = Convert.ToInt32(lastTID) + 1;

                if (nextTID < 1000000)
                {
                    nextTID = 1000001;
                }

                return nextTID;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"GenerateTransactionIdInt error: {ex.Message}");
                string timeStamp = DateTime.Now.ToString("yyyyMMddHHmmss");
                if (timeStamp.Length > 10)
                {
                    timeStamp = timeStamp.Substring(timeStamp.Length - 10);
                }
                return int.Parse(timeStamp);
            }
        }

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

        // FIXED: Enhanced Cancel button functionality
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Cancel button clicked");

            // Clear form fields completely
            ClearForm();

            // Reset ALL state - panels, buttons, ViewState
            ResetAllPanels();

            // Show visual feedback for cancel action
            ShowCancelFeedback();
        }

        private void ShowCancelFeedback()
        {
            string script = @"
                const formSection = document.querySelector('.transfer-form-section');
                const accountSection = document.querySelector('.account-selection-section');
                
                if (formSection) {
                    formSection.style.transition = 'all 0.4s ease';
                    formSection.style.transform = 'scale(0.98)';
                    formSection.style.opacity = '0.7';
                    setTimeout(() => {
                        formSection.style.transform = '';
                        formSection.style.opacity = '';
                    }, 400);
                }
                
                if (accountSection) {
                    accountSection.style.transition = 'all 0.3s ease';
                    accountSection.style.backgroundColor = '#fff3cd';
                    setTimeout(() => {
                        accountSection.style.backgroundColor = '';
                    }, 1000);
                }";
            ClientScript.RegisterStartupScript(this.GetType(), "CancelFeedback", script, true);
        }

        protected void btnNewTransfer_Click(object sender, EventArgs e)
        {
            ClearForm();

            // If we have a previously selected account, refresh its information and show the form again
            if (ViewState["SelectedAccountId"] != null)
            {
                selectedAccountId = (long)ViewState["SelectedAccountId"];
                RefreshCompleteAccountInfo(selectedAccountId);
                pnlTransferForm.Visible = true;
                pnlSuccess.Visible = false;
            }
            else
            {
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

                        if (storedHash.Length == 88 && IsBase64String(storedHash))
                        {
                            return PasswordHelper.VerifyPassword(password, storedHash);
                        }
                        else
                        {
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

        private void ResetAllPanels()
        {
            System.Diagnostics.Debug.WriteLine("ResetAllPanels called");

            // Hide all panels
            pnlTransferForm.Visible = false;
            pnlSuccess.Visible = false;

            // Clear ViewState
            ViewState["SelectedAccountId"] = null;
            ViewState["SelectedAccountType"] = null;

            // Reset all button visual states
            ResetAllButtonStates();

            // Clear account details
            ClearAccountDetails();
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

            lblSuccessTID.Text = transactionId;
            lblSuccessAmount.Text = amount.ToString("N2");
            lblSuccessAccount.Text = toAccount.ToString();
            lblSuccessReference.Text = string.IsNullOrEmpty(reference) ? "N/A" : reference;
            lblSuccessNewBalance.Text = newBalance.ToString("N2");
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