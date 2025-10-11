<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="vaultx.AdminLogin" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VaultX - Admin Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:ital,wght@0,100..700;1,100..700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: var(--font-stack);
            background: #f5f5f5;
            min-height: 100vh;
        }

        .admin-login-container {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* Left Panel - Image */
        .admin-left-panel {
            flex: 1;
            position: relative;
            overflow: hidden;
            min-height: 100vh;
        }

        .admin-left-panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .admin-left-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(26, 26, 26, 0.7) 0%, rgba(44, 62, 80, 0.8) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: white;
            padding: 40px;
            text-align: center;
        }

        .admin-branding h1 {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 800;
            margin-bottom: 20px;
            background: linear-gradient(90deg, #4ECDC4, #55EFC4, #A7FFE4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 8px;
            text-shadow: 0 0 30px rgba(78, 205, 196, 0.3);
        }

        .admin-branding p {
            font-size: clamp(1rem, 2vw, 1.3rem);
            opacity: 0.95;
            max-width: 500px;
            line-height: 1.8;
            margin-top: 15px;
        }

        .admin-features {
            margin-top: 40px;
            display: grid;
            gap: 20px;
            max-width: 600px;
        }

        .admin-feature-item {
            display: flex;
            align-items: center;
            gap: 15px;
            background: rgba(255, 255, 255, 0.1);
            padding: 15px 25px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .admin-feature-item:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(10px);
        }

        .admin-feature-item i {
            font-size: 2rem;
            color: #4ECDC4;
        }

        .admin-feature-item span {
            font-size: 1.1rem;
            font-weight: 500;
        }

        /* Right Panel - Login Form */
        .admin-right-panel {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px;
            min-height: 100vh;
        }

        .admin-form-container {
            width: 100%;
            max-width: 480px;
            background: white;
            padding: 50px 40px;
            border-radius: 25px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideInRight 0.6s ease-out;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .admin-form-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .admin-form-header .admin-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }

        .admin-form-header .admin-icon i {
            font-size: 2.5rem;
            color: white;
        }

        .admin-form-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .admin-form-header p {
            color: #666;
            font-size: 1rem;
        }

        .form-group {
            position: relative;
            margin-bottom: 25px;
        }

        .form-group i {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #667eea;
            font-size: 1.2rem;
            z-index: 1;
        }

        .form-control {
            width: 100%;
            padding: 15px 15px 15px 50px;
            font-size: 1rem;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            outline: none;
            transition: all 0.3s ease;
            background-color: #f8f9fa;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background-color: white;
        }

        .btn-admin-login {
            width: 100%;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-admin-login:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
        }

        .btn-admin-login:active {
            transform: translateY(-1px);
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-link a:hover {
            color: #764ba2;
            transform: translateX(-5px);
        }

        /* Success/Fail Panels */
        .result-panel {
            text-align: center;
            animation: fadeInScale 0.5s ease-out;
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .result-panel .icon {
            font-size: 5rem;
            margin-bottom: 20px;
        }

        .result-panel h2 {
            font-size: 2rem;
            margin-bottom: 15px;
            color: #333;
        }

        .result-panel p {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 25px;
        }

        .btn-retry {
            padding: 12px 30px;
            font-size: 1rem;
            font-weight: 600;
            color: white;
            background: linear-gradient(135deg, #FF6B6B 0%, #FF9F40 100%);
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-retry:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(255, 107, 107, 0.3);
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .admin-login-container {
                flex-direction: column;
            }

            .admin-left-panel {
                min-height: 40vh;
            }

            .admin-right-panel {
                min-height: 60vh;
            }

            .admin-features {
                display: none;
            }
        }

        @media (max-width: 576px) {
            .admin-form-container {
                padding: 40px 25px;
            }

            .admin-branding h1 {
                font-size: 2rem;
                letter-spacing: 4px;
            }

            .admin-form-header h2 {
                font-size: 1.6rem;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="admin-login-container">
            <!-- Left Panel - Branding & Image -->
            <div class="admin-left-panel">
                <img src="images/adminlogin.jpg" alt="VaultX Admin Portal" />
                <div class="admin-left-overlay">
                    <div class="admin-branding">
                        <h1>ADMIN PORTAL</h1>
                        <p>Secure access to VaultX Bank administrative dashboard. Manage users, accounts, and monitor all banking operations.</p>
                        
                        <div class="admin-features">
                            <div class="admin-feature-item">
                                <i class="fas fa-users-cog"></i>
                                <span>Manage Users & Accounts</span>
                            </div>
                            <div class="admin-feature-item">
                                <i class="fas fa-chart-line"></i>
                                <span>Monitor Transactions</span>
                            </div>
                            <div class="admin-feature-item">
                                <i class="fas fa-shield-alt"></i>
                                <span>Secure & Encrypted Access</span>
                            </div>
                            <div class="admin-feature-item">
                                <i class="fas fa-history"></i>
                                <span>Track Management History</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Panel - Login Form -->
            <div class="admin-right-panel">
                <!-- Login Form -->
                <asp:Panel ID="pnlLoginForm" runat="server" CssClass="admin-form-container">
                    <div class="admin-form-header">
                        <div class="admin-icon">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <h2>Admin Login</h2>
                        <p>Enter your credentials to access the admin panel</p>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-envelope"></i>
                        <asp:TextBox ID="txtAdminEmail" runat="server" CssClass="form-control" placeholder="Admin Email" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <i class="fa fa-lock"></i>
                        <asp:TextBox ID="txtAdminPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnAdminLogin" runat="server" Text="Login to Dashboard" CssClass="btn-admin-login" OnClick="btnAdminLogin_Click" />
                    </div>

                    <div class="back-link">
                        <a href="Home.aspx">
                            <i class="fas fa-arrow-left"></i>
                            Back to Home
                        </a>
                    </div>
                </asp:Panel>

                <!-- Success Panel -->
                <asp:Panel ID="pnlSuccess" runat="server" CssClass="admin-form-container result-panel" Visible="false">
                    <div class="icon" style="color: #4ECDC4;">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h2>Login Successful!</h2>
                    <p>Redirecting to admin dashboard...</p>
                </asp:Panel>

                <!-- Fail Panel -->
                <asp:Panel ID="pnlFail" runat="server" CssClass="admin-form-container result-panel" Visible="false">
                    <div class="icon" style="color: #FF6B6B;">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <h2>Login Failed</h2>
                    <p>Invalid credentials. Please check your email and password.</p>
                    <button type="button" class="btn-retry" onclick="window.location='AdminLogin.aspx'">Try Again</button>
                </asp:Panel>
            </div>
        </div>

        <script runat="server">
            protected void Page_PreInit(object sender, EventArgs e)
            {
                this.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
            }
        </script>
    </form>
</body>
</html>