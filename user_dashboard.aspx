<%@ Page Title="" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeBehind="user_dashboard.aspx.cs" Inherits="GAIL_QUIZ1.user_dashboard" %>


<asp:Content ID="ContentHead" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background: linear-gradient(to right, #eef2f7, #f8fbff);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            color: #2c3e50;
        }

        .container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 0 20px;
        }

        h2 {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 25px;
        }

        .section-nav {
            font-size: 14px;
            margin-bottom: 30px;
        }

        .section-nav a {
            margin-right: 15px;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .section-nav a.text-success:hover {
            color: #1e7e34;
        }

        .section-nav a.text-secondary:hover {
            color: #495057;
        }

        .section-nav a.text-danger:hover {
            color: #c82333;
        }

        .quiz-section {
            margin-bottom: 60px;
        }

        .quiz-section h4 {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 8px;
            border-bottom: 2px solid #dee2e6;
        }

        .quiz-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px 24px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .quiz-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.15);
        }

        .quiz-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 6px;
        }

        .quiz-meta {
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 10px;
        }

        .badge-status {
            display: inline-block;
            padding: 5px 14px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 600;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-completed {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .status-missed {
            background-color: #f8d7da;
            color: #721c24;
        }

        @media (max-width: 768px) {
            .quiz-card {
                padding: 16px;
            }
            h2 {
                font-size: 26px;
            }
            .quiz-section h4 {
                font-size: 18px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="container">
        

        <!-- Quick Navigation -->
        <div class="section-nav">
            <strong>Jump to:</strong>
            <a href="#active" class="text-success">Active</a>
            <a href="#completed" class="text-secondary">Completed</a>
            <a href="#missed" class="text-danger">Missed</a>
        </div>

        <!-- Active Quizzes -->
        <div id="active" class="quiz-section">
            <h4 class="text-success">Active Quizzes</h4>
            <div id="activeContainer" runat="server"></div>
        </div>

        <!-- Completed Quizzes -->
        <div id="completed" class="quiz-section">
            <h4 class="text-secondary">Completed Quizzes (Last 7 Days)</h4>
            <div id="completedContainer" runat="server"></div>
        </div>

        <!-- Missed Quizzes -->
        <div id="missed" class="quiz-section">
            <h4 class="text-danger">Missed Quizzes (Last 7 Days)</h4>
            <div id="missedContainer" runat="server"></div>
        </div>
    </div>
</asp:Content>
