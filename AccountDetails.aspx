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
            <asp:Button ID="btnDownloadStatement" runat="server" Text="Download Statement"
                CssClass="btn-action" OnClientClick="openYearModal(); return false;" />
        </div>
    </section>

    <!-- Middle Section: Nominee Details -->
    <section class="nominee-section">
        <h2>Nominee Details</h2>
        <div class="nominee-info">
            <div class="nominee-photo">
                <asp:Image ID="imgNominee" runat="server" CssClass="nominee-img" />
            </div>
            <div class="nominee-data">
                <div class="nominee-row">
                    <strong>Name:</strong>
                    <asp:Label ID="lblNomineeName" CssClass="value" runat="server" />
                </div>
                <div class="nominee-row">
                    <strong>NID Number:</strong>
                    <asp:Label ID="lblNomineeNID" CssClass="value" runat="server" />
                </div>
            </div>
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
                <span class="txn-type">Transaction Type</span>
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

    <!-- Year Selection Modal for PDF Export -->
    <asp:Panel ID="pnlYearModal" runat="server" CssClass="modal hide">
        <div class="modal-content">
            <!-- Close button -->
            <span class="close" onclick="closeYearModal()">&times;</span>

            <h2>Select Year for Statement</h2>

            <!-- Year Dropdown -->
            <asp:DropDownList ID="ddlYears" runat="server" CssClass="modal-input"></asp:DropDownList>

            <!-- Download PDF Button -->
            <asp:Button ID="btnDownloadPDF" runat="server" Text="Download PDF" CssClass="btn-action"
                OnClick="btnDownloadStatement_Click" />
        </div>
    </asp:Panel>

    <!-- Trigger button -->
    <!-- <asp:Button ID="btnOpenYearModal" runat="server" Text="Download Statement"
        CssClass="btn-action" OnClientClick="openYearModal(); return false;" />
        -->

    <script type="text/javascript">
        window.onload = function () {
            const modal = document.getElementById('<%= pnlYearModal.ClientID %>');

            window.openYearModal = function () {
                modal.classList.add('show');
                document.body.style.overflow = 'hidden';
            };

            window.closeYearModal = function () {
                modal.classList.remove('show');
                document.body.style.overflow = '';
            };
        };
    </script>
</asp:Content>
