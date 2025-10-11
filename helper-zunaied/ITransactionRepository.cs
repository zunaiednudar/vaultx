using System.Collections.Generic;
namespace vaultx.HelperZunaied
{
    public interface ITransactionRepository
    {
        List<dynamic> BindTransactionsFunction(int uid);
    }
}
