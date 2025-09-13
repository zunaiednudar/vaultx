<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="vaultx.Register" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VaultX - Register</title>
    <!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;600&family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="styles/global.css" type="text/css" />
  <link rel="stylesheet" href="styles/Register.css?v=<%= DateTime.Now.Ticks %>"  />
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <script runat="server">
            protected void Page_PreInit(object sender, EventArgs e)
            {
                this.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
            }
        </script>

        <div class="page-flex">
            <!-- Left: Form -->
            <div class="left-panel">
                
                <div class="form-container">
             <div class="logo-container" style="position:fixed; top:10px; left:50%; transform:translateX(-360%); z-index:10; background:white; padding:5px; border-radius:10px;">
    <img src="assets/logo.png" alt="VaultX Logo" class="logo" style="width:200px; height:40px; object-fit:cover;" />
</div>

                    <h2>Registration</h2>
                    <hr />

                    <!-- First Name -->
                    <div class="form-group">
                        <i class="fa fa-user"></i>
                        <asp:TextBox ID="txtFirstName" runat="server" required CssClass="form-control" placeholder="First Name"></asp:TextBox>
                 
                    </div>

                    <!-- Last Name -->
                    <div class="form-group">
                        <i class="fa fa-user"></i>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" required placeholder="Last Name"></asp:TextBox>
                   
                    </div>

                    <!-- NID -->
<div class="form-group">
    <i class="fa fa-id-card"></i>
    <asp:TextBox ID="txtNID" runat="server" CssClass="form-control" placeholder="National ID " required></asp:TextBox>

</div>

<!-- Date of Birth -->
<div class="form-group">
    <i class="fa fa-calendar"></i>
    <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" placeholder="Date of Birth" TextMode="Date"></asp:TextBox>
</div>


                    <!-- Email -->
                    <div class="form-group">
                        <i class="fa fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" required></asp:TextBox>
                     
                        <asp:RegularExpressionValidator ID="revEmail" CssClass="validator-text" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                    </div>

                    <!-- Phone -->
                    <div class="form-group">
                        <i class="fa fa-phone"></i>
                        
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone Number" required></asp:TextBox>
                      
                        <asp:RegularExpressionValidator ID="revPhone" CssClass="validator-text" runat="server" ControlToValidate="txtPhone"
                            ErrorMessage="Enter a valid phone number" ForeColor="Red" Display="Dynamic"
                                ValidationExpression="^\+?\d{10,15}$"  />
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <i class="fa fa-lock"></i>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPassword" CssClass="validator-text" runat="server" ControlToValidate="txtPassword"
                            ErrorMessage="Password is required" ForeColor="Red" Display="Dynamic" />
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <i class="fa fa-lock"></i>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Password"></asp:TextBox>
                        <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword"
                            ControlToCompare="txtPassword" ErrorMessage="Passwords do not match" ForeColor="Red" Display="Dynamic" />
                    </div>

               
<div class="form-group">
    <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary" OnClick="btnRegister_Click" />
</div>

<div class="form-group login-link" style="text-align:center; margin-top:2px;">
    <span id="ar">Already registered? </span>
    <a href="Login.aspx" style="color:#FF6B6B; font-weight:bold; text-decoration:none;">Login</a>
</div>

                </div>
            </div>
            
            <!-- Right: Image -->
            <div class="right-panel">
                <img src="assets/reg_img2.jpg" alt="VaultX Banner" />
            </div>
        </div>
    </form>
</body>
</html>
