<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin_Accounts.aspx.cs" Inherits="vaultx.Admin_Accounts" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Accounts</title>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;600&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
     
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <style>
* {
    font-family: var(--font-stack);
}



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





        body { background-color: #f4f6f9;

        }

        .modal-lg { max-width: 900px; }
        #accountsList { display: none; }
        .modal-header { background-color: #007BFF; color: #fff; }
        .btn-gradient { background: linear-gradient(90deg,#4ECDC4,#55EFC4); border: none; color: #fff; }
        .btn-gradient:hover { opacity: 0.9; }
        .table-hover tbody tr:hover { background-color: rgba(0,123,255,0.1); cursor: pointer; }
        .form-control:focus { border-color: #007BFF; box-shadow: 0 0 5px rgba(0,123,255,.3); }
        .profile-img { width: 120px; height: 120px; object-fit: cover; border-radius: 50%; border: 2px solid #007BFF; }
        .section-title { font-weight: 600; margin-bottom: 1rem; color: #007BFF; }
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="container mt-5">

    <!-- Top Cards -->
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card text-center" data-bs-toggle="modal" data-bs-target="#createAccountModal">
                <div class="card-body">
                    <h4 class="card-title"><i class="fa fa-user-plus"></i> Create Account</h4>
                    <p class="card-text">Click here to create a new account</p>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card text-center" onclick="document.getElementById('accountsList').style.display='block'">
                <div class="card-body">
                    <h4 class="card-title"><i class="fa fa-wallet"></i> Show Accounts</h4>
                    <p class="card-text">Click here to view all accounts</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Accounts List -->
    <div class="row mt-4" id="accountsList">
        <h3 class="mb-3">Accounts</h3>
        <table class="table table-striped table-hover">
            <thead class="table-primary">
                <tr>
                    <th>Account Number</th>
                    <th>Type</th>
                    <th>Holder</th>
                    <th>Balance</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr onclick="showAccountDetails('1001','Savings','John Doe','50000','Jane Doe','1234567890','images/nominee1.png')">
                    <td>1001</td>
                    <td>Savings</td>
                    <td>John Doe</td>
                    <td>50,000</td>
                    <td><button type="button" class="btn btn-sm btn-primary">More Details</button></td>
                </tr>
                <tr onclick="showAccountDetails('1002','Current','Jane Smith','120000','John Smith','0987654321','images/nominee2.png')">
                    <td>1002</td>
                    <td>Current</td>
                    <td>Jane Smith</td>
                    <td>120,000</td>
                    <td><button type="button" class="btn btn-sm btn-primary">More Details</button></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<!-- Create Account Modal -->
<div class="modal fade" id="createAccountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="fa fa-user-plus"></i> Create New Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6"><label>Account Number</label><asp:TextBox ID="txtAccountNumberCreate" runat="server" CssClass="form-control" /></div>
                    <div class="col-md-6"><label>Account Type</label>
                        <asp:DropDownList ID="ddlAccountTypeCreate" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Select Type" Value="" />
                            <asp:ListItem Text="Savings" Value="Savings" />
                            <asp:ListItem Text="Current" Value="Current" />
                            <asp:ListItem Text="Fixed Deposit" Value="Fixed Deposit" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6"><label>Holder Name</label><asp:TextBox ID="txtAccountHolderCreate" runat="server" CssClass="form-control" /></div>
                    <div class="col-md-6"><label>Balance</label><asp:TextBox ID="txtAccountBalanceCreate" runat="server" CssClass="form-control" /></div>

                    <h5 class="section-title">Nominee Details</h5>
                    <div class="col-md-6"><label>Nominee Name</label><asp:TextBox ID="txtNomineeNameCreate" runat="server" CssClass="form-control" /></div>
                    <div class="col-md-6"><label>Nominee NID</label><asp:TextBox ID="txtNomineeNIDCreate" runat="server" CssClass="form-control" /></div>
                    <div class="col-md-6">
                        <label>Nominee Picture</label>
                        <asp:FileUpload ID="fuNomineeCreate" runat="server" CssClass="form-control" onchange="previewNomineeCreate(this)" />
                        <img id="imgNomineePreview" class="profile-img mt-2" style="display:none;" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnCreateAccount" runat="server" Text="Create Account" CssClass="btn btn-success btn-gradient" />
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
                <h5 class="modal-title"><i class="fa fa-wallet"></i> Account Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h5 class="section-title">Account Info</h5>
                <div class="row g-3">
                    <div class="col-md-6"><label>Account Number</label><asp:TextBox ID="txtAccountNumber" runat="server" CssClass="form-control" ReadOnly="true" /></div>
                    <div class="col-md-6"><label>Account Type</label><asp:TextBox ID="txtAccountType" runat="server" CssClass="form-control" ReadOnly="true" /></div>
                    <div class="col-md-6"><label>Holder Name</label><asp:TextBox ID="txtAccountHolder" runat="server" CssClass="form-control" ReadOnly="true" /></div>
                    <div class="col-md-6"><label>Balance</label><asp:TextBox ID="txtAccountBalance" runat="server" CssClass="form-control" ReadOnly="true" /></div>
                </div>

                <h5 class="section-title mt-4">Nominee Details</h5>
                <div class="row g-3">
                    <div class="col-md-6"><label>Nominee Name</label><asp:TextBox ID="txtNomineeName" runat="server" CssClass="form-control" ReadOnly="true" /></div>
                    <div class="col-md-6"><label>Nominee NID</label><asp:TextBox ID="txtNomineeNID" runat="server" CssClass="form-control" ReadOnly="true" /></div>
                    <div class="col-md-6">
                        
                        <img id="imgNominee" class="profile-img" />
                        <div class="mt-2">
                            <label class="btn btn-sm btn-outline-primary mb-0">
                                Change Picture <asp:FileUpload ID="fuNomineeUpdate" runat="server" CssClass="d-none"/>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
 <button type="button" id="btnEnableUpdate" class="btn btn-warning" onclick="enableEditStep()">Enable Update</button>
                <button type="button" id="btnUpdate" class="btn btn-primary" style="display:none;" onclick="">Update</button>
                <button type="button" class="btn btn-danger" onclick="">Delete</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function previewNomineeCreate(input) {
        const img = document.getElementById('imgNomineePreview');
        if (input.files && input.files[0]) {
            img.src = URL.createObjectURL(input.files[0]);
            img.style.display = 'block';
        }
    }

    function showAccountDetails(number, type, holder, balance, nomineeName, nomineeNID, nomineePic) {
        document.getElementById('<%= txtAccountNumber.ClientID %>').value = number;
        document.getElementById('<%= txtAccountType.ClientID %>').value = type;
        document.getElementById('<%= txtAccountHolder.ClientID %>').value = holder;
        document.getElementById('<%= txtAccountBalance.ClientID %>').value = balance;
        document.getElementById('<%= txtNomineeName.ClientID %>').value = nomineeName;
        document.getElementById('<%= txtNomineeNID.ClientID %>').value = nomineeNID;
        document.getElementById('imgNominee').src = nomineePic || 'images/default.png';
        new bootstrap.Modal(document.getElementById('accountDetailsModal')).show();
    }

    function enableEditStep() {
        ['<%= txtAccountType.ClientID %>', '<%= txtAccountHolder.ClientID %>', '<%= txtAccountBalance.ClientID %>',
         '<%= txtNomineeName.ClientID %>', '<%= txtNomineeNID.ClientID %>'].forEach(id => document.getElementById(id).removeAttribute('readonly'));
        document.getElementById('btnEnableUpdate').style.display = 'none';
        document.getElementById('btnUpdate').style.display = 'inline-block';
    }
    function updateAccount() {
        alert("Account updated successfully.");
     
    }

    function deleteAccount() {
        if (confirm("Are you sure you want to delete this account?")) {
            alert("Account deleted successfully.");
            bootstrap.Modal.getInstance(document.getElementById('accountDetailsModal')).hide();
        }
    }
</script>

</form>
</body>
</html>
