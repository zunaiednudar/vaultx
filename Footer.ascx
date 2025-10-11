<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Footer.ascx.cs" Inherits="vaultx.Footer" %>

<footer class="site-footer">
    <div class="footer-content">
        <div class="footer-section">
            <h3>VaultX Bank</h3>
            <p>Secure. Smart. Seamless—modern banking designed for you.</p>
        </div>

        <div class="footer-section">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="Home.aspx">Home</a></li>
                <li><a href="Terms.aspx">Terms & Conditions</a></li>
                <li><a href="FAQ.aspx">FAQ</a></li>
                <li><a href="AdminLogin.aspx">Admin Portal</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h4>Contact Us</h4>
            <ul>
                <li><i class="fa fa-map-marker"></i> 123 Finance Ave, Khulna 9100</li>
                <li><i class="fa fa-phone"></i> +880 17 1234 5678</li>
                <li><i class="fa fa-envelope"></i> support@vaultxbank.com</li>
            </ul>
        </div>

        <div class="footer-section">
            <h4>Follow Us</h4>
            <div class="social-links">
                <a href="#" aria-label="Facebook"><i class="fab fa-facebook"></i></a>
                <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin"></i></a>
                <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>&copy; <%= DateTime.Now.Year %> VaultX Bank. All rights reserved.</p>
    </div>
</footer>

<style>
    .site-footer {
        background: linear-gradient(135deg, #1A1A1A 0%, #2C3E50 100%);
        color: #fff;
        padding: 50px 20px 20px;
        margin-top: 50px;
        font-family: var(--font-stack);
    }

    .footer-content {
        max-width: 1200px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 40px;
        margin-bottom: 30px;
    }

    .footer-section h3 {
        font-size: 1.8rem;
        margin-bottom: 15px;
        background: linear-gradient(90deg, #4ECDC4, #55EFC4);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-weight: 700;
    }

    .footer-section h4 {
        font-size: 1.2rem;
        margin-bottom: 15px;
        color: #4ECDC4;
        font-weight: 600;
    }

    .footer-section p {
        line-height: 1.6;
        opacity: 0.9;
    }

    .footer-section ul {
        list-style: none;
        padding: 0;
    }

    .footer-section ul li {
        margin-bottom: 10px;
        transition: all 0.3s ease;
    }

    .footer-section ul li a {
        color: #fff;
        text-decoration: none;
        transition: all 0.3s ease;
        opacity: 0.9;
    }

    .footer-section ul li a:hover {
        color: #4ECDC4;
        opacity: 1;
        padding-left: 5px;
    }

    .footer-section ul li i {
        margin-right: 10px;
        color: #4ECDC4;
    }

    .social-links {
        display: flex;
        gap: 15px;
    }

    .social-links a {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: rgba(78, 205, 196, 0.1);
        color: #4ECDC4;
        font-size: 1.2rem;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .social-links a:hover {
        background: #4ECDC4;
        color: #1A1A1A;
        transform: translateY(-3px);
    }

    .footer-bottom {
        text-align: center;
        padding-top: 20px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        opacity: 0.7;
    }

    @media (max-width: 768px) {
        .footer-content {
            grid-template-columns: 1fr;
            gap: 30px;
        }

        .site-footer {
            padding: 30px 20px 20px;
        }
    }
</style>