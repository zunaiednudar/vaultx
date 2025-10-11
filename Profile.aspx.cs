using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace vaultx
{
    /*
        Profile.aspx.cs
        Purpose: Server-side logic for the profile page. 
        Changes: Extra explanatory comments added to make intent and flow clearer for future maintainers.
        No behavior changes were made.
    */

    // Minimal DTO used by the repository and the page.
    public class User
    {
        // Unique identifier for the user (UID)
        public string UID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FathersName { get; set; }
        public string MothersName { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string NIDNumber { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string ProfileImage { get; set; }
        public string Division { get; set; }
        public string District { get; set; }
        public string Upazilla { get; set; }
        public string Address { get; set; }
        public string PostalCode { get; set; }
        public string Profession { get; set; }
        public decimal? MonthlyEarnings { get; set; }
    }

    public interface IUserRepository
    {
        User GetByUid(string uid);
        void UpdateProfileImage(string uid, string dbRelativePath);
    }

    // Concrete ADO.NET repository (keeps data-access in one place).
    public class UserRepository : IUserRepository
    {
        private readonly string _connectionString;

        /// <summary>
        /// Create a repository using a given connection string.
        /// Throws ArgumentNullException if connectionString is null.
        /// </summary>
        public UserRepository(string connectionString)
        {
            _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
        }

        /// <summary>
        /// Reads a user by UID. Returns null if user is not found.
        /// </summary>
        public User GetByUid(string uid)
        {
            if (string.IsNullOrWhiteSpace(uid)) return null;

            const string query = @"
                SELECT UID, FirstName, LastName, FathersName, MothersName, DateOfBirth, NIDNumber, Email, PhoneNumber, ProfileImage,
                       Division, District, Upazilla, Address, PostalCode, Profession, MonthlyEarnings
                FROM Users
                WHERE UID = @UID";

            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@UID", uid);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return null;

                    return new User
                    {
                        UID = Convert.ToString(reader["UID"]),
                        FirstName = Convert.ToString(reader["FirstName"]),
                        LastName = Convert.ToString(reader["LastName"]),
                        FathersName = Convert.ToString(reader["FathersName"]),
                        MothersName = Convert.ToString(reader["MothersName"]),
                        DateOfBirth = reader["DateOfBirth"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["DateOfBirth"]),
                        NIDNumber = Convert.ToString(reader["NIDNumber"]),
                        Email = Convert.ToString(reader["Email"]),
                        PhoneNumber = Convert.ToString(reader["PhoneNumber"]),
                        ProfileImage = Convert.ToString(reader["ProfileImage"]),
                        Division = Convert.ToString(reader["Division"]),
                        District = Convert.ToString(reader["District"]),
                        Upazilla = Convert.ToString(reader["Upazilla"]),
                        Address = Convert.ToString(reader["Address"]),
                        PostalCode = Convert.ToString(reader["PostalCode"]),
                        Profession = Convert.ToString(reader["Profession"]),
                        MonthlyEarnings = reader["MonthlyEarnings"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["MonthlyEarnings"])
                    };
                }
            }
        }

        /// <summary>
        /// Updates the ProfileImage path for a user in the database.
        /// Throws if uid or dbRelativePath are invalid.
        /// </summary>
        public void UpdateProfileImage(string uid, string dbRelativePath)
        {
            if (string.IsNullOrWhiteSpace(uid)) throw new ArgumentNullException(nameof(uid));
            if (dbRelativePath == null) throw new ArgumentNullException(nameof(dbRelativePath));

            const string query = "UPDATE Users SET ProfileImage = @ProfileImage WHERE UID = @UID";

            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@ProfileImage", dbRelativePath);
                cmd.Parameters.AddWithValue("@UID", uid);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

    public static class RepositoryFactory
    {
        /// <summary>
        /// Centralized factory method so callers depend on the IUserRepository interface.
        /// If you need a mock or alternative implementation, change this method only.
        /// </summary>
        public static IUserRepository CreateUserRepository()
        {
            // creation logic centralized here
            var conn = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
            return new UserRepository(conn);
        }
    }

    // Factory: returns an IUserRepository so consumers depend on the interface; swap implementations by changing this method.

    public partial class Profile : Page
    {
        // The page now asks the factory for an IUserRepository when needed.
        // This keeps the page free from direct ADO.NET construction and makes it easy to swap implementations.

        /// <summary>
        /// Page_Load: loads and binds profile data on first load.
        /// Important: redirects to Login.aspx if session UID is missing or user not found.
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var userId = Convert.ToString(Session["UID"]);
                if (string.IsNullOrEmpty(userId))
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                try
                {
                    // Obtain repository via factory (consumer uses interface only)
                    var repo = RepositoryFactory.CreateUserRepository();
                    var user = repo.GetByUid(userId);

                    if (user == null)
                    {
                        Response.Redirect("Login.aspx");
                        return;
                    }

                    // Bind values to controls (null-safe)
                    lblFullName.Text = (user.FirstName ?? "") + " " + (user.LastName ?? "");
                    lblProfession.Text = user.Profession ?? "";
                    lblFathersName.Text = user.FathersName ?? "";
                    lblMothersName.Text = user.MothersName ?? "";
                    lblDateOfBirth.Text = user.DateOfBirth?.ToString("dd MMM yyyy") ?? "";
                    lblNIDNumber.Text = user.NIDNumber ?? "";
                    lblEmail.Text = user.Email ?? "";
                    lblPhoneNumber.Text = user.PhoneNumber ?? "";
                    lblAddress.Text = user.Address ?? "";
                    lblDivision.Text = user.Division ?? "";
                    lblDistrict.Text = user.District ?? "";
                    lblUpazilla.Text = user.Upazilla ?? "";
                    lblPostalCode.Text = user.PostalCode ?? "";

                    imgProfile.ImageUrl = string.IsNullOrEmpty(user.ProfileImage) ? "images/default-profile.png" : user.ProfileImage;
                    lblProfessionDetail.Text = user.Profession ?? "";
                    lblMonthlyEarnings.Text = user.MonthlyEarnings.HasValue ? ("৳ " + user.MonthlyEarnings.Value.ToString("N2")) : "";
                }
                catch (Exception ex)
                {
                    // Surface a helpful message to the page during development.
                    // For production, consider logging and showing a friendly error page instead.
                    Response.Write("Error loading profile: " + ex.Message);
                }
            }
        }

        /// <summary>
        /// Handles saving of the profile photo posted from the FileUpload server control.
        /// Validates file extension and size, saves to disk and updates DB via repository.
        /// </summary>
        protected void btnUploadProfile_Click(object sender, EventArgs e)
        {
            // If no file, nothing to do
            if (!fuProfilePhoto.HasFile) return;

            var userId = Convert.ToString(Session["UID"]);
            if (string.IsNullOrEmpty(userId))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            try
            {
                // Validate extension
                string fileExtension = Path.GetExtension(fuProfilePhoto.FileName).ToLower();
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp" };
                bool isValidType = false;
                foreach (string ext in allowedExtensions)
                {
                    if (fileExtension == ext)
                    {
                        isValidType = true;
                        break;
                    }
                }

                if (!isValidType)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a valid image file (JPG, PNG, GIF, BMP).');", true);
                    return;
                }

                // Validate file size (5MB)
                if (fuProfilePhoto.PostedFile.ContentLength > 5 * 1024 * 1024)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('File size must be less than 5MB.');", true);
                    return;
                }

                // Save to disk
                string folderPath = Server.MapPath("~/images/profiles/");
                if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                string fileName = Guid.NewGuid().ToString() + fileExtension;
                string savePath = Path.Combine(folderPath, fileName);
                fuProfilePhoto.SaveAs(savePath);

                string dbPath = "~/images/profiles/" + fileName;

                // Update DB through repository obtained from factory
                var repo = RepositoryFactory.CreateUserRepository();
                repo.UpdateProfileImage(userId, dbPath);

                // Update UI
                imgProfile.ImageUrl = dbPath;

                // Show success via client script (ScriptManager-aware)
                if (ScriptManager.GetCurrent(this.Page) != null)
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "showSuccess", "showUploadSuccess();", true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "showSuccess", "showUploadSuccess();", true);
                }
            }
            catch (Exception ex)
            {
                // Keep UX responsive: show an alert with the error.
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error uploading photo: {ex.Message}');", true);
            }
        }
    }
}