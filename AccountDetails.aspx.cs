using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using static vaultx.Dashboard;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;

namespace vaultx
{
    public partial class AccountDetails : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

        // For demo, we select account ID via query string
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
                }
            }
        }

        private void LoadAccountInfo(string accountNumber)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
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

            using (SqlConnection conn = new SqlConnection(connectionString))
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
                                TransactionType = reader["FromAID"].ToString() == accountNumber.ToString() ? "Debit" : "Credit",
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

        protected void btnAddFunds_Click(object sender, EventArgs e)
        {
            // Redirect to Add Funds page or open modal
            Response.Redirect($"AddFunds.aspx?aid={AccountID}");
        }

        protected void btnDownloadStatement_Click(object sender, EventArgs e)
        {
            string accountNumber = Request.QueryString["account"];
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT FromAID as [From], ToAID as [To], Amount, Reference, Date
                                 FROM Transactions
                                 WHERE FromAID = @AID OR ToAID = @AID
                                 ORDER BY Date DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AID", accountNumber);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }

            // Export CSV
            // Response.Clear();
            // Response.Buffer = true;
            // Response.AddHeader("content-disposition", $"attachment;filename=Statement_{accountNumber}.csv");
            // Response.Charset = "";
            // Response.ContentType = "application/text";

            // for (int i = 0; i < dt.Columns.Count; i++)
            // {
            //     Response.Write(dt.Columns[i]);
            //     if (i < dt.Columns.Count - 1) Response.Write(",");
            // }
            // Response.Write("\n");

            // foreach (DataRow row in dt.Rows)
            // {
            //      for (int i = 0; i < dt.Columns.Count; i++)
            //     {
            //         Response.Write(row[i].ToString());
            //         if (i < dt.Columns.Count - 1) Response.Write(",");
            //     }
            //     Response.Write("\n");
            // }
            // Response.Flush();
            // Response.End();
            // Create PDF document
            Document pdfDoc = new Document(PageSize.A4, 25, 25, 30, 30);
            MemoryStream memoryStream = new MemoryStream();
            PdfWriter.GetInstance(pdfDoc, memoryStream);
            pdfDoc.Open();

            // Title
            Paragraph title = new Paragraph($"Account Statement - {accountNumber}")
            {
                Alignment = Element.ALIGN_CENTER,
                SpacingAfter = 20f
            };
            pdfDoc.Add(title);

            // Table
            PdfPTable table = new PdfPTable(dt.Columns.Count);
            table.WidthPercentage = 100;

            // Headers
            foreach (DataColumn column in dt.Columns)
            {
                PdfPCell cell = new PdfPCell(new Phrase(column.ColumnName))
                {
                    BackgroundColor = BaseColor.LIGHT_GRAY,
                    HorizontalAlignment = Element.ALIGN_CENTER
                };
                table.AddCell(cell);
            }

            // Data rows
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

            // Send PDF to browser
            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", $"attachment;filename=Statement_{accountNumber}.pdf");
            Response.Buffer = true;
            Response.BinaryWrite(bytes);
            Response.Flush();
            Response.End();
        }

        private void LoadNomineeDetails(string accountId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT NomineeName, NomineeNID, NomineeImage FROM Accounts WHERE AID = @AccountID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AccountID", accountId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblNomineeName.Text = reader["NomineeName"].ToString();
                    lblNomineeNID.Text = reader["NomineeNID"].ToString();
                    imgNominee.ImageUrl = reader["NomineeImage"].ToString(); // stored path "~/images/nominees/..."
                }
            }
        }

    }
}
