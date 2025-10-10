// FACTORY DESIGN PATTERN
namespace vaultx.HelperZunaied
{
    public class RepositoryFactory
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
