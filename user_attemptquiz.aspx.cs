using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class user_attemptquiz : System.Web.UI.Page
    {
        private string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;
        private int userId
        {
            get
            {
                if (Session["EMP_NO"] == null)
                {
                    Response.Redirect("~/Loginpage.aspx", true); // true ends response
                    return -1; // Required, but will never be hit
                }
                return Convert.ToInt32(Session["EMP_NO"]);
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAvailableQuizzes();
            }
        }

        private void LoadAvailableQuizzes()
        {
            DataTable dt = new DataTable();

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = @"
                    SELECT qr.QUIZ_ID, qr.QUIZ_TITLE, qr.QUIZ_START_TIME, qr.QUIZ_END_TIME, qr.QUIZ_DURATION, qr.DEPARTMENT
                    FROM QUIZ_REQUEST qr
                    WHERE qr.QUIZ_STATUS = 'Approved'
                      AND NOW() BETWEEN qr.QUIZ_START_TIME AND qr.QUIZ_END_TIME
                      AND NOT EXISTS (
                          SELECT 1 FROM QUIZ_ANSWER ans 
                          WHERE ans.QUIZ_ID = qr.QUIZ_ID AND ans.USER_ID = @UserId
                      )
                    ORDER BY qr.QUIZ_END_TIME DESC";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            if (dt.Rows.Count > 0)
            {
                quizRepeater.DataSource = dt;
                quizRepeater.DataBind();
            }
            else
            {
                litMessage.Text = "<div class='alert alert-info'>No active quizzes available to attempt right now.</div>";
            }
        }

        protected void quizRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "StartQuiz")
            {
                string quizId = e.CommandArgument.ToString();
                Response.Redirect($"~/user_quizpage.aspx?quizId={quizId}", false);
            }
        }
    }
}
