using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace vaultx.support_zunaied
{
    public interface ITransactionRepository
    {
        List<dynamic> BindTransactionsFunction(int uid);
    }
}
