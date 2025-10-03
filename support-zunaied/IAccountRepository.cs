using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace vaultx.support_zunaied
{
    public interface IAccountRepository
    {
        List<dynamic> BindAccountsFunction(int uid);
        DataTable GetUserAccounts(int uid);
        int GetLastAccountNumber();
        void CreateAccount(int aid, string type, int uid, string nomineeName, string nomineeNID, string nomineeImage);
    }
}