<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgetPassword.aspx.cs" Inherits="vaultx.ForgetPassword" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VaultX - Forgot Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;600&family=Poppins:wght@400;600&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/Register.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="page-flex">
        
            <div class="left-panel-lg">
                <img src="images/reg_img.jpg" alt="VaultX Banner" />
            </div>

            
            <div class="right-panel-login">
            
                <asp:Panel ID="pnlEmail" runat="server" CssClass="form-container-lg">
                    <div class="welcome-msg-pass">
                        RESET YOUR <br /><span>PASSWORD</span>
                    </div>
                   
                    <hr />
                    <div class="form-group">
                        <i class="fa fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your registered email"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="btnSendOtp" runat="server" Text="Send OTP" CssClass="btn" OnClick="btnSendOtp_Click" />
                    </div>
                </asp:Panel>

              
                <asp:Panel ID="pnlOtp" runat="server" CssClass="form-container-lg" Visible="false">
                    <h2>Verify OTP</h2>
                    <p style="text-align:center;">We sent a 6-digit OTP to your email.</p>
                    <div class="form-group">
                        <i class="fa fa-key"></i>
                        <asp:TextBox ID="txtOtp" runat="server" CssClass="form-control" placeholder="Enter OTP"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="btnVerifyOtp" runat="server" Text="Verify OTP" CssClass="btn" OnClick="btnVerifyOtp_Click" />
                    </div>
                </asp:Panel>

 
<asp:Panel ID="pnlReset" runat="server" CssClass="form-container-lg" Visible="false">
    <h2>Reset Password</h2>

    <div class="form-group">
  <i class="fa fa-lock" style="position:absolute; top:10px; left:12px; pointer-events:none; transform:none; color:#aaa; font-size:1rem;"></i>
        <asp:TextBox 
            ID="txtNewPassword" 
            runat="server" 
            CssClass="form-control" 
            TextMode="Password" 
            placeholder="New Password">
        </asp:TextBox>

       
        <asp:RequiredFieldValidator 
            ID="rfvNewPassword" 
            runat="server" 
            ControlToValidate="txtNewPassword"
            ErrorMessage="Password is required" 
            ForeColor="Red" 
            Display="Dynamic" />

        <asp:RegularExpressionValidator 
            ID="revNewPassword" 
            runat="server" 
            ControlToValidate="txtNewPassword"
            ErrorMessage="Password must be at least 8 characters long and include uppercase, lowercase, number, and special character." 
            ForeColor="Red" 
            Display="Dynamic"
            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$">
        </asp:RegularExpressionValidator>
    </div>

    <div class="form-group">
  <i class="fa fa-lock" style="position:absolute; top:10px; left:12px; pointer-events:none; transform:none; color:#aaa; font-size:1rem;"></i>
        <asp:TextBox 
            ID="txtConfirmPassword" 
            runat="server" 
            CssClass="form-control" 
            TextMode="Password" 
            placeholder="Confirm Password">
        </asp:TextBox>

  
        <asp:CompareValidator 
            ID="cvConfirmPassword" 
            runat="server" 
            ControlToValidate="txtConfirmPassword" 
            ControlToCompare="txtNewPassword" 
            ErrorMessage="Passwords do not match" 
            ForeColor="Red" 
            Display="Dynamic" />
    </div>

    <div class="form-group">
        <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="btn" OnClick="btnResetPassword_Click" />
    </div>
</asp:Panel>


                  <asp:Panel ID="wrongotp" runat="server" CssClass="form-container-lg" Visible="false">
      <div style="text-align:center; font-size:2rem; font-weight:bold; color:red;">
          Wrong OTP!<br />
          Try Again.
      </div>
      
  </asp:Panel>


              
                <asp:Panel ID="pnlSuccess" runat="server" CssClass="form-container-lg" Visible="false">
                    <div style="text-align:center; font-size:2rem; font-weight:bold; color:#4ECDC4;">
                        ✅ Password Reset Successfully!
                    </div>
                    <p style="text-align:center; font-size:1rem; margin-top:10px;">
                        You can now <a href="Login.aspx" style="color:#FF6B6B; font-weight:bold;">login</a> with your new password.
                    </p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>