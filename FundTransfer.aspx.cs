using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using vaultx.cls;

using System.Net;
using System.Net.Mail;

namespace vaultx
{
    /*
        FundTransfer.aspx.cs
        Purpose: Server-side logic and event handlers for fund transfers.
        Key responsibilities:
         - Load and display the logged-in user's name and account summaries.
         - Handle account-type selection and show/hide the transfer form.
         - Validate transfer inputs and business rules (password, balance, receiver existence).
         - Send OTP to user's registered email for confirmation.
         - Perform the database transfer inside a transaction and record a transaction row.
         - Provide friendly error/success UI by toggling panels and invoking client-side modals.
        Security notes (important):
         - SMTP credentials and any secrets should be stored in secure configuration (not hard-coded).
         - Ensure SQL parameters are used (this file already uses parameterized queries).
         - Consider rate-limiting OTP attempts and storing OTPs server-side for stronger validation.
    */

    public partial class FundTransfer : Page
    {
        // Selected AID (account id) from database - persisted into ViewState when set
        private long selectedAccountId = 0;

        // Current authenticated user id (resolved from Session)
        private int currentUserId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication check: try two session keys for compatibility (UserId or UID)
            var userId = Session["UserId"] ?? Session["UID"];
            if (userId == null)
            {
                // Not authenticated - redirect to login and preserve return URL
                Response.Redirect("Login.aspx?returnUrl=" + Request.Url.AbsolutePath);
                return;
            }

            currentUserId = Convert.ToInt32(userId);

            if (!IsPostBack)
            {
                // Initial page load: populate account holder name and reset UI state
                LoadAccountHolderName(currentUserId);
                ResetAllPanels();

                // Helpful debug for developers while working locally
                System.Diagnostics.Debug.WriteLine("Page_Load - Initial state set");
            }
            else
            {
                // On postback restore state that is persisted in ViewState
                if (ViewState["SelectedAccountId"] != null)
                {
                    selectedAccountId = (long)ViewState["SelectedAccountId"];
                }

                // Reapply CSS classes to account type buttons to maintain UI consistency on postback
                RestoreButtonSelection();
            }
        }

        /// <summary>
        /// Loads the account holder's display name from Users table and updates lblAccountHolderName.
        /// Gracefully handles DB errors by showing a friendly placeholder.
        /// </summary>
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
                        // No user found with given UID (shouldn't happen if session is valid)
                        lblAccountHolderName.Text = "Unknown User";
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                // Avoid throwing for UI rendering; log useful debug info and show placeholder text
                lblAccountHolderName.Text = "Error loading user information";
                System.Diagnostics.Debug.WriteLine($"LoadAccountHolderName error: {ex.Message}");
            }
        }

        /// <summary>
        /// Account type button click handler.
        /// Behavior:
        /// - Toggles off selection when clicking the same button again.
        /// - Switches to a different account type and queries for the user's account of that type.
        /// - Updates ViewState and button CSS classes for persistence across postbacks.
        /// </summary>
        protected void btnAccountType_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string accountType = btn.CommandArgument;

            string currentSelectedType = ViewState["SelectedAccountType"] as string;

            System.Diagnostics.Debug.WriteLine($"Button clicked: {accountType}, Current: {currentSelectedType}");

            // Toggle off if user clicked the already selected account type
            if (currentSelectedType == accountType)
            {
                System.Diagnostics.Debug.WriteLine("Toggling OFF - Same button clicked");

                // Clear selection state (ViewState) but leave form input values intact
                ViewState["SelectedAccountType"] = null;
                ViewState["SelectedAccountId"] = null;

                // Reset visual states and hide transfer panels
                ResetAllButtonStates();
                pnlTransferForm.Visible = false;
                pnlSuccess.Visible = false;

                ClearAccountDetails();

                // Optional client-side visual feedback
                ShowToggleOffFeedback();
                return;
            }

            // New selection: update ViewState and UI, then check DB for the latest account of that type
            System.Diagnostics.Debug.WriteLine("Switching account type or first selection");
            ViewState["SelectedAccountType"] = accountType;
            UpdateButtonSelection(accountType);
            CheckAccountAndUpdateForm(currentUserId, accountType);
        }

        /// <summary>
        /// Adds the 'selected' CSS class to the chosen account-type button and clears others.
        /// </summary>
        private void UpdateButtonSelection(string selectedAccountType)
        {
            System.Diagnostics.Debug.WriteLine($"UpdateButtonSelection: {selectedAccountType}");

            // Clear previous states first
            ResetAllButtonStates();

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
                case "Student":
                    btnStudent.CssClass = "account-type-btn selected";
                    System.Diagnostics.Debug.WriteLine("Student button selected");
                    break;
            }
        }

        private void ResetAllButtonStates()
        {
            // Normalize classes back to default for all buttons
            btnSavings.CssClass = "account-type-btn";
            btnCurrent.CssClass = "account-type-btn";
            btnStudent.CssClass = "account-type-btn";
            System.Diagnostics.Debug.WriteLine("All button states reset");
        }

        private void RestoreButtonSelection()
        {
            // Reapply the previously selected account type (if any) on postback
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
            // Clear only the account summary fields (does not clear transfer form input values)
            lblFromAccountType.Text = "";
            lblFromAccountNumber.Text = "";
            lblFromAccountBalance.Text = "";
        }

        /// <summary>
        /// Small client-side animation to indicate toggling off a selection.
        /// This registers a startup script to run in the browser after postback.
        /// </summary>
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

        /// <summary>
        /// Queries the Accounts table for the most recent account of the requested type for the user.
        /// If found: updates the account summary, stores SelectedAccountId in ViewState and shows the form.
        /// If not found: clears selection and asks client to show a 'no account' modal.
        /// </summary>
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
                        // Account found - update only the account summary (do not clear any user-entered form values)
                        selectedAccountId = Convert.ToInt64(reader["AID"]);
                        ViewState["SelectedAccountId"] = selectedAccountId;

                        string accountTypeText = reader["AccountType"].ToString();
                        string accountNumber = reader["AID"].ToString();
                        decimal balance = Convert.ToDecimal(reader["Balance"]);

                        lblFromAccountType.Text = accountTypeText;
                        lblFromAccountNumber.Text = accountNumber;
                        lblFromAccountBalance.Text = balance.ToString("N2");

                        // Show transfer form (server control visibility)
                        pnlTransferForm.Visible = true;
                        pnlSuccess.Visible = false;

                        // Visual cue for account switch
                        ShowAccountSwitchFeedback();
                    }
                    else
                    {
                        // No account of this type exists for the user - reset selection and notify client
                        ViewState["SelectedAccountId"] = null;
                        ViewState["SelectedAccountType"] = null;
                        ResetAllButtonStates();

                        string script = $"showNoAccountModal('{accountType}');";
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowNoAccountModal", script, true);

                        // Clear account details and hide the form
                        ClearAccountDetails();
                        pnlTransferForm.Visible = false;
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                // Show a user-friendly modal and log the exception for diagnostics
                ShowErrorModal($"Error checking account: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"CheckAccountAndUpdateForm error: {ex.Message}");
            }
        }

        /// <summary>
        /// Brief visual highlight when the account selection changes.
        /// Registered as client script to keep server-side code focused on data operations.
        /// </summary>
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

        /// <summary>
        /// btnSend_Click validates inputs and business rules, then sends OTP for confirmation.
        /// Transfer is actually performed after OTP verification (btnVerifyOtp_Click).
        /// </summary>
        protected void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                // Ensure an account was selected (SelectedAccountId persisted in ViewState)
                if (ViewState["SelectedAccountId"] == null)
                {
                    ShowErrorModal("Please select an account first.");
                    return;
                }

                // Basic presence checks - more detailed checks follow
                if (string.IsNullOrWhiteSpace(txtAccountNo.Text) ||
                    string.IsNullOrWhiteSpace(txtAmount.Text) ||
                    string.IsNullOrWhiteSpace(txtPassword.Text) ||
                    !chkTerms.Checked)
                {
                    ShowErrorModal("Please fill all required fields and accept terms.");
                    return;
                }

                selectedAccountId = (long)ViewState["SelectedAccountId"];

                // Validate amount numeric and > 0
                if (!decimal.TryParse(txtAmount.Text, out decimal amount) || amount <= 0)
                {
                    ShowErrorModal("Please enter a valid amount greater than zero.");
                    return;
                }

                // Validate receiver account number format
                if (!long.TryParse(txtAccountNo.Text, out long toAccountId))
                {
                    ShowErrorModal("Please enter a valid account number.");
                    return;
                }

                // Business rule: cannot transfer to the same account
                if (selectedAccountId == toAccountId)
                {
                    ShowErrorModal("Cannot transfer to the same account.");
                    return;
                }

                // 1) Validate user's password (supports stored hashed and plain text legacy)
                if (!ValidateUserPassword(currentUserId, txtPassword.Text))
                {
                    ShowErrorModal("Password mismatch. Please enter your correct password.");
                    return;
                }

                // 2) Ensure receiver account exists
                if (!AccountExists(toAccountId))
                {
                    ShowErrorModal("Receiver account not found. Please check the account number.");
                    return;
                }

                // 3) Balance checks and minimum balance enforcement (keep ৳500)
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

                // All validations passed — send OTP to user's email to confirm transfer.
                Random rnd = new Random();
                string otp = rnd.Next(100000, 999999).ToString();

                // Keep OTP value server-side in HiddenField and client-side (short-lived) cookie.
                // Using cookies is convenient but consider storing OTP server-side (DB/cache) for improved security.
                hfTransferOtp.Value = otp;

                HttpCookie otpCookie = new HttpCookie("TransferOtp")
                {
                    Value = otp,
                    Expires = DateTime.Now.AddMinutes(5)
                };
                Response.Cookies.Add(otpCookie);

                // Store recipient email in cookie (used by resend flow)
                HttpCookie emailCookie = new HttpCookie("TransferEmail")
                {
                    Value = GetUserEmail(currentUserId),
                    Expires = DateTime.Now.AddMinutes(5)
                };
                Response.Cookies.Add(emailCookie);

                // Send OTP via email. Note: SMTP credentials are currently in code (see SendOtpEmail) — move to secure config.
                SendOtpEmail(emailCookie.Value, otp);

                // Hide transfer form and show OTP modal on client
                pnlTransferForm.Visible = false;
                ClientScript.RegisterStartupScript(this.GetType(), "ShowOtpModal", "showOtpModal();", true);

                // Inject client-side OTP countdown (90s) and update lblOtpTimer
                string script = $@"
    var timeLeft = 90;
    var timerElem = document.getElementById('{lblOtpTimer.ClientID}');
    var timer = setInterval(function() {{
        if(timeLeft <= 0) {{
            clearInterval(timer);
            timerElem.innerHTML = 'OTP expired. Please try again.';
        }} 
        else {{
            timerElem.innerHTML = 'Time remaining: ' + timeLeft + 's';
        }}
        timeLeft--;
    }}, 1000);";
                ClientScript.RegisterStartupScript(this.GetType(), "StartOtpTimer", script, true);
            }
            catch (Exception ex)
            {
                // Generic error handling; present friendly message and log debug details
                System.Diagnostics.Debug.WriteLine($"btnSend_Click error: {ex.Message}");
                ShowErrorModal("An unexpected error occurred. Please try again.");
            }
        }

        // Helper: retrieve user's email from Users table
        private string GetUserEmail(int userId)
        {
            string email = "";
            string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Email FROM Users WHERE UID = @UID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UID", userId);
                conn.Open();
                var result = cmd.ExecuteScalar();
                if (result != null) email = result.ToString();
            }

            return email;
        }

        /// <summary>
        /// Sends OTP email to the provided address.
        /// IMPORTANT: Move credentials to a secure store or configuration file and do not keep plaintext passwords in code.
        /// </summary>
        private void SendOtpEmail(string toEmail, string otp)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("diptochy430@gmail.com", "VaultX Bank");
                mail.To.Add(toEmail);
                mail.Subject = "VaultX Bank - OTP for Fund Transfer";
                mail.Body = $"Your OTP for fund transfer is: {otp}. It is valid for 5 minutes.";
                mail.IsBodyHtml = false;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential("diptochy430@gmail.com", "xvlrzedqehmtrzbs");
                smtp.EnableSsl = true;

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                // If sending OTP fails, inform user and log the exception for diagnostics
                System.Diagnostics.Debug.WriteLine($"SendOtpEmail error: {ex.Message}");
                ShowErrorModal("Failed to send OTP. Please try again.");
            }
        }

        /// <summary>
        /// Resend OTP handler: regenerates OTP, sets cookies and emails it again.
        /// If email cookie is missing the flow is aborted and user is asked to restart.
        /// </summary>
        protected void btnResendOtp_Click(object sender, EventArgs e)
        {
            Random rnd = new Random();
            string otp = rnd.Next(100000, 999999).ToString();

            hfTransferOtp.Value = otp;
            HttpCookie otpCookie = new HttpCookie("TransferOtp") { Value = otp, Expires = DateTime.Now.AddMinutes(5) };
            Response.Cookies.Add(otpCookie);

            HttpCookie emailCookie = Request.Cookies["TransferEmail"];
            if (emailCookie != null)
            {
                SendOtpEmail(emailCookie.Value, otp);
                ShowErrorModal("A new OTP has been sent to your email.");
            }
            else
            {
                // If we do not have the user's email in cookie, require the user to restart transfer
                ShowErrorModal("Cannot resend OTP. Please restart the transfer.");
                ClientScript.RegisterStartupScript(this.GetType(), "CloseOtpModal", "closeOtpModal();", true);
                pnlTransferForm.Visible = true;
            }
        }

        /// <summary>
        /// Verifies the OTP entered by the user and proceeds to perform the transfer if valid.
        /// OTP is validated against the short-lived cookie set earlier.
        /// </summary>
        protected void btnVerifyOtp_Click(object sender, EventArgs e)
        {
            string enteredOtp = txtOtp.Text.Trim();
            HttpCookie otpCookie = Request.Cookies["TransferOtp"];
            HttpCookie emailCookie = Request.Cookies["TransferEmail"];

            if (otpCookie == null || emailCookie == null)
            {
                // OTP expired or cookies deleted
                ShowErrorModal("OTP expired. Please try again.");

                ClientScript.RegisterStartupScript(this.GetType(), "CloseOtpModal", "closeOtpModal();", false);
                pnlTransferForm.Visible = true;

                return;
            }

            if (enteredOtp == otpCookie.Value)
            {
                // Successful OTP - clear cookies and proceed with transfer
                otpCookie.Expires = DateTime.Now.AddDays(-1);
                emailCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(otpCookie);
                Response.Cookies.Add(emailCookie);

                selectedAccountId = (long)ViewState["SelectedAccountId"];
                decimal amount = Convert.ToDecimal(txtAmount.Text);
                long toAccountId = Convert.ToInt64(txtAccountNo.Text);
                ProcessTransferWithRetry(selectedAccountId, toAccountId, amount, txtReference.Text?.Trim());
            }
            else
            {
                // OTP mismatch
                ShowErrorModal("Invalid OTP. Please try again.");
            }
        }

        /// <summary>
        /// Processes transfer with a simple retry loop to handle transient DB failures.
        /// On success: shows the success panel and refreshes account info.
        /// On repeated failure: shows an error modal with reason.
        /// </summary>
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
                    // Simple backoff between retries
                    System.Threading.Thread.Sleep(500);
                }
            }

            if (result != null && result.Success)
            {
                // Update UI to show success and clear the form for next transfer
                ShowSuccess(result.TransactionId, amount, toAccountId, reference, result.NewSenderBalance);
                ClearForm();

                // Refresh account summary details (balance) for the chosen account
                RefreshCompleteAccountInfo(fromAccountId);
            }
            else
            {
                // All retries exhausted - present the error message to the user
                string errorMessage = result?.ErrorMessage ?? "Transfer could not be completed. Please try again later.";
                ShowErrorModal(errorMessage);
            }
        }

        /// <summary>
        /// Core DB logic that performs the funds movement inside an explicit SQL transaction.
        /// Steps:
        /// 1) Generate a TID (transaction identifier)
        /// 2) Verify sender balance
        /// 3) Verify receiver exists
        /// 4) Debit sender
        /// 5) Credit receiver
        /// 6) Insert Transactions record
        /// 7) Query new sender balance and commit
        /// All DB updates happen within a SqlTransaction to guarantee atomicity.
        /// </summary>
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
                            // Step 1: Generate TID (int). Keep this method DB-aware and safe for concurrency.
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

                            // Step 8: All operations successful - commit
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
                            // Rollback and return a friendly message; log the SQL exception for diagnostics.
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
                            // Generic rollback and error handling
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
                // Failure to open connection or another outer error
                System.Diagnostics.Debug.WriteLine($"ProcessFundTransfer connection error: {ex.Message}");
                return new TransferResult
                {
                    Success = false,
                    ErrorMessage = "Database connection failed."
                };
            }
        }

        /// <summary>
        /// Generates the next TID (transaction id) as an int.
        /// Falls back to a timestamp-based value if the SELECT fails.
        /// </summary>
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
                // If lookup fails, use a deterministic fallback derived from current timestamp
                System.Diagnostics.Debug.WriteLine($"GenerateTransactionIdInt error: {ex.Message}");
                string timeStamp = DateTime.Now.ToString("yyyyMMddHHmmss");
                if (timeStamp.Length > 10)
                {
                    timeStamp = timeStamp.Substring(timeStamp.Length - 10);
                }
                return int.Parse(timeStamp);
            }
        }

        // Small DTO used locally to indicate transfer result and optional error message
        private class TransferResult
        {
            public bool Success { get; set; }
            public string TransactionId { get; set; }
            public decimal NewSenderBalance { get; set; }
            public string ErrorMessage { get; set; }
        }

        /// <summary>
        /// Refreshes account summary details for a given account id (AID).
        /// Called after successful transfers to show current balance.
        /// </summary>
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
                // Non-fatal - log for developers
                System.Diagnostics.Debug.WriteLine($"RefreshCompleteAccountInfo error: {ex.Message}");
            }
        }

        /// <summary>
        /// Clears the transfer form input fields.
        /// </summary>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Cancel button clicked");

            // Remove user input from the form
            ClearForm();

            // Reset UI state (hide panels, clear ViewState and button selections)
            ResetAllPanels();

            // Provide a visual feedback to the user that cancel occurred
            ShowCancelFeedback();
        }

        // Simple client-side visual effect to show cancel acknowledgement
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

        /// <summary>
        /// Handler for 'New Transfer' button on success panel: clears form and shows form if an account is selected.
        /// </summary>
        protected void btnNewTransfer_Click(object sender, EventArgs e)
        {
            ClearForm();

            // If an account was previously selected, refresh its data and show the form
            if (ViewState["SelectedAccountId"] != null)
            {
                selectedAccountId = (long)ViewState["SelectedAccountId"];
                RefreshCompleteAccountInfo(selectedAccountId);
                pnlTransferForm.Visible = true;
                pnlSuccess.Visible = false;
            }
            else
            {
                // No account selected -> reset UI to initial state
                ResetAllPanels();
            }
        }

        /// <summary>
        /// Validates the supplied password against stored value.
        /// Supports hashed (base64 salted hash) and legacy plain text for compatibility.
        /// Returns true if password matches, false otherwise.
        /// </summary>
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

                        // Heuristic: if stored value looks like a base64 hash -> verify using PasswordHelper
                        if (storedHash.Length == 88 && IsBase64String(storedHash))
                        {
                            return PasswordHelper.VerifyPassword(password, storedHash);
                        }
                        else
                        {
                            // Legacy: plain-text comparison (not recommended) kept for backwards compatibility
                            return storedHash == password;
                        }
                    }

                    return false;
                }
            }
            catch (Exception ex)
            {
                // Log and treat as validation failure (avoid revealing details to user)
                System.Diagnostics.Debug.WriteLine($"ValidateUserPassword error: {ex.Message}");
                return false;
            }
        }

        // Helper to test if a string is base64-encoded
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

        // Checks if an account with the given AID exists
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

        // Reads the balance for the requested account (used for validation prior to transfer)
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

        /// <summary>
        /// Resets panels, clears ViewState and returns button UI to default.
        /// Use this to return the page to its initial state.
        /// </summary>
        private void ResetAllPanels()
        {
            System.Diagnostics.Debug.WriteLine("ResetAllPanels called");

            // Hide panels
            pnlTransferForm.Visible = false;
            pnlSuccess.Visible = false;

            // Clear persisted selection
            ViewState["SelectedAccountId"] = null;
            ViewState["SelectedAccountType"] = null;

            // Reset button appearance and summary
            ResetAllButtonStates();
            ClearAccountDetails();
        }

        /// <summary>
        /// Register and show a client-side modal with a sanitized message string.
        /// Always escapes quotes and newlines to prevent script injection.
        /// </summary>
        private void ShowErrorModal(string message)
        {
            string escapedMessage = message.Replace("'", "\\'").Replace("\"", "\\\"")
                                         .Replace("\r\n", "\\n").Replace("\r", "\\n").Replace("\n", "\\n");
            string script = $"showTransferErrorModal('{escapedMessage}');";
            ClientScript.RegisterStartupScript(this.GetType(), "ShowErrorModal", script, true);
        }

        /// <summary>
        /// Populate the success panel with transaction details and show it.
        /// </summary>
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

        /// <summary>
        /// Clear only the input fields (keeps account selection and UI state unless ResetAllPanels is called).
        /// </summary>
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