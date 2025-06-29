<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeBehind="admin_result.aspx.cs" Inherits="GAIL_QUIZ1.admin_result" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        h2 {
            text-align: center;
            margin-top: 30px;
            color: #2c3e50;
        }
        .table-container {
            max-width: 1150px;
            margin: auto;
            padding: 20px;
        }
        .result-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }
        .result-table th {
            background-color: #007bff;
            color: white;
            padding: 10px;
            text-align: left;
        }
        .result-table td {
            padding: 10px;
            border-top: 1px solid #ddd;
        }
        .btn-view {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="table-container">
        <h2>All Completed Quizzes</h2>
        <asp:GridView ID="gvAllCompleted" runat="server" AutoGenerateColumns="False"
            CssClass="result-table"
            OnRowCommand="gvAllCompleted_RowCommand"
            EmptyDataText="No completed quizzes found.">
            <Columns>
                <asp:BoundField HeaderText="Sr. No." DataField="RowNum" />
                <asp:BoundField HeaderText="Quiz Title" DataField="QUIZ_TITLE" />
                <asp:BoundField HeaderText="Department" DataField="DEPARTMENT" />
                <asp:BoundField HeaderText="Location" DataField="LOCATION" />
                <asp:BoundField HeaderText="Date" DataField="QUIZ_DATE" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField HeaderText="Start Time" DataField="QUIZ_START_TIME" DataFormatString="{0:HH:mm}" />
                <asp:BoundField HeaderText="End Time" DataField="QUIZ_END_TIME" DataFormatString="{0:HH:mm}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnView" runat="server" Text="View Results"
                            CommandName="ViewResults"
                            CommandArgument='<%# Eval("QUIZ_ID") %>'
                            CssClass="btn-view" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
