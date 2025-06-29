using System;
using System.Configuration;
using System.Data;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class user_result_detail : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string quizIdStr = Request.QueryString["quizId"];
                string userIdStr = Request.QueryString["userId"];

                if (int.TryParse(quizIdStr, out int quizId) && int.TryParse(userIdStr, out int userId))
                {
                    LoadQuizTitle(quizId);
                    LoadQuestionWiseResult(quizId, userId);
                }
                else
                {
                    Response.Redirect("user_result.aspx?msg=InvalidRequest");
                }
            }
        }

        private void LoadQuizTitle(int quizId)
        {
            string query = "SELECT QUIZ_TITLE FROM QUIZ_REQUEST WHERE QUIZ_ID = @quizId";
            using (var conn = new MySqlConnection(connStr))
            using (var cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@quizId", quizId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                    lblQuizTitle.Text = result.ToString();
            }
        }

        private void LoadQuestionWiseResult(int quizId, int userId)
        {
            string query = @"
                SELECT 
                    q.QUESTION,
                    q.CORRECT_OPTION,
                    IFNULL(a.SELECTED_OPTION, '-') AS SELECTED_OPTION,
                    a.ATTEMPTED_AT,
                    CASE WHEN a.SELECTED_OPTION = q.CORRECT_OPTION THEN 1 ELSE 0 END AS IS_CORRECT
                FROM QUIZ_QUESTIONS q
                LEFT JOIN QUIZ_ANSWER a ON q.QUESTION_ID = a.QUESTION_ID AND a.QUIZ_ID = @quizId AND a.USER_ID = @userId
                WHERE q.QUIZ_ID = @quizId;
            ";

            DataTable dt = new DataTable();
            using (var conn = new MySqlConnection(connStr))
            using (var cmd = new MySqlCommand(query, conn))
            using (var da = new MySqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@quizId", quizId);
                cmd.Parameters.AddWithValue("@userId", userId);
                da.Fill(dt);
            }

            dt.Columns.Add("RowNum", typeof(int));
            for (int i = 0; i < dt.Rows.Count; i++)
                dt.Rows[i]["RowNum"] = i + 1;

            gvDetails.DataSource = dt;
            gvDetails.DataBind();
        }
    }
}
