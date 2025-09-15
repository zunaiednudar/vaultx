using System;
using System.Web.UI;

namespace vaultx
{
    public partial class Profile : Page
    {
        // Structure matching the database, not implemented yet
        private class UserProfile
        {
            public string FullName { get; set; }
            public string Profession { get; set; }
            public string FathersName { get; set; }
            public string MothersName { get; set; }
            public string DateOfBirth { get; set; }
            public string NIDNumber { get; set; }
            public string Email { get; set; }
            public string PhoneNumber { get; set; }
            public string Address { get; set; }
            public string Division { get; set; }
            public string District { get; set; }
            public string Upazilla { get; set; }
            public string PostalCode { get; set; }
            public string ProfileImage { get; set; }
            public string MonthlyEarnings { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Demo data
                var user = new UserProfile
                {
                    FullName = "This is a name",
                    Profession = "Student",
                    FathersName = "Father Name",
                    MothersName = "Mother Name",
                    DateOfBirth = "15 March 2002",
                    NIDNumber = "1234567890",
                    Email = "demoemail@gmail.com",
                    PhoneNumber = "+8801712345678",
                    Address = "123, Lake Road, Khulna",
                    Division = "Khulna",
                    District = "Khulna",
                    Upazilla = "Daulatpur",
                    PostalCode = "9203",
                    ProfileImage = "images/default-profile.png",
                    MonthlyEarnings = "৳ 5000.00"
                };

                // Set demo info to controls
                lblFullName.Text = user.FullName;
                lblProfession.Text = user.Profession;
                lblFathersName.Text = user.FathersName;
                lblMothersName.Text = user.MothersName;
                lblDateOfBirth.Text = user.DateOfBirth;
                lblNIDNumber.Text = user.NIDNumber;
                lblEmail.Text = user.Email;
                lblPhoneNumber.Text = user.PhoneNumber;
                lblAddress.Text = user.Address;
                lblDivision.Text = user.Division;
                lblDistrict.Text = user.District;
                lblUpazilla.Text = user.Upazilla;
                lblPostalCode.Text = user.PostalCode;
                imgProfile.ImageUrl = user.ProfileImage;
                lblProfessionDetail.Text = user.Profession;
                lblMonthlyEarnings.Text = user.MonthlyEarnings;
            }
        }
    }
}