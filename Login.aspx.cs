using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;
using vaultx.cls;

namespace vaultx
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

           
            if (!IsPostBack)
            {
                HttpCookie cookie = Request.Cookies["VaultXUser"];
                if (cookie != null)
                {
                    string email = cookie["Email"];
                    string uidStr = cookie["UID"];
                    if (!string.IsNullOrEmpty(email) && !string.IsNullOrEmpty(uidStr))
                    {
                        int uid;
                        if (int.TryParse(uidStr, out uid))
                        {
                            Session["Email"] = email;
                            Session["UID"] = uid;
                            //Response.Redirect("Home.aspx");
                            //Context.ApplicationInstance.CompleteRequest();

                        }
                    }
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
           
            string password = txtPassword.Text.Trim();
            if (email == "adminvaultx@hotmail.business" && password == "admin")
            {
                Response.Redirect("Admin.aspx");
            }
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "EmptyFields", "alert('Please fill all fields');", true);
                return;
            }

            // Basic input validation
            if (!InputValidator.IsValidEmail(email))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "InvalidEmail", "alert('Please enter a valid email address');", true);
                return;
            }

            // Check for potential SQL injection
            if (InputValidator.ContainsSqlInjection(email) || InputValidator.ContainsSqlInjection(password))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "SecurityAlert", "alert('Invalid input detected');", true);
                return;
            }

            int uid = GetUserID(email, password);
            if (uid > 0)
            {
                // Save session with consistent variable names
                Session["Email"] = email;
                Session["UserId"] = uid;
                Session["UID"] = uid; // Keep both for backward compatibility

               //cookie
                if (chkRememberMe.Checked) 
                {
                    HttpCookie cookie = new HttpCookie("VaultXUser");
                    cookie["Email"] = email;
                    cookie["UID"] = uid.ToString();
                    cookie.Expires = DateTime.Now.AddDays(30);
                    cookie.HttpOnly = true; // Prevent XSS
                    Response.Cookies.Add(cookie);
                }
                pnlLoginForm.Visible = false;
                pnlSuccess.Visible = true;
                string script = @"
    sessionStorage.setItem('VaultXLoggedIn', 'true');
    setTimeout(function(){ window.location='Home.aspx'; }, 2000);
";
                ClientScript.RegisterStartupScript(this.GetType(), "Redirect", script, true);
            }
            else
            {
                pnlLoginForm.Visible = false;
                pnlfail.Visible = true;

            }
        }

        private int GetUserID(string email, string password)
        {
            int uid = 0;
            string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT UID, Password FROM dbo.Users WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string storedHash = reader["Password"].ToString();
                        
                        // Check if password is already hashed (base64 string of 64 bytes = 88 chars)
                        if (storedHash.Length == 88 && IsBase64String(storedHash))
                        {
                            // Use new secure verification
                            if (PasswordHelper.VerifyPassword(password, storedHash))
                            {
                                uid = Convert.ToInt32(reader["UID"]);
                            }
                        }
                        else
                        {
                            // Legacy plain text comparison (for migration period)
                            if (storedHash == password)
                            {
                                uid = Convert.ToInt32(reader["UID"]);
                                // TODO: Migrate this password to hashed version
                                MigratePasswordToHash(email, password);
                            }
                        }
                    }
                }
            }

            return uid;
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

        private void MigratePasswordToHash(string email, string password)
        {
            try
            {
                string hashedPassword = PasswordHelper.HashPassword(password);
                string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
                
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "UPDATE dbo.Users SET Password=@Password WHERE Email=@Email";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    cmd.Parameters.AddWithValue("@Email", email);
                    
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                // Log error but don't prevent login
                System.Diagnostics.Debug.WriteLine($"Password migration failed: {ex.Message}");
            }
        }

        private bool IsUserValid(string email, int uid)
        {
            string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM dbo.Users WHERE Email=@Email AND UID=@UID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@UID", uid);
                
                conn.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }
    }
}
