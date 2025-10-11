using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
namespace vaultx
{
    public partial class AccountDetails : System.Web.UI.Page
    {
        protected int AccountID => Convert.ToInt32(Request.QueryString["aid"] ?? "0");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string accountNumber = Request.QueryString["account"];
                if (!string.IsNullOrEmpty(accountNumber))
                {
                    LoadAccountInfo(accountNumber);
                    LoadTransactions(accountNumber);
                    LoadNomineeDetails(accountNumber);
                    PopulateYearDropdown(accountNumber);
                }
            }
        }
        private void PopulateYearDropdown(string accountNumber)
        {
            int createdYear = DateTime.Now.Year;
            using (SqlConnection conn = HelperZunaied.DatabaseConnection.getInstance().GetConnection())
            {
                string query = "SELECT CreatedAt FROM Accounts WHERE AID = @AID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AID", accountNumber);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                        createdYear = Convert.ToDateTime(result).Year;
                    ddlYears.Items.Clear();
                    for (int year = DateTime.Now.Year; year >= createdYear; year--)
                    {
                        ddlYears.Items.Add(new System.Web.UI.WebControls.ListItem(year.ToString(), year.ToString()));
                    }
                }
            }
        }
        private void LoadAccountInfo(string accountNumber)
        {
            using (SqlConnection conn = HelperZunaied.DatabaseConnection.getInstance().GetConnection())
            {
                string query = @"SELECT A.AID, A.AccountType, A.Balance, A.CreatedAt, U.FirstName, U.LastName
                                 FROM Accounts A
                                 INNER JOIN Users U ON A.UID = U.UID
                                 WHERE A.AID = @AID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AID", accountNumber);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblAccountNumber.Text = reader["AID"].ToString();
                            lblAccountType.Text = reader["AccountType"].ToString();
                            lblCreatedAt.Text = Convert.ToDateTime(reader["CreatedAt"]).ToString("MMM dd, yyyy");
                            lblAccountHolder.Text = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                        }
                    }
                }
            }
        }
        private void LoadTransactions(string accountNumber)
        {
            var transactions = new List<dynamic>();
            using (SqlConnection conn = HelperZunaied.DatabaseConnection.getInstance().GetConnection())
            {
                string query = @"SELECT T.FromAID, T.ToAID, T.Amount, T.Reference, T.Date
                                 FROM Transactions T
                                 WHERE T.FromAID = @AID OR T.ToAID = @AID
                                 ORDER BY T.Date DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AID", accountNumber);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            transactions.Add(new
                            {
                                FromAccountNumber = reader["FromAID"].ToString(),
                                ToAccountNumber = reader["ToAID"].ToString(),
                                TransactionType = reader["FromAID"].ToString() == accountNumber ? "Debit" : "Credit",
                                Amount = Convert.ToDecimal(reader["Amount"]),
                                Reference = reader["Reference"].ToString(),
                                Date = Convert.ToDateTime(reader["Date"])
                            });
                        }
                    }
                }
            }
            rptAccountTransactions.DataSource = transactions;
            rptAccountTransactions.DataBind();
        }
        private void LoadNomineeDetails(string accountNumber)
        {
            using (SqlConnection conn = HelperZunaied.DatabaseConnection.getInstance().GetConnection())
            {
                string query = "SELECT NomineeName, NomineeNID, NomineeImage FROM Accounts WHERE AID = @AccountID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountID", accountNumber);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblNomineeName.Text = reader["NomineeName"].ToString();
                            lblNomineeNID.Text = reader["NomineeNID"].ToString();
                            imgNominee.ImageUrl = reader["NomineeImage"].ToString();
                        }
                    }
                }
            }
        }
        protected void btnUploadNominee_Click(object sender, EventArgs e)
        {
            if (!fuNominee.HasFile) return;
            string folderPath = Server.MapPath("~/images/nominees/");
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);
            string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuNominee.FileName);
            string savePath = Path.Combine(folderPath, fileName);
            fuNominee.SaveAs(savePath);
            string dbPath = "~/images/nominees/" + fileName;
            using (SqlConnection conn = HelperZunaied.DatabaseConnection.getInstance().GetConnection())
            {
                string query = "UPDATE Accounts SET NomineeImage = @NomineeImage WHERE AID = @AccountID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@NomineeImage", dbPath);
                    cmd.Parameters.AddWithValue("@AccountID", Request.QueryString["account"]);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            imgNominee.ImageUrl = dbPath;
        }
        protected void btnDownloadStatement_Click(object sender, EventArgs e)
        {
            string accountNumber = Request.QueryString["account"];
            if (string.IsNullOrEmpty(ddlYears.SelectedValue)) return;
            int selectedYear = Convert.ToInt32(ddlYears.SelectedValue);
            DataTable dt = new DataTable();
            using (SqlConnection conn = HelperZunaied.DatabaseConnection.getInstance().GetConnection())
            {
                string query = @"SELECT FromAID as [From], ToAID as [To], Amount, Reference, Date
                                 FROM Transactions
                                 WHERE (FromAID = @AID OR ToAID = @AID) AND YEAR(Date) = @Year
                                 ORDER BY Date DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AID", accountNumber);
                    cmd.Parameters.AddWithValue("@Year", selectedYear);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }
            // Create PDF
            Document pdfDoc = new Document(PageSize.A4, 25, 25, 30, 30);
            MemoryStream memoryStream = new MemoryStream();
            PdfWriter.GetInstance(pdfDoc, memoryStream);
            pdfDoc.Open();
            Paragraph title = new Paragraph($"Account Statement - {accountNumber}")
            {
                Alignment = Element.ALIGN_CENTER,
                SpacingAfter = 20f
            };
            pdfDoc.Add(title);
            PdfPTable table = new PdfPTable(dt.Columns.Count) { WidthPercentage = 100 };
            foreach (DataColumn column in dt.Columns)
            {
                PdfPCell cell = new PdfPCell(new Phrase(column.ColumnName))
                {
                    BackgroundColor = BaseColor.LIGHT_GRAY,
                    HorizontalAlignment = Element.ALIGN_CENTER
                };
                table.AddCell(cell);
            }
            foreach (DataRow row in dt.Rows)
            {
                foreach (DataColumn column in dt.Columns)
                {
                    PdfPCell cell = new PdfPCell(new Phrase(row[column].ToString()))
                    {
                        HorizontalAlignment = Element.ALIGN_CENTER
                    };
                    table.AddCell(cell);
                }
            }
            pdfDoc.Add(table);
            pdfDoc.Close();
            byte[] bytes = memoryStream.ToArray();
            memoryStream.Close();
            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", $"attachment;filename=Statement_{accountNumber}.pdf");
            Response.Buffer = true;
            Response.BinaryWrite(bytes);
            Response.Flush();
            Response.End();
        }
    }
}