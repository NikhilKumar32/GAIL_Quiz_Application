<%@ Page Title="" Language="C#" MasterPageFile="~/quizadmin.master" AutoEventWireup="true" CodeBehind="quizadmin_results.aspx.cs" Inherits="GAIL_QUIZ1.quizadmin_results" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #eef2f3, #ffffff);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin: 30px 0 20px;
            font-size: 26px;
        }

        .table-container {
            max-width: 1150px;
            margin: auto;
            padding: 0 20px 40px;
        }

        .result-table {
            width: 100%;
            border-collapse: collapse;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            background-color: #fff;
        }

        .result-table th {
            background-color: #007bff;
            color: white;
            text-align: left;
            padding: 12px;
            font-size: 15px;
        }

        .result-table td {
            padding: 12px;
            border-top: 1px solid #dee2e6;
            color: #333;
        }

        .result-table tr:hover {
            background-color: #f1f7ff;
        }

        .btn-view {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 6px 14px;
            font-size: 14px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .btn-view:hover {
            background-color: #218838;
        }

        .aspNetDisabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="table-container">
        <h2>Completed Quiz Results</h2>
        <asp:GridView ID="gvCompleted" runat="server"
            AutoGenerateColumns="false"
            CssClass="result-table"
            GridLines="Horizontal"
            EmptyDataText="No completed quizzes found."
            OnRowCommand="gvCompleted_RowCommand"
            HeaderStyle-HorizontalAlign="Left">
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
                        <asp:Button ID="btnViewResults" runat="server"
                            Text="View Results"
                            CommandName="ViewResults"
                            CommandArgument='<%# Eval("QUIZ_ID") %>'
                            CssClass="btn-view" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
