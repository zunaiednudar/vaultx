<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="vaultx.Profile" %>

<asp:Content ID="ProfileHead" ContentPlaceHolderID="SiteHead" runat="server">
    <link rel="stylesheet" href="styles/profile.css" />
    <meta name="description" content="VaultX Bank — User Profile Information" />
</asp:Content>

<asp:Content ID="ProfileMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <div class="profile-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <asp:Image ID="imgProfile" runat="server" CssClass="profile-image" AlternateText="Profile Picture" />
            <h1 class="profile-name">
                <asp:Label ID="lblFullName" runat="server" Text=""></asp:Label>
            </h1>
            <p class="profile-profession">
                <asp:Label ID="lblProfession" runat="server" Text=""></asp:Label>
            </p>
        </div>

        <!-- Profile Information -->
        <div class="profile-content">
            <!-- Personal Information -->
            <div class="info-section">
                <h2 class="section-title">Personal Information</h2>
                <div class="info-item">
                    <label>Father's Name:</label>
                    <span><asp:Label ID="lblFathersName" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>Mother's Name:</label>
                    <span><asp:Label ID="lblMothersName" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>Date of Birth:</label>
                    <span><asp:Label ID="lblDateOfBirth" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>NID Number:</label>
                    <span><asp:Label ID="lblNIDNumber" runat="server" Text=""></asp:Label></span>
                </div>
            </div>

            <!-- Contact Information -->
            <div class="info-section">
                <h2 class="section-title">Contact Information</h2>
                <div class="info-item">
                    <label>Email:</label>
                    <span><asp:Label ID="lblEmail" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>Phone:</label>
                    <span><asp:Label ID="lblPhoneNumber" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>Address:</label>
                    <span><asp:Label ID="lblAddress" runat="server" Text=""></asp:Label></span>
                </div>
            </div>

            <!-- Location Information -->
            <div class="info-section">
                <h2 class="section-title">Location Details</h2>
                <div class="info-item">
                    <label>Division:</label>
                    <span><asp:Label ID="lblDivision" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>District:</label>
                    <span><asp:Label ID="lblDistrict" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>Upazilla:</label>
                    <span><asp:Label ID="lblUpazilla" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>Postal Code:</label>
                    <span><asp:Label ID="lblPostalCode" runat="server" Text=""></asp:Label></span>
                </div>
            </div>

            <!-- Financial Information -->
            <div class="info-section">
                <h2 class="section-title">Financial Information</h2>
                <div class="info-item">
                    <label>Profession:</label>
                    <span><asp:Label ID="lblProfessionDetail" runat="server" Text=""></asp:Label></span>
                </div>
                <div class="info-item">
                    <label>Monthly Earnings:</label>
                    <span class="earnings"><asp:Label ID="lblMonthlyEarnings" runat="server" Text=""></asp:Label></span>
                </div>
            </div>
        </div>

        <!-- Action Buttons 
        <div class="profile-actions">
            <asp:Button ID="btnEditProfile" runat="server" Text="Edit Profile" CssClass="btn btn-primary" />
            <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn btn-secondary" />
        </div>
        -->
    </div>
</asp:Content>