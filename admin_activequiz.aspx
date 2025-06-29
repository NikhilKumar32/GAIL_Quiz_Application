<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeBehind="admin_activequiz.aspx.cs" Inherits="GAIL_QUIZ1.admin_activequiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background: linear-gradient(to right, #eef1f5, #f5f7fa);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #2c3e50;
            margin: 0;
            padding: 0px;
        }

        h4 {
            font-size: 30px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            letter-spacing: 0.5px;
            animation: fadeIn 1s ease-out;
        }

        .grid-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
            animation: slideFade 0.8s ease;
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 10px;
            margin-top: 10px;
        }

        .table th {
            background-color: #f1f3f9;
            color: #2c3e50;
            text-align: left;
            padding: 14px 16px;
            font-size: 15px;
            border-bottom: 2px solid #dee2e6;
        }

        .table td {
            background-color: #fff;
            padding: 14px 16px;
            font-size: 14px;
            border-bottom: 1px solid #f0f2f5;
            transition: all 0.2s ease;
        }

        .table tr:hover td {
            background-color: #f8fbfe;
            transform: scale(1.005);
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.08);
        }

        @keyframes slideFade {
            from { opacity: 0; transform: translateY(25px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .section-header {
            padding-left: 30px;
            margin-bottom: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="section-header">
        <h4 style="padding-top: 5px;">Active Quizzes</h4>
    </div>

    <div class="grid-container">
        <asp:GridView ID="gvActiveQuizzes" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered">
            <Columns>
                <asp:BoundField HeaderText="S.No" DataField="SerialNo" />
                <asp:BoundField HeaderText="Title" DataField="QUIZ_TITLE" />
                <asp:BoundField HeaderText="Start Time" DataField="QUIZ_START_TIME" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                <asp:BoundField HeaderText="End Time" DataField="QUIZ_END_TIME" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                <asp:BoundField HeaderText="Duration (min)" DataField="QUIZ_DURATION" />
                <asp:BoundField HeaderText="Requested By" DataField="EMP_NAME" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
