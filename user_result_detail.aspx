<%@ Page Title="" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeBehind="user_result_detail.aspx.cs" Inherits="GAIL_QUIZ1.user_result_detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .container {
            margin: 40px auto;
            width: 90%;
        }

        .title {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .question-table {
            width: 100%;
            border-collapse: collapse;
        }

        .question-table th, .question-table td {
            padding: 10px;
            border: 1px solid #ccc;
            vertical-align: top;
        }

        .correct {
            background-color: #d4edda;
        }

        .incorrect {
            background-color: #f8d7da;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="container">
        <div class="title">
            Your Result - 
            <asp:Label ID="lblQuizTitle" runat="server" />
        </div>

        <asp:GridView ID="gvDetails" runat="server" AutoGenerateColumns="False" CssClass="question-table" HeaderStyle-BackColor="#f1f1f1">
            <Columns>
                <asp:BoundField HeaderText="Q.No." DataField="RowNum" />
                <asp:BoundField HeaderText="Question" DataField="QUESTION" HtmlEncode="false" />
                <asp:BoundField HeaderText="Correct Answer" DataField="CORRECT_OPTION" />
                <asp:BoundField HeaderText="Your Answer" DataField="SELECTED_OPTION" />
                <asp:BoundField HeaderText="Attempted At" DataField="ATTEMPTED_AT" DataFormatString="{0:dd-MMM-yyyy HH:mm}" />
                <asp:TemplateField HeaderText="Result">
                    <ItemTemplate>
                        <asp:Label ID="lblResult" runat="server" 
                            Text='<%# Eval("IS_CORRECT").ToString() == "1" ? "Correct" : "Wrong" %>'
                            CssClass='<%# Eval("IS_CORRECT").ToString() == "1" ? "correct" : "incorrect" %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
