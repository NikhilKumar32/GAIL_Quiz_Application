using System;
using System.Data;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class admin_activequiz : System.Web.UI.Page
    {
        private string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadActiveQuizzes();
            }
        }

        private void LoadActiveQuizzes()
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        q.QUIZ_ID,
                        q.QUIZ_TITLE,
                        q.QUIZ_START_TIME,
                        q.QUIZ_END_TIME,
                        q.QUIZ_DURATION,
                        e.EMP_NAME
                    FROM QUIZ_REQUEST q
                    INNER JOIN ERP_HR_DAT e ON q.REQUESTED_BY = e.EMP_NO
                    WHERE q.QUIZ_STATUS = 'Approved'
                      AND NOW() BETWEEN q.QUIZ_START_TIME AND q.QUIZ_END_TIME
                    ORDER BY q.QUIZ_START_TIME ASC";

                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Add serial numbers
                dt.Columns.Add("SerialNo", typeof(int));
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i]["SerialNo"] = i + 1;
                }

                gvActiveQuizzes.DataSource = dt;
                gvActiveQuizzes.DataBind();
            }
        }
    }
}
