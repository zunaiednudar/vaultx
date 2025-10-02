<%@ Page Language="C#" AutoEventWireup="true" %>

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

        .mb-3 {
            text-align: center;
            font-size: 40px;
            font-weight:bold;
            letter-spacing:10px;
            color:white;
            padding: 5px;
            background-color: var(--color-bg-secondary);
            border-radius:5px;
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
    
    tr{
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

        #phn {
            display: none;
        }
        .card h4 {
            font-size: 1.3rem;
        }

        .card p {
            font-size: 0.9rem;
        }
       
    }


        body { background-color: #f4f6f9;
                margin-bottom:30px;
        }
        
        .modal-lg { max-width: 900px; }
        #usersList { display: none; }
        .modal-header { background-color: #007BFF; color: #fff; }
        
       .modal-body{
           font-size:20px;
       }
       .form-control{
           font-size:20px;
       }
        .table-hover tbody tr:hover { background-color: rgba(0,123,255,0.1); cursor: pointer; }
        .form-control:focus { border-color: #007BFF; box-shadow: 0 0 5px rgba(0,123,255,.3); }
        .profile-img { width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 2px solid #007BFF; }
    </style>
</head>
<body>
<form id="form1" runat="server">
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
        <h3 class="mb-3">USERS</h3>
        <table class="table table-striped table-hover">
            <thead class="table-primary">
                <tr>
                    <th>UID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th id="phn">Phone</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <tr onclick="showUserDetails('1','John','Doe','Father John','Mother Doe','01-01-1990','1234567890123','john@example.com','1234567890','Dhaka','Dhaka','Dhanmondi','Road 1','1205','Engineer','50000','images/default.png')">
                    <td>1</td>
                    <td>John</td>
                    <td>Doe</td>
                    <td>john@example.com</td>
                    <td id="phn">1234567890</td>
                    <td><button type="button" class="btn btn-sm btn-primary">More Details</button></td>
                </tr>
                <tr onclick="showUserDetails('2','Jane','Smith','Father Smith','Mother Jane','15-05-1992','9876543210987','jane@example.com','0987654321','Chattogram','Chattogram','Pahartali','Street 5','4000','Teacher','40000','images/default.png')">
                    <td>2</td>
                    <td>Jane</td>
                    <td>Smith</td>
                    <td>jane@example.com</td>
                    <td id="phn">0987654321</td>
                    <td><button type="button" class="btn btn-sm btn-primary">More Details</button></td>
                </tr>
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
                <label>Profile Picture</label>
                <asp:FileUpload ID="fuAddProfile" runat="server" CssClass="form-control"/>
            </div>
        </div>
      </div>
      <div class="modal-footer">
        <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn btn-primary" />
        <button type="button" class="btn btn-primary cls" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


    <!-- Transaction Details Modal -->
<div class="modal fade" id="transactionDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header  text-white">
                <h5 class="modal-title"><i class="fa fa-history"></i> Transaction History</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
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
                    <div class="mt-2">
                        <label class="btn btn-sm btn-outline-primary mb-0">
                            Change Picture <asp:FileUpload ID="fuProfile" runat="server" CssClass="d-none"/>
                        </label>
                    </div>
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
                       <button type="button" class="btn btn-primary" 
        onclick="window.location.href='Admin_Accounts.aspx';">
    Account Details
</button>

                        <button type="button" class="btn btn-primary" onclick="transaction()">Transaction Details</button>
              <button type="button" id="btnEnableUpdate" class="btn btn-warning" onclick="enableEditStep()">Enable Update</button>
                <button type="button" id="btnUpdate" class="btn btn-primary" style="display:none;" onclick="">Update</button>

                <button type="button" class="btn btn-danger" onclick="">Delete</button>
              
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS & Flatpickr -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<script>
    flatpickr("#<%= txtAddDOB.ClientID %>", { dateFormat: "d-m-Y", altInput: true, altFormat: "d-m-Y", allowInput: true });

    function showUserDetails(uid, first, last, father, mother, dob, nid, email, phone, division, district, upazilla, address, postal, profession, earnings, profile) {
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
    function transaction() {
        // Close any other modals that might be open
        const userModalEl = document.getElementById('userDetailsModal');
        const userModal = bootstrap.Modal.getInstance(userModalEl);
        if (userModal) {
            userModal.hide();
        }

        const addUserModalEl = document.getElementById('addUserModal');
        const addUserModal = bootstrap.Modal.getInstance(addUserModalEl);
        if (addUserModal) {
            addUserModal.hide();
        }

        // Example static data for demo, replace with server-side data
        const transactions = [
            { tid: 'TX1001', date: '2025-09-28', amount: 5000, type: 'Credit', from: '12345', to: '67890', ref: 'Salary' },
            { tid: 'TX1002', date: '2025-09-27', amount: 1500, type: 'Debit', from: '12345', to: '98765', ref: 'Bill Payment' }
        ];

        const tbody = document.getElementById('transactionHistoryBody');
        tbody.innerHTML = ''; // Clear previous rows

        transactions.forEach(tx => {
            const row = `<tr>
            <td>${tx.tid}</td>
            <td>${tx.date}</td>
            <td>৳ ${tx.amount.toFixed(2)}</td>
            <td>${tx.type}</td>
            <td>${tx.from}</td>
            <td>${tx.to}</td>
            <td>${tx.ref}</td>
        </tr>`;
            tbody.insertAdjacentHTML('beforeend', row);
        });

        // Open the transaction modal
        new bootstrap.Modal(document.getElementById('transactionDetailsModal')).show();
    }




    function deleteUser() {
        if (confirm("Are you sure you want to delete this user?")) {
            alert("User deleted successfully.");
            document.getElementById('userDetailsModal').querySelector('.btn-close').click();
        }
    }
</script>
</form>
</body>
</html>
