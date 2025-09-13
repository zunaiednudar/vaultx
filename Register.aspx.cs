using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace vaultx
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"INSERT INTO dbo.register 
                                     (UFirstName, ULastName, UEmail, UPhoneNumber, UNID, UDOB, CreatedAt)
                                     VALUES (@FName, @LName, @Email, @Phone, @NID, @DOB, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.Add("@FName", SqlDbType.NVarChar, 50).Value = txtFirstName.Text.Trim();
                        cmd.Parameters.Add("@LName", SqlDbType.NVarChar, 50).Value = txtLastName.Text.Trim();
                        cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = txtEmail.Text.Trim();
                        cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 20).Value = txtPhone.Text.Trim();
                        cmd.Parameters.Add("@NID", SqlDbType.NVarChar, 20).Value = txtNID.Text.Trim();
                        cmd.Parameters.Add("@DOB", SqlDbType.Date).Value = string.IsNullOrEmpty(txtDOB.Text.Trim())
                                                                       ? (object)DBNull.Value
                                                                       : DateTime.Parse(txtDOB.Text.Trim());

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }

                // JS for spinner → tick → redirect
                string script = @"
                    document.body.innerHTML = `
                        <div style='height:100vh; display:flex; justify-content:center; align-items:center; flex-direction:column; font-family:Poppins, sans-serif; background:#f5f5f5;'>
                            <h1 style='font-size:3rem; background:linear-gradient(90deg, #4ECDC4, #55EFC4, #A7FFE4); -webkit-background-clip:text; -webkit-text-fill-color:transparent; margin-bottom:20px;'>Registration Successful!</h1>
                            <div class='spinner'></div>
                            <div class='tick' style='display:none;'>&#10004;</div>
                        </div>
                    `;
                    var style = document.createElement('style');
                    style.innerHTML = `
                        .spinner {
                            border: 8px solid #f3f3f3;
                            border-top: 8px solid #1E90FF;
                            border-radius: 50%;
                            width: 80px;
                            height: 80px;
                            animation: spin 1.5s linear infinite;
                            margin-bottom: 20px;
                        }
                        .tick {
                            font-size: 5rem;
                            color: #1E90FF;
                            animation: pop 0.5s ease forwards;
                        }
                        @keyframes spin {
                            0% { transform: rotate(0deg); }
                            100% { transform: rotate(360deg); }
                        }
                        @keyframes pop {
                            0% { transform: scale(0); opacity:0; }
                            100% { transform: scale(1); opacity:1; }
                        }
                    `;
                    document.head.appendChild(style);

                    setTimeout(function() {
                        document.querySelector('.spinner').style.display = 'none';
                        document.querySelector('.tick').style.display = 'block';
                    }, 1500);

                    setTimeout(function() { window.location.href='Login.aspx'; }, 3000);
                ";

                ClientScript.RegisterStartupScript(this.GetType(), "SuccessScript", script, true);
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }
    }
}
