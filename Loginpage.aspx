<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Loginpage.aspx.cs" Inherits="GAIL_QUIZ1.Loginpage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Page</title>
    <link href="Login.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
    <h2>Welcome to GAIL Quiz Portal</h2>

    <div class="form-group">
        <label for="ddlRole">Select Role</label>
            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                <asp:ListItem Text="-- Choose Role --" Value="" />
                <asp:ListItem Text="Admin" Value="admin" />
                <asp:ListItem Text="Quiz Admin" Value="quizadmin" />
                <asp:ListItem Text="User" Value="user" />
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label for="txtEmpNo">Employee Number</label>
            <asp:TextBox ID="txtEmpNo" runat="server" CssClass="form-control" Placeholder="Enter your EMP NO" />
        </div>

        <div class="form-group">
            <label for="txtPassword">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="Enter your password" />
        </div>

        <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />

        <asp:Label ID="lblMessage" runat="server" />
    </div>


    </form>
</body>
</html>
