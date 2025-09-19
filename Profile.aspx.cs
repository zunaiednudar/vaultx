using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace vaultx
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Get user ID from session
                var userId = Session["UserId"];
                if (userId == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Use connection string from web.config
                string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

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
    }
}