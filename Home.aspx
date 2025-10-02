<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="vaultx.Home" %>

<asp:Content ID="HomeHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/global.css" />
    <link rel="stylesheet" href="styles/home.css" />
    <script src="scripts/home.js" defer></script>
    <meta name="description" content="VaultX Bank — secure, smart, and modern banking for everyone." />
    
    <!-- INLINE STYLES FOR ACCOUNT SECTION -->
    <style>
        /* Account Section Forced Styles */
        .account-types {
            padding: 50px 0 !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%) !important;
            position: relative !important;
            overflow: hidden !important;
        }

        .account-types::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><g fill="%23ffffff" fill-opacity="0.1"><circle cx="30" cy="30" r="4"/></g></svg>');
            pointer-events: none;
        }

        .account-grid {
            display: grid !important;
            grid-template-columns: repeat(3, 1fr) !important;
            gap: 30px !important;
            align-items: start !important;
            position: relative !important;
            z-index: 2 !important;
        }

        .account-card {
            background: #fff !important;
            border-radius: 15px !important;
            overflow: hidden !important;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15) !important;
            transition: all 0.4s ease !important;
            position: relative !important;
            cursor: pointer !important;
            border: 3px solid transparent !important;
        }

        .account-card:hover {
            transform: translateY(-15px) scale(1.02) !important;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2) !important;
        }

        .savings-card:hover {
            border-color: #4CAF50 !important;
        }

        .current-card:hover {
            border-color: #2196F3 !important;
        }

        .student-card:hover {
            border-color: #FF9800 !important;
        }

        .account-card__icon-section {
            height: 220px !important;
            padding: 40px 20px 30px !important;
            text-align: center !important;
            position: relative !important;
            overflow: hidden !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            flex-direction: column !important;
        }

        .savings-card .account-card__icon-section {
            background: linear-gradient(135deg, #4CAF50 0%, #66BB6A 100%) !important;
        }

        .current-card .account-card__icon-section {
            background: linear-gradient(135deg, #2196F3 0%, #42A5F5 100%) !important;
        }

        .student-card .account-card__icon-section {
            background: linear-gradient(135deg, #FF9800 0%, #FFA726 100%) !important;
        }

        .account-card__icon {
            font-size: 5rem !important;
            margin-bottom: 20px !important;
            display: block !important;
            color: #1A1A1A !important;
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2) !important;
            transition: all 0.5s ease !important;
            position: relative !important;
            z-index: 2 !important;
        }

        .account-card:hover .account-card__icon {
            transform: scale(1.1) rotate(5deg) !important;
            filter: brightness(1.1) contrast(1.1) !important;
        }

        .account-card__content {
            padding: 0 30px 30px !important;
            position: relative !important;
            z-index: 2 !important;
            transition: all 0.3s ease !important;
        }

        .account-card__title {
            margin-bottom: 15px !important;
            font-size: 1.8rem !important;
            color: #1A1A1A !important;
            font-family: 'Josefin Sans', Helvetica, sans-serif !important;
            transition: all 0.3s ease !important;
            text-align: center !important;
            font-weight: 700 !important;
        }

        .savings-card:hover .account-card__title {
            color: #4CAF50 !important;
        }

        .current-card:hover .account-card__title {
            color: #2196F3 !important;
        }

        .student-card:hover .account-card__title {
            color: #FF9800 !important;
        }

        .account-card__subtitle {
            color: #666 !important;
            font-family: 'Josefin Sans', Helvetica, sans-serif !important;
            line-height: 1.5 !important;
            transition: all 0.3s ease !important;
            text-align: center !important;
            margin-bottom: 25px !important;
            font-style: italic !important;
            font-size: 1.1rem !important;
        }

        .account-card:hover .account-card__subtitle {
            color: #333 !important;
        }

        .account-features {
            list-style: none !important;
            padding: 0 !important;
            margin-bottom: 30px !important;
        }

        .account-features li {
            margin-bottom: 12px !important;
            font-family: 'Josefin Sans', Helvetica, sans-serif !important;
            color: #444 !important;
            transition: all 0.3s ease !important;
            padding: 10px 0 10px 30px !important;
            border-bottom: 1px solid #f1f3f4 !important;
            position: relative !important;
            font-size: 1rem !important;
            line-height: 1.5 !important;
        }

        .account-features li::before {
            content: '✓' !important;
            position: absolute !important;
            left: 0 !important;
            font-weight: bold !important;
            font-size: 1.2rem !important;
            top: 10px !important;
            transition: all 0.3s ease !important;
        }

        .savings-card .account-features li::before {
            color: #4CAF50 !important;
        }

        .current-card .account-features li::before {
            color: #2196F3 !important;
        }

        .student-card .account-features li::before {
            color: #FF9800 !important;
        }

        .account-features li:hover {
            color: #1A1A1A !important;
/*            transform: translateX(8px) !important;*/
            background: rgba(0, 0, 0, 0.02) !important;
        }

        .savings-card .account-features li:hover {
            border-bottom-color: #4CAF50 !important;
        }

        .current-card .account-features li:hover {
            border-bottom-color: #2196F3 !important;
        }

        .student-card .account-features li:hover {
            border-bottom-color: #FF9800 !important;
        }

        .account-features li:hover::before {
            transform: scale(1.3) !important;
        }

        .account-card__buttons {
            display: flex !important;
            gap: 15px !important;
            margin-top: 25px !important;
        }

        .account-btn {
            flex: 1 !important;
            text-align: center !important;
            padding: 15px 20px !important;
            border-radius: 10px !important;
            text-decoration: none !important;
            font-weight: 700 !important;
            font-family: 'Josefin Sans', Helvetica, sans-serif !important;
            transition: all 0.3s ease !important;
            position: relative !important;
            overflow: hidden !important;
            text-transform: uppercase !important;
            letter-spacing: 1.2px !important;
            font-size: 0.9rem !important;
            border: 2px solid transparent !important;
            display: block !important;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1) !important;
        }

        .account-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.3);
            transition: left 0.5s;
        }

        .account-btn:hover::before {
            left: 100%;
        }

        .account-btn--primary {
            color: #1A1A1A !important;
        }

        .savings-card .account-btn--primary {
            background: #4CAF50 !important;
        }

        .current-card .account-btn--primary {
            background: #2196F3 !important;
        }

        .student-card .account-btn--primary {
            background: #FF9800 !important;
        }

        .account-btn--primary:hover {
            transform: translateY(-3px) !important;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2) !important;
            color: #1A1A1A !important;
        }

        .savings-card .account-btn--primary:hover {
            background: #388E3C !important;
        }

        .current-card .account-btn--primary:hover {
            background: #1976D2 !important;
        }

        .student-card .account-btn--primary:hover {
            background: #F57C00 !important;
        }

        .account-btn--secondary {
            background: transparent !important;
            font-weight: 600 !important;
        }

        .savings-card .account-btn--secondary {
            color: #4CAF50 !important;
            border-color: #4CAF50 !important;
        }

        .current-card .account-btn--secondary {
            color: #2196F3 !important;
            border-color: #2196F3 !important;
        }

        .student-card .account-btn--secondary {
            color: #FF9800 !important;
            border-color: #FF9800 !important;
        }

        .account-btn--secondary:hover {
            transform: translateY(-3px) !important;
            color: #1A1A1A !important;
        }

        .savings-card .account-btn--secondary:hover {
            background: #4CAF50 !important;
        }

        .current-card .account-btn--secondary:hover {
            background: #2196F3 !important;
        }

        .student-card .account-btn--secondary:hover {
            background: #FF9800 !important;
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .account-grid {
                grid-template-columns: repeat(2, 1fr) !important;
            }
        }

        @media (max-width: 768px) {
            .account-grid {
                grid-template-columns: 1fr !important;
            }

            .account-card__buttons {
                flex-direction: column !important;
            }

            .account-card:hover {
                transform: translateY(-8px) !important;
            }
        }
    </style>
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

    <!-- ACCOUNT TYPES SECTION - NEW MODERN DESIGN -->
    <section class="account-types" aria-labelledby="account-types-title">
        <div class="container">
            <h2 id="account-types-title" class="section-title">Choose Your Account Type</h2>

            <div class="account-grid" role="list">
                <!-- Savings Account -->
                <article class="account-card savings-card" role="listitem">
                    <div class="account-card__icon-section">
                        <div class="account-card__icon">🏦</div>
                    </div>
                    <div class="account-card__content">
                        <h3 class="account-card__title">Savings Account</h3>
                        <p class="account-card__subtitle">High-yield savings for your future growth</p>
                        <ul class="account-features">
                            <li>6.5% APY interest rate</li>
                            <li>500&#2547/year maintenance charge</li>
                            <li>Platinum Card - Dual currency support</li>
                            <li>Investment advisory services</li>
                            <li>Limited transactions (50/month)</li>
                            <li>Premium customer support</li>
                            <li>Mobile banking & online access</li>
                        </ul>
                        <div class="account-card__buttons">
                            <a href="Register.aspx" class="account-btn account-btn--primary">Open Account</a>
                        </div>
                    </div>
                </article>

                <!-- Current Account -->
                <article class="account-card current-card" role="listitem">
                    <div class="account-card__icon-section">
                        <div class="account-card__icon">💼</div>
                    </div>
                    <div class="account-card__content">
                        <h3 class="account-card__title">Current Account</h3>
                        <p class="account-card__subtitle">Perfect for business and daily transactions</p>
                        <ul class="account-features">
                            <li>4.5% APY interest rate</li>
                            <li>1000&#2547/year maintenance charge</li>
                            <li>Gold Card - Dual currency support</li>
                            <li>Business banking solutions</li>
                            <li>Unlimited transactions</li>
                            <li>Overdraft facility available</li>
                            <li>Checkbook & demand drafts</li>
                        </ul>
                        <div class="account-card__buttons">
                            <a href="Register.aspx" class="account-btn account-btn--primary">Open Account</a>
                        </div>
                    </div>
                </article>

                <!-- Student Account -->
                <article class="account-card student-card" role="listitem">
                    <div class="account-card__icon-section">
                        <div class="account-card__icon">🎓</div>
                    </div>
                    <div class="account-card__content">
                        <h3 class="account-card__title">Student Account</h3>
                        <p class="account-card__subtitle">Designed for students with zero charges</p>
                        <ul class="account-features">
                            <li>2.5% APY interest rate</li>
                            <li>0&#2547/year - No maintenance charges</li>
                            <li>Basic Card - Standard features</li>
                            <li>Educational loan assistance</li>
                            <li>Limited transactions (30/month)</li>
                            <li>Student discounts & offers</li>
                            <li>Mobile banking access</li>
                        </ul>
                        <div class="account-card__buttons">
                            <a href="Register.aspx" class="account-btn account-btn--primary">Open Account</a>
                        </div>
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