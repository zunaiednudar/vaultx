using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Runtime.InteropServices;
using System.Web;
using vaultx.cls;

namespace vaultx
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Validate password strength
            string password = txtPassword.Text.Trim();
            if (!PasswordHelper.IsPasswordStrong(password))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "WeakPassword", 
                    "alert('Password must be at least 8 characters and contain uppercase, lowercase, number, and special character.');", true);
                return;
            }
            
            hfPassword.Value = password;


            // Validate required fields
            if (string.IsNullOrWhiteSpace(txtFirstName.Text) || 
                string.IsNullOrWhiteSpace(txtLastName.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtPhone.Text) ||
                string.IsNullOrWhiteSpace(txtNID.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "MissingFields", "alert('Please fill all required fields.');", true);
                return;
            }
            
            // Validate email format
            if (!IsValidEmail(txtEmail.Text.Trim()))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "InvalidEmail", "alert('Please enter a valid email address.');", true);
                return;
            }
            
            // Check if email already exists
            if (IsEmailExists(txtEmail.Text.Trim()))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "EmailExists", "alert('This email is already registered.');", true);
                return;
            }

            string profileImage = null;

            // Validate and process profile image upload
            if (fuProfileImage.HasFile)
            {
                // Validate file type
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
                string fileExtension = Path.GetExtension(fuProfileImage.PostedFile.FileName).ToLower();
                
                if (!Array.Exists(allowedExtensions, ext => ext == fileExtension))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "InvalidFile", "alert('Only JPG, JPEG, PNG, and GIF files are allowed.');", true);
                    return;
                }
                
                // Validate file size (max 5MB)
                if (fuProfileImage.PostedFile.ContentLength > 5 * 1024 * 1024)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "FileTooLarge", "alert('File size must be less than 5MB.');", true);
                    return;
                }
                
                // Generate unique filename to prevent conflicts
                string fileName = Guid.NewGuid().ToString() + fileExtension;
                string savePath = Server.MapPath("~/images/profile_img/") + fileName;

                if (!Directory.Exists(Server.MapPath("~/images/profile_img/")))
                    Directory.CreateDirectory(Server.MapPath("~/images/profile_img/"));

                fuProfileImage.SaveAs(savePath);

                profileImage = "~/images/profile_img/" + fileName;

                hfProfileImagePath.Value = profileImage;
            }


          
            Random rnd = new Random();
            string otp = rnd.Next(100000, 999999).ToString();

            // Store OTP in cookie
            HttpCookie otpCookie = new HttpCookie("UserOtp");
            otpCookie.Value = otp;
            otpCookie.Expires = DateTime.Now.AddMinutes(5);
            Response.Cookies.Add(otpCookie);

            HttpCookie emailCookie = new HttpCookie("UserEmail");
            emailCookie.Value = txtEmail.Text.Trim();
            emailCookie.Expires = DateTime.Now.AddMinutes(5);
            Response.Cookies.Add(emailCookie);

            // Send OTP
            SendOtpEmail(txtEmail.Text.Trim(), otp);

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
                mail.Subject = "Your VaultX OTP - Secure Verification";
                mail.Body = $@"Dear User,

Your OTP for VaultX account registration is: {otp}

This OTP is valid for 5 minutes only.

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
                throw new Exception("OTP Email failed: " + ex.Message);
            }
        }

        protected void btnVerifyOtp_Click(object sender, EventArgs e)
        {
            string enteredOtp = hfEnteredOtp.Value;
            HttpCookie otpCookie = Request.Cookies["UserOtp"];
            HttpCookie emailCookie = Request.Cookies["UserEmail"];

            if (otpCookie == null || emailCookie == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "OtpExpired", "alert('OTP expired. Please register again.'); window.location='Register.aspx';", true);
                return;
            }

            if (enteredOtp == otpCookie.Value)
            {

                string profileImagePath = hfProfileImagePath.Value;


                string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
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
                    
                    // Hash the password before storing
                    string hashedPassword = PasswordHelper.HashPassword(hfPassword.Value);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);

                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                // Clear OTP cookies
                otpCookie.Expires = DateTime.Now.AddDays(-1);
                emailCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(otpCookie);
                Response.Cookies.Add(emailCookie);

               pnlSuccess.Visible = true;
                pnlStep3.Visible = false;
                pnlStep2.Visible = false;
                pnlStep1.Visible = false;
                areg.Visible = false;
                string script = @"setTimeout(function() {
                          window.location='Login.aspx';
                      }, 3000);";
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
