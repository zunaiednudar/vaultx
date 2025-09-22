<%@ Page Title="Error" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="ErrorHead" ContentPlaceHolderID="SiteHead" runat="server">
    <meta name="description" content="VaultX Bank — Error" />
    <style>
        .error-container {
            text-align: center;
            padding: 50px 20px;
            min-height: 400px;
        }
        .error-icon {
            font-size: 100px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 32px;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 18px;
            color: #7f8c8d;
            margin-bottom: 30px;
        }
        .btn-home {
            background-color: #3498db;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 20px;
        }
        .btn-home:hover {
            background-color: #2980b9;
            text-decoration: none;
            color: white;
        }
    </style>
</asp:Content>

<asp:Content ID="ErrorMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        <h1 class="error-title">Oops! Something went wrong</h1>
        <p class="error-message">
            We're sorry, but an unexpected error has occurred. Our team has been notified and is working to fix this issue.
        </p>
        <p class="error-message">
            Please try again later or contact our support team if the problem persists.
        </p>
        <a href="Home.aspx" class="btn-home">
            <i class="fas fa-home"></i> Return to Home
        </a>
    </div>
</asp:Content>