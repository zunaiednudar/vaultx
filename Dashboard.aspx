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
                    <div class="account-card">
                        <h3><%# Eval("AccountNumber") %></h3>
                        <p>Balance: $<%# Eval("Balance") %></p>
                        <p>Type: <%# Eval("AccountType") %></p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Placeholder cards will be added in code-behind if less than 3 accounts -->
            <!-- Single placeholder (visible only if needed, added in code-behind) -->
            <asp:PlaceHolder ID="phAddAccount" runat="server" Visible="false">
                <div class="account-card add-card" onclick="openModal();">
                    +
                </div>
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
                <!--<span class="txn-id">Transaction ID</span>-->
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
    <asp:Panel ID="pnlAccountModal" runat="server" CssClass="modal" Style="display: none;">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Create New Account</h2>
            <asp:Label ID="lblModalMessage" runat="server" ForeColor="Red"></asp:Label>
            <asp:DropDownList ID="ddlAccountType" runat="server">
                <asp:ListItem Text="Select Account Type" Value="" />
                <asp:ListItem Text="Current" Value="Current" />
                <asp:ListItem Text="Savings" Value="Savings" />
                <asp:ListItem Text="Fixed Deposit" Value="Fixed Deposit" />
            </asp:DropDownList>
            <br />
            <br />
            <asp:Button ID="btnCreateAccount" runat="server" Text="Create Account" OnClick="btnCreateAccount_Click" />
        </div>
    </asp:Panel>

    <!--JavaScript-->
    <script type="text/javascript">
        window.onload = function () {
            window.openModal = function () {
                document.getElementById('<%= pnlAccountModal.ClientID %>').style.display = 'flex';
        };

        window.closeModal = function () {
            document.getElementById('<%= pnlAccountModal.ClientID %>').style.display = 'none';
            };
        };
    </script>
</asp:Content>
