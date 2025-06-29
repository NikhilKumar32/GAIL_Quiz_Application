using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class user_dashboard : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EMP_NO"] == null)
            {
                Response.Redirect("~/Loginpage.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                int userId = Convert.ToInt32(Session["EMP_NO"]);
                LoadUserQuizzes(userId);
            }
        }

        private void LoadUserQuizzes(int userId)
        {
            List<QuizInfo> quizzes = new List<QuizInfo>();

            using (var conn = new MySqlConnection(connStr))
            {
                conn.Open();

                string query = @"
                    SELECT 
                        qr.QUIZ_ID,
                        qr.QUIZ_TITLE,
                        qr.DEPARTMENT,
                        qr.QUIZ_DURATION,
                        qr.QUIZ_START_TIME,
                        qr.QUIZ_END_TIME,
                        CASE
                            WHEN EXISTS (
                                SELECT 1 FROM QUIZ_ANSWER qa 
                                WHERE qa.USER_ID = @UserId AND qa.QUIZ_ID = qr.QUIZ_ID
                            ) THEN 'completed'
                            WHEN NOW() > qr.QUIZ_END_TIME THEN 'missed'
                            ELSE 'active'
                        END AS Status
                    FROM QUIZ_REQUEST qr
                    WHERE qr.QUIZ_STATUS = 'Approved'
                    ORDER BY qr.QUIZ_END_TIME DESC";

                using (var cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            quizzes.Add(new QuizInfo
                            {
                                QuizId = Convert.ToInt32(reader["QUIZ_ID"]),
                                Title = reader["QUIZ_TITLE"].ToString(),
                                Department = reader["DEPARTMENT"].ToString(),
                                Duration = Convert.ToInt32(reader["QUIZ_DURATION"]),
                                StartTime = Convert.ToDateTime(reader["QUIZ_START_TIME"]),
                                EndTime = Convert.ToDateTime(reader["QUIZ_END_TIME"]),
                                Status = reader["Status"].ToString()
                            });
                        }
                    }
                }
            }

            activeContainer.InnerHtml = BuildQuizTable(quizzes, "active");
            completedContainer.InnerHtml = BuildQuizTable(quizzes, "completed");
            missedContainer.InnerHtml = BuildQuizTable(quizzes, "missed");
        }

        private string BuildQuizTable(List<QuizInfo> quizzes, string status)
        {
            var sb = new StringBuilder();
            int serial = 1;
            var filtered = quizzes.FindAll(q => q.Status == status);

            if (filtered.Count == 0)
                return "<p>No quizzes found.</p>";

            sb.Append(@"
                <table class='table table-bordered table-striped'>
                    <thead class='table-light'>
                        <tr>
                            <th>S.No</th>
                            <th>Title</th>
                            <th>Department</th>
                            <th>Duration (mins)</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>");

            foreach (var quiz in filtered)
            {
                sb.AppendFormat(@"
                    <tr>
                        <td>{0}</td>
                        <td>{1}</td>
                        <td>{2}</td>
                        <td>{3}</td>
                        <td>{4:yyyy-MM-dd HH:mm}</td>
                        <td>{5:yyyy-MM-dd HH:mm}</td>
                        <td>{6}</td>
                    </tr>",
                    serial++, quiz.Title, quiz.Department, quiz.Duration, quiz.StartTime, quiz.EndTime, quiz.Status);
            }

            sb.Append("</tbody></table>");
            return sb.ToString();
        }

        private class QuizInfo
        {
            public int QuizId { get; set; }
            public string Title { get; set; }
            public string Department { get; set; }
            public int Duration { get; set; }
            public DateTime StartTime { get; set; }
            public DateTime EndTime { get; set; }
            public string Status { get; set; }
        }
    }
}
