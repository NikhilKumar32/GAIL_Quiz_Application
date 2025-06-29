using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class admin_dashboard : System.Web.UI.Page
    {
        private string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Session check
            if (Session["EMP_NO"] == null)
            {
                Response.Redirect("~/Loginpage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindQuizRequests("All");
            }
        }

        private void BindQuizRequests(string filter)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = @"
                    SELECT q.QUIZ_ID, q.QUIZ_TITLE, q.QUIZ_DESCRIPTION, q.QUIZ_START_TIME, q.QUIZ_END_TIME, 
                           q.QUIZ_DATE, q.QUIZ_DURATION, q.QUIZ_STATUS, e.EMP_NAME, q.DATE_SUBMITTED, q.DEPARTMENT
                    FROM QUIZ_REQUEST q
                    INNER JOIN ERP_HR_DAT e ON q.REQUESTED_BY = e.EMP_NO
                ";

                if (filter == "Pending")
                    query += " WHERE q.QUIZ_STATUS = 'Pending' ";
                else if (filter == "Taken")
                    query += " WHERE q.QUIZ_STATUS IN ('Approved', 'Rejected') ";

                query += " ORDER BY q.DATE_SUBMITTED DESC";

                using (MySqlDataAdapter da = new MySqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvQuizRequests.DataSource = dt;
                    gvQuizRequests.DataBind();
                }
            }
        }

        protected void ddlActionFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindQuizRequests(ddlActionFilter.SelectedValue);
        }

        protected void gvQuizRequests_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Accept" || e.CommandName == "Reject")
            {
                // Validate session again for safety
                if (Session["EMP_NO"] == null)
                {
                    Response.Redirect("~/Loginpage.aspx");
                    return;
                }

                int quizId = Convert.ToInt32(e.CommandArgument);
                string newStatus = (e.CommandName == "Accept") ? "Approved" : "Rejected";
                int adminEmpNo = Convert.ToInt32(Session["EMP_NO"]);
                string adminComment = "";

                // Get the row
                GridViewRow row = ((Control)e.CommandSource).NamingContainer as GridViewRow;

                // Check rejection reason if rejecting
                if (row != null && newStatus == "Rejected")
                {
                    TextBox txtReason = row.FindControl("txtRejectReason") as TextBox;
                    if (txtReason != null)
                    {
                        adminComment = txtReason.Text.Trim();
                        if (string.IsNullOrWhiteSpace(adminComment))
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Rejection reason is required.');", true);
                            return;
                        }
                    }
                }

                // Update the request in the database
                try
                {
                    using (MySqlConnection conn = new MySqlConnection(connStr))
                    {
                        conn.Open();

                        string updateQuery = @"
                            UPDATE QUIZ_REQUEST 
                            SET QUIZ_STATUS = @Status,
                                ACTIONED_BY = @AdminEmpNo,
                                DATE_REVIEWED = NOW(),
                                ADMIN_COMMENTS = @Comment
                            WHERE QUIZ_ID = @QuizId";

                        using (MySqlCommand cmd = new MySqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@Status", newStatus);
                            cmd.Parameters.AddWithValue("@AdminEmpNo", adminEmpNo);
                            cmd.Parameters.AddWithValue("@QuizId", quizId);
                            cmd.Parameters.AddWithValue("@Comment", adminComment);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    BindQuizRequests(ddlActionFilter.SelectedValue); // Refresh
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "error", $"alert('Database error: {ex.Message}');", true);
                }
            }
        }
    }
}
