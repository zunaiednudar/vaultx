<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="vaultx.Logout" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Logging Out...</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!--CSS-->
        <link rel="stylesheet" href="styles/global.css?v=<%= DateTime.Now.Ticks %>" />
        <link rel="stylesheet" href="styles/logout.css?v=<%= DateTime.Now.Ticks %>" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align:center;margin-top:100px;">
            <h2>Logging you out...</h2>
            <p>Please wait while we end your session.</p>
        </div>
    </form>
</body>
</html>
