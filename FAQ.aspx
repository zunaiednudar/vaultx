<%@ Page Title="FAQ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FAQ.aspx.cs" Inherits="vaultx.FAQ" %>

<asp:Content ID="FAQHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="styles/faq.css?v=<%= DateTime.Now.Ticks %>" />
   
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
    
        .faq-search {
            max-width: 600px;
            margin: 0 auto 30px;
            position: relative;
        }

        .faq-search input {
            width: 100%;
            padding: 12px 45px 12px 15px; 
            font-size: 1.1rem;
            border: 2px solid #ccc;
            border-radius: 8px;
            outline: none;
        }

        .faq-search input:focus {
            border-color: #0077cc;
            box-shadow: 0 0 5px rgba(0, 119, 204, 0.4);
        }

       
        .faq-search .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 1.2rem;
            pointer-events: none; 
        }
    </style>
</asp:Content>

<asp:Content ID="FAQContent" ContentPlaceHolderID="SiteMainContent" runat="server">
   
    <section class="faq-banner">
        <img src="images/FAQ-banner.jpg" alt="VaultX Bank FAQ Banner" class="faq-banner__image" />
        <div class="faq-banner__overlay" aria-hidden="true"></div>
        <div class="faq-banner__content">
            <h1 class="faq-banner__title">Frequently Asked Questions</h1>
            <p class="faq-banner__subtitle">Find answers to common questions about VaultX Bank services</p>
        </div>
    </section>

 
    <div class="faq-search">
        <input type="text" id="faqSearch" placeholder="Search for a question...">
        <i class="fas fa-search search-icon"></i>
    </div>

 
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

      
        <div class="faq-item">
            <button type="button" class="faq-question">What types of accounts can I open?</button>
            <div class="faq-answer">
                <p>VaultX Bank offers savings, current, and fixed deposit accounts. Each account type has unique benefits such as higher interest rates for fixed deposits or flexible transactions for current accounts.</p>
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question">Can I use VaultX Bank internationally?</button>
            <div class="faq-answer">
                <p>Yes, VaultX Bank cards and online services are globally accepted. International transactions may be subject to currency conversion fees depending on the location and regulations.</p>
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question">Does VaultX Bank charge for ATM withdrawals?</button>
            <div class="faq-answer">
                <p>ATM withdrawals are free at VaultX ATMs. For third-party ATMs, a small service fee may apply after a certain number of free transactions per month.</p>
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question">How do I enable two-factor authentication?</button>
            <div class="faq-answer">
                <p>You can enable two-factor authentication (2FA) from your security settings in the profile dashboard. Options include SMS OTP or authenticator apps for added security.</p>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const faqItems = document.querySelectorAll('.faq-item');
            const searchInput = document.getElementById('faqSearch');

           
            faqItems.forEach(item => {
                const question = item.querySelector('.faq-question');
                question.addEventListener('click', () => {
                    const isOpen = item.classList.contains('open');
                    faqItems.forEach(i => i.classList.remove('open'));
                    if (!isOpen) item.classList.add('open');
                });
            });

      
            searchInput.addEventListener("keyup", () => {
                const term = searchInput.value.toLowerCase();
                faqItems.forEach(item => {
                    const text = item.querySelector('.faq-question').textContent.toLowerCase();
                    if (text.includes(term)) {
                        item.style.display = "block";
                    } else {
                        item.style.display = "none";
                    }
                });
            });
        });
    </script>
</asp:Content>
