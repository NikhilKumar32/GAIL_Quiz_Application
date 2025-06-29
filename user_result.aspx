<%@ Page Title="" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeBehind="user_result.aspx.cs" Inherits="GAIL_QUIZ1.user_result" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .table-container {
            margin: 40px auto;
            width: 90%;
        }

        h2 {
            text-align: center;
            margin: 30px 0;
            color: #2c3e50;
        }

        .result-table {
            width: 100%;
            border-collapse: collapse;
        }

        .result-table th, .result-table td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }

        .btn-view {
            background-color: #007bff;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="table-container">
        <h2>Your Attempted Quizzes</h2>

        <asp:GridView ID="gvUserQuizzes" runat="server" AutoGenerateColumns="False"
            CssClass="result-table" OnRowCommand="gvUserQuizzes_RowCommand">
            <Columns>
                <asp:BoundField HeaderText="Sr. No." DataField="RowNum" />
                <asp:BoundField HeaderText="Quiz Title" DataField="QUIZ_TITLE" />
                <asp:BoundField HeaderText="Department" DataField="DEPARTMENT" />
                <asp:BoundField HeaderText="Date" DataField="QUIZ_DATE" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField HeaderText="Score" DataField="SCORE" />
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnView" runat="server" Text="View Result" CommandName="ViewResult"
                            CommandArgument='<%# Eval("QUIZ_ID") %>' CssClass="btn-view" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
