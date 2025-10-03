using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Web;

namespace vaultx
{
    public partial class Admin : Page
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsersFromDatabase();
            }
        }

        private void LoadUsersFromDatabase()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT UID, FirstName, LastName, Email, PhoneNumber, 
                               FathersName, MothersName, DateOfBirth, NIDNumber,
                               Division, District, Upazilla, Address, PostalCode,
                               Profession, MonthlyEarnings, ProfileImage
                        FROM dbo.Users 
                        ORDER BY UID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    SqlDataReader reader = cmd.ExecuteReader();

                    StringBuilder usersHtml = new StringBuilder();

                    while (reader.Read())
                    {
                        string profileImage = reader["ProfileImage"] != DBNull.Value ?
                            reader["ProfileImage"].ToString() : "images/default.png";

                        string dob = reader["DateOfBirth"] != DBNull.Value ?
                            Convert.ToDateTime(reader["DateOfBirth"]).ToString("dd-MM-yyyy") : "";

                        // Escape single quotes for JavaScript
                        string firstName = EscapeJavaScript(reader["FirstName"].ToString());
                        string lastName = EscapeJavaScript(reader["LastName"].ToString());
                        string fatherName = EscapeJavaScript(reader["FathersName"]?.ToString() ?? "");
                        string motherName = EscapeJavaScript(reader["MothersName"]?.ToString() ?? "");
                        string email = EscapeJavaScript(reader["Email"].ToString());
                        string phone = EscapeJavaScript(reader["PhoneNumber"]?.ToString() ?? "");
                        string division = EscapeJavaScript(reader["Division"]?.ToString() ?? "");
                        string district = EscapeJavaScript(reader["District"]?.ToString() ?? "");
                        string upazilla = EscapeJavaScript(reader["Upazilla"]?.ToString() ?? "");
                        string address = EscapeJavaScript(reader["Address"]?.ToString() ?? "");
                        string postal = EscapeJavaScript(reader["PostalCode"]?.ToString() ?? "");
                        string profession = EscapeJavaScript(reader["Profession"]?.ToString() ?? "");
                        string nid = EscapeJavaScript(reader["NIDNumber"]?.ToString() ?? "");

                        usersHtml.AppendFormat(@"
                            <tr onclick=""showUserDetails('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}','{14}','{15}','{16}')"">
                                <td>{0}</td>
                                <td>{1}</td>
                                <td>{2}</td>
                                <td>{7}</td>
                                <td>{8}</td>
                                <td><button type='button' class='btn btn-sm btn-primary'>More Details</button></td>
                            </tr>",
                            reader["UID"],
                            firstName,
                            lastName,
                            fatherName,
                            motherName,
                            dob,
                            nid,
                            email,
                            phone,
                            division,
                            district,
                            upazilla,
                            address,
                            postal,
                            profession,
                            reader["MonthlyEarnings"],
                            profileImage
                        );
                    }

                    // Inject users into the page using JavaScript
                    string script = $@"
                        $(document).ready(function() {{
                            var tbody = $('#usersTableBody');
                            if (tbody.length > 0) {{
                                tbody.html(`{usersHtml}`);
                            }}
                        }});";

                    ClientScript.RegisterStartupScript(this.GetType(), "LoadUsers", script, true);
                }
            }
            catch (Exception ex)
            {
                // If there's an error, keep the static data for now
                string errorScript = $@"console.log('Database error: {EscapeJavaScript(ex.Message)}');";
                ClientScript.RegisterStartupScript(this.GetType(), "DatabaseError", errorScript, true);
            }
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate required fields
                if (string.IsNullOrEmpty(txtAddFirstName.Text.Trim()) ||
                    string.IsNullOrEmpty(txtAddLastName.Text.Trim()) ||
                    string.IsNullOrEmpty(txtAddEmail.Text.Trim()) ||
                    string.IsNullOrEmpty(txtAddPassword.Text.Trim()))
                {
                    ShowMessage("Please fill in all required fields (First Name, Last Name, Email, Password).", "error");
                    return;
                }

                // Check if email already exists
                if (IsEmailExists(txtAddEmail.Text.Trim()))
                {
                    ShowMessage("Email already exists. Please use a different email.", "error");
                    return;
                }

                // Handle profile image upload
                string profileImagePath = null;
                if (fuAddProfile.HasFile)
                {
                    string fileName = Path.GetFileName(fuAddProfile.PostedFile.FileName);
                    string extension = Path.GetExtension(fileName).ToLower();

                    if (extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif")
                    {
                        string uniqueFileName = Guid.NewGuid().ToString() + extension;
                        string savePath = Server.MapPath("~/images/profile_img/") + uniqueFileName;

                        if (!Directory.Exists(Server.MapPath("~/images/profile_img/")))
                            Directory.CreateDirectory(Server.MapPath("~/images/profile_img/"));

                        fuAddProfile.SaveAs(savePath);
                        profileImagePath = "images/profile_img/" + uniqueFileName;
                    }
                    else
                    {
                        ShowMessage("Please upload only image files (jpg, jpeg, png, gif).", "error");
                        return;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get next UID
                    string getMaxUIDQuery = "SELECT ISNULL(MAX(UID), 999) FROM dbo.Users";
                    SqlCommand cmdMax = new SqlCommand(getMaxUIDQuery, conn);
                    int newUID = (int)cmdMax.ExecuteScalar() + 1;

                    string query = @"
                        INSERT INTO dbo.Users
                        (UID, FirstName, LastName, FathersName, MothersName, DateOfBirth, 
                         NIDNumber, Email, PhoneNumber, ProfileImage, Division, District, 
                         Upazilla, Address, PostalCode, Profession, MonthlyEarnings, Password)
                        VALUES
                        (@UID, @FirstName, @LastName, @FathersName, @MothersName, @DateOfBirth,
                         @NIDNumber, @Email, @PhoneNumber, @ProfileImage, @Division, @District,
                         @Upazilla, @Address, @PostalCode, @Profession, @MonthlyEarnings, @Password)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", newUID);
                    cmd.Parameters.AddWithValue("@FirstName", txtAddFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtAddLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@FathersName", txtAddFather.Text.Trim());
                    cmd.Parameters.AddWithValue("@MothersName", txtAddMother.Text.Trim());

                    // Handle date of birth
                    if (!string.IsNullOrEmpty(txtAddDOB.Text.Trim()))
                    {
                        try
                        {
                            DateTime dob = DateTime.ParseExact(txtAddDOB.Text.Trim(), "dd-MM-yyyy", CultureInfo.InvariantCulture);
                            cmd.Parameters.AddWithValue("@DateOfBirth", dob);
                        }
                        catch
                        {
                            cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);
                        }
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@NIDNumber", txtAddNID.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtAddEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@PhoneNumber", txtAddPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@ProfileImage", (object)profileImagePath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Division", txtAddDivision.Text.Trim());
                    cmd.Parameters.AddWithValue("@District", txtAddDistrict.Text.Trim());
                    cmd.Parameters.AddWithValue("@Upazilla", txtAddUpazilla.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", txtAddAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@PostalCode", txtAddPostal.Text.Trim());
                    cmd.Parameters.AddWithValue("@Profession", txtAddProfession.Text.Trim());

                    decimal earnings = 0;
                    if (!string.IsNullOrEmpty(txtAddEarnings.Text.Trim()))
                    {
                        decimal.TryParse(txtAddEarnings.Text.Trim(), out earnings);
                    }
                    cmd.Parameters.AddWithValue("@MonthlyEarnings", earnings);
                    cmd.Parameters.AddWithValue("@Password", txtAddPassword.Text.Trim());

                    cmd.ExecuteNonQuery();
                }

                ShowMessage("User added successfully!", "success");
                ClearAddUserForm();

                // Reload the page to show updated users
                Response.Redirect(Request.Url.AbsoluteUri);
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding user: " + ex.Message, "error");
            }
        }

        [WebMethod]
        public static string UpdateUser(string uid, string firstName, string lastName,
            string fatherName, string motherName, string dob, string nid, string email,
            string phone, string division, string district, string upazilla,
            string address, string postal, string profession, string earnings)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if email already exists for other users
                    string checkEmailQuery = "SELECT COUNT(*) FROM dbo.Users WHERE Email = @Email AND UID != @UID";
                    SqlCommand checkCmd = new SqlCommand(checkEmailQuery, conn);
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    checkCmd.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    int emailCount = (int)checkCmd.ExecuteScalar();

                    if (emailCount > 0)
                    {
                        return "Error: Email already exists for another user.";
                    }

                    string query = @"
                        UPDATE dbo.Users SET 
                            FirstName = @FirstName, LastName = @LastName, 
                            FathersName = @FathersName, MothersName = @MothersName,
                            DateOfBirth = @DateOfBirth, NIDNumber = @NIDNumber,
                            Email = @Email, PhoneNumber = @PhoneNumber,
                            Division = @Division, District = @District,
                            Upazilla = @Upazilla, Address = @Address,
                            PostalCode = @PostalCode, Profession = @Profession,
                            MonthlyEarnings = @MonthlyEarnings
                        WHERE UID = @UID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@FathersName", fatherName ?? "");
                    cmd.Parameters.AddWithValue("@MothersName", motherName ?? "");

                    // Handle date of birth
                    if (!string.IsNullOrEmpty(dob))
                    {
                        try
                        {
                            DateTime dobDate = DateTime.ParseExact(dob, "dd-MM-yyyy", CultureInfo.InvariantCulture);
                            cmd.Parameters.AddWithValue("@DateOfBirth", dobDate);
                        }
                        catch
                        {
                            cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);
                        }
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@NIDNumber", nid ?? "");
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PhoneNumber", phone ?? "");
                    cmd.Parameters.AddWithValue("@Division", division ?? "");
                    cmd.Parameters.AddWithValue("@District", district ?? "");
                    cmd.Parameters.AddWithValue("@Upazilla", upazilla ?? "");
                    cmd.Parameters.AddWithValue("@Address", address ?? "");
                    cmd.Parameters.AddWithValue("@PostalCode", postal ?? "");
                    cmd.Parameters.AddWithValue("@Profession", profession ?? "");

                    // Handle monthly earnings
                    decimal earningsValue = 0;
                    if (!string.IsNullOrEmpty(earnings))
                    {
                        decimal.TryParse(earnings, out earningsValue);
                    }
                    cmd.Parameters.AddWithValue("@MonthlyEarnings", earningsValue);

                    cmd.ExecuteNonQuery();
                }
                return "success";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string DeleteUser(string uid)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // First delete user's transactions
                    string deleteTransactionsQuery = @"
                        DELETE FROM dbo.Transactions 
                        WHERE FromAID IN (SELECT AID FROM dbo.Accounts WHERE UID = @UID)
                           OR ToAID IN (SELECT AID FROM dbo.Accounts WHERE UID = @UID)";

                    SqlCommand cmdTrans = new SqlCommand(deleteTransactionsQuery, conn);
                    cmdTrans.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    cmdTrans.ExecuteNonQuery();

                    // Then delete user's accounts
                    string deleteAccountsQuery = "DELETE FROM dbo.Accounts WHERE UID = @UID";
                    SqlCommand cmdAcc = new SqlCommand(deleteAccountsQuery, conn);
                    cmdAcc.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    cmdAcc.ExecuteNonQuery();

                    // Finally delete the user
                    string deleteUserQuery = "DELETE FROM dbo.Users WHERE UID = @UID";
                    SqlCommand cmdUser = new SqlCommand(deleteUserQuery, conn);
                    cmdUser.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    cmdUser.ExecuteNonQuery();
                }
                return "success";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string GetUserTransactions(string uid)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT t.TID, t.FromAID, t.ToAID, t.Amount, t.Reference, t.Date,
                               CASE 
                                   WHEN a1.UID = @UID AND a2.UID != @UID THEN 'Debit'
                                   WHEN a2.UID = @UID AND a1.UID != @UID THEN 'Credit'
                                   WHEN a1.UID = @UID AND a2.UID = @UID THEN 'Transfer'
                                   ELSE 'Unknown'
                               END as TransactionType
                        FROM dbo.Transactions t
                        LEFT JOIN dbo.Accounts a1 ON t.FromAID = a1.AID
                        LEFT JOIN dbo.Accounts a2 ON t.ToAID = a2.AID
                        WHERE a1.UID = @UID OR a2.UID = @UID
                        ORDER BY t.Date DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    SqlDataReader reader = cmd.ExecuteReader();

                    StringBuilder json = new StringBuilder();
                    json.Append("[");

                    bool first = true;
                    while (reader.Read())
                    {
                        if (!first) json.Append(",");

                        string reference = reader["Reference"] != DBNull.Value
                            ? EscapeJsonString(reader["Reference"].ToString())
                            : "";

                        json.AppendFormat(@"{{
                            ""tid"": ""{0}"",
                            ""date"": ""{1:yyyy-MM-dd}"",
                            ""amount"": {2},
                            ""type"": ""{3}"",
                            ""from"": ""{4}"",
                            ""to"": ""{5}"",
                            ""ref"": ""{6}""
                        }}",
                        reader["TID"],
                        reader["Date"],
                        reader["Amount"],
                        reader["TransactionType"],
                        reader["FromAID"],
                        reader["ToAID"],
                        reference);

                        first = false;
                    }

                    json.Append("]");
                    return json.ToString();
                }
            }
            catch (Exception ex)
            {
                return "[]";
            }
        }

        [WebMethod]
        public static string GetUserAccounts(string uid)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT AID, AccountType, Balance, CreatedAt, NomineeName, NomineeNID, NomineeImage
                        FROM dbo.Accounts 
                        WHERE UID = @UID
                        ORDER BY AID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    SqlDataReader reader = cmd.ExecuteReader();

                    StringBuilder json = new StringBuilder();
                    json.Append("[");

                    bool first = true;
                    while (reader.Read())
                    {
                        if (!first) json.Append(",");

                        string nomineeName = reader["NomineeName"] != DBNull.Value
                            ? EscapeJsonString(reader["NomineeName"].ToString())
                            : "";

                        string nomineeNID = reader["NomineeNID"] != DBNull.Value
                            ? EscapeJsonString(reader["NomineeNID"].ToString())
                            : "";

                        string nomineeImage = reader["NomineeImage"] != DBNull.Value
                            ? EscapeJsonString(reader["NomineeImage"].ToString())
                            : "";

                        json.AppendFormat(@"{{
                            ""aid"": {0},
                            ""accountType"": ""{1}"",
                            ""balance"": {2},
                            ""createdAt"": ""{3:yyyy-MM-dd}"",
                            ""nomineeName"": ""{4}"",
                            ""nomineeNid"": ""{5}"",
                            ""nomineeImage"": ""{6}""
                        }}",
                        reader["AID"],
                        reader["AccountType"],
                        reader["Balance"],
                        reader["CreatedAt"],
                        nomineeName,
                        nomineeNID,
                        nomineeImage);

                        first = false;
                    }

                    json.Append("]");
                    return json.ToString();
                }
            }
            catch (Exception ex)
            {
                return "[]";
            }
        }

        [WebMethod]
        [System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
        public static string AddAccount(string uid, string accountType, string balance, string nomineeName, string nomineeNID)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"AddAccount called: uid={uid}, type={accountType}, balance={balance}");

                if (!IsValidAccountType(accountType))
                {
                    return "Error: Invalid account type. Must be 'Student', 'Savings', or 'Current'.";
                }

                // Check if user already has an account of this type
                using (SqlConnection checkConn = new SqlConnection(connectionString))
                {
                    checkConn.Open();
                    string checkQuery = "SELECT COUNT(*) FROM dbo.Accounts WHERE UID = @UID AND AccountType = @AccountType";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, checkConn);
                    checkCmd.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    checkCmd.Parameters.AddWithValue("@AccountType", accountType);
                    int count = (int)checkCmd.ExecuteScalar();

                    if (count > 0)
                    {
                        return "Error: User already has an account of this type.";
                    }
                }

                decimal balanceValue = 0;
                if (!string.IsNullOrEmpty(balance))
                {
                    if (!decimal.TryParse(balance, out balanceValue) || balanceValue < 0)
                    {
                        return "Error: Balance must be a non-negative number.";
                    }
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get next AID
                    string getMaxAIDQuery = "SELECT ISNULL(MAX(AID), 99999) FROM dbo.Accounts";
                    SqlCommand cmdMax = new SqlCommand(getMaxAIDQuery, conn);
                    long newAID = (long)cmdMax.ExecuteScalar() + 1;

                    string query = @"
                INSERT INTO dbo.Accounts
                (AID, UID, AccountType, NomineeName, NomineeNID, Balance, CreatedAt)
                VALUES
                (@AID, @UID, @AccountType, @NomineeName, @NomineeNID, @Balance, GETDATE())";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AID", newAID);
                    cmd.Parameters.AddWithValue("@UID", Convert.ToInt32(uid));
                    cmd.Parameters.AddWithValue("@AccountType", accountType);
                    cmd.Parameters.AddWithValue("@NomineeName", string.IsNullOrEmpty(nomineeName) ? DBNull.Value : (object)nomineeName);
                    cmd.Parameters.AddWithValue("@NomineeNID", string.IsNullOrEmpty(nomineeNID) ? DBNull.Value : (object)nomineeNID);
                    cmd.Parameters.AddWithValue("@Balance", balanceValue);

                    cmd.ExecuteNonQuery();

                    System.Diagnostics.Debug.WriteLine("Account added successfully with AID: " + newAID);
                }
                return "success";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("AddAccount Error: " + ex.ToString());
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string UpdateAccount(string aid, string balance, string nomineeName, string nomineeNID)
        {
            try
            {
                decimal balanceValue = 0;
                if (!string.IsNullOrEmpty(balance))
                {
                    if (!decimal.TryParse(balance, out balanceValue) || balanceValue < 0)
                    {
                        return "Error: Balance must be a non-negative number.";
                    }
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"
                        UPDATE dbo.Accounts SET 
                            Balance = @Balance,
                            NomineeName = @NomineeName,
                            NomineeNID = @NomineeNID
                        WHERE AID = @AID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AID", Convert.ToInt64(aid));
                    cmd.Parameters.AddWithValue("@Balance", balanceValue);
                    cmd.Parameters.AddWithValue("@NomineeName", string.IsNullOrEmpty(nomineeName) ? DBNull.Value : (object)nomineeName);
                    cmd.Parameters.AddWithValue("@NomineeNID", string.IsNullOrEmpty(nomineeNID) ? DBNull.Value : (object)nomineeNID);

                    cmd.ExecuteNonQuery();
                }
                return "success";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string DeleteAccount(string aid)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // First delete associated transactions
                    string deleteTransactionsQuery = @"
                        DELETE FROM dbo.Transactions 
                        WHERE FromAID = @AID OR ToAID = @AID";
                    SqlCommand cmdTrans = new SqlCommand(deleteTransactionsQuery, conn);
                    cmdTrans.Parameters.AddWithValue("@AID", Convert.ToInt64(aid));
                    cmdTrans.ExecuteNonQuery();

                    // Then delete the account
                    string deleteAccountQuery = "DELETE FROM dbo.Accounts WHERE AID = @AID";
                    SqlCommand cmdAcc = new SqlCommand(deleteAccountQuery, conn);
                    cmdAcc.Parameters.AddWithValue("@AID", Convert.ToInt64(aid));
                    cmdAcc.ExecuteNonQuery();
                }
                return "success";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        private static bool IsValidAccountType(string accountType)
        {
            return accountType == "Student" || accountType == "Savings" || accountType == "Current";
        }

        private bool IsEmailExists(string email)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM dbo.Users WHERE Email = @Email";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        private void ClearAddUserForm()
        {
            txtAddFirstName.Text = "";
            txtAddLastName.Text = "";
            txtAddFather.Text = "";
            txtAddMother.Text = "";
            txtAddDOB.Text = "";
            txtAddNID.Text = "";
            txtAddEmail.Text = "";
            txtAddPhone.Text = "";
            txtAddDivision.Text = "";
            txtAddDistrict.Text = "";
            txtAddUpazilla.Text = "";
            txtAddAddress.Text = "";
            txtAddPostal.Text = "";
            txtAddProfession.Text = "";
            txtAddEarnings.Text = "";
            txtAddPassword.Text = "";
        }

        private void ShowMessage(string message, string type)
        {
            string alertType = type == "success" ? "alert-success" : "alert-danger";
            string uniqueID = "ShowMessage_" + Guid.NewGuid().ToString("N");
            string script = $@"
                $(document).ready(function() {{
                    var alertDiv = $('<div class=""alert {alertType} alert-dismissible fade show position-fixed"" style=""top: 20px; right: 20px; z-index: 9999;"">');
                    alertDiv.html('{EscapeJavaScript(message)} <button type=""button"" class=""btn-close"" data-bs-dismiss=""alert""></button>');
                    $('body').append(alertDiv);
                    setTimeout(function() {{ 
                        alertDiv.alert('close');
                    }}, 5000);
                }});";

            ClientScript.RegisterStartupScript(this.GetType(), uniqueID, script, true);
        }

        private static string EscapeJavaScript(string input)
        {
            if (string.IsNullOrEmpty(input))
                return "";

            return input.Replace("\\", "\\\\")
                        .Replace("'", "\\'")
                        .Replace("\"", "\\\"")
                        .Replace("\n", "\\n")
                        .Replace("\r", "\\r")
                        .Replace("\t", "\\t");
        }

        private static string EscapeJsonString(string input)
        {
            if (string.IsNullOrEmpty(input))
                return "";

            return input.Replace("\\", "\\\\")
                        .Replace("\"", "\\\"")
                        .Replace("\n", "\\n")
                        .Replace("\r", "\\r")
                        .Replace("\t", "\\t");
        }
    }
}
