<%@ Page Title="Fund Transfer" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FundTransfer.aspx.cs" Inherits="vaultx.FundTransfer" %>

<asp:Content ID="FundTransferHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/fundtransfer.css" />
    <script src="scripts/fundtransfer.js?v=<%= DateTime.Now.Ticks %>"></script>
    <meta name="description" content="VaultX Bank — Fund Transfer" />
</asp:Content>

<asp:Content ID="FundTransferMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <!-- Your existing HTML content remains the same -->
    <div class="fund-transfer-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-exchange-alt"></i> Fund Transfer</h1>
            <p>Transfer money securely between accounts</p>
        </div>

        <!-- Account Holder Info Section -->
        <div class="account-holder-info">
            <div class="holder-card">
                <div class="holder-icon">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="holder-details">
                    <h3>Account Holder</h3>
                    <p class="holder-name"><asp:Label ID="lblAccountHolderName" runat="server"></asp:Label></p>
                </div>
            </div>
        </div>

        <!-- Account Type Selection Section -->
        <div class="account-selection-section">
            <h2>Select Account Type</h2>
            <div class="account-types-container">
                <asp:Button ID="btnSavings" runat="server" Text="Savings" CssClass="account-type-btn" 
                    OnClick="btnAccountType_Click" CommandArgument="Savings" CausesValidation="false" />
                <asp:Button ID="btnCurrent" runat="server" Text="Current" CssClass="account-type-btn" 
                    OnClick="btnAccountType_Click" CommandArgument="Current" CausesValidation="false" />
                <asp:Button ID="btnStudent" runat="server" Text="Student" CssClass="account-type-btn" 
                    OnClick="btnAccountType_Click" CommandArgument="Student" CausesValidation="false" />
            </div>
        </div>

        <!-- Transfer Form -->
        <div class="transfer-form-section">
            <asp:Panel ID="pnlTransferForm" runat="server" CssClass="transfer-form" Visible="false">
                <h3>Transfer Details</h3>
                <div class="selected-account-summary">
                    <span>From: <asp:Label ID="lblFromAccountType" runat="server"></asp:Label> 
                    (Account: <asp:Label ID="lblFromAccountNumber" runat="server"></asp:Label>)</span>
                    <span class="account-balance-info">Available Balance: ৳ <asp:Label ID="lblFromAccountBalance" runat="server"></asp:Label></span>
                </div>

                <div class="form-body">
                    <div class="form-group">
                        <label for="<%= txtAccountNo.ClientID %>">
                            <i class="fas fa-university"></i>
                            Receiver's Account Number
                        </label>
                        <asp:TextBox ID="txtAccountNo" runat="server" CssClass="form-control" 
                            placeholder="Enter receiver's account number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAccountNo" runat="server" ControlToValidate="txtAccountNo" 
                            ErrorMessage="Account number is required" CssClass="validator-text" Display="Dynamic" 
                            ValidationGroup="TransferValidation" />
                    </div>

                    <div class="form-group">
                        <label for="<%= txtAmount.ClientID %>">
                            <i class="fas fa-money-bill-wave"></i>
                            Amount
                        </label>
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" 
                            placeholder="Enter amount to transfer" TextMode="Number" step="0.01" min="1"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAmount" runat="server" ControlToValidate="txtAmount" 
                            ErrorMessage="Amount is required" CssClass="validator-text" Display="Dynamic" 
                            ValidationGroup="TransferValidation" />
                    </div>

                    <div class="form-group">
                        <label for="<%= txtReference.ClientID %>">
                            <i class="fas fa-sticky-note"></i>
                            Reference (Optional)
                        </label>
                        <asp:TextBox ID="txtReference" runat="server" CssClass="form-control" 
                            placeholder="Enter reference or note"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtPassword.ClientID %>">
                            <i class="fas fa-lock"></i>
                            Password
                        </label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                            TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                            ErrorMessage="Password is required" CssClass="validator-text" Display="Dynamic" 
                            ValidationGroup="TransferValidation" />
                    </div>

                    <div class="form-group checkbox-group">
                        <asp:CheckBox ID="chkTerms" runat="server" CssClass="checkbox-input" />
                        <label for="<%= chkTerms.ClientID %>" class="checkbox-label">
                            I agree to the <a href="Terms.aspx" target="_blank">Terms and Conditions</a>
                        </label>
                        <asp:CustomValidator ID="cvTerms" runat="server" 
                            ErrorMessage="You must agree to the terms and conditions" 
                            CssClass="validator-text" Display="Dynamic" 
                            ClientValidationFunction="validateTerms" 
                            ValidationGroup="TransferValidation" />
                    </div>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnSend" runat="server" Text="Send Money" CssClass="btn btn-primary" 
                        OnClick="btnSend_Click" ValidationGroup="TransferValidation" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" 
                        OnClick="btnCancel_Click" CausesValidation="false" />
                </div>
            </asp:Panel>

            <!-- Success Panel -->
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="result-panel success">
                <div class="result-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h3>Transfer Successful!</h3>
                <p>Your fund transfer has been completed successfully.</p>
                <div class="transfer-details">
                    <div class="detail-item">
                        <span class="detail-label">Transaction ID:</span>
                        <span class="detail-value"><asp:Label ID="lblSuccessTID" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Amount Transferred:</span>
                        <span class="detail-value">৳ <asp:Label ID="lblSuccessAmount" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">To Account:</span>
                        <span class="detail-value"><asp:Label ID="lblSuccessAccount" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Reference:</span>
                        <span class="detail-value"><asp:Label ID="lblSuccessReference" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-item balance-info">
                        <span class="detail-label">Your New Balance:</span>
                        <span class="detail-value balance-highlight">৳ <asp:Label ID="lblSuccessNewBalance" runat="server"></asp:Label></span>
                    </div>
                </div>
                <asp:Button ID="btnNewTransfer" runat="server" Text="New Transfer" CssClass="btn btn-primary" 
                    OnClick="btnNewTransfer_Click" CausesValidation="false" />
            </asp:Panel>
        </div>
    </div>

    <!-- No Account Modal -->
    <div class="modal-overlay" id="noAccountModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3>No Account Available</h3>
            <p>You don't have a <span id="selectedAccountType"></span> account.</p>
            <p>Please contact your bank to open this type of account or select a different account type.</p>
            <button type="button" class="btn btn-secondary" onclick="closeNoAccountModal()">OK</button>
        </div>
    </div>

    <!-- Transfer Error Modal -->
    <div class="modal-overlay" id="transferErrorModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-icon error-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            <h3>Transfer Error</h3>
            <p id="transferErrorMessage"></p>
            <button type="button" class="btn btn-primary" onclick="closeTransferErrorModal()">Try Again</button>
        </div>
    </div>

    <!-- No embedded script needed anymore - everything is in fundtransfer.js -->
</asp:Content>