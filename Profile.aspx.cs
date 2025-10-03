using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace vaultx
{
    public partial class Profile : Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get user ID from session
                var userId = Session["UID"];
                if (userId == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        string query = @"SELECT FirstName, LastName, FathersName, MothersName, DateOfBirth, NIDNumber, Email, PhoneNumber, ProfileImage, Division, District, Upazilla, Address, PostalCode, Profession, MonthlyEarnings
                                         FROM Users WHERE UID = @UID";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@UID", userId);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            lblFullName.Text = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                            lblProfession.Text = reader["Profession"].ToString();
                            lblFathersName.Text = reader["FathersName"].ToString();
                            lblMothersName.Text = reader["MothersName"].ToString();

                            // Handle date formatting safely
                            if (reader["DateOfBirth"] != DBNull.Value)
                            {
                                lblDateOfBirth.Text = Convert.ToDateTime(reader["DateOfBirth"]).ToString("dd MMM yyyy");
                            }

                            lblNIDNumber.Text = reader["NIDNumber"].ToString();
                            lblEmail.Text = reader["Email"].ToString();
                            lblPhoneNumber.Text = reader["PhoneNumber"].ToString();
                            lblAddress.Text = reader["Address"].ToString();
                            lblDivision.Text = reader["Division"].ToString();
                            lblDistrict.Text = reader["District"].ToString();
                            lblUpazilla.Text = reader["Upazilla"].ToString();
                            lblPostalCode.Text = reader["PostalCode"].ToString();

                            // Handle profile image safely
                            string profileImage = reader["ProfileImage"].ToString();
                            imgProfile.ImageUrl = string.IsNullOrEmpty(profileImage) ? "images/default-profile.png" : profileImage;

                            lblProfessionDetail.Text = reader["Profession"].ToString();

                            // Handle monthly earnings safely
                            if (reader["MonthlyEarnings"] != DBNull.Value)
                            {
                                lblMonthlyEarnings.Text = "৳ " + Convert.ToDecimal(reader["MonthlyEarnings"]).ToString("N2");
                            }
                        }
                        else
                        {
                            // User not found
                            Response.Redirect("Login.aspx");
                        }
                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    // Log error and redirect to error page or show user-friendly message
                    Response.Write("Error loading profile: " + ex.Message);
                }
            }
        }

        protected void btnUploadProfile_Click(object sender, EventArgs e)
        {
            if (!fuProfilePhoto.HasFile) return;

            // Get user ID from session
            var userId = Session["UID"];
            if (userId == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            try
            {
                // Validate file type
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

                // Validate file size (5MB limit)
                if (fuProfilePhoto.PostedFile.ContentLength > 5 * 1024 * 1024)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('File size must be less than 5MB.');", true);
                    return;
                }

                string folderPath = Server.MapPath("~/images/profiles/");
                if (!Directory.Exists(folderPath))
                    Directory.CreateDirectory(folderPath);

                string fileName = Guid.NewGuid().ToString() + fileExtension;
                string savePath = Path.Combine(folderPath, fileName);
                fuProfilePhoto.SaveAs(savePath);

                string dbPath = "~/images/profiles/" + fileName;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Users SET ProfileImage = @ProfileImage WHERE UID = @UID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ProfileImage", dbPath);
                        cmd.Parameters.AddWithValue("@UID", userId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                imgProfile.ImageUrl = dbPath;

                // Ensure the startup script runs for both full and async postbacks
                if (System.Web.UI.ScriptManager.GetCurrent(this.Page) != null)
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