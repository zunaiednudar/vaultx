
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="vaultx.Admin" %>
<%@ Register Src="Sidebar.ascx" TagName="Sidebar" TagPrefix="uc" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Panel - Manage Users</title>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;600&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
   <link rel="stylesheet" href="styles/sidebar.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <style>
     * {
    font-family: var(--font-stack);
  
 
}

.admin-banner {
    position: relative;
    width: 100%;
   height:300px;
    max-height: 500px;
    text-align: center;
    margin-bottom: 40px;
    overflow: hidden;

    border-radius: 5px;
}

.admin-banner__image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
    display: block;
    border-radius: var(--radius);
    box-shadow: var(--box-shadow);
}

.admin-banner__overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  
    z-index: 1;
}

.admin-banner__content {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: #fff;
    z-index: 2;
    text-align: center;
    padding: 0 15px;
    text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.7);
}

.admin-banner__title {
    font-size: clamp(1.5rem, 4vw, 3rem);
    margin: 0;
    letter-spacing:15px;

    font-weight: 700;
    text-wrap: nowrap;
}

.admin-banner__subtitle {
    font-size: clamp(1rem, 2.5vw, 1.5rem);
    margin-top: 10px;
    font-weight: 400;
    line-height: 1.3;
}

      
     

            .card {
        cursor: pointer;
        transition: transform 0.3s, box-shadow 0.3s;
        border-radius: 12px;
        text-align: center;
        padding: 40px 20px;
           background-color:dodgerblue;
        color: #fff;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 200px;
         

        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }

       

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
    }

    .card h4 {
        font-size: 1.8rem;
        margin-bottom: 10px;
    }

    .card p {
        font-size: 1.3rem;
        opacity: 0.9;
    }
    .cls{
        background-color:gray;
    }
    .cls:hover{
                background-color:dimgrey;
    }
    
    #usersTableBody{
          font-size: clamp(14px, 2vw, 20px); 
    }

    .btn{
        font-size:clamp(14px, 2vw, 20px); 
 
    }
    /* Responsive adjustments */
    @media (max-width: 768px) {
        .card {
            height: 180px;
            padding: 30px 15px;
        }

        .card h4 {
            font-size: 1.5rem;
        }


        .card p {
            font-size: 0.95rem;
        }
    }

    @media (max-width: 576px) {
        .card {
            height: 160px;
            padding: 25px 10px;
        }

     
        .card h4 {
            font-size: 1.3rem;
        }

        .card p {
            font-size: 0.9rem;
        }
       
    }


    

.file-upload-button {
    width: 100%;
    padding: 5px;
    margin-bottom: 7px;
    margin-top:5px;
    font-size: var(--font-sz-md);
    color: var(--color-font-primary);
    background-color: var(--color-bg-tertiary);
    border: 1px solid var(--color-bg-tertiary);
    border-radius: var(--radius);
    cursor: pointer;
    text-align: center;
    transition: background-color 0.3s ease, transform 0.2s ease;
}

    .file-upload-button:hover {
        background-color: var(--color-bg-secondary);
        transform: scale(1.03);
    }

    .file-upload-button::-webkit-file-upload-button {
        visibility: hidden;
    }

    .file-upload-button::before {
        content: "Choose File";
        display: inline-block;
        width: 100%;
        padding: 5px;
        background-color: var(--color-bg-tertiary);
        color: var(--color-font-primary);
        border-radius: var(--radius);
        text-align: center;
        cursor: pointer;
        font-size: var(--font-sz-md);
    }

    .file-upload-button:hover::before {
        background-color: var(--color-bg-secondary);
        transform: scale(1.03);
    }

.file-name-label {
    display: block;
    margin-top: 5px;
    font-style: italic;
    color: #555;
}

.img-preview {
    margin-top: 10px;
    margin-bottom: 10px;
    border-radius: 8px;
    border: 1px solid #ccc;
    padding: 3px;
}


        body { background-color: #f4f6f9;
                margin-bottom:30px;
        }
        
        .modal-lg { max-width: 900px; }
        #usersList { display: none; }
        .modal-header { background-color: #007BFF; color: #fff; }
        
       .modal-body{
           font-size:16px;
       }
       .form-control{
           font-size:16px;
       }
        .table-hover tbody tr:hover { background-color: rgba(0,123,255,0.1); cursor: pointer; }
        .form-control:focus { border-color: #007BFF; box-shadow: 0 0 5px rgba(0,123,255,.3); }
        .profile-img { width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 2px solid #007BFF; }
        
        .nominee-img { 
            width: 50px; 
            height: 50px; 
            object-fit: cover; 
            border-radius: 4px; 
            border: 1px solid #ddd;
        }
    </style>



</head>
<body>
<form id="form1" runat="server">



    
            <uc:Sidebar ID="Sidebar1" runat="server" />

   <!-- Hamburger button -->
   <button type="button" class="hamburger" onclick="toggleSidebar(event)" aria-label="Toggle sidebar">
       <span class="bar bar1"></span>
       <span class="bar bar2"></span>
       <span class="bar bar3"></span>
   </button>




     <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>
       <!-- Banner -->
       <!-- Banner -->
    <section class="admin-banner">
        <img src="images/admin.jpg" class="admin-banner__image" />
        <div class="admin-banner__overlay" aria-hidden="true"></div>
        <div class="admin-banner__content">
            <h1 class="admin-banner__title">ADMIN PANEL</h1>
           
        </div>
    </section>


<div class="container mt-5">
    <div class="row g-4">
        <!-- Add User Card -->
        <div class="col-md-6">
            <div class="card text-center" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <div class="card-body">
                    <h4 class="card-title"><i class="fa fa-user-plus"></i> Add User</h4>
                    <p class="card-text">Click here to add a new user</p>
                </div>
            </div>
        </div>

        <!-- Show Users Card -->
        <div class="col-md-6">
            <div class="card text-center" onclick="document.getElementById('usersList').style.display='block'">
                <div class="card-body">
                    <h4 class="card-title"><i class="fa fa-users"></i> Show Users</h4>
                    <p class="card-text">Click here to view all users</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Users List -->
<div class="row mt-4" id="usersList">
    
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead class="table-primary">
                <tr>
                    <th>UID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="usersTableBody">
                <!-- Users will be loaded dynamically -->
            </tbody>
        </table>
    </div>
</div>


<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fa fa-user-plus"></i> Add New User</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
            <div class="col-md-6"><label>First Name</label><asp:TextBox ID="txtAddFirstName" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Last Name</label><asp:TextBox ID="txtAddLastName" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Father's Name</label><asp:TextBox ID="txtAddFather" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Mother's Name</label><asp:TextBox ID="txtAddMother" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Date of Birth</label><asp:TextBox ID="txtAddDOB" runat="server" CssClass="form-control" placeholder="Select Date"></asp:TextBox></div>
            <div class="col-md-6"><label>National ID</label><asp:TextBox ID="txtAddNID" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Email</label><asp:TextBox ID="txtAddEmail" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Phone Number</label><asp:TextBox ID="txtAddPhone" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Division</label><asp:TextBox ID="txtAddDivision" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>District</label><asp:TextBox ID="txtAddDistrict" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Upazilla</label><asp:TextBox ID="txtAddUpazilla" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Address</label><asp:TextBox ID="txtAddAddress" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Postal Code</label><asp:TextBox ID="txtAddPostal" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Profession</label><asp:TextBox ID="txtAddProfession" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Monthly Earning</label><asp:TextBox ID="txtAddEarnings" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="col-md-6"><label>Password</label><asp:TextBox ID="txtAddPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox></div>
            <div class="col-md-6">
            
    <label class="form-label">Profile Image</label>
    <asp:FileUpload ID="fuAddProfile" runat="server" CssClass="file-upload-button" onchange="previewImageAdmin(this)" />
    <asp:Label ID="lblFileNameA" runat="server" CssClass="text-muted"></asp:Label>
    <asp:Image ID="imgPreviewA" runat="server" CssClass="img-preview" Style="max-width:150px; display:none;" />


   

       
            </div>
        </div>
      </div>
   

      <div class="modal-footer">
        <asp:Button ID="Button1" runat="server" Text="Add User" CssClass="btn btn-primary" OnClick="btnAddUser_Click" />
        <button type="button" class="btn btn-primary cls" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<!-- Transaction Details Modal -->
<div class="modal fade" id="transactionDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header text-white">
                <h5 class="modal-title"><i class="fa fa-history"></i> Transaction History</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-secondary">
                            <tr>
                                <th>Transaction ID</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Type</th>
                                <th>From Account</th>
                                <th>To Account</th>
                                <th>Reference</th>
                            </tr>
                        </thead>
                        <tbody id="transactionHistoryBody">
                            <!-- Transaction rows will be injected here -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- User Details Modal (View/Edit/Delete) -->
<div class="modal fade" id="userDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fa fa-user"></i> User Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <img id="imgProfile" class="profile-img" src="images/default.png" alt="Profile Picture" />
                  
                </div>
                <div class="row g-3">
                    <div class="col-md-6"><label>First Name</label><asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Last Name</label><asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Father's Name</label><asp:TextBox ID="txtFather" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Mother's Name</label><asp:TextBox ID="txtMother" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Date of Birth</label><asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>National ID</label><asp:TextBox ID="txtNID" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Email</label><asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Phone</label><asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Division</label><asp:TextBox ID="txtDivision" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>District</label><asp:TextBox ID="txtDistrict" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Upazilla</label><asp:TextBox ID="txtUpazilla" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Address</label><asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Postal Code</label><asp:TextBox ID="txtPostal" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Profession</label><asp:TextBox ID="txtProfession" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    <div class="col-md-6"><label>Monthly Earning</label><asp:TextBox ID="txtEarnings" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="showAccountsModal()">Account Details</button>
                <button type="button" class="btn btn-primary" onclick="loadTransactions()">Transaction Details</button>
                <button type="button" id="btnEnableUpdate" class="btn btn-warning" onclick="enableEditStep()">Enable Update</button>
                <button type="button" id="btnUpdate" class="btn btn-primary" style="display:none;" onclick="updateUser()">Update</button>
                <button type="button" class="btn btn-danger" onclick="deleteUser()">Delete</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Account Details Modal -->
<div class="modal fade" id="accountDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa fa-university"></i> Account Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="d-flex justify-content-end mb-3">
                    <button type="button" class="btn btn-success" onclick="showAddAccountModal()">
                        <i class="fa fa-plus"></i> Add New Account
                    </button>
                </div>
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-secondary">
                            <tr>
                                <th>Account ID</th>
                                <th>Account Type</th>
                                <th>Balance</th>
                                <th>Created Date</th>
                                <th>Nominee Name</th>
                             
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="accountsTableBody">
                            <!-- Accounts will be loaded dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Add Account Modal -->
<div class="modal fade" id="addAccountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa fa-plus-circle"></i> Add New Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">Account Type</label>
                    <select id="accountType" class="form-select">
                        <option value="Student">Student</option>
                        <option value="Savings">Savings</option>
                        <option value="Current">Current</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Initial Balance</label>
                    <input type="number" id="initialBalance" class="form-control" value="0" min="0" step="0.01">
                </div>

                <!-- Nominee Image Upload 
                <div class="mb-3">
                    <label class="form-label">Nominee Image</label>
                    <input type="file" id="nomineeImage" class="form-control file-upload-button" accept="image/*" onchange="previewNomineeImage(this)">
                    <div id="nomineeImagePreview" class="img-preview" style="max-width:150px; display:none; margin-top:10px;"></div>
                </div>
                    -->

                <div class="mb-3">
                    <label class="form-label">Nominee Name</label>
                    <input type="text" id="nomineeName" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Nominee NID</label>
                    <input type="text" id="nomineeNID" class="form-control">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" onclick="addAccount()">Add Account</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- Edit Account Modal -->
<div class="modal fade" id="editAccountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark">
                <h5 class="modal-title"><i class="fa fa-edit"></i> Edit Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editAccountId">
                
               
                
                <div class="mb-3">
                    <label class="form-label">Account Type</label>
                    <input type="text" id="editAccountType" class="form-control" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Balance</label>
                    <input type="number" id="editBalance" class="form-control" min="0" step="0.01">
                </div>
                <div class="mb-3">
                    <label class="form-label">Nominee Name</label>
                    <input type="text" id="editNomineeName" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Nominee NID</label>
                    <input type="text" id="editNomineeNID" class="form-control">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="updateAccount()">Update Account</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- jQuery for AJAX -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap JS & Flatpickr -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
      <script src='<%= ResolveUrl("scripts/sidebar.js") %>?v=<%= DateTime.Now.Ticks %>'></script>
<script>
    flatpickr("#<%= txtAddDOB.ClientID %>", { dateFormat: "d-m-Y", altInput: true, altFormat: "d-m-Y", allowInput: true });

    let currentUID = null;

    function showUserDetails(uid, first, last, father, mother, dob, nid, email, phone, division, district, upazilla, address, postal, profession, earnings, profile) {
        currentUID = uid;
        document.getElementById('<%= txtFirstName.ClientID %>').value = first;
        document.getElementById('<%= txtLastName.ClientID %>').value = last;
        document.getElementById('<%= txtFather.ClientID %>').value = father;
        document.getElementById('<%= txtMother.ClientID %>').value = mother;
        document.getElementById('<%= txtDOB.ClientID %>').value = dob;
        document.getElementById('<%= txtNID.ClientID %>').value = nid;
        document.getElementById('<%= txtEmail.ClientID %>').value = email;
        document.getElementById('<%= txtPhone.ClientID %>').value = phone;
        document.getElementById('<%= txtDivision.ClientID %>').value = division;
        document.getElementById('<%= txtDistrict.ClientID %>').value = district;
        document.getElementById('<%= txtUpazilla.ClientID %>').value = upazilla;
        document.getElementById('<%= txtAddress.ClientID %>').value = address;
        document.getElementById('<%= txtPostal.ClientID %>').value = postal;
        document.getElementById('<%= txtProfession.ClientID %>').value = profession;
        document.getElementById('<%= txtEarnings.ClientID %>').value = earnings;
        document.getElementById('imgProfile').src = profile;
        new bootstrap.Modal(document.getElementById('userDetailsModal')).show();
    }

    function enableEditStep() {
        let fields = ['<%= txtFirstName.ClientID %>', '<%= txtLastName.ClientID %>', '<%= txtFather.ClientID %>', '<%= txtMother.ClientID %>', '<%= txtDOB.ClientID %>', '<%= txtNID.ClientID %>', '<%= txtEmail.ClientID %>', '<%= txtPhone.ClientID %>', '<%= txtDivision.ClientID %>', '<%= txtDistrict.ClientID %>', '<%= txtUpazilla.ClientID %>', '<%= txtAddress.ClientID %>', '<%= txtPostal.ClientID %>', '<%= txtProfession.ClientID %>', '<%= txtEarnings.ClientID %>'];
        fields.forEach(id => document.getElementById(id).removeAttribute('readonly'));
        document.getElementById('btnEnableUpdate').style.display = 'none';
        document.getElementById('btnUpdate').style.display = 'inline-block';
    }
    
    function updateUser() {
        if (!currentUID) return;

        const userData = {
            uid: currentUID,
            firstName: document.getElementById('<%= txtFirstName.ClientID %>').value,
            lastName: document.getElementById('<%= txtLastName.ClientID %>').value,
            fatherName: document.getElementById('<%= txtFather.ClientID %>').value,
            motherName: document.getElementById('<%= txtMother.ClientID %>').value,
            dob: document.getElementById('<%= txtDOB.ClientID %>').value,
            nid: document.getElementById('<%= txtNID.ClientID %>').value,
            email: document.getElementById('<%= txtEmail.ClientID %>').value,
            phone: document.getElementById('<%= txtPhone.ClientID %>').value,
            division: document.getElementById('<%= txtDivision.ClientID %>').value,
            district: document.getElementById('<%= txtDistrict.ClientID %>').value,
            upazilla: document.getElementById('<%= txtUpazilla.ClientID %>').value,
            address: document.getElementById('<%= txtAddress.ClientID %>').value,
            postal: document.getElementById('<%= txtPostal.ClientID %>').value,
            profession: document.getElementById('<%= txtProfession.ClientID %>').value,
            earnings: document.getElementById('<%= txtEarnings.ClientID %>').value
        };

        $.ajax({
            type: "POST",
            url: "Admin.aspx/UpdateUser",
            data: JSON.stringify(userData),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d === "success") {
                    alert("User updated successfully!");
                    location.reload();
                } else {
                    alert(response.d);
                }
            },
            error: function (error) {
                alert("Error updating user: " + error.statusText);
            }
        });
    }

    function deleteUser() {
        if (!currentUID) return;

        if (confirm("Are you sure you want to delete this user? This will also delete all associated accounts and transactions.")) {
            $.ajax({
                type: "POST",
                url: "Admin.aspx/DeleteUser",
                data: JSON.stringify({ uid: currentUID }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        alert("User deleted successfully!");
                        location.reload();
                    } else {
                        alert(response.d);
                    }
                },
                error: function (error) {
                    alert("Error deleting user: " + error.statusText);
                }
            });
        }
    }

    function loadTransactions() {
        if (!currentUID) return;

        $.ajax({
            type: "POST",
            url: "Admin.aspx/GetUserTransactions",
            data: JSON.stringify({ uid: currentUID }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                const transactions = JSON.parse(response.d);
                const tbody = document.getElementById('transactionHistoryBody');
                tbody.innerHTML = '';

                if (transactions.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="7" class="text-center">No transactions found</td></tr>';
                } else {
                    transactions.forEach(tx => {
                        const row = `<tr>
                            <td>${tx.tid}</td>
                            <td>${new Date(tx.date).toLocaleDateString()}</td>
                            <td>৳ ${parseFloat(tx.amount).toFixed(2)}</td>
                            <td>${tx.type}</td>
                            <td>${tx.from}</td>
                            <td>${tx.to}</td>
                            <td>${tx.ref || ''}</td>
                        </tr>`;
                        tbody.insertAdjacentHTML('beforeend', row);
                    });
                }

                // Close user modal and open transaction modal
                bootstrap.Modal.getInstance(document.getElementById('userDetailsModal')).hide();
                new bootstrap.Modal(document.getElementById('transactionDetailsModal')).show();
            },
            error: function (error) {
                alert("Error loading transactions: " + error.statusText);
            }
        });
    }

   

    // Account management functions
    function showAccountsModal() {
        if (!currentUID) return;

        // Load accounts for this user
        loadUserAccounts(currentUID);

        // Close user details modal and open accounts modal
        bootstrap.Modal.getInstance(document.getElementById('userDetailsModal')).hide();
        new bootstrap.Modal(document.getElementById('accountDetailsModal')).show();
    }

    function loadUserAccounts(userId) {
        $.ajax({
            type: "POST",
            url: "Admin.aspx/GetUserAccounts",
            data: JSON.stringify({ uid: userId }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                const accounts = JSON.parse(response.d);
                const tbody = document.getElementById('accountsTableBody');
                tbody.innerHTML = '';

                if (accounts.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="7" class="text-center">No accounts found</td></tr>';
                } else {
                    accounts.forEach(acc => {
                        const row = `<tr>
                            <td>${acc.aid}</td>
                            <td>${acc.accountType}</td>
                            <td>৳ ${parseFloat(acc.balance).toFixed(2)}</td>
                            <td>${new Date(acc.createdAt).toLocaleDateString()}</td>
                            <td>${acc.nomineeName || ''}</td>
                
                            <td>
                                <button type="button" class="btn btn-sm btn-warning" onclick="showEditAccountModal(${acc.aid}, '${acc.accountType}', ${acc.balance}, '${acc.nomineeName || ''}', '${acc.nomineeNid || ''}', '${acc.nomineeImage || ''}')">
                                    <i class="fa fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-danger ms-1" onclick="deleteAccount(${acc.aid})">
                                    <i class="fa fa-trash"></i>
                                </button>
                            </td>
                        </tr>`;
                        tbody.insertAdjacentHTML('beforeend', row);
                    });
                }
            },
            error: function (error) {
                alert("Error loading accounts: " + error.statusText);
            }
        });
    }

    function showAddAccountModal() {
        // Reset form
        document.getElementById('accountType').value = 'Savings';
        document.getElementById('initialBalance').value = '0';
        document.getElementById('nomineeName').value = '';
        document.getElementById('nomineeNID').value = '';
 

        // Close accounts modal and open add account modal
        bootstrap.Modal.getInstance(document.getElementById('accountDetailsModal')).hide();
        new bootstrap.Modal(document.getElementById('addAccountModal')).show();
    }

    function addAccount() {
        if (!currentUID) {
            alert("No user selected!");
            return;
        }

        const accountType = document.getElementById('accountType').value;
        const balance = document.getElementById('initialBalance').value;
        const nomineeName = document.getElementById('nomineeName').value;
        const nomineeNID = document.getElementById('nomineeNID').value;

        const accountData = {
            uid: currentUID,
            accountType: accountType,
            balance: balance,
            nomineeName: nomineeName,
            nomineeNID: nomineeNID
        };

        console.log("Sending account data:", accountData);

        $.ajax({
            type: "POST",
            url: "Admin.aspx/AddAccount",
            data: JSON.stringify(accountData),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                console.log("Response:", response);
                if (response.d === "success") {
                    alert("Account added successfully!");
                    bootstrap.Modal.getInstance(document.getElementById('addAccountModal')).hide();
                    showAccountsModal();
                } else {
                    alert("Error: " + response.d);
                }
            },
            error: function (xhr, status, error) {
                console.log("AJAX Error:", xhr.responseText);
                alert("Error adding account. Check console for details.");
            }
        });
    }

    function showEditAccountModal(aid, accountType, balance, nomineeName, nomineeNID, nomineeImage) {
        document.getElementById('editAccountId').value = aid;
        document.getElementById('editAccountType').value = accountType;
        document.getElementById('editBalance').value = balance;
        document.getElementById('editNomineeName').value = nomineeName || '';
        document.getElementById('editNomineeNID').value = nomineeNID || '';
        
      

        bootstrap.Modal.getInstance(document.getElementById('accountDetailsModal')).hide();
        new bootstrap.Modal(document.getElementById('editAccountModal')).show();
    }

    function updateAccount() {
        const accountId = document.getElementById('editAccountId').value;
        const balance = document.getElementById('editBalance').value;
        const nomineeName = document.getElementById('editNomineeName').value;
        const nomineeNID = document.getElementById('editNomineeNID').value;

        const accountData = {
            aid: accountId,
            balance: balance,
            nomineeName: nomineeName,
            nomineeNID: nomineeNID
        };

        console.log("Updating account:", accountData);

        $.ajax({
            type: "POST",
            url: "Admin.aspx/UpdateAccount",
            data: JSON.stringify(accountData),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                console.log("Update response:", response);

                if (response.d === "success") {
                    alert("Account updated successfully!");
                    bootstrap.Modal.getInstance(document.getElementById('editAccountModal')).hide();
                    showAccountsModal();
                } else {
                    alert("Error: " + response.d);
                }
            },
            error: function (xhr, status, error) {
                console.log("AJAX Error:", xhr.responseText);
                alert("Error updating account: " + error);
            }
        });
    }

    function deleteAccount(aid) {
        if (confirm("Are you sure you want to delete this account? This will also delete all associated transactions.")) {
            $.ajax({
                type: "POST",
                url: "Admin.aspx/DeleteAccount",
                data: JSON.stringify({ aid: aid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        alert("Account deleted successfully!");
                        // Refresh accounts
                        loadUserAccounts(currentUID);
                    } else {
                        alert(response.d);
                    }
                },
                error: function (error) {
                    alert("Error deleting account: " + error.statusText);
                }
            });
        }
    }

    function previewImageAdmin(input) {
        const file = input.files[0];
        if (file) {
            document.getElementById('<%= lblFileNameA.ClientID %>').innerText = file.name;
            const imgPreviewA = document.getElementById('<%= imgPreviewA.ClientID %>');
            imgPreviewA.src = URL.createObjectURL(file);
            imgPreviewA.style.display = "block";
        }
    }

    // Alias for backward compatibility
    function transaction() {
        loadTransactions();
    }
</script>
</form>
</body>
</html>
