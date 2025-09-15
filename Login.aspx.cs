using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;

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
                    string password = cookie["Password"];
                    string uidStr = cookie["UID"];
                    if (!string.IsNullOrEmpty(email) && !string.IsNullOrEmpty(password) && !string.IsNullOrEmpty(uidStr))
                    {
                        int uid;
                        if (int.TryParse(uidStr, out uid))
                        {
                            Session["Email"] = email;
                            Session["UID"] = uid;
                            //Response.Redirect("Dashboard.aspx");
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

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "EmptyFields", "alert('Please fill all fields');", true);
                return;
            }

            int uid = GetUserID(email, password);
            if (uid > 0)
            {
                // Save session
                Session["Email"] = email;
                Session["UID"] = uid;

               //cookie
                if (chkRememberMe.Checked) 
                {
                    HttpCookie cookie = new HttpCookie("VaultXUser");
                    cookie["Email"] = email;
                    cookie["Password"] = password;
                    cookie["UID"] = uid.ToString();
                    cookie.Expires = DateTime.Now.AddDays(30);
                    Response.Cookies.Add(cookie);
                }
                pnlLoginForm.Visible = false;
                pnlSuccess.Visible = true;
                ClientScript.RegisterStartupScript(this.GetType(), "Redirect", "setTimeout(function(){ window.location='Dashboard.aspx'; }, 2000);", true);
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
                string query = "SELECT UID FROM dbo.Registration WHERE UEmail=@Email AND UPassword=@Password AND IsVerified=1";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password); // Use hashed password in production

                conn.Open();
                object result = cmd.ExecuteScalar();
                conn.Close();

                if (result != null)
                    uid = Convert.ToInt32(result);
            }

            return uid;
        }
    }
}
