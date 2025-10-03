// FACTORY DESIGN PATTERN

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vaultx.support_zunaied
{
    public class RepositoryFactory
    {
        public static IAccountRepository GetAccountRepository()
        {
            return new AccountRepository();
        }

        public static ITransactionRepository GetUserRepository()
        {
            return new TransactionRepository();
        }
    }
}
