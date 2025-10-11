using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace vaultx
{
    public partial class ForgetPassword : System.Web.UI.Page
    {
        private string GeneratedOtp
        {
            get { return (string)ViewState["GeneratedOtp"]; }
            set { ViewState["GeneratedOtp"] = value; }
        }
        protected void Page_PreInit(object sender, EventArgs e)
        {
            this.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
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
                
                GeneratedOtp = new Random().Next(100000, 999999).ToString();
                UserEmail = email;

               
                SendOtpEmail(email, GeneratedOtp);

              
                System.Diagnostics.Debug.WriteLine("OTP for " + email + ": " + GeneratedOtp);

            
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
            if (txtNewPassword.Text == txtConfirmPassword.Text)
            {
                UpdatePassword(UserEmail, txtNewPassword.Text.Trim());
                pnlReset.Visible = false;
                pnlSuccess.Visible = true;
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
                string query = "UPDATE dbo.Users SET Password=@Password WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Password", newPassword); // hash in production
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void SendOtpEmail(string toEmail, string otp)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("your-email@gmail.com"); 
                mail.To.Add(toEmail);
                mail.Subject = "VaultX Account Verification – Your One-Time Password (OTP)";
                mail.Body = $@"
<html>
  <body style='font-family:Arial,sans-serif; color:#333;'>
    <h2 style='color:#4ECDC4;'>VaultX Account Verification</h2>
    <p>Dear User,</p>
    <p>Thank you for registering with <strong>VaultX</strong>. To complete your registration, please use the following <strong>One-Time Password (OTP)</strong>:</p>
    <p style='font-size:1.5rem; font-weight:bold; color:#FF6B6B;'>{otp}</p>
    <p>This OTP is valid for the next 10 minutes. Please do not share it with anyone.</p>
    <p>Best regards,<br/><strong>The VaultX Team</strong></p>
  </body>
</html>
";
                mail.IsBodyHtml = true;  

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential("diptochy430@gmail.com", "xvlrzedqehmtrzbs"); // app password
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