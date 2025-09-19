<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="vaultx.Dashboard" %>

<asp:Content ID="DashboardHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/dashboard.css" type="text/css" />
</asp:Content>

<asp:Content ID="DashboardMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <!-- Accounts Section -->
    <section class="accounts-section">
        <h2>My Accounts</h2>
        <div class="accounts-grid">
            <asp:Repeater ID="rptAccounts" runat="server">
                <ItemTemplate>
                    <div class="account-card" onclick="openAccountDetails('<%# Eval("AccountNumber") %>')">
                        <h3><%# Eval("AccountNumber") %></h3>
                        <p>Balance: $<%# Eval("Balance") %></p>
                        <p>Type: <%# Eval("AccountType") %></p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Placeholder card for adding new account -->
            <asp:PlaceHolder ID="phAddAccount" runat="server" Visible="false">
                <div class="account-card add-card" onclick="openModal();">+</div>
            </asp:PlaceHolder>
        </div>
    </section>

    <!-- Transactions Section -->
    <section class="transactions-section">
        <h2>Recent Transactions</h2>
        <div class="transactions-list">
            <!-- Header Row -->
            <div class="transaction-item header">
                <span class="txn-faid">From</span>
                <span class="txn-taid">To</span>
                <span class="txn-type">Transaction Type</span>
                <span class="txn-amount">Amount</span>
                <span class="txn-reference">Reference</span>
                <span class="txn-date">Date</span>
            </div>

            <!-- Transaction Items -->
            <asp:Repeater ID="rptTransactions" runat="server">
                <ItemTemplate>
                    <div class="transaction-item">
                        <span class="txn-faid"><%# Eval("FromAccountNumber") %></span>
                        <span class="txn-taid"><%# Eval("ToAccountNumber") %></span>
                        <span class="txn-type"><%# Eval("TransactionType") %></span>
                        <span class="txn-amount">$<%# Eval("Amount") %></span>
                        <span class="txn-reference"><%# Eval("Reference") %></span>
                        <span class="txn-date"><%# Eval("Date", "{0:MMM dd, yyyy}") %></span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

    <!-- Account Creation Modal -->
    <asp:Panel ID="pnlAccountModal" runat="server" CssClass="modal hide">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Create New Account</h2>

            <asp:Label ID="lblModalMessage" runat="server" ForeColor="Red"></asp:Label>

            <!-- Account Type -->
            <asp:DropDownList ID="ddlAccountType" runat="server">
                <asp:ListItem Text="Select Type" Value="" />
                <asp:ListItem Text="Current" Value="Current" />
                <asp:ListItem Text="Savings" Value="Savings" />
                <asp:ListItem Text="Fixed Deposit" Value="Fixed Deposit" />
            </asp:DropDownList>

            <!-- Nominee Name -->
            <asp:Label ID="lblNomineeName" runat="server" Text="Nominee Name:" AssociatedControlID="txtNomineeName"></asp:Label>
            <asp:TextBox ID="txtNomineeName" runat="server" CssClass="modal-input" />

            <!-- Nominee NID -->
            <asp:Label ID="lblNomineeNID" runat="server" Text="Nominee NID:" AssociatedControlID="txtNomineeNID"></asp:Label>
            <asp:TextBox ID="txtNomineeNID" runat="server" CssClass="modal-input" />

            <!-- Nominee Image -->
            <asp:Label ID="lblNomineeImage" runat="server" Text="Nominee Image:" AssociatedControlID="fuNomineeImage"></asp:Label>
            <asp:FileUpload ID="fuNomineeImage" runat="server" CssClass="file-upload-button" />


            <!-- Submit Button -->
            <asp:Button ID="btnCreateAccount" runat="server" Text="Create Account" OnClick="btnCreateAccount_Click" />
        </div>
    </asp:Panel>

    <!-- JavaScript for modal animations -->
    <script type="text/javascript">
        window.onload = function () {
            const modal = document.getElementById('<%= pnlAccountModal.ClientID %>');

            window.openModal = function () {
                modal.classList.remove('hide');
                modal.classList.add('show');
            };

            window.closeModal = function () {
                modal.classList.remove('show');
                modal.classList.add('hide');
            };
        };

        function openAccountDetails(accountNumber) {
            window.location.href = '/AccountDetails.aspx?account=' + encodeURIComponent(accountNumber);
        }
    </script>
</asp:Content>
