// FACTORY DESIGN PATTERN

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vaultx
{
    public class RepositoryFactoryZ
    {
        public static IAccountRepository CreateAccountRepository()
        {
            return new AccountRepository();
        }

        public static ITransactionRepository CreateTransactionRepository()
        {
            return new TransactionRepository();
        }
    }
}
