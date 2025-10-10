using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
namespace vaultx.HelperZunaied
{
    public class AccountRepository : IAccountRepository
    {
        public List<dynamic> BindAccountsFunction(int uid)
        {
            var accounts = new List<dynamic>();
            using (SqlConnection connection = DatabaseConnection.getInstance().GetConnection())
            {
                string query = @"
                                SELECT AID, AccountType, Balance, CreatedAt
                                FROM Accounts
                                WHERE UID = @UID
                                ORDER BY CreatedAt ASC
                                ";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UID", uid);
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            accounts.Add(new
                            {
                                AccountNumber = reader["AID"].ToString(),
                                Balance = Convert.ToDecimal(reader["Balance"]),
                                AccountType = reader["AccountType"].ToString()
                            });
                        }
                    }
                }
            }
            return accounts;
        }
        public DataTable GetUserAccounts(int uid)
        {
            using (SqlConnection connection = DatabaseConnection.getInstance().GetConnection())
            {
                string query = "SELECT AID, AccountType, Balance, CreatedAt FROM Accounts WHERE UID = @UID";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UID", uid);
                    SqlDataAdapter dataAdapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    dataAdapter.Fill(dataTable);
                    return dataTable;
                }
            }
        }
        public int GetLastAccountNumber()
        {
            using (SqlConnection connection = DatabaseConnection.getInstance().GetConnection())
            {
                string query = "SELECT ISNULL(MAX(CAST(AID AS INT)), 100000) FROM Accounts";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    int maxAid = (int)command.ExecuteScalar();
                    return maxAid;
                }
            }
        }
        public void CreateAccount(int aid, string type, int uid, string nomineeName, string nomineeNID, string nomineeImage)
        {
            using (SqlConnection connection = DatabaseConnection.getInstance().GetConnection())
            {
                string query = @"
                    INSERT INTO Accounts (AID, AccountType, Balance, UID, NomineeName, NomineeNID, NomineeImage)
                    VALUES (@AID, @AccountType, @Balance, @UID, @NomineeName, @NomineeNID, @NomineeImage)
                ";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@AID", aid.ToString());
                    command.Parameters.AddWithValue("@AccountType", type);
                    command.Parameters.AddWithValue("@Balance", 0.00m);
                    command.Parameters.AddWithValue("@UID", uid);
                    command.Parameters.AddWithValue("@NomineeName", nomineeName);
                    command.Parameters.AddWithValue("@NomineeNID", nomineeNID);
                    command.Parameters.AddWithValue("@NomineeImage", nomineeImage);
                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}