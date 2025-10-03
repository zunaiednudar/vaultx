// FACTORY DESIGN PATTERN

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace vaultx.support_zunaied
{
    public class RepositoryFactory
    {
        public IAccountRepository CreateAccountRepository()
        {
            return new AccountRepository();
        }

        public ITransactionRepository CreateTransactionRepository()
        {
            return new TransactionRepository();
        }
    }
}
