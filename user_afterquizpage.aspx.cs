using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class user_afterquizpage : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;
        private int UserId
        {
            get
            {
                if (Session["EMP_NO"] == null)
                {
                    Response.Redirect("~/Loginpage.aspx");
                    return -1; // This line will not be hit, but required for method return
                }
                return Convert.ToInt32(Session["EMP_NO"]);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["quizId"] == null)
                {
                    Response.Redirect("~/user_dashboard.aspx");
                    return;
                }

                int quizId = Convert.ToInt32(Request.QueryString["quizId"]);
                LoadQuizResults(quizId);
            }
        }

        private void LoadQuizResults(int quizId)
        {
            var results = new List<QuestionResult>();
            int correctCount = 0;

            using (var conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = @"
                    SELECT q.QUESTION, q.OPTION_A, q.OPTION_B, q.OPTION_C, q.OPTION_D,
                           q.CORRECT_OPTION, a.SELECTED_OPTION
                    FROM QUIZ_QUESTIONS q
                    LEFT JOIN QUIZ_ANSWER a 
                        ON q.QUESTION_ID = a.QUESTION_ID AND a.USER_ID = @uid AND a.QUIZ_ID = @qid
                    WHERE q.QUIZ_ID = @qid";

                using (var cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@uid", UserId);
                    cmd.Parameters.AddWithValue("@qid", quizId);

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var correct = reader["CORRECT_OPTION"].ToString();
                            var selected = reader["SELECTED_OPTION"]?.ToString();

                            bool isCorrect = selected != null && selected.Equals(correct, StringComparison.OrdinalIgnoreCase);
                            if (isCorrect) correctCount++;

                            results.Add(new QuestionResult
                            {
                                Text = reader["QUESTION"].ToString(),
                                CorrectOption = correct,
                                SelectedOption = selected ?? "-",
                                IsCorrect = isCorrect
                            });
                        }
                    }
                }
            }

            lblResult.Text = "Quiz Completed!";
            lblSummary.Text = $"Your Score: {correctCount} / {results.Count}";

            rptResults.DataSource = results;
            rptResults.DataBind();
        }

        protected void btnGoBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/user_dashboard.aspx");
        }

        private class QuestionResult
        {
            public string Text { get; set; }
            public string CorrectOption { get; set; }
            public string SelectedOption { get; set; }
            public bool IsCorrect { get; set; }
        }
    }
}
