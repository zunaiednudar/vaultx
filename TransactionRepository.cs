using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Util;

namespace vaultx
{
    public class TransactionRepository : ITransactionRepository
    {
        public List<dynamic> BindTransactionsFunction(int uid)
        {
            var transactions = new List<dynamic>();
            using (SqlConnection connection = DatabaseConnection.getInstance().GetConnection())
            {
                string query = @"
                                SELECT TOP 10 T.TID, T.FromAID, T.ToAID, T.Amount, T.Reference, T.Date, A.AID, A.AccountType
                                FROM Transactions T INNER JOIN Accounts A ON T.FromAID = A.AID OR T.ToAID = A.AID
                                WHERE A.UID = @UID
                                ORDER BY T.Date DESC
                                ";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UID", uid);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            transactions.Add(new
                            {
                                FromAccountNumber = reader["FromAID"].ToString(),
                                ToAccountNumber = reader["ToAID"].ToString(),
                                TransactionType = (reader["FromAID"].ToString() == reader["AID"].ToString()) ? "Debit" : "Credit",
                                Amount = Convert.ToDecimal(reader["Amount"]),
                                Reference = reader["Reference"].ToString(),
                                Date = Convert.ToDateTime(reader["Date"])
                            });
                        }
                    }
                }
            }
            return transactions;
        }
    }
}