using System;
using System.Web;

namespace vaultx
{
    // Subject interface
    public interface ILogout
    {
        void Execute(HttpContext context);
    }

    // Real logout implementation
    public class RealLogout : ILogout
    {
        public void Execute(HttpContext context)
        {
            // Clear session
            context.Session.Clear();
            context.Session.Abandon();

            // Clear cookie if exists
            if (context.Request.Cookies["VaultXUser"] != null)
            {
                HttpCookie cookie = new HttpCookie("VaultXUser");
                cookie.Expires = DateTime.Now.AddDays(-1);
                context.Response.Cookies.Add(cookie);
            }

          
            context.Response.Write("<script>sessionStorage.removeItem('VaultXLoggedIn');</script>");

          
            context.Response.Redirect("Home.aspx");
        }
    }

    // Proxy class
    public class LogoutProxy : ILogout
    {
        private readonly ILogout _realLogout;

        public LogoutProxy()
        {
            _realLogout = new RealLogout();
        }

        public void Execute(HttpContext context)
        {
            
            if (context.Request.QueryString["confirm"] == "true")
            {
                _realLogout.Execute(context);
            }
            else
            {
                
                context.Response.Redirect("Home.aspx");
            }
        }
    }

    // Page code-behind
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ILogout logout = new LogoutProxy();
            logout.Execute(HttpContext.Current);
        }
    }
}