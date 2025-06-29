<%@ Page Title="" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeBehind="user_attemptquiz.aspx.cs" Inherits="GAIL_QUIZ1.user_attemptquiz" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        body {
            background: linear-gradient(to right, #f0f2f5, #ffffff);
            font-family: 'Segoe UI', sans-serif;
        }

        .quiz-list-container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h2.text-primary {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50 !important;
            margin-bottom: 25px;
        }

        .quiz-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #fff;
            padding: 20px 24px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
            transition: transform 0.2s ease;
        }

        .quiz-card:hover {
            transform: scale(1.01);
        }

        .quiz-details {
            flex-grow: 1;
        }

        .quiz-details h5 {
            font-size: 20px;
            margin-bottom: 8px;
            color: #007bff;
        }

        .quiz-details p {
            margin: 0;
            font-size: 15px;
            color: #555;
            line-height: 1.6;
        }

        .quiz-actions {
            margin-left: 30px;
        }

        .btn-start {
            background-color: #007bff;
            color: white !important;
            text-decoration: none !important;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            display: inline-block;
            transition: transform 0.2s ease;
        }

        .btn-start:hover {
            transform: scale(1.05);
            color: white !important;
            text-decoration: none !important;
        }
    </style>

    <div class="quiz-list-container">
        <h2 class="text-primary">Available Quizzes</h2>

        <asp:Literal ID="litMessage" runat="server" />

        <asp:Repeater ID="quizRepeater" runat="server" OnItemCommand="quizRepeater_ItemCommand">
            <ItemTemplate>
                <div class="quiz-card">
                    <div class="quiz-details">
                        <h5><%# Container.ItemIndex + 1 %>. <%# Eval("QUIZ_TITLE") %></h5>
                        <p>
                            <strong>Department:</strong> <%# Eval("DEPARTMENT") %><br />
                            <strong>Start:</strong> <%# Eval("QUIZ_START_TIME", "{0:yyyy-MM-dd HH:mm}") %><br />
                            <strong>End:</strong> <%# Eval("QUIZ_END_TIME", "{0:yyyy-MM-dd HH:mm}") %><br />
                            <strong>Duration:</strong> <%# Eval("QUIZ_DURATION") %> min
                        </p>
                    </div>
                    <div class="quiz-actions">
                        <asp:LinkButton ID="btnStart" runat="server"
                            CssClass="btn-start"
                            Text="Start Quiz"
                            CommandName="StartQuiz"
                            CommandArgument='<%# Eval("QUIZ_ID") %>' />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
