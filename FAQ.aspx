<%@ Page Title="FAQ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FAQ.aspx.cs" Inherits="vaultx.FAQ" %>

<asp:Content ID="FAQHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/faq.css?v=<%= DateTime.Now.Ticks %>" />
</asp:Content>

<asp:Content ID="FAQContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <!-- Banner Section -->
    <section class="faq-banner">
        <img src="images/FAQ-banner.jpg" alt="VaultX Bank FAQ Banner" class="faq-banner__image" />
    </section>

    <!-- FAQ Content -->
    <div class="faq-content container">
        <p>Here are some of the most frequently asked questions about VaultX Bank. Click on each question to reveal the answer.</p>

        <div class="faq-item">
            <button type="button" class="faq-question">How do I create an account?</button>
            <div class="faq-answer">
                <p>Click on the Register page, fill in your details, verify your email via OTP, and set a password to create an account.</p>
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question">How can I reset my password?</button>
            <div class="faq-answer">
                <p>Go to the Login page, click "Forgot Password", and follow the steps to reset your password via email verification.</p>
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question">How do I update my profile information?</button>
            <div class="faq-answer">
                <p>After logging in, go to your profile dashboard and click "Edit Profile". Make changes and save to update your information.</p>
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question">Are my transactions secure?</button>
            <div class="faq-answer">
                <p>Yes. VaultX Bank uses multi-factor authentication and AI-driven monitoring to ensure your transactions are secure.</p>
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question">How do I contact support?</button>
            <div class="faq-answer">
                <p>You can reach our customer support via the Contact Us page or by emailing support@vaultx.com.</p>
            </div>
        </div>
    </div>

  
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const faqItems = document.querySelectorAll('.faq-item');

            faqItems.forEach(item => {
                const question = item.querySelector('.faq-question');

                question.addEventListener('click', () => {
                    const isOpen = item.classList.contains('open');

                    faqItems.forEach(i => i.classList.remove('open'));

                    if (!isOpen) {
                        item.classList.add('open');
                    }
                });
            });
        });
    </script>
</asp:Content>
