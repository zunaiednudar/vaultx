using System;
using System.Web.UI;

namespace vaultx
{
    public partial class Sidebar : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.DataBind(); // Required to evaluate <%# %> expressions
        }
    }
}
