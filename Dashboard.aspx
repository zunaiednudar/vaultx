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
                <div class="account-card add-card">
                    +
                </div>
            </asp:PlaceHolder>
        </div>
    </section>

    <!-- Transactions Section -->
    <section class="transactions-section">
        <h2>Recent Transactions</h2>
        <div class="transactions-list">
            <asp:Repeater ID="rptTransactions" runat="server">
                <ItemTemplate>
                    <div class="transaction-item">
                        <span class="txn-aid"><%# Eval("AccountNumber", "{0:MMM dd, yyyy}") %></span>
                        <span class="txn-type"><%# Eval("TransactionType") %></span>
                        <span class="txn-id"><%# Eval("TransactionId") %></span>
                        <span class="txn-amount">$<%# Eval("Amount") %></span>
                        <span class="txn-reference"><%# Eval("Reference") %></span>
                        <span class="txn-date"><%# Eval("Date", "{0:MMM dd, yyyy}") %></span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>
