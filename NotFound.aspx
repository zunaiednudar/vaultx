<%@ Page Title="Page Not Found" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

<asp:Content ID="NotFoundHead" ContentPlaceHolderID="SiteHead" runat="server">
    <meta name="description" content="VaultX Bank — Page Not Found" />
    <style>
        .notfound-container {
            text-align: center;
            padding: 50px 20px;
            min-height: 400px;
        }
        .notfound-icon {
            font-size: 100px;
            color: #f39c12;
            margin-bottom: 20px;
        }
        .notfound-title {
            font-size: 48px;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .notfound-message {
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

<asp:Content ID="NotFoundMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <div class="notfound-container">
        <div class="notfound-icon">
            <i class="fas fa-search"></i>
        </div>
        <h1 class="notfound-title">404</h1>
        <p class="notfound-message">
            The page you're looking for doesn't exist or has been moved.
        </p>
        <p class="notfound-message">
            Please check the URL or use the navigation menu to find what you need.
        </p>
        <a href="Home.aspx" class="btn-home">
            <i class="fas fa-home"></i> Return to Home
        </a>
    </div>
</asp:Content>