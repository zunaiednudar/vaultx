using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace vaultx
{
    #region Email Sending (Factory Pattern)

    public interface IEmailSender
    {
        void Send(string toEmail, string subject, string body);
    }

    public class SmtpEmailSender : IEmailSender
    {
        private readonly string _smtpHost;
        private readonly int _smtpPort;
        private readonly string _username;
        private readonly string _password;

        public SmtpEmailSender(string smtpHost, int smtpPort, string username, string password)
        {
            _smtpHost = smtpHost;
            _smtpPort = smtpPort;
            _username = username;
            _password = password;
        }

        public void Send(string toEmail, string subject, string body)
        {
            MailMessage mail = new MailMessage
            {
                From = new MailAddress(_username),
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            };
            mail.To.Add(toEmail);

            SmtpClient smtp = new SmtpClient(_smtpHost, _smtpPort)
            {
                Credentials = new NetworkCredential(_username, _password),
                EnableSsl = true
            };
            smtp.Send(mail);
        }
    }

    public static class EmailSenderFactory
    {
        public static IEmailSender CreateSmtpSender()
        {
            return new SmtpEmailSender(
                "smtp.gmail.com",
                587,
                "diptochy430@gmail.com",
                "xvlrzedqehmtrzbs" // In production, use secure storage for passwords
            );
        }
    }

    #endregion

    #region Database Connection (Singleton Pattern)

    public sealed class Database
    {
        private static Database _instance = null;
        private static readonly object _lock = new object();
        private readonly string _connectionString;

        private Database()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
        }

        public static Database Instance
        {
            get
            {
                if (_instance == null)
                {
                    lock (_lock)
                    {
                        if (_instance == null)
                            _instance = new Database();
                    }
                }
                return _instance;
            }
        }

        public SqlConnection GetConnection()
        {
            return new SqlConnection(_connectionString);
        }
    }

    #endregion

    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            hfPassword.Value = txtPassword.Text.Trim();

            string profileImage = null;
            if (fuProfileImage.HasFile)
            {
                string fileName = Path.GetFileName(fuProfileImage.PostedFile.FileName);
                string savePath = Server.MapPath("~/images/profiles/") + fileName;

                if (!Directory.Exists(Server.MapPath("~/images/profiles/")))
                    Directory.CreateDirectory(Server.MapPath("~/images/profiles/"));

                fuProfileImage.SaveAs(savePath);
                profileImage = "images/profiles/" + fileName;
                hfProfileImagePath.Value = profileImage;
            }

            // Generate OTP
            Random rnd = new Random();
            string otp = rnd.Next(100000, 999999).ToString();

            // Store OTP & Email in cookies
            Response.Cookies.Add(new HttpCookie("UserOtp") { Value = otp, Expires = DateTime.Now.AddMinutes(5) });
            Response.Cookies.Add(new HttpCookie("UserEmail") { Value = txtEmail.Text.Trim(), Expires = DateTime.Now.AddMinutes(5) });

            // Send OTP using Factory Pattern
            IEmailSender emailSender = EmailSenderFactory.CreateSmtpSender();
            string emailBody = $@"
<html>
  <body style='font-family:Arial,sans-serif; color:#333;'>
    <h2 style='color:#4ECDC4;'>VaultX Account Verification</h2>
    <p>Dear User,</p>
    <p>Thank you for registering with <strong>VaultX</strong>. To complete your registration, please use the following <strong>One-Time Password (OTP)</strong>:</p>
    <p style='font-size:1.5rem; font-weight:bold; color:#FF6B6B;'>{otp}</p>
    <p>This OTP is valid for the next 10 minutes. Please do not share it with anyone.</p>
    <p>Best regards,<br/><strong>The VaultX Team</strong></p>
  </body>
</html>";
            emailSender.Send(txtEmail.Text.Trim(), "VaultX Account Verification – OTP", emailBody);

            // Show OTP panel
            string script = @"document.getElementById('regForm').style.display='none';
                              document.getElementById('otpForm').style.display='block';
                              var timeLeft = 90;
                              var timerElem = document.getElementById('timer');
                              var timer = setInterval(function(){
                                  if(timeLeft <= 0){ clearInterval(timer); timerElem.innerHTML='OTP expired. Please try again.'; } 
                                  else{ timerElem.innerHTML='Time remaining: ' + timeLeft + 's'; }
                                  timeLeft -= 1;
                              }, 1000);";
            ClientScript.RegisterStartupScript(this.GetType(), "ShowOtpForm", script, true);
        }

        protected void btnVerifyOtp_Click(object sender, EventArgs e)
        {
            string enteredOtp = hfEnteredOtp.Value;
            HttpCookie otpCookie = Request.Cookies["UserOtp"];
            HttpCookie emailCookie = Request.Cookies["UserEmail"];

            if (otpCookie == null || emailCookie == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "OtpExpired",
                    "alert('OTP expired. Please register again.'); window.location='Register.aspx';", true);
                return;
            }

            if (enteredOtp == otpCookie.Value)
            {
                string profileImagePath = hfProfileImagePath.Value;

                using (SqlConnection conn = Database.Instance.GetConnection())
                {
                    conn.Open();
                    string getMaxUIDQuery = "SELECT ISNULL(MAX(UID), 999) FROM dbo.Users";
                    SqlCommand cmdMax = new SqlCommand(getMaxUIDQuery, conn);
                    int newUID = (int)cmdMax.ExecuteScalar() + 1;

                    string query = @"
INSERT INTO dbo.Users
(UID, FirstName, LastName, FathersName, MothersName, DateOfBirth, NIDNumber, Email, PhoneNumber, ProfileImage,
 Division, District, Upazilla, Address, PostalCode, Profession, MonthlyEarnings, Password)
VALUES
(@UID, @FName, @LName, @FathersName, @MothersName, @DOB, @NID, @Email, @Phone, @ProfileImage,
 @Division, @District, @Upazilla, @Address, @PostalCode, @Profession, @MonthlyEarnings, @Password)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", newUID);
                    cmd.Parameters.AddWithValue("@FName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@FathersName", TextBox1.Text.Trim());
                    cmd.Parameters.AddWithValue("@MothersName", TextBox2.Text.Trim());
                    cmd.Parameters.AddWithValue("@DOB", string.IsNullOrEmpty(txtDOB.Text.Trim()) ? (object)DBNull.Value : DateTime.Parse(txtDOB.Text.Trim()));
                    cmd.Parameters.AddWithValue("@NID", txtNID.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@ProfileImage", (object)profileImagePath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Division", ddlDivision.SelectedValue);
                    cmd.Parameters.AddWithValue("@District", hfDistrict.Value);
                    cmd.Parameters.AddWithValue("@Upazilla", TextBox3.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", TextBox4.Text.Trim());
                    cmd.Parameters.AddWithValue("@PostalCode", TextBox5.Text.Trim());
                    cmd.Parameters.AddWithValue("@Profession", TextBox6.Text.Trim());
                    cmd.Parameters.AddWithValue("@MonthlyEarnings", string.IsNullOrEmpty(TextBox7.Text.Trim()) ? 0 : Convert.ToDecimal(TextBox7.Text.Trim()));
                    cmd.Parameters.AddWithValue("@Password", hfPassword.Value);

                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                
                otpCookie.Expires = DateTime.Now.AddDays(-1);
                emailCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(otpCookie);
                Response.Cookies.Add(emailCookie);

                pnlSuccess.Visible = true;
                pnlStep3.Visible = false;
                pnlStep2.Visible = false;
                pnlStep1.Visible = false;
                areg.Visible = false;

                string script = @"setTimeout(function() { window.location='Login.aspx'; }, 3000);";
                ClientScript.RegisterStartupScript(this.GetType(), "RedirectAfterSuccess", script, true);
            }
            else
            {
                pnlfail.Visible = true;
                pnlStep3.Visible = false;
                pnlStep2.Visible = false;
                pnlStep1.Visible = false;
                areg.Visible = false;
            }
        }
    }
}
