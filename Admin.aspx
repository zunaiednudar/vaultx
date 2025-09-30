<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="vaultx.Admin" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Panel - Manage Users</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <style>
        .card {
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            border-radius: 12px;
            text-align: center;
            padding: 40px 20px;
            background: linear-gradient(135deg, #4ECDC4, #5567FC);
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
            font-size: 1rem;
            opacity: 0.9;
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


        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        .modal-lg { max-width: 900px; }
        #usersList { display: none; }
        .modal-header { background-color: #007BFF; color: #fff; }
        .btn-gradient { background: linear-gradient(90deg,#4ECDC4,#55EFC4); border: none; color: #fff; }
        .btn-gradient:hover { opacity: 0.9; }
        .table-hover tbody tr:hover { background-color: rgba(0,123,255,0.1); cursor: pointer; }
        .form-control:focus { border-color: #007BFF; box-shadow: 0 0 5px rgba(0,123,255,.3); }
        .profile-img { width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 2px solid #007BFF; }
    </style>
</head>
<body>
<form id="form1" runat="server">

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
        <h3 class="mb-3">Users</h3>
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
                <label>Profile Picture</label>
                <asp:FileUpload ID="fuAddProfile" runat="server" CssClass="form-control"/>
            </div>
        </div>
      </div>
      <div class="modal-footer">
        <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn btn-success btn-gradient" OnClick="btnAddUser_Click" />
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<!-- Transaction Details Modal -->
<div class="modal fade" id="transactionDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
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
                <div class="text-center mb-3">
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

                <button type="button" class="btn btn-primary" onclick="loadTransactions()">Transaction Details</button>
                <button type="button" id="btnEnableUpdate" class="btn btn-warning" onclick="enableEditStep()">Enable Update</button>
                <button type="button" id="btnUpdate" class="btn btn-primary" style="display:none;" onclick="updateUser()">Update</button>

                <button type="button" class="btn btn-danger" onclick="deleteUser()">Delete</button>
                
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- jQuery for AJAX -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap JS & Flatpickr -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

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

    // Alias for backward compatibility
    function transaction() {
        loadTransactions();
    }
</script>
</form>
</body>
</html>