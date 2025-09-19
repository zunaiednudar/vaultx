<%@ Page Title="AccountDetails" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountDetails.aspx.cs" Inherits="vaultx.AccountDetails" %>

<asp:Content ID="AccountDetailsHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/accountdetails.css" type="text/css" />
</asp:Content>

<asp:Content ID="AccountDetailsMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">

    <!-- Upper Section: Account Info -->
    <section class="account-info-section">
        <h2>Account Details</h2>
        <div class="account-info">
            <div class="account-info-row">
                <strong>Account Number:</strong>
                <asp:Label ID="lblAccountNumber" runat="server" />
            </div>

            <div class="account-info-row">
                <strong>Account Type:</strong>
                <asp:Label ID="lblAccountType" runat="server" />
            </div>

            <div class="account-info-row">
                <strong>Account Creation Date:</strong>
                <asp:Label ID="lblCreatedAt" runat="server" />
            </div>

            <div class="account-info-row">
                <strong>Account Holder:</strong>
                <asp:Label ID="lblAccountHolder" runat="server" />
            </div>

            <asp:Button ID="btnAddFunds" runat="server" Text="Add Funds" OnClick="btnAddFunds_Click" CssClass="btn-action" />
            <asp:Button ID="btnDownloadStatement" runat="server" Text="Download Statement" OnClick="btnDownloadStatement_Click" CssClass="btn-action" />
        </div>
    </section>

    <!-- Lower Section: Transactions -->
    <section class="transactions-section">
        <h2>Transactions</h2>
        <div class="transactions-list">
            <!-- Header Row -->
            <div class="transaction-item header">
                <span class="txn-faid">From</span>
                <span class="txn-taid">To</span>
                <span class="txn-type">Type</span>
                <span class="txn-amount">Amount</span>
                <span class="txn-reference">Reference</span>
                <span class="txn-date">Date</span>
            </div>

            <!-- Transaction Items -->
            <asp:Repeater ID="rptAccountTransactions" runat="server">
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

</asp:Content>
