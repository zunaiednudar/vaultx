using System;
using System.IO;
using System.Web;

namespace vaultx
{
    public class Global : HttpApplication
    {
        protected void Application_Error(object sender, EventArgs e)
        {
            var ex = Server.GetLastError();
            try
            {
                var dir = Server.MapPath("~/App_Data");
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
                File.AppendAllText(Path.Combine(dir, "error.log"),
                    DateTime.UtcNow.ToString("u") + " - " + (ex?.ToString() ?? "null") + Environment.NewLine + new string('-', 80) + Environment.NewLine);
            }
            catch { /* avoid second failure */ }

            // show error to browser when debugging
            if (HttpContext.Current != null && HttpContext.Current.IsDebuggingEnabled)
            {
                Response.Clear();
                Response.ContentType = "text/plain";
                Response.Write(ex?.ToString() ?? "null");
                Response.End();
            }
        }
    }
}