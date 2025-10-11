using System.Collections.Generic;
using System.Data;
namespace vaultx.HelperZunaied
{
    public interface IAccountRepository
    {
        List<dynamic> BindAccountsFunction(int uid);
        DataTable GetUserAccounts(int uid);
        int GetLastAccountNumber();
        void CreateAccount(int aid, string type, int uid, string nomineeName, string nomineeNID, string nomineeImage);
    }
}