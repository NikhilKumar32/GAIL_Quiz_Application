using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class user_quizpage : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;
        private int UserId
        {
            get
            {
                if (Session["EMP_NO"] == null)
                {
                    Response.Redirect("~/Loginpage.aspx", true); // true ends the response
                    return -1; // required by syntax but never reached
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
                ViewState["quizId"] = quizId;

                string keyPrefix = $"Quiz_{UserId}_{quizId}";

                if (Session[$"{keyPrefix}_StartTime"] == null)
                {
                    Session[$"{keyPrefix}_StartTime"] = DateTime.Now;
                    Session[$"{keyPrefix}_DurationSeconds"] = GetQuizDurationSeconds(quizId);
                }


                var loadedQuestions = LoadQuestions(quizId);
                if (loadedQuestions == null || loadedQuestions.Count == 0)
                {
                    // Redirect with a message or show alert
                    Response.Redirect("~/user_dashboard.aspx?msg=NoQuestionsAvailable");
                    return;
                }
                ViewState["quizQuestions"] = loadedQuestions;

                DisplayQuestion(0);
                BindSidebar();
            }

            SetRemainingTime();
        }

        private int GetQuizDurationSeconds(int quizId)
        {
            int durationMinutes = 10;
            using (var conn = new MySqlConnection(connStr))
            {
                conn.Open();
                var query = "SELECT QUIZ_DURATION FROM QUIZ_REQUEST WHERE QUIZ_ID = @quizId";
                using (var cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@quizId", quizId);
                    var result = cmd.ExecuteScalar();
                    if (result != null && int.TryParse(result.ToString(), out int min))
                        durationMinutes = min;
                }
            }
            return durationMinutes * 60;
        }

        private void SetRemainingTime()
        {
            int quizId = (int)ViewState["quizId"];
            string keyPrefix = $"Quiz_{UserId}_{quizId}";

            if (Session[$"{keyPrefix}_StartTime"] != null && Session[$"{keyPrefix}_DurationSeconds"] != null)
            {
                DateTime start = (DateTime)Session[$"{keyPrefix}_StartTime"];
                int duration = (int)Session[$"{keyPrefix}_DurationSeconds"];

                int remaining = duration - (int)(DateTime.Now - start).TotalSeconds;

                hfRemainingSeconds.Value = remaining > 0 ? remaining.ToString() : "0";

                if (remaining <= 0 && !Response.IsRequestBeingRedirected)
                {
                    btnSubmit_Click(null, EventArgs.Empty);
                    DisableQuizUI();
                }
            }
        }

        private void DisableQuizUI()
        {
            lblQuestion.Visible = false;
            rblOptions.Visible = false;
            btnNext.Visible = false;
            btnSubmit.Visible = false;
            sidebarContainer.Visible = false;
        }

        private List<Question> LoadQuestions(int quizId)
        {
            var questions = new List<Question>();
            int randomCount = 0;

            using (var conn = new MySqlConnection(connStr))
            {
                conn.Open();

                // Step 1: Get NUM_RANDOM_QUESTIONS from QUIZ_REQUEST
                string countQuery = "SELECT NUM_RANDOM_QUESTIONS FROM QUIZ_REQUEST WHERE QUIZ_ID = @quizId";
                using (var countCmd = new MySqlCommand(countQuery, conn))
                {
                    countCmd.Parameters.AddWithValue("@quizId", quizId);
                    var result = countCmd.ExecuteScalar();
                    if (result != DBNull.Value && int.TryParse(result.ToString(), out int num))
                    {
                        randomCount = num;
                    }
                }

                // Step 2: Build correct SQL query
                string fetchQuery = randomCount > 0
                    ? $"SELECT * FROM QUIZ_QUESTIONS WHERE QUIZ_ID = @quizId ORDER BY RAND() LIMIT {randomCount}"
                    : "SELECT * FROM QUIZ_QUESTIONS WHERE QUIZ_ID = @quizId";

                using (var fetchCmd = new MySqlCommand(fetchQuery, conn))
                {
                    fetchCmd.Parameters.AddWithValue("@quizId", quizId);

                    using (var reader = fetchCmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            questions.Add(new Question
                            {
                                Id = Convert.ToInt32(reader["QUESTION_ID"]),
                                Text = reader["QUESTION"].ToString(),
                                OptionA = reader["OPTION_A"].ToString(),
                                OptionB = reader["OPTION_B"].ToString(),
                                OptionC = reader["OPTION_C"].ToString(),
                                OptionD = reader["OPTION_D"].ToString(),
                                CorrectOption = reader["CORRECT_OPTION"].ToString()
                            });
                        }
                    }
                }
            }

            return questions;
        }



        private void DisplayQuestion(int index)
        {
            var questions = ViewState["quizQuestions"] as List<Question>;
            if (questions == null || index >= questions.Count) return;

            hfQuestionIndex.Value = index.ToString();
            var q = questions[index];

            lblQuestion.Text = $"{index + 1}. {q.Text}";
            rblOptions.Items.Clear();
            rblOptions.Items.Add(new ListItem(q.OptionA, "A"));
            rblOptions.Items.Add(new ListItem(q.OptionB, "B"));
            rblOptions.Items.Add(new ListItem(q.OptionC, "C"));
            rblOptions.Items.Add(new ListItem(q.OptionD, "D"));

            if (!string.IsNullOrEmpty(q.SelectedOption))
                rblOptions.SelectedValue = q.SelectedOption;

            btnNext.Visible = index < questions.Count - 1;
            btnSubmit.Style["display"] = index == questions.Count - 1 ? "inline-block" : "none";
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            SaveAnswer();
            DisplayQuestion(int.Parse(hfQuestionIndex.Value) + 1);
            BindSidebar();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            SaveAnswer();
            ScriptManager.RegisterStartupScript(this, GetType(), "clearStorage", "localStorage.removeItem('quizEndTime');", true);
            Response.Redirect($"~/user_afterquizpage.aspx?quizId={ViewState["quizId"]}");
        }

        protected void rblOptions_SelectedIndexChanged(object sender, EventArgs e)
        {
            SaveAnswer();
            ScriptManager.RegisterStartupScript(this, GetType(), "markSidebar", $"markAttempted({hfQuestionIndex.Value});", true);
            BindSidebar();
        }

        private void SaveAnswer()
        {
            var questions = ViewState["quizQuestions"] as List<Question>;
            if (questions == null) return;

            int index = int.Parse(hfQuestionIndex.Value);
            var q = questions[index];
            string selected = rblOptions.SelectedValue;
            if (string.IsNullOrEmpty(selected)) return;

            q.SelectedOption = selected;
            ViewState["quizQuestions"] = questions;

            using (var conn = new MySqlConnection(connStr))
            {
                conn.Open();

                var checkQuery = "SELECT COUNT(*) FROM QUIZ_ANSWER WHERE USER_ID = @uid AND QUIZ_ID = @qid AND QUESTION_ID = @qid2";
                using (var checkCmd = new MySqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@uid", UserId);
                    checkCmd.Parameters.AddWithValue("@qid", (int)ViewState["quizId"]);
                    checkCmd.Parameters.AddWithValue("@qid2", q.Id);

                    int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                    string query = count == 0
                        ? "INSERT INTO QUIZ_ANSWER (USER_ID, QUIZ_ID, QUESTION_ID, SELECTED_OPTION) VALUES (@uid, @qid, @qid2, @opt)"
                        : "UPDATE QUIZ_ANSWER SET SELECTED_OPTION = @opt WHERE USER_ID = @uid AND QUIZ_ID = @qid AND QUESTION_ID = @qid2";

                    using (var cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@uid", UserId);
                        cmd.Parameters.AddWithValue("@qid", (int)ViewState["quizId"]);
                        cmd.Parameters.AddWithValue("@qid2", q.Id);
                        cmd.Parameters.AddWithValue("@opt", selected);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        private void BindSidebar()
        {
            var questions = ViewState["quizQuestions"] as List<Question>;
            rptSidebar.DataSource = questions?.ConvertAll(q => new { IsAttempted = !string.IsNullOrEmpty(q.SelectedOption) });
            rptSidebar.DataBind();
        }

        [Serializable]
        private class Question
        {
            public int Id;
            public string Text;
            public string OptionA;
            public string OptionB;
            public string OptionC;
            public string OptionD;
            public string CorrectOption;
            public string SelectedOption;
        }
    }
}
