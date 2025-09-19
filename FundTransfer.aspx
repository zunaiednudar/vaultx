<%@ Page Title="Fund Transfer" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FundTransfer.aspx.cs" Inherits="vaultx.FundTransfer" %>

<asp:Content ID="FundTransferHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/fundtransfer.css" />
    <meta name="description" content="VaultX Bank — Fund Transfer" />
</asp:Content>

<asp:Content ID="FundTransferMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <div class="fund-transfer-container">
        <!-- Balance Information -->
        <div class="balance-section">
            <div class="balance-card current-balance">
                <div class="balance-icon">
                    <i class="fas fa-wallet"></i>
                </div>
                <div class="balance-info">
                    <h3>Current Balance</h3>
                    <div class="balance-amount">
                        <asp:Label ID="lblCurrentBalance" runat="server" Text="৳ 0.00"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="balance-card available-balance">
                <div class="balance-icon">
                    <i class="fas fa-coins"></i>
                </div>
                <div class="balance-info">
                    <h3>Available Balance</h3>
                    <div class="balance-amount">
                        <asp:Label ID="lblAvailableBalance" runat="server" Text="৳ 0.00"></asp:Label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Transfer Form -->
        <div class="transfer-form-section">
            <asp:Panel ID="pnlTransferForm" runat="server" CssClass="transfer-form">
                <div class="form-header">
                    <h2><i class="fas fa-exchange-alt"></i> Fund Transfer</h2>
                    <p>Transfer money securely to any account</p>
                </div>
                
                <div class="form-body">
                    <div class="form-group">
                        <label for="<%= txtAccountNo.ClientID %>">
                            <i class="fas fa-university"></i>
                            Account No (Receiver)
                        </label>
                        <asp:TextBox ID="txtAccountNo" runat="server" CssClass="form-control" 
                            placeholder="Enter receiver's account number" required></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAccountNo" runat="server" ControlToValidate="txtAccountNo" 
                            ErrorMessage="Account number is required" CssClass="validator-text" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label for="<%= txtAmount.ClientID %>">
                            <i class="fas fa-money-bill-wave"></i>
                            Amount
                        </label>
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" 
                            placeholder="Enter amount to transfer" TextMode="Number" step="0.01" min="1" required></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvAmount" runat="server" ControlToValidate="txtAmount" 
                            ErrorMessage="Amount is required" CssClass="validator-text" Display="Dynamic" />
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
                            TextMode="Password" placeholder="Enter your password" required></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                            ErrorMessage="Password is required" CssClass="validator-text" Display="Dynamic" />
                    </div>

                    <div class="form-group checkbox-group">
                        <asp:CheckBox ID="chkTerms" runat="server" CssClass="checkbox-input" />
                        <label for="<%= chkTerms.ClientID %>" class="checkbox-label">
                            I agree to the <a href="#" target="_blank">Terms and Conditions</a>
                        </label>
                        <asp:CustomValidator ID="cvTerms" runat="server" 
                            ErrorMessage="You must agree to the terms and conditions" 
                            CssClass="validator-text" Display="Dynamic" 
                            ClientValidationFunction="validateTerms" />
                    </div>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnSend" runat="server" Text="Send Money" CssClass="btn btn-primary" 
                        OnClick="btnSend_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" 
                        OnClientClick="clearForm(); return false;" />
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
                        <span class="detail-label">Amount:</span>
                        <span class="detail-value"><asp:Label ID="lblSuccessAmount" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">To Account:</span>
                        <span class="detail-value"><asp:Label ID="lblSuccessAccount" runat="server"></asp:Label></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Reference:</span>
                        <span class="detail-value"><asp:Label ID="lblSuccessReference" runat="server"></asp:Label></span>
                    </div>
                </div>
                <asp:Button ID="btnNewTransfer" runat="server" Text="New Transfer" CssClass="btn btn-primary" 
                    OnClick="btnNewTransfer_Click" />
            </asp:Panel>

            <!-- Error Panel -->
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="result-panel error">
                <div class="result-icon">
                    <i class="fas fa-times-circle"></i>
                </div>
                <h3>Transfer Failed</h3>
                <p><asp:Label ID="lblErrorMessage" runat="server"></asp:Label></p>
                <asp:Button ID="btnTryAgain" runat="server" Text="Try Again" CssClass="btn btn-secondary" 
                    OnClick="btnTryAgain_Click" />
            </asp:Panel>
        </div>
    </div>

    <script type="text/javascript">
        function validateTerms(sender, args) {
            var checkbox = document.getElementById('<%= chkTerms.ClientID %>');
            args.IsValid = checkbox.checked;
        }

        function clearForm() {
            document.getElementById('<%= txtAccountNo.ClientID %>').value = '';
            document.getElementById('<%= txtAmount.ClientID %>').value = '';
            document.getElementById('<%= txtReference.ClientID %>').value = '';
            document.getElementById('<%= txtPassword.ClientID %>').value = '';
            document.getElementById('<%= chkTerms.ClientID %>').checked = false;
        }
    </script>
</asp:Content>