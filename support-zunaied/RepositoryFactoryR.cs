using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vaultx.support_zunaied
{
    public class RepositoryFactoryR
    {
        public static IAccountRepository CreateAccountRepositoryR()
        {
            return new AccountRepository();
        }

        public static ITransactionRepository CreateTransactionRepositoryR()
        {
            return new TransactionRepository();
        }
    }
}