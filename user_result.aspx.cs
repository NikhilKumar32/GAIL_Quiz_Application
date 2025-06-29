using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class user_result : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadAttemptedQuizzes();
        }

        private void LoadAttemptedQuizzes()
        {
            int userId = Session["EMP_NO"] != null ? Convert.ToInt32(Session["EMP_NO"]) : 0;

            string query = @"
                SELECT 
                    r.QUIZ_ID,
                    r.QUIZ_TITLE,
                    r.DEPARTMENT,
                    r.QUIZ_DATE,
                    COUNT(CASE WHEN q.CORRECT_OPTION = a.SELECTED_OPTION THEN 1 END) AS SCORE
                FROM QUIZ_ANSWER a
                JOIN QUIZ_REQUEST r ON a.QUIZ_ID = r.QUIZ_ID
                JOIN QUIZ_QUESTIONS q ON a.QUESTION_ID = q.QUESTION_ID
                WHERE a.USER_ID = @userId
                GROUP BY r.QUIZ_ID, r.QUIZ_TITLE, r.DEPARTMENT, r.QUIZ_DATE
                ORDER BY r.QUIZ_DATE DESC;
            ";

            DataTable dt = new DataTable();
            using (var conn = new MySqlConnection(connStr))
            using (var cmd = new MySqlCommand(query, conn))
            using (var da = new MySqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@userId", userId);
                da.Fill(dt);
            }

            // Add RowNum
            dt.Columns.Add("RowNum", typeof(int));
            for (int i = 0; i < dt.Rows.Count; i++)
                dt.Rows[i]["RowNum"] = i + 1;

            gvUserQuizzes.DataSource = dt;
            gvUserQuizzes.DataBind();
        }

        protected void gvUserQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewResult")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                int userId = Convert.ToInt32(Session["EMP_NO"]);
                Response.Redirect($"user_result_detail.aspx?quizId={quizId}&userId={userId}");
            }
        }
    }
}
