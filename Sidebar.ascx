<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Sidebar.ascx.cs" Inherits="vaultx.Sidebar" %>

<aside class="site-sidebar" id="sidebar">
    <!-- Top menu -->
    <ul class="sidebar-menu">
        <br /><br />
        <li class='<%# Page.Title == "Home" ? "active" : "" %>'>
            <a href="Home.aspx"><i class="fas fa-home"></i> Home</a>
        </li>
        <li class='<%# Page.Title == "Dashboard" ? "active" : "" %>'>
            <a href="Dashboard.aspx"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        </li>
        <li>
            <a href="FundTransfer.aspx"><i class="fas fa-exchange-alt"></i> Fund Transfer</a>
        </li>
        <li>
            <a href="Profile.aspx"><i class="fas fa-user"></i> Profile</a>
        </li>
        <li>
            <a href="Terms.aspx"><i class="fas fa-file-contract"></i> Terms &amp; Conditions</a>
        </li>
        <li>
            <a href="FAQ.aspx"><i class="fas fa-question-circle"></i> FAQ</a>
        </li>
    </ul>

    <!-- Bottom menu -->
    <ul class="sidebar-menu bottom-menu">
        <li>
            <a href="Logout.aspx"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </li>
    </ul>
</aside>
