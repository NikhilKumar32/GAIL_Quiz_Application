<%@ Page Title="" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeBehind="user_afterquizpage.aspx.cs" Inherits="GAIL_QUIZ1.user_afterquizpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        .result-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .result-header {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .question-block {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #ddd;
        }

        .question-text {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .option {
            margin-left: 20px;
            display: block;
        }

        .correct {
            color: green;
            font-weight: bold;
        }

        .wrong {
            color: red;
            font-weight: bold;
        }

        .summary {
            font-size: 18px;
            margin-bottom: 25px;
        }
    </style>

    <div class="result-container">
        <asp:Label ID="lblResult" runat="server" CssClass="result-header" />
        <asp:Label ID="lblSummary" runat="server" CssClass="summary" />

        <asp:Repeater ID="rptResults" runat="server">
            <ItemTemplate>
                <div class="question-block">
                    <div class="question-text">
                        Q<%# Container.ItemIndex + 1 %>. <%# Eval("Text") %>
                    </div>
                    <div class="option"><b>Your Answer:</b> 
                        <span class='<%# Eval("IsCorrect").ToString() == "True" ? "correct" : "wrong" %>'>
                            <%# Eval("SelectedOption") %>
                        </span>
                    </div>
                    <div class="option"><b>Correct Answer:</b> <%# Eval("CorrectOption") %></div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Button ID="btnGoBack" runat="server" CssClass="btn btn-primary" Text="Go to Dashboard" OnClick="btnGoBack_Click" />
    </div>
</asp:Content>

