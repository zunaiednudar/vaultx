<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="vaultx.Home" %>

<asp:Content ID="HomeHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/home.css" />
    <script src="scripts/home.js" defer></script>
    <meta name="description" content="VaultX Bank — secure, smart, and modern banking for everyone." />
</asp:Content>
<asp:Content ID="HomeMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <!-- HERO SECTION -->
    <section class="hero" role="banner" aria-label="Bank hero section">
        <img src="images/hero.jpg" alt="Modern bank building with city skyline" class="hero__image" />
        <div class="hero__overlay" aria-hidden="true"></div>
        <div class="hero__content">
            <h1 class="hero__title" aria-label="VaultX Bank">VaultX Bank</h1>
            <p class="hero__subtitle">
                Secure. Smart. Seamless—modern banking designed for you.
            </p>
        </div>
    </section>

    <!-- ABOUT / DESCRIPTION -->
    <section class="about" aria-labelledby="about-title">
        <div class="container">
            <h2 id="about-title" class="section-title">Why VaultX?</h2>
            <p class="about__text">
                At <strong>VaultX</strong>, we combine top-tier security with intuitive digital tools to help you
                save, invest, and grow. From zero-fee accounts to 24/7 support, our mission is simple:
                make your money work harder—safely and transparently.
            </p>
        </div>
    </section>

    <!-- FEATURE CARDS -->
    <section class="features" aria-labelledby="features-title">
        <div class="container">
            <h2 id="features-title" class="section-title">Explore Our Features</h2>

            <div class="card-grid" role="list">
                <!-- Card 1 -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature1.jpg" alt="Mobile phone showing banking app" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Instant Mobile Banking</h3>
                        <p class="card__text">Transfer, pay bills, and manage cards on the go with real-time alerts.</p>
                    </div>
                </article>

                <!-- Card 2 -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature2.jpg" alt="Shield icon representing security" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Bank-Grade Security</h3>
                        <p class="card__text">Multi-factor authentication and AI-driven fraud monitoring keep your money safe.</p>
                    </div>
                </article>

                <!-- Card 3 -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature3.jpg" alt="Hand holding a savings jar" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">High-Yield Savings</h3>
                        <p class="card__text">Competitive rates with zero hidden fees—watch your savings grow faster.</p>
                    </div>
                </article>

                <!-- Card 4 -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature4.jpg" alt="Credit card on a table" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Smart Cards</h3>
                        <p class="card__text">Freeze, set limits, and create virtual cards for safer online shopping.</p>
                    </div>
                </article>

                <!-- Card 5 -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature5.jpg" alt="Laptop with investment charts" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Investing Made Easy</h3>
                        <p class="card__text">Start small with diversified portfolios and auto-invest plans.</p>
                    </div>
                </article>

                <!-- Card 6 -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature6.jpg" alt="Customer support headset icon" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">24/7 Human Support</h3>
                        <p class="card__text">Talk to real experts anytime—chat, phone, or email.</p>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <!-- CONTACT INFO -->
    <section class="contact" aria-labelledby="contact-title">
        <div class="container contact__grid">
            <div>
                <h2 id="contact-title" class="section-title">Contact Us</h2>
                <ul class="contact__list" aria-label="Bank contact information">
                    <li><strong>Address:</strong> 123 Finance Ave, Khulna 9100</li>
                    <li><strong>Phone:</strong> <a href="tel:+8801712345678">+880 17 1234 5678</a></li>
                    <li><strong>Email:</strong> <a href="mailto:support@vaultxbank.com">support@vaultxbank.com</a></li>
                    <li><strong>Hours:</strong> Sat–Thu, 9:00–17:00 (BST)</li>
                </ul>
                <a class="btn btn--primary" href="https://maps.google.com" target="_blank" rel="noopener" aria-label="Open map to our branch">Open in Maps</a>
            </div>

            <div class="contact__panel" role="note" aria-label="Security & compliance note">
                <h3 class="contact__panel-title">Your Security First</h3>
                <p class="contact__panel-text">
                    We never ask for your PIN, OTP, or full card details over phone/email.
                    If you suspect fraud, call our hotline immediately.
                </p>
            </div>
        </div>
    </section>
</asp:Content>