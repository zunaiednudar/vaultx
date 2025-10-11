using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace vaultx
{
    public partial class AdminLogin : Page
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;

            // Check if admin is already logged in
            if (!IsPostBack)
            {
                if (Session["AdminID"] != null)
                {
                    Response.Redirect("Admin.aspx");
                }
            }
        }

        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            string email = txtAdminEmail.Text.Trim();
            string password = txtAdminPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "EmptyFields", "alert('Please fill in all fields');", true);
                return;
            }

            // Verify admin credentials
            int adminId = GetAdminID(email, password);
            if (adminId > 0)
            {
                // Set admin session
                Session["AdminID"] = adminId;
                Session["AdminEmail"] = email;
                Session["IsAdmin"] = true;

                // Store admin info in session
                string adminName = GetAdminName(adminId);
                Session["AdminName"] = adminName;

                // Show success panel
                pnlLoginForm.Visible = false;
                pnlSuccess.Visible = true;

                // Redirect to admin panel
                string script = @"
                    setTimeout(function(){ window.location='Admin.aspx'; }, 2000);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "Redirect", script, true);
            }
            else
            {
                pnlLoginForm.Visible = false;
                pnlFail.Visible = true;
            }
        }

        private int GetAdminID(string email, string password)
        {
            int adminId = 0;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT AdminID FROM dbo.Admin WHERE Email=@Email AND Password=@Password";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    conn.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null)
                        adminId = Convert.ToInt32(result);
                }
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine("Admin login error: " + ex.Message);
            }

            return adminId;
        }

        private string GetAdminName(int adminId)
        {
            string adminName = "";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT Name FROM dbo.Admin WHERE AdminID=@AdminID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AdminID", adminId);

                    conn.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null)
                        adminName = result.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Get admin name error: " + ex.Message);
            }

            return adminName;
        }
    }
}