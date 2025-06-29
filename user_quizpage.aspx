<%@ Page Title="Attempt Quiz" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeBehind="user_quizpage.aspx.cs" Inherits="GAIL_QUIZ1.user_quizpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <style>
        .quiz-container {
    max-width: 860px;
    margin: 50px auto;
    padding: 40px;
    background: linear-gradient(to bottom right, #ffffff, #f9f9f9);
    border-radius: 16px;
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
    font-family: 'Segoe UI', sans-serif;
    position: relative;
}

#timer {
    font-size: 18px;
    font-weight: 600;
    text-align: right;
    color: #343a40;
    margin-bottom: 25px;
}

.question-label {
    font-size: 22px;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 24px;
    line-height: 1.5;
}

.option-list {
    margin-bottom: 30px;
}

.option-list input[type="radio"] {
    margin-right: 8px;
}

.option-list label {
    font-size: 16px;
    padding: 10px 14px;
    display: block;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    margin-bottom: 12px;
    background-color: #fdfdfd;
    transition: background 0.2s ease, border-color 0.2s ease;
    cursor: pointer;
}

.option-list label:hover {
    background-color: #f1f1f1;
    border-color: #adb5bd;
}

.option-list input[type="radio"]:checked + label {
    background-color: #e7f3ff;
    border-color: #4dabf7;
    color: #1c3faa;
    font-weight: bold;
}

.quiz-actions {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    margin-top: 10px;
}

.quiz-actions .btn {
    padding: 12px 24px;
    font-size: 16px;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
}

.quiz-actions .btn-primary {
    background-color: #007bff;
    color: #fff;
}

.quiz-actions .btn-primary:hover {
    background-color: #0056b3;
    transform: translateY(-1px);
}

.quiz-actions .btn-success {
    background-color: #28a745;
    color: #fff;
}

.quiz-actions .btn-success:hover {
    background-color: #1e7e34;
    transform: translateY(-1px);
}

.sidebar {
    position: fixed;
    top: 140px;
    right: 40px;
    width: 140px;
    background: #ffffff;
    padding: 16px;
    border-radius: 12px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    z-index: 1000;
}

.sidebar span {
    display: inline-block;
    width: 40px;
    padding: 8px 0;
    margin: 6px;
    text-align: center;
    border-radius: 6px;
    font-size: 14px;
    background-color: #e9ecef;
    transition: background-color 0.2s ease;
}

.sidebar .attempted {
    background-color: #198754;
    color: white;
    font-weight: 600;
}

@media screen and (max-width: 768px) {
    .sidebar {
        position: static;
        margin-top: 30px;
        width: 100%;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
    }

    .sidebar span {
        margin: 4px;
    }

    .quiz-actions {
        flex-direction: column;
        align-items: flex-end;
    }
}

    </style>

    <asp:HiddenField ID="hfRemainingSeconds" runat="server" />
    <asp:HiddenField ID="hfQuestionIndex" runat="server" />

    <div class="quiz-container">
        <div id="timer">Time Remaining: <span id="timerText">--:--</span></div>

        <asp:Label ID="lblQuestion" runat="server" CssClass="question-label" />

        <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="option-list" RepeatDirection="Vertical"
            AutoPostBack="true" OnSelectedIndexChanged="rblOptions_SelectedIndexChanged" />

        <div class="quiz-actions">
            <asp:Button ID="btnNext" runat="server" Text="Next" CssClass="btn btn-primary" OnClick="btnNext_Click" />
            <asp:Button ID="btnSubmit" runat="server" Text="Submit Quiz" CssClass="btn btn-success" OnClick="btnSubmit_Click" Style="display: none;" />
        </div>
    </div>

    <div id="sidebarContainer" runat="server" class="sidebar">
        <asp:Repeater ID="rptSidebar" runat="server">
            <ItemTemplate>
                <span class='<%# (bool)Eval("IsAttempted") ? "attempted" : "" %>'>Q<%# Container.ItemIndex + 1 %></span>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <script type="text/javascript">
        var interval;

        document.addEventListener("DOMContentLoaded", function () {
            var timerText = document.getElementById("timerText");

            // 👇 Create unique key using server-side UserId and QuizId
            var quizKey = "quizEndTime_<%= Session["EMP_NO"] %>_<%= Request.QueryString["quizId"] %>";
        var endTime = localStorage.getItem(quizKey);

        if (!endTime) {
            var seconds = parseInt(document.getElementById('<%= hfRemainingSeconds.ClientID %>').value);
            var now = new Date().getTime();
            endTime = now + (seconds * 1000);
            localStorage.setItem(quizKey, endTime);
        } else {
            endTime = parseInt(endTime);
        }

        updateTimer(endTime);
        interval = setInterval(() => updateTimer(endTime), 1000);

        function updateTimer(endTime) {
            const now = new Date().getTime();
            const remaining = Math.floor((endTime - now) / 1000);

            if (remaining <= 0) {
                clearInterval(interval);
                localStorage.removeItem(quizKey);
                timerText.textContent = "00:00";
                __doPostBack('<%= btnSubmit.UniqueID %>', '');
            } else {
                const min = Math.floor(remaining / 60).toString().padStart(2, "0");
                const sec = (remaining % 60).toString().padStart(2, "0");
                timerText.textContent = `${min}:${sec}`;
            }
        }
    });

        function markAttempted(index) {
            const spans = document.querySelectorAll('.sidebar span');
            if (spans[index]) spans[index].classList.add('attempted');
        }

        // Detect if the page is being unloaded (refresh, close, or navigate away)
        window.addEventListener("beforeunload", function (e) {
            // Attempt auto-submit only if quiz is still running
            var timerValue = document.getElementById("timerText").textContent;
            if (timerValue !== "00:00") {
                // Prevent default unload (optional warning dialog)
                // e.preventDefault(); 
                // e.returnValue = '';
                // Trigger submit
                __doPostBack('<%= btnSubmit.UniqueID %>', '');
    }
    });

    // Also handle mobile tab-switching or minimize
    document.addEventListener("visibilitychange", function () {
        if (document.visibilityState === 'hidden') {
            var timerValue = document.getElementById("timerText").textContent;
            if (timerValue !== "00:00") {
                __doPostBack('<%= btnSubmit.UniqueID %>', '');
            }
        }
    });


    </script>

</asp:Content>
