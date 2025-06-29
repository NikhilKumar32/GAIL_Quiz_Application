using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Configuration;

namespace GAIL_QUIZ1
{
    public partial class quizadmin_dashboard : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuizRequests();
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQuizRequests();
        }

        private void LoadQuizRequests()
        {
            if (Session["EMP_NO"] == null)
            {
                Response.Redirect("~/Loginpage.aspx");
                return;
            }

            int requestedBy = Convert.ToInt32(Session["EMP_NO"]);
            string selectedStatus = ddlStatusFilter.SelectedValue;
            var quizRequests = new List<QuizRequest>();

            try
            {
                using (var conn = new MySqlConnection(connStr))
                {
                    conn.Open();

                    string query = @"
                        SELECT 
                            q.QUIZ_ID, q.QUIZ_TITLE, q.QUIZ_DESCRIPTION, q.QUIZ_STATUS, q.ADMIN_COMMENTS,
                            q.QUIZ_START_TIME, q.QUIZ_END_TIME, q.QUIZ_DURATION,
                            q.DATE_SUBMITTED, q.DATE_REVIEWED,
                            (SELECT COUNT(*) FROM QUIZ_QUESTIONS qq WHERE qq.QUIZ_ID = q.QUIZ_ID) AS QuestionCount,
                            e.EMP_NAME AS ReviewedBy
                        FROM quiz_request q
                        LEFT JOIN ERP_HR_DAT e ON q.ACTIONED_BY = e.EMP_NO
                        WHERE q.REQUESTED_BY = @RequestedBy";

                    if (!string.IsNullOrEmpty(selectedStatus))
                    {
                        query += " AND q.QUIZ_STATUS = @Status";
                    }

                    query += " ORDER BY q.DATE_SUBMITTED DESC";

                    using (var cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@RequestedBy", requestedBy);

                        if (!string.IsNullOrEmpty(selectedStatus))
                        {
                            cmd.Parameters.AddWithValue("@Status", selectedStatus);
                        }

                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                quizRequests.Add(new QuizRequest
                                {
                                    Id = Convert.ToInt32(reader["QUIZ_ID"]),
                                    Title = reader["QUIZ_TITLE"].ToString(),
                                    Description = reader["QUIZ_DESCRIPTION"] as string ?? "",
                                    Status = reader["QUIZ_STATUS"].ToString(),
                                    Reason = reader["ADMIN_COMMENTS"] as string ?? "",
                                    StartTime = reader["QUIZ_START_TIME"] as DateTime?,
                                    EndTime = reader["QUIZ_END_TIME"] as DateTime?,
                                    Duration = reader["QUIZ_DURATION"] != DBNull.Value ? Convert.ToInt32(reader["QUIZ_DURATION"]) : 0,
                                    SubmittedOn = reader["DATE_SUBMITTED"] as DateTime?,
                                    ReviewedOn = reader["DATE_REVIEWED"] as DateTime?,
                                    QuestionCount = Convert.ToInt32(reader["QuestionCount"]),
                                    ReviewedBy = reader["ReviewedBy"] as string ?? ""
                                });
                            }
                        }
                    }
                }

                gvRequests.DataSource = quizRequests;
                gvRequests.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write($"<div style='color:red;'>Error: {ex.Message}</div>");
            }
        }

        protected void gvRequests_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument.ToString(), out int requestId)) return;

            switch (e.CommandName)
            {
                case "Proceed":
                    Response.Redirect($"~/quizadmin_createquiz.aspx?requestId={requestId}");
                    break;
                case "Edit":
                    Response.Redirect($"~/quizadmin_request.aspx?editRequestId={requestId}");
                    break;
            }
        }

        public class QuizRequest
        {
            public int Id { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public string Status { get; set; }
            public string Reason { get; set; }
            public DateTime? StartTime { get; set; }
            public DateTime? EndTime { get; set; }
            public int Duration { get; set; }
            public DateTime? SubmittedOn { get; set; }
            public DateTime? ReviewedOn { get; set; }
            public int QuestionCount { get; set; }
            public string ReviewedBy { get; set; }
        }
    }
}
