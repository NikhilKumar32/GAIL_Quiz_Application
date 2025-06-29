using System;
using System.Data;
using System.Configuration;
using MySql.Data.MySqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GAIL_QUIZ1
{
    public partial class quizadmin_results_participants : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int quizId = Convert.ToInt32(Request.QueryString["quizId"]);
                lblQuizId.Text = quizId.ToString();
                LoadParticipants(quizId);
            }
        }

        private void LoadParticipants(int quizId)
        {
            string query = @"
                SELECT 
                    u.USER_ID,
                    e.EMP_NAME,
                    e.DEPT,
                    e.LOCATION,
                    COUNT(CASE WHEN q.CORRECT_OPTION = a.SELECTED_OPTION THEN 1 END) AS Score
                FROM QUIZ_ANSWER a
                JOIN ERP_HR_DAT e ON a.USER_ID = e.EMP_NO
                JOIN QUIZ_QUESTIONS q ON a.QUESTION_ID = q.QUESTION_ID
                JOIN QUIZ_REQUEST r ON a.QUIZ_ID = r.QUIZ_ID
                JOIN (SELECT DISTINCT USER_ID FROM QUIZ_ANSWER WHERE QUIZ_ID = @quizId) u ON a.USER_ID = u.USER_ID
                WHERE a.QUIZ_ID = @quizId
                GROUP BY u.USER_ID, e.EMP_NAME, e.DEPT, e.LOCATION
                ORDER BY Score DESC;
            ";

            var dt = new DataTable();
            using (var conn = new MySqlConnection(connStr))
            using (var cmd = new MySqlCommand(query, conn))
            using (var da = new MySqlDataAdapter(cmd))
            {
                cmd.Parameters.AddWithValue("@quizId", quizId);
                da.Fill(dt);
            }

            // Add row numbers
            dt.Columns.Add("RowNum", typeof(int));
            for (int i = 0; i < dt.Rows.Count; i++)
                dt.Rows[i]["RowNum"] = i + 1;

            gvParticipants.DataSource = dt;
            gvParticipants.DataBind();
        }

        protected void gvParticipants_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewParticipant")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                int quizId = Convert.ToInt32(lblQuizId.Text);
                Response.Redirect($"quizadmin_participant_detail.aspx?quizId={quizId}&userId={userId}");
            }
        }
    }
}