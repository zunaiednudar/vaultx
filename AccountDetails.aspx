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
            <asp:Button ID="btnDownloadStatement" runat="server" Text="Download Statement" CssClass="btn-action" OnClientClick="openYearModal(); return false;" />
        </div>
    </section>

    <!-- Middle Section: Nominee Details -->
    <section class="nominee-section">
        <h2>Nominee Details</h2>
        <div class="nominee-info">
            <div class="nominee-photo">
                <asp:Image ID="imgNominee" runat="server" CssClass="nominee-img" />
            </div>

            <!-- Custom File Upload + Upload button -->
            <div class="file-upload-wrapper">
                <!-- Hidden FileUpload -->
                <asp:FileUpload ID="fuNominee" runat="server" CssClass="hidden-file" />

                <!-- Custom Choose File Button -->
                <button type="button" class="btn-choose-file" onclick="document.getElementById('<%= fuNominee.ClientID %>').click();">
                    Choose File
                </button>

                <!-- Upload Button -->
                <asp:Button ID="btnUploadNominee" runat="server" Text="Upload" CssClass="btn-upload" OnClick="btnUploadNominee_Click" />
            </div>

            <!-- Optional file name display -->
            <span id="selectedFileName" class="file-name-label"></span>

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
            <div class="transaction-item header">
                <span class="txn-faid">From</span>
                <span class="txn-taid">To</span>
                <span class="txn-type">Transaction Type</span>
                <span class="txn-amount">Amount</span>
                <span class="txn-reference">Reference</span>
                <span class="txn-date">Date</span>
            </div>
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

    <!-- Year Selection Modal -->
    <asp:Panel ID="pnlYearModal" runat="server" CssClass="modal hide">
        <div class="modal-content">
            <span class="close" onclick="closeYearModal()">&times;</span>
            <h2>Select Year for Statement</h2>
            <asp:DropDownList ID="ddlYears" runat="server" CssClass="modal-input"></asp:DropDownList>
            <asp:Button ID="btnDownloadPDF" runat="server" Text="Download PDF" CssClass="btn-action" OnClick="btnDownloadStatement_Click" />
        </div>
    </asp:Panel>

    <!-- JS Scripts -->
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

        // Display chosen file name
        var fileInput = document.getElementById("<%= fuNominee.ClientID %>");
        var fileNameLabel = document.getElementById("selectedFileName");
        fileInput.addEventListener("change", function () {
            if (fileInput.files.length > 0) {
                fileNameLabel.textContent = fileInput.files[0].name;
            } else {
                fileNameLabel.textContent = "";
            }
        });
    </script>
</asp:Content>