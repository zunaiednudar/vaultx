// SINGLETON PATTERN IMPLEMENTATION

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace vaultx.support_zunaied
{
    public class DatabaseConnection
    {
        private static DatabaseConnection instance = null;
        private readonly string connectionString;

        private DatabaseConnection()
        {
            connectionString = ConfigurationManager.ConnectionStrings["VaultXDbConnection"].ConnectionString;
        }

        public static DatabaseConnection getInstance()
        {
            if (instance == null)
            {
                instance = new DatabaseConnection();
            }
            return instance;
        }

        public SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }
    }
}