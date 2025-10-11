<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="vaultx.Login" %>
<%@ Register Src="Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VaultX - Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
 <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
 <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:ital,wght@0,100..700;1,100..700&display=swap" rel="stylesheet" />

  <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/Register.css?v=<%= DateTime.Now.Ticks %>" />
      <link rel="stylesheet" href="styles/sidebar.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfEmail" runat="server" />


            <uc:Sidebar ID="Sidebar1" runat="server" />

   
   <button type="button" class="hamburger" onclick="toggleSidebar(event)" aria-label="Toggle sidebar">
       <span class="bar bar1"></span>
       <span class="bar bar2"></span>
       <span class="bar bar3"></span>
   </button>

        <div class="page-flex">

           
    <div class="left-panel-lg"> 
        <img src="images/reg_img.jpg" alt="VaultX Banner" /> 

    </div>

           
            <div class="right-panel-login" style="flex:1; display:flex; justify-content:center; align-items:center; background:#f5f5f5;">
               
    
               
                <asp:Panel ID="pnlLoginForm" runat="server" CssClass="form-container-lg">
                    <div class="welcome-msg">
                        WELCOME TO <br /><span>VaultX</span>
                    </div>

                    <h2 style="text-align:center;">Login</h2>
                    <hr />

                    <div class="form-group">
                        <i class="fa fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-lock"></i>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" required></asp:TextBox>
                    </div>

                    <div class="form-group" style="text-align:left; margin-bottom:20px;">
                        <asp:CheckBox ID="chkRememberMe" runat="server" Text=" Remember Me" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
                    </div>

                    <div style="display:flex;flex-direction:column;gap:5px">
                        <div class="form-group" style="text-align:center; margin-top:10px;">
                            <a href="ForgetPassword.aspx" style="color:#FF6B6B; font-weight:bold; text-decoration:none;">Forgot Password?</a>
                        </div>
                        <div class="form-group" style="text-align:center; margin-top:10px;">
                            <span>Not registered? </span>
                            <a href="Register.aspx" style="color:#FF6B6B; font-weight:bold; text-decoration:none;">Register</a>
                        </div>
                    </div>
                </asp:Panel>

               
  <asp:Panel ID="pnlSuccess" runat="server" CssClass="form-container-lg" Visible="false">
                    <div style="text-align:center; font-size:2rem; font-weight:bold; color:var(--color-bg-secondary);">
                        🎉 Login Successful! 🎉
                    </div>
                    <p style="text-align:center; font-size:1rem; margin-top:10px;">
                        Redirecting to your dashboard...
                    </p>
                </asp:Panel>


     <asp:Panel ID="pnlfail" runat="server" CssClass="form-container-lg" Visible="false">
                    <div style="text-align:center; font-size:2rem; font-weight:bold; color:var(--color-bg-secondary);">
                         ❌ Login Failed! <br />Try Again
                    </div>
                  
                </asp:Panel>

            </div>
        </div>
           <script src='<%= ResolveUrl("scripts/sidebar.js") %>?v=<%= DateTime.Now.Ticks %>'></script>
        <script runat="server">
            protected void Page_PreInit(object sender, EventArgs e)
            {
                this.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
            }
        </script>
    </form>
</body>
</html>
