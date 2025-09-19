using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace vaultx
{
    public partial class FundTransfer : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                var userId = Session["UserId"];
                if (userId == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // TODO: Load user balances
                lblCurrentBalance.Text = "৳ 5,000.00";
                lblAvailableBalance.Text = "৳ 4,500.00";
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            // TODO: Implement fund transfer logic

            // For now, just show a simple message
            ShowError("Fund transfer functionality will be implemented later.");
        }

        protected void btnNewTransfer_Click(object sender, EventArgs e)
        {
            // TODO: Reset form for new transfer
            ClearForm();
            pnlSuccess.Visible = false;
            pnlError.Visible = false;
            pnlTransferForm.Visible = true;
        }

        protected void btnTryAgain_Click(object sender, EventArgs e)
        {
            // TODO: Show form again after error
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
            pnlTransferForm.Visible = true;
        }

        private void ShowError(string message)
        {
            pnlTransferForm.Visible = false;
            pnlSuccess.Visible = false;
            pnlError.Visible = true;
            lblErrorMessage.Text = message;
        }

        private void ClearForm()
        {
            txtAccountNo.Text = "";
            txtAmount.Text = "";
            txtReference.Text = "";
            txtPassword.Text = "";
            chkTerms.Checked = false;
        }
    }
}