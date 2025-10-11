<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="vaultx.AdminLogin" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VaultX - Admin Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:ital,wght@0,100..700;1,100..700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/Register.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="page-flex">
            <div class="left-panel-lg"> 
                <img src="images/admin.jpg" alt="VaultX Admin Banner" /> 
            </div>

            <div class="right-panel-login" style="flex:1; display:flex; justify-content:center; align-items:center; background:#f5f5f5;">
                <asp:Panel ID="pnlLoginForm" runat="server" CssClass="form-container-lg">
                    <div class="welcome-msg">
                        ADMIN <br /><span>PORTAL</span>
                    </div>

                    <h2 style="text-align:center;">Admin Login</h2>
                    <hr />

                    <div class="form-group">
                        <i class="fa fa-envelope"></i>
                        <asp:TextBox ID="txtAdminEmail" runat="server" CssClass="form-control" placeholder="Admin Email" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-lock"></i>
                        <asp:TextBox ID="txtAdminPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnAdminLogin" runat="server" Text="Login as Admin" CssClass="btn btn-primary" OnClick="btnAdminLogin_Click" />
                    </div>

                    <div style="display:flex;flex-direction:column;gap:5px">
                        <div class="form-group" style="text-align:center; margin-top:10px;">
                            <a href="Home.aspx" style="color:#FF6B6B; font-weight:bold; text-decoration:none;">← Back to Home</a>
                        </div>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlSuccess" runat="server" CssClass="form-container-lg" Visible="false">
                    <div style="text-align:center; font-size:2rem; font-weight:bold; color:var(--color-bg-secondary);">
                        🎉 Login Successful! 🎉
                    </div>
                    <p style="text-align:center; font-size:1rem; margin-top:10px;">
                        Redirecting to admin panel...
                    </p>
                </asp:Panel>

                <asp:Panel ID="pnlFail" runat="server" CssClass="form-container-lg" Visible="false">
                    <div style="text-align:center; font-size:2rem; font-weight:bold; color:var(--color-bg-secondary);">
                        ❌ Login Failed! <br />Invalid Credentials
                    </div>
                    <div class="form-group" style="text-align:center; margin-top:20px;">
                        <button type="button" class="btn btn-primary" onclick="window.location='AdminLogin.aspx'">Try Again</button>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <script runat="server">
            protected void Page_PreInit(object sender, EventArgs e)
            {
                this.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
            }
        </script>
    </form>
</body>
</html>