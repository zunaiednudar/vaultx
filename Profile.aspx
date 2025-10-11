<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="vaultx.Profile" %>

<asp:Content ID="ProfileHead" ContentPlaceHolderID="SiteHead" runat="server">
    <!--
        Profile.aspx
        Purpose: Shows the current user's profile information and allows uploading a profile photo.
        Notes: Styles and JS for the upload/preview behavior live inline here for simplicity.
        Added extra comment lines to make maintenance notes visible to future readers.
    -->
    <link rel="stylesheet" href="styles/profile.css" />
    <meta name="description" content="VaultX Bank — User Profile Information" />
    <style>
        /* Profile Photo Upload Styles */
        .profile-photo-upload {
            position: relative;
            margin-top: 15px;
        }

        .photo-upload-overlay {
            position: absolute;
            top: -135px;
            left: 50%;
            transform: translateX(-50%);
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(0, 0, 0, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            cursor: pointer;
            z-index: 10;
        }

        .profile-image:hover + .profile-photo-upload .photo-upload-overlay,
        .photo-upload-overlay:hover {
            opacity: 1;
        }

        .photo-upload-overlay .upload-icon {
            color: white;
            font-size: 24px;
            font-weight: bold;
        }

        .file-upload-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
            margin-top: 10px;
        }

        .hidden-file {
            display: none;
        }

        .upload-controls {
            display: none; /* Hidden by default */
            flex-direction: column;
            gap: 15px;
            align-items: center;
            margin-top: 15px;
        }

        .upload-controls.show {
            display: flex; /* Show when photo is selected */
        }

        .btn-upload {
            padding: 10px 20px;
            border: none;
            border-radius: var(--radius);
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            font-family: var(--font-stack);
            text-decoration: none;
            display: inline-block;
            text-align: center;
            background: #007bff;
            color: white;
            min-width: 120px;
        }

        .btn-upload:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
        }

        .photo-preview-container {
            display: none;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .photo-preview-container.show {
            display: flex;
        }

        .photo-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--color-bg-secondary);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
        }

        .file-name-label {
            font-size: 0.85rem;
            color: var(--color-font-secondary);
            max-width: 250px;
            word-break: break-word;
            text-align: center;
            font-weight: 500;
        }

        .upload-success-message {
            background: #d4edda;
            color: #155724;
            padding: 10px 16px;
            border-radius: var(--radius);
            font-size: 0.85rem;
            margin-top: 15px;
            display: none;
            border: 1px solid #c3e6cb;
            text-align: center;
            animation: fadeInUp 0.3s ease-in;
        }

        @keyframes fadeInUp {
            from { 
                opacity: 0; 
                transform: translateY(10px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }

        .cancel-upload {
            background: #e41d1d;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: var(--radius);
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.25s ease;
            font-family: var(--font-stack);
        }

        .cancel-upload:hover {
            background: #f10c0c;
            transform: translateY(-1px);
        }

        .upload-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Hover effect on profile name - newly added */
        .profile-name {
            transition: color 0.25s ease, transform 0.25s ease;
            cursor: default;
            display: inline-block; /* allow transform without affecting flow */
        }

        .profile-name:hover {
            color: #007bff;
            transform: translateY(-3px) scale(1.03);
/*            text-decoration: underline;*/
            cursor: pointer; /* indicates interactiveness */
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .photo-upload-overlay {
                top: -115px;
                width: 100px;
                height: 100px;
            }

            .photo-preview {
                width: 90px;
                height: 90px;
            }

            .upload-actions {
                flex-direction: column;
                gap: 8px;
            }

            .btn-upload, .cancel-upload {
                width: 100%;
                max-width: 200px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="ProfileMainContent" ContentPlaceHolderID="SiteMainContent" runat="server">
    <!--
        Main profile markup.
        Extra comments have been added to clarify sections for future edits:
        - Header (image + name + profession)
        - Photo upload controls (preview, save, cancel)
        - Profile details sections (Personal, Contact, Location, Financial)
        These comments are intentionally verbose to help future maintainers.
    -->
    <div class="profile-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <!-- Profile picture - click to open file picker -->
            <asp:Image ID="imgProfile" runat="server" CssClass="profile-image" AlternateText="Profile Picture" onclick="triggerPhotoUpload()" />
            
            <!-- Profile Photo Upload Section -->
            <div class="profile-photo-upload">
                <div class="photo-upload-overlay" onclick="triggerPhotoUpload()">
                    <span class="upload-icon">📷</span>
                </div>
                
                <!-- Custom File Upload -->
                <div class="file-upload-wrapper">
                    <!-- Hidden FileUpload control. Kept server-side for compatibility with existing code-behind. -->
                    <asp:FileUpload ID="fuProfilePhoto" runat="server" CssClass="hidden-file" accept="image/*" />

                    <!-- Photo Preview (Hidden by default) -->
                    <div id="photoPreviewContainer" class="photo-preview-container">
                        <img id="photoPreview" class="photo-preview" alt="Photo Preview" />
                        <div id="selectedProfileFileName" class="file-name-label"></div>
                    </div>

                    <!-- Upload Controls (Hidden by default) -->
                    <div id="uploadControls" class="upload-controls">
                        <div class="upload-actions">
                            <!-- Upload Button -->
                            <asp:Button ID="btnUploadProfile" runat="server" Text="💾 Save Photo" CssClass="btn-upload" OnClick="btnUploadProfile_Click" />
                            <!-- Cancel Button -->
                            <button type="button" class="cancel-upload" onclick="cancelPhotoUpload()">✖ Cancel</button>
                        </div>
                    </div>

                    <!-- Success message -->
                    <div id="uploadSuccessMessage" class="upload-success-message">
                        ✅ Profile photo updated successfully!
                    </div>
                </div>
            </div>
            
            <!-- Profile name and profession -->
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

    <!-- JS Scripts for Profile Photo Upload -->
    <script type="text/javascript">
        // Global variables
        // NOTE: we use server controls; the ClientID values are resolved on server render.
        var profileFileInput = document.getElementById("<%= fuProfilePhoto.ClientID %>");
        var profileFileNameLabel = document.getElementById("selectedProfileFileName");
        var uploadButton = document.getElementById("<%= btnUploadProfile.ClientID %>");
        var photoPreviewContainer = document.getElementById("photoPreviewContainer");
        var photoPreview = document.getElementById("photoPreview");
        var uploadControls = document.getElementById("uploadControls");
        var successMessage = document.getElementById("uploadSuccessMessage");

        // Function to trigger file input (kept lightweight)
        function triggerPhotoUpload() {
            // If control exists, open file picker
            if (profileFileInput) profileFileInput.click();
        }

        // Function to cancel photo upload
        function cancelPhotoUpload() {
            // Reset file input
            if (profileFileInput) profileFileInput.value = '';
            
            // Hide preview and controls
            if (photoPreviewContainer) photoPreviewContainer.classList.remove("show");
            if (uploadControls) uploadControls.classList.remove("show");
            
            // Clear file name
            if (profileFileNameLabel) profileFileNameLabel.textContent = "";
            
            // Hide success message if visible
            if (successMessage) successMessage.style.display = 'none';
        }

        // Handle file selection (guard added for safety)
        if (profileFileInput) {
            profileFileInput.addEventListener("change", function () {
                if (profileFileInput.files.length > 0) {
                    var file = profileFileInput.files[0];
                    
                    // Validate file type
                    if (!file.type.startsWith('image/')) {
                        alert('Please select a valid image file.');
                        profileFileInput.value = '';
                        return;
                    }

                    // Validate file size (5MB limit)
                    if (file.size > 5 * 1024 * 1024) {
                        alert('File size must be less than 5MB.');
                        profileFileInput.value = '';
                        return;
                    }

                    // Display file name
                    if (profileFileNameLabel) profileFileNameLabel.textContent = file.name;
                    
                    // Show preview
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        if (photoPreview) {
                            photoPreview.src = e.target.result;
                            photoPreviewContainer.classList.add("show");
                            uploadControls.classList.add("show");
                        }
                    };
                    reader.readAsDataURL(file);
                    
                    // Hide success message if visible
                    if (successMessage) successMessage.style.display = 'none';
                } else {
                    // Hide preview and controls if no file selected
                    cancelPhotoUpload();
                }
            });
        }

        // Initialize on page load
        window.addEventListener('load', function() {
            // Add click handler for profile image
            var profileImage = document.getElementById("<%= imgProfile.ClientID %>");
            if (profileImage) {
                profileImage.style.cursor = "pointer";
                profileImage.title = "Click to upload new photo";
            }

            // Ensure controls are hidden initially
            if (photoPreviewContainer) photoPreviewContainer.classList.remove("show");
            if (uploadControls) uploadControls.classList.remove("show");
        });

        // Show success message after upload (called from code-behind)
        // Made it a global function to ensure it can be called
        window.showUploadSuccess = function () {
            // Show success message with animation
            if (successMessage) successMessage.style.display = 'block';

            // Hide preview and controls
            cancelPhotoUpload();

            // Hide success message after 4 seconds
            setTimeout(function () {
                if (successMessage) successMessage.style.display = 'none';
            }, 4000);
        };
    </script>
</asp:Content>