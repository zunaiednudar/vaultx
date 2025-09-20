using System;
using System.Web.UI;

namespace vaultx
{
    public partial class Sidebar : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool isLoggedIn = Session["UID"] != null;

            string script = $"var VaultXLoggedIn = {isLoggedIn.ToString().ToLower()};";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SetLoginFlag", script, true);
        }
    }
}
