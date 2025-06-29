<%@ Page Title="" Language="C#" MasterPageFile="~/quizadmin.master" AutoEventWireup="true" CodeBehind="quizadmin_results_participants.aspx.cs" Inherits="GAIL_QUIZ1.quizadmin_results_participants" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .table-container {
            margin: 40px auto;
            width: 90%;
        }
        .table-title {
            font-size: 24px;
            margin-bottom: 20px;
            font-weight: bold;
        }
        .participant-table {
            width: 100%;
            border-collapse: collapse;
        }
        .participant-table th, .participant-table td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        .action-button {
            padding: 6px 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="table-container">
        <div class="table-title">Participants for Quiz ID: 
            <asp:Label ID="lblQuizId" runat="server" />
        </div>

        <asp:GridView ID="gvParticipants" runat="server" AutoGenerateColumns="False" CssClass="participant-table" OnRowCommand="gvParticipants_RowCommand">
            <Columns>
                <asp:BoundField HeaderText="Sr. No." DataField="RowNum" />
                <asp:BoundField HeaderText="Participant Name" DataField="EMP_NAME" />
                <asp:BoundField HeaderText="Department" DataField="DEPT" />
                <asp:BoundField HeaderText="Location" DataField="LOCATION" />
                <asp:BoundField HeaderText="Score" DataField="Score" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnView" runat="server" Text="View" CssClass="action-button"
                            CommandName="ViewParticipant"
                            CommandArgument='<%# Eval("USER_ID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
