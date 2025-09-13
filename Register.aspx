<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="vaultx.Register" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VaultX - Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;600&family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles/global.css" type="text/css" />
    <link rel="stylesheet" href="styles/Register.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .otp-box { width: 40px; height: 50px; text-align:center; font-size:1.5rem; border:1px solid #ccc; border-radius:8px; }
        .otp-box:focus { border-color:#4ECDC4; outline:none; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfEmail" runat="server" />
        <asp:HiddenField ID="hfEnteredOtp" runat="server" />
        <asp:Button ID="btnVerifyOtp" runat="server" OnClick="btnVerifyOtp_Click" Style="display:none;" />

        <script runat="server">
            protected void Page_PreInit(object sender, EventArgs e)
            {
                this.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
            }
        </script>

        <div class="page-flex">
            <div class="left-panel">

               
                <div class="form-container" id="regForm">
                    <div class="logo-container" style="position:fixed; top:10px; left:50%; transform:translateX(-360%); z-index:10; background:white; padding:5px; border-radius:10px;">
                        <img src="assets/logo.png" alt="VaultX Logo" class="logo" style="width:200px; height:40px; object-fit:cover;" />
                    </div>

                    <h2>Registration</h2>
                    <hr />

                    <div class="form-group">
                        <i class="fa fa-user"></i>
                        <asp:TextBox ID="txtFirstName" runat="server" required CssClass="form-control" placeholder="First Name"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-user"></i>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" required placeholder="Last Name"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-id-card"></i>
                        <asp:TextBox ID="txtNID" runat="server" CssClass="form-control" placeholder="National ID" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-calendar"></i>
                        <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" placeholder="Date of Birth" TextMode="Date"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" required></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revEmail" CssClass="validator-text" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                    </div>

                    <div class="form-group">
                        <i class="fa fa-phone"></i>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone Number" required></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revPhone" CssClass="validator-text" runat="server" ControlToValidate="txtPhone"
                            ErrorMessage="Enter a valid phone number" ForeColor="Red" Display="Dynamic"
                            ValidationExpression="^\+?\d{10,15}$" />
                    </div>

                    <div class="form-group">
                        <i class="fa fa-lock"></i>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPassword" CssClass="validator-text" runat="server" ControlToValidate="txtPassword"
                            ErrorMessage="Password is required" ForeColor="Red" Display="Dynamic" />
                    </div>

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

              




                <div class="form-container" id="otpForm" style="display:none;">
                    <h2 style="text-align:center;">Verify OTP</h2>
                    <p style="font-size:0.9rem; text-align:center;">We sent a 6-digit OTP to your email.</p>
                    <div style="display:flex; justify-content:center; gap:10px; margin:15px 0;">
                        <input type="text" maxlength="1" class="otp-box" id="otp1" onkeyup="moveNext(this,1)" />
                        <input type="text" maxlength="1" class="otp-box" id="otp2" onkeyup="moveNext(this,2)" />
                        <input type="text" maxlength="1" class="otp-box" id="otp3" onkeyup="moveNext(this,3)" />
                        <input type="text" maxlength="1" class="otp-box" id="otp4" onkeyup="moveNext(this,4)" />
                        <input type="text" maxlength="1" class="otp-box" id="otp5" onkeyup="moveNext(this,5)" />
                        <input type="text" maxlength="1" class="otp-box" id="otp6" onkeyup="moveNext(this,6)" />
                    </div>
                    <button type="button" onclick="submitOtp()" style="padding:12px; background:linear-gradient(90deg,#4ECDC4,#55EFC4); color:#fff; border:none; border-radius:10px; cursor:pointer; width:100%; font-weight:bold;">Submit OTP</button>
                    <p id="otpMsg" style="color:red; margin-top:10px; text-align:center;"></p>
                    <p id="timer" style="text-align:center; margin-top:10px; font-size:0.9rem; color:#555;"></p>
                </div>

            </div>

            <div class="right-panel">
                <img src="assets/reg_img2.jpg" alt="VaultX Banner" />
            </div>
        </div>

        <script>
            function moveNext(current, index)
            {
                if(current.value.length === 1 && index < 6) document.getElementById('otp' + (index+1)).focus();
            }
            function submitOtp()
            {
                var otp = '';
                for (var i = 1; i <= 6; i++) otp += document.getElementById('otp' + i).value;
                document.getElementById('<%= hfEnteredOtp.ClientID %>').value = otp;
                __doPostBack('<%= btnVerifyOtp.UniqueID %>', '');
            }

        </script>
    </form>
</body>
</html>
