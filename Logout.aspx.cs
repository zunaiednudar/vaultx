using System;
using System.Web;

namespace vaultx
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Only perform logout if confirm=true is passed from modal JS
            if (Request.QueryString["confirm"] == "true")
            {
                // Clear session
                Session.Clear();
                Session.Abandon();

                // Clear cookie if exists
                if (Request.Cookies["VaultXUser"] != null)
                {
                    HttpCookie cookie = new HttpCookie("VaultXUser");
                    cookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(cookie);
                }

                // Clear JS sessionStorage login flag
                Response.Write("<script>sessionStorage.removeItem('VaultXLoggedIn');</script>");

                // Redirect back to home (or login page)
                Response.Redirect("Home.aspx");
            }
            else
            {
                // If someone opens Logout.aspx directly, just go Home
                Response.Redirect("Home.aspx");
            }
        }
    }
}
