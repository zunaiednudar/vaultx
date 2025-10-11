<%@ Page Title="Terms & Conditions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Terms.aspx.cs" Inherits="vaultx.Terms" %>

<asp:Content ID="TermsHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/terms.css?v=<%= DateTime.Now.Ticks %>" />
</asp:Content>

<asp:Content ID="TermsContent" ContentPlaceHolderID="SiteMainContent" runat="server">

    <section class="terms-banner" role="banner" aria-label="VaultX Bank Terms Banner">
        <img src="images/terms.png" alt="VaultX Bank Terms Banner" class="terms-banner__image" />
        <div class="terms-banner__overlay" aria-hidden="true"></div>
        <div class="terms-banner__content">
            <h1 class="terms-banner__title" aria-label="VaultX Bank Terms & Conditions">Terms & Conditions</h1>
            <p class="terms-banner__subtitle">
                Understand your rights and responsibilities with VaultX Bank.
            </p>
        </div>
    </section>

    <div class="terms-content">
        <p id="wcl">
            Welcome to VaultX Bank. By using our services, you agree to comply with the following terms and conditions. Please read carefully. These terms are designed to ensure your safety, protect your rights, and clarify responsibilities when using VaultX Bank's services.
        </p>
        <ol>
            <li>
                <strong>Account Usage:</strong> You are responsible for maintaining the confidentiality of your login credentials, including your username, password, and any authentication codes. Sharing your account or using someone else’s credentials is strictly prohibited. Unauthorized access may result in temporary or permanent suspension of your account, and you may be held liable for any damages caused by such access.
            </li>
            <li>
                <strong>Transactions:</strong> All transactions initiated through VaultX Bank are final once processed. While we take all measures to ensure accurate execution, VaultX Bank is not liable for delays, errors, or failures caused by third-party payment processors, banks, or technical issues. Please double-check all transaction details before confirming.
            </li>
            <li>
                <strong>Privacy:</strong> VaultX Bank values your privacy and employs strict measures to protect your personal and financial information. Data collected is used solely for banking operations, fraud prevention, compliance with legal obligations, and improving our services. We do not sell or share your information with unauthorized third parties.
            </li>
            <li>
                <strong>Fees:</strong> Service fees applicable to your account or specific transactions will be clearly displayed before confirmation. Fees may vary depending on the type of service, transaction method, or currency used. By proceeding, you agree to these charges, which are non-refundable unless required by law or VaultX policy.
            </li>
            <li>
                <strong>Interest Rates:</strong> Interest rates for deposits, loans, and other financial products are subject to change at VaultX Bank's discretion. Updates will be communicated via our official channels. Your account may accrue interest based on the prevailing rates at the time of calculation.
            </li>
            <li>
                <strong>Compliance:</strong> Users are required to adhere to all applicable laws, regulations, and VaultX Bank policies. Any illegal activity, money laundering, fraud, or misuse of services is strictly prohibited. Violation may result in account suspension, legal action, or reporting to regulatory authorities.
            </li>
            <li>
                <strong>Security:</strong> VaultX Bank employs advanced security measures, including multi-factor authentication, encryption, and AI-driven monitoring, to protect your account. Users must report any suspicious activity immediately. The bank is not liable for losses resulting from negligence, sharing credentials, or failure to follow security recommendations.
            </li>
            <li>
                <strong>Electronic Communication:</strong> Important statements, notifications, and communications may be delivered electronically, including email or in-app notifications. Users are responsible for maintaining active contact information and reviewing communications promptly.
            </li>
            <li>
                <strong>Termination:</strong> VaultX Bank reserves the right to suspend or close accounts for non-compliance, security risks, or suspicious activities. Users will be notified of termination, but immediate action may be taken if required to protect the bank or other users.
            </li>
            <li>
                <strong>Dispute Resolution:</strong> In case of disputes, parties agree to first attempt amicable resolution. If unresolved, disputes will be subject to arbitration under Bangladesh laws. The decision of the arbitrator shall be final and binding, and users waive the right to pursue court litigation, except where required by law.
            </li>
            <li>
                <strong>Third-Party Services:</strong> VaultX Bank may integrate or work with third-party providers (e.g., payment processors, analytics services). While we carefully select these partners, we are not liable for their actions, availability, or service quality. Users are advised to review third-party terms before engaging with them.
            </li>
            <li>
                <strong>Updates:</strong> VaultX Bank may revise these terms at any time. Updates will be posted on our website or communicated via official channels. Continued use of our services after updates indicates acceptance of the revised terms. Users are encouraged to regularly review the Terms & Conditions.
            </li>
        </ol>
        <p id="wcl">
            By using VaultX Bank services, you acknowledge that you have read, understood, and agreed to these Terms & Conditions. You agree to comply with all rules, maintain secure access, and act responsibly while using our services.
        </p>
    </div>
</asp:Content>
