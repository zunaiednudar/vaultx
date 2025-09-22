using System;
using System.Web.UI;

namespace vaultx
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Set active navigation based on current page
            string currentPage = System.IO.Path.GetFileNameWithoutExtension(Request.Url.AbsolutePath);

            switch (currentPage.ToLower())
            {
                case "home":
                    navHome.Attributes["class"] = "site-nav-ul-li active";
                    break;
                case "dashboard":
                    navDashboard.Attributes["class"] = "site-nav-ul-li active";
                    break;
                default:
                    // No active class for other pages
                    break;
            }
        }
    }
}