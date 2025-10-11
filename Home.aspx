<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="vaultx.Home" %>

<asp:Content ID="HomeHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/global.css" />
    <link rel="stylesheet" href="styles/home.css" />
    <script src="scripts/home.js" defer></script>
    <meta name="description" content="VaultX Bank — secure, smart, and modern banking for everyone." />
    
    <!-- ============================================= -->
    <!-- INLINE STYLES FOR ACCOUNT & MARQUEE SECTIONS -->
    <!-- ============================================= -->
    <style>
        /* ========================================== */
        /* ACCOUNT SECTION STYLES */
        /* Provides comprehensive styling for account type cards with gradients, hover effects, and responsive design */
        /* ========================================== */
        
        /* Main account types section with gradient background and decorative pattern */
        .account-types {
            padding: 50px 0 !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%) !important;
            position: relative !important;
            overflow: hidden !important;
        }

        /* Decorative SVG pattern overlay for visual interest */
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

        /* Grid layout for account cards - 3 columns on desktop */
        .account-grid {
            display: grid !important;
            grid-template-columns: repeat(3, 1fr) !important;
            gap: 30px !important;
            align-items: start !important;
            position: relative !important;
            z-index: 2 !important;
        }

        /* Individual account card base styling with shadow and transitions */
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

        /* Card hover effect - lifts and scales the card */
        .account-card:hover {
            transform: translateY(-15px) scale(1.02) !important;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2) !important;
        }

        /* Account-specific border colors on hover */
        .savings-card:hover {
            border-color: #4CAF50 !important;
        }

        .current-card:hover {
            border-color: #2196F3 !important;
        }

        .student-card:hover {
            border-color: #FF9800 !important;
        }

        /* Icon section at top of each card */
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

        /* Gradient backgrounds for each account type icon section */
        .savings-card .account-card__icon-section {
            background: linear-gradient(135deg, #4CAF50 0%, #66BB6A 100%) !important;
        }

        .current-card .account-card__icon-section {
            background: linear-gradient(135deg, #2196F3 0%, #42A5F5 100%) !important;
        }

        .student-card .account-card__icon-section {
            background: linear-gradient(135deg, #FF9800 0%, #FFA726 100%) !important;
        }

        /* Large emoji icon styling */
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

        /* Icon animation on card hover */
        .account-card:hover .account-card__icon {
            transform: scale(1.1) rotate(5deg) !important;
            filter: brightness(1.1) contrast(1.1) !important;
        }

        /* Card content area below the icon */
        .account-card__content {
            padding: 0 30px 30px !important;
            position: relative !important;
            z-index: 2 !important;
            transition: all 0.3s ease !important;
        }

        /* Account type title styling */
        .account-card__title {
            margin-bottom: 15px !important;
            font-size: 1.8rem !important;
            color: #1A1A1A !important;
            font-family: 'Josefin Sans', Helvetica, sans-serif !important;
            transition: all 0.3s ease !important;
            text-align: center !important;
            font-weight: 700 !important;
        }

        /* Title color changes on hover to match account theme */
        .savings-card:hover .account-card__title {
            color: #4CAF50 !important;
        }

        .current-card:hover .account-card__title {
            color: #2196F3 !important;
        }

        .student-card:hover .account-card__title {
            color: #FF9800 !important;
        }

        /* Subtitle/tagline styling */
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

        /* Features list container */
        .account-features {
            list-style: none !important;
            padding: 0 !important;
            margin-bottom: 30px !important;
        }

        /* Individual feature items with checkmark */
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

        /* Checkmark icon before each feature */
        .account-features li::before {
            content: '✓' !important;
            position: absolute !important;
            left: 0 !important;
            font-weight: bold !important;
            font-size: 1.2rem !important;
            top: 10px !important;
            transition: all 0.3s ease !important;
        }

        /* Account-specific checkmark colors */
        .savings-card .account-features li::before {
            color: #4CAF50 !important;
        }

        .current-card .account-features li::before {
            color: #2196F3 !important;
        }

        .student-card .account-features li::before {
            color: #FF9800 !important;
        }

        /* Feature item hover effects */
        .account-features li:hover {
            color: #1A1A1A !important;
            background: rgba(0, 0, 0, 0.02) !important;
        }

        /* Bottom border color change on hover */
        .savings-card .account-features li:hover {
            border-bottom-color: #4CAF50 !important;
        }

        .current-card .account-features li:hover {
            border-bottom-color: #2196F3 !important;
        }

        .student-card .account-features li:hover {
            border-bottom-color: #FF9800 !important;
        }

        /* Checkmark scale animation on hover */
        .account-features li:hover::before {
            transform: scale(1.3) !important;
        }

        /* Button container at bottom of card */
        .account-card__buttons {
            display: flex !important;
            gap: 15px !important;
            margin-top: 25px !important;
        }

        /* Base button styling for account cards */
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

        /* Shine effect animation on button hover */
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

        /* Primary button base color */
        .account-btn--primary {
            color: #1A1A1A !important;
        }

        /* Account-specific primary button colors */
        .savings-card .account-btn--primary {
            background: #4CAF50 !important;
        }

        .current-card .account-btn--primary {
            background: #2196F3 !important;
        }

        .student-card .account-btn--primary {
            background: #FF9800 !important;
        }

        /* Primary button hover effects */
        .account-btn--primary:hover {
            transform: translateY(-3px) !important;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2) !important;
            color: #1A1A1A !important;
        }

        /* Darker shades on hover for primary buttons */
        .savings-card .account-btn--primary:hover {
            background: #388E3C !important;
        }

        .current-card .account-btn--primary:hover {
            background: #1976D2 !important;
        }

        .student-card .account-btn--primary:hover {
            background: #F57C00 !important;
        }

        /* Secondary button styling - outlined */
        .account-btn--secondary {
            background: transparent !important;
            font-weight: 600 !important;
        }

        /* Account-specific secondary button colors */
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

        /* Secondary button hover effects */
        .account-btn--secondary:hover {
            transform: translateY(-3px) !important;
            color: #1A1A1A !important;
        }

        /* Fill background on hover for secondary buttons */
        .savings-card .account-btn--secondary:hover {
            background: #4CAF50 !important;
        }

        .current-card .account-btn--secondary:hover {
            background: #2196F3 !important;
        }

        .student-card .account-btn--secondary:hover {
            background: #FF9800 !important;
        }

        /* ========================================== */
        /* UPDATES MARQUEE STYLES - SIMPLIFIED */
        /* Clean, minimal scrolling updates banner */
        /* ========================================== */
        
        /* Main banner container with dark gradient background */
        .updates-banner {
            background: linear-gradient(90deg, #0f172a 0%, #1e3a8a 50%, #0f172a 100%);
            color: #fff;
            padding: 12px 0;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        /* Animated gradient background effect */
        .updates-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 200%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.05), transparent);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { left: -100%; }
            100% { left: 100%; }
        }

        /* Inner container for centering content */
        .updates-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }

        /* Static "UPDATES" label badge */
        .updates-label {
            background: rgba(59, 130, 246, 0.3);
            backdrop-filter: blur(10px);
            color: #fff;
            padding: 10px 18px;
            border-radius: 8px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            font-size: 0.9rem;
            white-space: nowrap;
            border: 2px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        /* Marquee container - hides overflow */
        .marquee {
            overflow: hidden;
            position: relative;
            flex: 1;
        }

        /* Scrolling track containing update items */
        .marquee__track {
            display: inline-flex;
            gap: 60px;
            white-space: nowrap;
            align-items: center;
            animation: marquee 35s linear infinite;
            padding: 2px 0;
        }

        /* Individual update item styling - SIMPLIFIED (no background, border, or icon) */
        .marquee__item {
            display: inline-block;
            color: #fff;
            font-weight: 500;
            font-size: 0.95rem;
            font-family: 'Josefin Sans', Helvetica, sans-serif;
            transition: all 0.3s ease;
        }

        /* Hover effect - pauses animation and slightly brightens text */
        .marquee:hover .marquee__track {
            animation-play-state: paused;
        }

        .marquee__item:hover {
            color: #fbbf24;
            transform: scale(1.05);
        }

        /* Continuous scrolling animation - duplicated content creates seamless loop */
        @keyframes marquee {
            from { transform: translateX(0%); }
            to { transform: translateX(-50%); }
        }

        /* ========================================== */
        /* RESPONSIVE DESIGN */
        /* Adjusts layout for different screen sizes */
        /* ========================================== */
        
        /* Tablet view - 2 column grid */
        @media (max-width: 992px) {
            .account-grid {
                grid-template-columns: repeat(2, 1fr) !important;
            }
        }

        /* Mobile view - single column and stacked elements */
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

            /* Stack updates label and marquee vertically on mobile */
            .updates-container {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
            }

            .updates-label {
                align-self: flex-start;
            }

            /* Faster scroll on mobile for better UX */
            .marquee__track {
                animation-duration: 25s;
                gap: 40px;
            }
        }

        /* Small mobile - reduce padding and font sizes */
        @media (max-width: 600px) {
            .updates-banner {
                padding: 10px 0;
            }

            .updates-label {
                font-size: 0.8rem;
                padding: 8px 14px;
            }

            .marquee__item {
                font-size: 0.85rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="HomeMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <!-- ============================================= -->
    <!-- HERO SECTION -->
    <!-- Main banner with full-width image and overlay text -->
    <!-- ============================================= -->
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

    <!-- ============================================= -->
    <!-- UPDATES MARQUEE SECTION - SIMPLIFIED -->
    <!-- Clean scrolling text updates without borders or icons -->
    <!-- Accessible with ARIA labels and pause-on-hover -->
    <!-- ============================================= -->
    <section class="updates-banner" aria-label="Latest updates and announcements" role="region">
        <div class="updates-container">
            <!-- Static label badge -->
            <div class="updates-label" aria-hidden="true">Updates</div>
            
            <!-- Scrolling marquee container -->
            <div class="marquee" aria-live="polite">
                <!-- Track containing update items - duplicated for seamless loop -->
                <div class="marquee__track">
                    <!-- First set of updates -->
                    <span class="marquee__item">New: 6.5% APY on Savings Accounts — Limited time offer!</span>
                    <span class="marquee__item">Service Notice: Scheduled maintenance Sat 11pm–1am BST.</span>
                    <span class="marquee__item">Security Tip: Never share OTP or PIN — official channels only.</span>
                    <span class="marquee__item">Product Launch: Student accounts now include free overdraft up to ৳5,000.</span>
                    <span class="marquee__item">Partner Offer: Get 10% cashback on partner merchants — check app for details.</span>
                    <span class="marquee__item">Mobile App: New features added - Try bill splitting and expense tracking!</span>
                    
                    <!-- Duplicate set for continuous scrolling effect -->
                    <span class="marquee__item">New: 6.5% APY on Savings Accounts — Limited time offer!</span>
                    <span class="marquee__item">Service Notice: Scheduled maintenance Sat 11pm–1am BST.</span>
                    <span class="marquee__item">Security Tip: Never share OTP or PIN — official channels only.</span>
                    <span class="marquee__item">Product Launch: Student accounts now include free overdraft up to ৳5,000.</span>
                    <span class="marquee__item">Partner Offer: Get 10% cashback on partner merchants — check app for details.</span>
                    <span class="marquee__item">Mobile App: New features added - Try bill splitting and expense tracking!</span>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================= -->
    <!-- ABOUT SECTION -->
    <!-- Describes VaultX Bank's mission and value proposition -->
    <!-- ============================================= -->
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

    <!-- ============================================= -->
    <!-- FEATURE CARDS SECTION -->
    <!-- Showcases key banking features in card grid layout -->
    <!-- ============================================= -->
    <section class="features" aria-labelledby="features-title">
        <div class="container">
            <h2 id="features-title" class="section-title">Explore Our Features</h2>

            <div class="card-grid" role="list">
                <!-- Feature Card 1: Mobile Banking -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature1.jpg" alt="Mobile phone showing banking app" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Instant Mobile Banking</h3>
                        <p class="card__text">Transfer, pay bills, and manage cards on the go with real-time alerts.</p>
                    </div>
                </article>

                <!-- Feature Card 2: Security -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature2.jpg" alt="Shield icon representing security" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Bank-Grade Security</h3>
                        <p class="card__text">Multi-factor authentication and AI-driven fraud monitoring keep your money safe.</p>
                    </div>
                </article>

                <!-- Feature Card 3: Savings -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature3.jpg" alt="Hand holding a savings jar" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">High-Yield Savings</h3>
                        <p class="card__text">Competitive rates with zero hidden fees—watch your savings grow faster.</p>
                    </div>
                </article>

                <!-- Feature Card 4: Smart Cards -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature4.jpg" alt="Credit card on a table" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Smart Cards</h3>
                        <p class="card__text">Freeze, set limits, and create virtual cards for safer online shopping.</p>
                    </div>
                </article>

                <!-- Feature Card 5: Investing -->
                <article class="card" role="listitem">
                    <div class="card__image-wrap">
                        <img src="images/feature5.jpg" alt="Laptop with investment charts" class="card__image" />
                    </div>
                    <div class="card__body">
                        <h3 class="card__title">Investing Made Easy</h3>
                        <p class="card__text">Start small with diversified portfolios and auto-invest plans.</p>
                    </div>
                </article>

                <!-- Feature Card 6: Support -->
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

    <!-- ============================================= -->
    <!-- ACCOUNT TYPES SECTION -->
    <!-- Displays three account types with detailed features -->
    <!-- Interactive cards with hover effects -->
    <!-- ============================================= -->
    <section class="account-types" aria-labelledby="account-types-title">
        <div class="container">
            <h2 id="account-types-title" class="section-title">Account Types</h2>

            <div class="account-grid" role="list">
                <!-- Savings Account Card -->
                <article class="account-card savings-card" role="listitem">
                    <div class="account-card__icon-section">
                        <div class="account-card__icon">🏦</div>
                    </div>
                    <div class="account-card__content">
                        <h3 class="account-card__title">Savings Account</h3>
                        <p class="account-card__subtitle">High-yield savings for your future growth</p>
                        <ul class="account-features">
                            <li>6.5% APY interest rate</li>
                            <li>৳500/year maintenance charge</li>
                            <li>Platinum Card - Dual currency support</li>
                            <li>Investment advisory services</li>
                            <li>Limited transactions (50/month)</li>
                            <li>Premium customer support</li>
                            <li>Mobile banking & online access</li>
                        </ul>
                    </div>
                </article>

                <!-- Current Account Card -->
                <article class="account-card current-card" role="listitem">
                    <div class="account-card__icon-section">
                        <div class="account-card__icon">💼</div>
                    </div>
                    <div class="account-card__content">
                        <h3 class="account-card__title">Current Account</h3>
                        <p class="account-card__subtitle">Perfect for business and daily transactions</p>
                        <ul class="account-features">
                            <li>4.5% APY interest rate</li>
                            <li>৳1000/year maintenance charge</li>
                            <li>Gold Card - Dual currency support</li>
                            <li>Business banking solutions</li>
                            <li>Unlimited transactions</li>
                            <li>Overdraft facility available</li>
                            <li>Checkbook & demand drafts</li>
                        </ul>
                    </div>
                </article>

                <!-- Student Account Card -->
                <article class="account-card student-card" role="listitem">
                    <div class="account-card__icon-section">
                        <div class="account-card__icon">🎓</div>
                    </div>
                    <div class="account-card__content">
                        <h3 class="account-card__title">Student Account</h3>
                        <p class="account-card__subtitle">Designed for students with zero charges</p>
                        <ul class="account-features">
                            <li>2.5% APY interest rate</li>
                            <li>৳0/year - No maintenance charges</li>
                            <li>Basic Card - Standard features</li>
                            <li>Educational loan assistance</li>
                            <li>Limited transactions (30/month)</li>
                            <li>Student discounts & offers</li>
                            <li>Mobile banking access</li>
                        </ul>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <!-- ============================================= -->
    <!-- CONTACT SECTION -->
    <!-- Provides bank contact information and security notice -->
    <!-- Split layout with contact details and security panel -->
    <!-- ============================================= -->
    <section class="contact" aria-labelledby="contact-title">
        <div class="container contact__grid">
            <!-- Contact Information Column -->
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

            <!-- Security Notice Panel -->
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