using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using vaultx.cls;

namespace vaultx
{
    public partial class ForgetPassword : System.Web.UI.Page
    {
        private string GeneratedOtp
        {
            get { return (string)ViewState["GeneratedOtp"]; }
            set { ViewState["GeneratedOtp"] = value; }
        }

        private string UserEmail
        {
            get { return (string)ViewState["UserEmail"]; }
            set { ViewState["UserEmail"] = value; }
        }

        protected void btnSendOtp_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            if (IsEmailRegistered(email))
            {
                // generate OTP and store in ViewState
                GeneratedOtp = new Random().Next(100000, 999999).ToString();
                UserEmail = email;

                // send OTP email
                SendOtpEmail(email, GeneratedOtp);

                // for development, also write to debug console
                System.Diagnostics.Debug.WriteLine("OTP for " + email + ": " + GeneratedOtp);

                // switch to OTP panel
                pnlEmail.Visible = false;
                pnlOtp.Visible = true;
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Email not found!');", true);
            }
        }

        protected void btnVerifyOtp_Click(object sender, EventArgs e)
        {
            if (txtOtp.Text.Trim() == GeneratedOtp)
            {
                pnlOtp.Visible = false;
                pnlReset.Visible = true;
            }
            else
            {
                pnlOtp.Visible = false;
                wrongotp.Visible = true;
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            // Validate password strength
            string newPassword = txtNewPassword.Text.Trim();
            if (!PasswordHelper.IsPasswordStrong(newPassword))
            {
                lblPasswordError.Text = "Password must be at least 8 characters and contain uppercase, lowercase, number, and special character.";
                return;
            }
            
            if (txtNewPassword.Text == txtConfirmPassword.Text)
            {
                UpdatePassword(UserEmail, newPassword);
                pnlReset.Visible = false;
                pnlSuccess.Visible = true;
            }
            else
            {
                lblPasswordError.Text = "Passwords do not match!";
            }
        }

        private bool IsEmailRegistered(string email)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM dbo.Users WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private void UpdatePassword(string email, string newPassword)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string hashedPassword = PasswordHelper.HashPassword(newPassword);
                string query = "UPDATE dbo.Users SET Password=@Password WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Password", hashedPassword);
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void SendOtpEmail(string toEmail, string otp)
        {
            try
            {
                string smtpEmail = ConfigurationManager.AppSettings["SmtpEmail"] ?? "your-app@example.com";
                string smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"] ?? "";
                string smtpHost = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
                int smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(smtpEmail, "VaultX Bank");
                mail.To.Add(toEmail);
                mail.Subject = "Password Reset OTP - VaultX Bank";
                mail.Body = $@"Dear User,

Your OTP for password reset is: {otp}

This OTP is valid for 10 minutes only.

If you did not request this, please ignore this email.

Best regards,
VaultX Team";
                mail.IsBodyHtml = false;

                SmtpClient smtp = new SmtpClient(smtpHost, smtpPort);
                smtp.Credentials = new NetworkCredential(smtpEmail, smtpPassword);
                smtp.EnableSsl = true;

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error sending OTP: {ex.Message}');", true);
            }
        }
    }
}
