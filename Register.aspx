
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="vaultx.Register" EnableEventValidation="false" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VaultX - Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;600&family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/Register.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

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
                    <div class="logo-container">
                        <img src="images/logo.png" alt="VaultX Logo" class="logo" style="width:200px; height:40px; object-fit:cover;" />
                    </div>

                    <h2>Registration</h2>
                    <hr />


                    <asp:Panel ID="pnlStep1" runat="server"  class="step-panel" >
                    <div class="form-group">
                        <i class="fa fa-user"></i>
                        <asp:TextBox ID="txtFirstName" runat="server" required CssClass="form-control" placeholder="First Name"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-user"></i>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" required placeholder="Last Name"></asp:TextBox>
                    </div>

                    <div class="form-group">
    <i class="fa fa-user"></i>
    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"  placeholder="Father's Name"></asp:TextBox>
</div>

                    <div class="form-group">
    <i class="fa fa-user"></i>
    <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control"  placeholder="Mother's Name"></asp:TextBox>
</div>

                     <div class="form-group">
     <i class="fa fa-calendar"></i>
     <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" placeholder="Date of Birth" ></asp:TextBox>
 </div>

                    <div class="form-group">
                        <i class="fa fa-id-card"></i>
                        <asp:TextBox ID="txtNID" runat="server" CssClass="form-control" placeholder="National ID" required></asp:TextBox>
                    </div>

                   

                    <div class="form-group">
                        <i class="fa fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" required></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revEmail" CssClass="validator-text" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Invalid email format" ForeColor="Red" Display="Dynamic"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                    </div>

                  

                        <asp:Button ID="btnNext1" runat="server" Text="Next →" CssClass="btn btn-primary" OnClientClick="nextStep(1); return false;" />
                        </asp:Panel>



                    <asp:Panel ID="pnlStep2" runat="server" class="step-panel" style="display:none;">


                          <div class="form-group">
      <i class="fa fa-phone"></i>
      <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone Number" required></asp:TextBox>
      <asp:RegularExpressionValidator ID="revPhone" CssClass="validator-text" runat="server" ControlToValidate="txtPhone"
          ErrorMessage="Enter a valid phone number" ForeColor="Red" Display="Dynamic"
          ValidationExpression="^\+?\d{10,15}$" />
  </div>

                        <div class="form-group">
    <i class="fa fa-map-marker-alt"></i>
    <asp:DropDownList ID="ddlDivision" runat="server" CssClass="form-control" AutoPostBack="false" OnChange="populateDistricts()" >
        <asp:ListItem Text="Select Division" Value=""></asp:ListItem>
        <asp:ListItem Text="Dhaka" Value="Dhaka"></asp:ListItem>
        <asp:ListItem Text="Chattogram" Value="Chattogram"></asp:ListItem>
        <asp:ListItem Text="Khulna" Value="Khulna"></asp:ListItem>
       <asp:ListItem Text="Rajshahi" Value="Rajshahi"></asp:ListItem>
         <asp:ListItem Text="Barishal" Value="Barisal"></asp:ListItem>
         <asp:ListItem Text="Sylhet" Value="Sylhet"></asp:ListItem>
         <asp:ListItem Text="Rangpur" Value="Rangpur"></asp:ListItem>
         <asp:ListItem Text="Mymensingh" Value="Mymensingh"></asp:ListItem>
         
    </asp:DropDownList>
</div>

<div class="form-group">
    <i class="fa fa-map-marker-alt"></i>
    <asp:DropDownList ID="ddlDistrict" runat="server" CssClass="form-control" AutoPostBack="false">
        <asp:ListItem Text="Select District" Value=""></asp:ListItem>
    </asp:DropDownList>
</div>
<asp:HiddenField ID="hfDistrict" runat="server" />

<div class="form-group">
    <i class="fa fa-map-marker-alt"></i>
    <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control"  placeholder="Upazilla"></asp:TextBox>
</div>

                        <div class="form-group">
    <i class="fa fa-map-marker-alt"></i>
    <asp:TextBox ID="TextBox4" runat="server" CssClass="form-control"  placeholder="Address"></asp:TextBox>
</div>

                        <div class="form-group">
    <i class="fa fa-map-marker-alt"></i>
    <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control"  placeholder="Postal Code"></asp:TextBox>
</div>

                        <div class="form-group">
    <i class="fa fa-map-marker-alt"></i>
    <asp:TextBox ID="TextBox6" runat="server" CssClass="form-control"  placeholder="Profession"></asp:TextBox>
</div>

                        <div class="form-group">
    <i class="fa fa-map-marker-alt"></i>
    <asp:TextBox ID="TextBox7" runat="server" CssClass="form-control"  placeholder="Monthly Earning"></asp:TextBox>
</div>
                        <div style="display:flex; gap:10px;">
                             <asp:Button ID="btnPre1" runat="server" Text="← Previous" CssClass="btn btn-primary" OnClientClick="preStep(1); return false;" />
                        <asp:Button ID="btnNext2" runat="server" Text="Next →" CssClass="btn btn-primary" OnClientClick="nextStep(2); return false;" />
                            </div>
                        </asp:Panel>








     <asp:Panel ID="pnlStep3" runat="server" class="step-panel" style="display:none;">

         <div class="form-group">
    <i class="fa fa-image"></i>
    <asp:FileUpload ID="fuProfileImage" runat="server" CssClass="form-control" />
             <asp:HiddenField ID="hfProfileImagePath" runat="server" />

</div>



                    <div class="form-group">
        <i class="fa fa-lock"></i>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
            ErrorMessage="Password is required" ForeColor="Red" Display="Dynamic" ValidationGroup="Step3" />
    </div>
                   <div class="form-group">
        <i class="fa fa-lock"></i>
        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Password"></asp:TextBox>
        <asp:HiddenField ID="hfPassword" runat="server" />

                       <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword"
            ControlToCompare="txtPassword" ErrorMessage="Passwords do not match" ForeColor="Red" Display="Dynamic" ValidationGroup="Step3" />
    </div>
           <div style="display:flex; gap:10px;">
       <asp:Button ID="btnPre2" runat="server" Text="← Previous" CssClass="btn btn-primary" OnClientClick="preStep(3); return false;" />
   <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary" ValidationGroup="Step3" OnClick="btnRegister_Click" />
      </div>
                     
</asp:Panel>
         



 
                 

                    <div class="form-group login-link" style="text-align:center; margin-top:9px;">
                     
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
                <img src="images/reg_img2.jpg" alt="VaultX Banner" />
            </div>
        </div>

        <script>

            function nextStep(currentStep) {
               
                var panels = document.querySelectorAll('[id^="pnlStep"]');
                panels.forEach(function (p) {
                    p.style.display = 'none';
                });

                
                var nextPanel = document.getElementById('pnlStep' + (currentStep + 1));
                if (nextPanel) {
                    nextPanel.style.display = 'block';
                }
            }


            function preStep(currentStep) {
               
                var panels = document.querySelectorAll('[id^="pnlStep"]');
                panels.forEach(function (p) {
                    p.style.display = 'none';
                });

                
                var prePanel = document.getElementById('pnlStep' + (currentStep - 1));
                if (prePanel) {
                    prePanel.style.display = 'block';
                } else {
                    
                    var firstPanel = document.getElementById('pnlStep1');
                    if (firstPanel) firstPanel.style.display = 'block';
                }
            }





            const districts = {
                "Barishal": [
                    "Barguna",
                    "Barishal",
                    "Bhola",
                    "Jhalokati",
                    "Patuakhali",
                    "Pirojpur"
                ],
                "Chattogram": [
                    "Bandarban",
                    "Brahmanbaria",
                    "Chandpur",
                    "Chattogram",
                    "Cumilla",
                    "Cox's Bazar",
                    "Feni",
                    "Khagrachhari",
                    "Lakshmipur",
                    "Noakhali",
                    "Rangamati"
                ],
                "Dhaka": [
                    "Dhaka",
                    "Faridpur",
                    "Gazipur",
                    "Gopalganj",
                    "Kishoreganj",
                    "Madaripur",
                    "Manikganj",
                    "Munshiganj",
                    "Narayanganj",
                    "Narsingdi",
                    "Rajbari",
                    "Shariatpur",
                    "Tangail"
                ],
                "Khulna": [
                    "Bagerhat",
                    "Chuadanga",
                    "Jashore",
                    "Jhenaidah",
                    "Khulna",
                    "Kushtia",
                    "Magura",
                    "Meherpur",
                    "Narail",
                    "Satkhira"
                ],
                "Mymensingh": [
                    "Jamalpur",
                    "Mymensingh",
                    "Netrokona",
                    "Sherpur"
                ],
                "Rajshahi": [
                    "Bogura",
                    "Jaipurhat",
                    "Naogaon",
                    "Natore",
                    "Nawabganj",
                    "Pabna",
                    "Rajshahi",
                    "Sirajganj"
                ],
                "Rangpur": [
                    "Dinajpur",
                    "Gaibandha",
                    "Kurigram",
                    "Lalmonirhat",
                    "Nilphamari",
                    "Panchagarh",
                    "Rangpur",
                    "Thakurgaon"
                ],
                "Sylhet": [
                    "Habiganj",
                    "Moulvibazar",
                    "Sunamganj",
                    "Sylhet"
                ]


            };



            document.getElementById('<%= ddlDivision.ClientID %>').addEventListener('change', function () {
                const distDropdown = document.getElementById('<%= ddlDistrict.ClientID %>');
                 
                    distDropdown.innerHTML = '<option value="">Select District</option>';
                  

                    const selectedDivision = this.value;
                    if (districts[selectedDivision]) {
                        districts[selectedDivision].forEach(d => {
                            const option = document.createElement('option');
                            option.text = d;
                            option.value = d;
                            distDropdown.add(option);
                        });
                    }
                });
            
                flatpickr("#<%= txtDOB.ClientID %>", {
                 dateFormat: "d-m-Y",  
             altInput: true,
             altFormat: "d-m-Y",
             allowInput: true
    });
       
           
                function showStep(stepNumber) {
        var steps = [1,2,3,4];
                steps.forEach(function(s){
            var pnl = document.getElementById('pnlStep'+s);
                if(pnl) pnl.style.display = (s === stepNumber) ? 'block' : 'none';
        });
    }
       
            document.getElementById('<%= ddlDistrict.ClientID %>').addEventListener('change', function () {
        document.getElementById('<%= hfDistrict.ClientID %>').value = this.value;
    });

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