using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace vaultx
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAccounts();
                BindTransactions();
            }
        }

        private void BindAccounts()
        {
            var accounts = new List<dynamic>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                                SELECT AID, AType, ABalance, ACreatedAt
                                FROM Accounts
                                WHERE UID = @UID
                                ORDER BY ACreatedAt ASC
                                ";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UID", Session["UID"]);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            accounts.Add(new
                            {
                                AccountNumber = reader["AID"].ToString(),
                                Balance = Convert.ToDecimal(reader["ABalance"]),
                                AccountType = reader["AType"].ToString()
                            });
                        }
                    }
                }
            }

            rptAccounts.DataSource = accounts;
            rptAccounts.DataBind();

            // Show + if less than 3 accounts
            phAddAccount.Visible = (accounts.Count < 3);
        }

        private void BindTransactions()
        {
            var transactions = new List<dynamic>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                                SELECT TOP 10 T.TID, T.AID, T.TrxID, T.TType, T.TAmount, T.TReference, T.TDate
                                FROM Transactions T INNER JOIN Accounts A ON T.AID = A.AID
                                WHERE A.UID = @UID
                                ORDER BY T.TDate DESC
                                ";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UID", Session["UID"]);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            transactions.Add(new
                            {
                                AccountNumber = reader["AID"].ToString(),
                                TransactionType = reader["TType"].ToString(),
                                TransactionId = reader["TrxID"].ToString(),
                                Amount = Convert.ToDecimal(reader["TAmount"]),
                                Reference = reader["TReference"].ToString(),
                                Date = Convert.ToDateTime(reader["TDate"])
                            });
                        }
                    }
                }
            }

            rptTransactions.DataSource = transactions;
            rptTransactions.DataBind();
        }
    }
}