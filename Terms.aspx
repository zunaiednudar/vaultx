<%@ Page Title="Terms & Conditions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Terms.aspx.cs" Inherits="vaultx.Terms" %>

<asp:Content ID="TermsHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/terms.css?v=<%= DateTime.Now.Ticks %>" />
</asp:Content>

<asp:Content ID="TermsContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <!-- Banner Section -->
    <section class="terms-banner">
        <img src="images/terms.jpg" alt="VaultX Bank Terms Banner" class="terms-banner__image" />
      
    </section>

    <!-- Terms Content -->
    <div class="terms-content container">
        <p>Welcome to VaultX Bank. By using our services, you agree to comply with the following terms and conditions. Please read carefully.</p>

        <ol>
            <li><strong>Account Usage:</strong> Keep your login credentials confidential. Unauthorized use may result in account suspension.</li>
            <li><strong>Transactions:</strong> All transactions are final. VaultX is not responsible for third-party delays or errors.</li>
            <li><strong>Privacy:</strong> Your personal and financial information is securely stored and only used for banking operations.</li>
            <li><strong>Fees:</strong> Applicable service fees will be displayed prior to confirming transactions.</li>
            <li><strong>Interest Rates:</strong> Rates may change at VaultX's discretion without prior notice.</li>
            <li><strong>Compliance:</strong> Users must follow all laws and VaultX policies.</li>
            <li><strong>Security:</strong> Multi-factor authentication and AI-driven monitoring protect your account. Report suspicious activity immediately.</li>
            <li><strong>Electronic Communication:</strong> Statements, notifications, and communications may be sent electronically.</li>
            <li><strong>Termination:</strong> VaultX reserves the right to suspend or close accounts in case of non-compliance.</li>
            <li><strong>Dispute Resolution:</strong> Any disputes will be subject to arbitration under Bangladesh laws.</li>
            <li><strong>Third-Party Services:</strong> VaultX is not liable for services outside its control (e.g., partner payment processors).</li>
            <li><strong>Updates:</strong> VaultX may update these terms; continued use implies acceptance.</li>
        </ol>

        <p>By using VaultX Bank services, you acknowledge that you have read, understood, and agreed to these Terms & Conditions.</p>
    </div>
</asp:Content>
