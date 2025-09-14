using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using System.Net.Mail;

namespace vaultx
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtPassword.Text))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "NoPassword", "alert('Password cannot be empty!');", true);
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

                Random rnd = new Random();
                string otp = rnd.Next(100000, 999999).ToString();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"INSERT INTO dbo.Registration
                                     (UFirstName, ULastName, UEmail, UPhoneNumber, UPassword, UNID, UDOB, UOTP, IsVerified, CreatedAt)
                                     VALUES (@FName, @LName, @Email, @Phone, @Password, @NID, @DOB, @OTP, 0, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FName", txtFirstName.Text.Trim());
                        cmd.Parameters.AddWithValue("@LName", txtLastName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());
                        cmd.Parameters.AddWithValue("@NID", txtNID.Text.Trim());
                        cmd.Parameters.AddWithValue("@DOB", string.IsNullOrEmpty(txtDOB.Text.Trim()) ? (object)DBNull.Value : DateTime.Parse(txtDOB.Text.Trim()));
                        cmd.Parameters.AddWithValue("@OTP", otp);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }

                hfEmail.Value = txtEmail.Text.Trim();

                SendOtpEmail(hfEmail.Value, otp);

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
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        private void SendOtpEmail(string toEmail, string otp)
        {
            try
            {
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("yourmail@example.com");
                mail.To.Add(toEmail);
                mail.Subject = "Your VaultX OTP";
                mail.Body = $"Your OTP is: {otp}";

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential("diptochy430@gmail.com", "xvlrzedqehmtrzbs");
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
            string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT TOP 1 UOTP FROM dbo.Registration WHERE UEmail=@Email ORDER BY CreatedAt DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", hfEmail.Value);

                conn.Open();
                string otpFromDb = (string)cmd.ExecuteScalar();
                conn.Close();

                if (enteredOtp == otpFromDb)
                {
                    conn.Open();
                    string updateQuery = @"
                        WITH Latest AS (
                            SELECT TOP 1 *
                            FROM dbo.Registration
                            WHERE UEmail = @Email
                            ORDER BY CreatedAt DESC
                        )
                        UPDATE Latest
                        SET IsVerified = 1";

                    SqlCommand update = new SqlCommand(updateQuery, conn);
                    update.Parameters.AddWithValue("@Email", hfEmail.Value);
                    update.ExecuteNonQuery();
                    conn.Close();

                    string successScript = @"
                document.body.innerHTML = `
    <div style=""height:100vh; display:flex; justify-content:center; align-items:center; flex-direction:column; font-family:Poppins, sans-serif; background:#f5f5f5;"">
          
        <div class=""spinner""></div>
<div class=""result"" style=""text-align:center;"">
<h1>Registration <br> Verified!</h1>
      
       
    </div>
</div>
`;

var style = document.createElement(""style"");
style.innerHTML = `
    .spinner {
        border: 6px solid #f3f3f3;
        border-top: 6px solid #4ECDC4;
        border-radius: 50%;
        width: 60px;
        height: 60px;
        animation: spin 1s linear infinite;
    }

.result h1 {
        font-size: 2.5rem;
        background: linear-gradient(90deg, #4ECDC4, #55EFC4, #A7FFE4);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin: 0;
        animation: fadeIn 0.5s ease forwards;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
 

    @keyframes fadeIn {
        0% { opacity: 0; transform: translateY(10px); }
        100% { opacity: 1; transform: translateY(0); }
    }
.result {
        display: none;
        flex-direction: column;
        align-items: center;
        gap: 15px;
    }
   
    @keyframes pop {
        0% { transform: scale(0.3); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }
`;
document.head.appendChild(style);


setTimeout(function() {
    document.querySelector('.spinner').style.display = 'none';

    document.querySelector('.result').style.display = 'flex';
}, 1500);

setTimeout(function() {
    window.location.href = 'Login.aspx';
}, 3000);


                    ";
                    ClientScript.RegisterStartupScript(this.GetType(), "SuccessOtp", successScript, true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "WrongOtp", "document.getElementById('otpMsg').innerText='Invalid OTP!';", true);
                }
            }
        }
    }
}
