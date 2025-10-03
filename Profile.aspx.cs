using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace vaultx
{
    // Minimal DTO used by the repository and the page.
    public class User
    {
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

        public UserRepository(string connectionString)
        {
            _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
        }

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
                    Response.Write("Error loading profile: " + ex.Message);
                }
            }
        }

        protected void btnUploadProfile_Click(object sender, EventArgs e)
        {
            if (!fuProfilePhoto.HasFile) return;

            var userId = Convert.ToString(Session["UID"]);
            if (string.IsNullOrEmpty(userId))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            try
            {
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

                if (fuProfilePhoto.PostedFile.ContentLength > 5 * 1024 * 1024)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('File size must be less than 5MB.');", true);
                    return;
                }

                string folderPath = Server.MapPath("~/images/profiles/");
                if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

                string fileName = Guid.NewGuid().ToString() + fileExtension;
                string savePath = Path.Combine(folderPath, fileName);
                fuProfilePhoto.SaveAs(savePath);

                string dbPath = "~/images/profiles/" + fileName;

                // Update DB through repository obtained from factory
                var repo = RepositoryFactory.CreateUserRepository();
                repo.UpdateProfileImage(userId, dbPath);

                imgProfile.ImageUrl = dbPath;

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
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error uploading photo: {ex.Message}');", true);
            }
        }
    }
}