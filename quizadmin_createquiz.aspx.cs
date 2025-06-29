using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML.Excel;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class quizadmin_createquiz : Page
    {
        // Serializable question model to store question info
        [Serializable]
        public class QuestionModel
        {
            public string QuestionText { get; set; }
            public string Option1 { get; set; }
            public string Option2 { get; set; }
            public string Option3 { get; set; }
            public string Option4 { get; set; }
            public string CorrectOption { get; set; }
        }

        // Use ViewState to keep questions across postbacks
        private List<QuestionModel> Questions
        {
            get => ViewState["Questions"] as List<QuestionModel> ?? new List<QuestionModel>();
            set => ViewState["Questions"] = value;
        }

        // Request ID from query string, cached in ViewState
        private int RequestId
        {
            get
            {
                if (ViewState["RequestId"] != null)
                    return (int)ViewState["RequestId"];

                int id = 0;
                int.TryParse(Request.QueryString["requestId"], out id);
                ViewState["RequestId"] = id;
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {   
                if (RequestId <= 0)
                {
                    Response.Write("❌ Invalid or missing Request ID.");
                    Response.End();
                    return;
                }

                Questions = new List<QuestionModel>();
                hiddenRequestId.Value = RequestId.ToString();
                BindQuestionsRepeater();
            }
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string question = txtQuestion.Text.Trim();
            string opt1 = txtOption1.Text.Trim();
            string opt2 = txtOption2.Text.Trim();
            string opt3 = txtOption3.Text.Trim();
            string opt4 = txtOption4.Text.Trim();

            if (string.IsNullOrEmpty(question) ||
                string.IsNullOrEmpty(opt1) ||
                string.IsNullOrEmpty(opt2) ||
                string.IsNullOrEmpty(opt3) ||
                string.IsNullOrEmpty(opt4))
            {
                Response.Write("<script>alert('Please fill in all question fields.');</script>");
                return;
            }

            var options = new[] { opt1, opt2, opt3, opt4 };
            var distinctOptions = new HashSet<string>(options, StringComparer.OrdinalIgnoreCase);
            if (distinctOptions.Count < options.Length)
            {
                Response.Write("<script>alert('All options must be different. Please ensure no two options are the same.');</script>");
                return;
            }

            // Determine which radio button is checked
            string correct = null;
            if (rbtnOption1.Checked) correct = "1";
            else if (rbtnOption2.Checked) correct = "2";
            else if (rbtnOption3.Checked) correct = "3";
            else if (rbtnOption4.Checked) correct = "4";

            if (string.IsNullOrEmpty(correct))
            {
                Response.Write("<script>alert('Please select the correct option.');</script>");
                return;
            }

            // Create new question object
            var newQuestion = new QuestionModel
            {
                QuestionText = question,
                Option1 = opt1,
                Option2 = opt2,
                Option3 = opt3,
                Option4 = opt4,
                CorrectOption = correct
            };

            // Get current list, add new, save back to ViewState
            var qList = Questions;
            qList.Add(newQuestion);
            Questions = qList;

            // Rebind Repeater
            BindQuestionsRepeater();

            // Clear inputs for next question
            txtQuestion.Text = "";
            txtOption1.Text = "";
            txtOption2.Text = "";
            txtOption3.Text = "";
            txtOption4.Text = "";
            rbtnOption1.Checked = false;
            rbtnOption2.Checked = false;
            rbtnOption3.Checked = false;
            rbtnOption4.Checked = false;
        }



        private void BindQuestionsRepeater()
        {
            var qList = Questions;
            rptQuestions.DataSource = qList;
            rptQuestions.DataBind();
        }

        protected void btnConfirmSubmit_Click(object sender, EventArgs e)
        {
            if (RequestId <= 0)
            {
                Response.Write("❌ No valid request ID.");
                return;
            }

            var qList = Questions;
            if (qList.Count == 0)
            {
                Response.Write("⚠️ No questions to submit.");
                return;
            }

            int randomCount = 0;
            bool hasRandom = int.TryParse(txtRandomCount.Text.Trim(), out randomCount);

            if (hasRandom && (randomCount <= 0 || randomCount > qList.Count))
            {
                Response.Write($"<script>alert('❌ Random question count must be between 1 and {qList.Count}.');</script>");
                return;
            }

            try
            {
                List<QuestionModel> questionsToSave = qList;

                SaveQuestionsToDatabase(questionsToSave);
                if (hasRandom)
                {
                    UpdateRandomCountInQuizRequest(RequestId, randomCount);
                }

                Questions = new List<QuestionModel>(); // Clear after save
                Response.Redirect("~/quizadmin_dashboard.aspx");
            }
            catch (Exception ex)
            {
                Response.Write($"❌ Error saving questions: {ex.Message}");
            }
        }

        private void UpdateRandomCountInQuizRequest(int quizId, int randomCount)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            using (var conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE QUIZ_REQUEST SET NUM_RANDOM_QUESTIONS = @Count WHERE QUIZ_ID = @QuizId";
                using (var cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    cmd.Parameters.AddWithValue("@Count", randomCount);
                    cmd.ExecuteNonQuery();
                }
            }
        }


        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteQuestion")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                var qList = Questions;

                if (index >= 0 && index < qList.Count)
                {
                    qList.RemoveAt(index);
                    Questions = qList;
                    BindQuestionsRepeater();
                }
            }
        }


        private void SaveQuestionsToDatabase(List<QuestionModel> questions)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            using (var conn = new MySqlConnection(connStr))
            {
                conn.Open();

                foreach (var q in questions)
                {
                    string query = @"
                INSERT INTO QUIZ_QUESTIONS
                (QUIZ_ID, QUESTION, OPTION_A, OPTION_B, OPTION_C, OPTION_D, CORRECT_OPTION)
                VALUES
                (@QuizId, @Question, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectOption)";

                    using (var cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", RequestId);
                        cmd.Parameters.AddWithValue("@Question", q.QuestionText);
                        cmd.Parameters.AddWithValue("@OptionA", q.Option1);
                        cmd.Parameters.AddWithValue("@OptionB", q.Option2);
                        cmd.Parameters.AddWithValue("@OptionC", q.Option3);
                        cmd.Parameters.AddWithValue("@OptionD", q.Option4);

                        string correctOptionChar;
                        switch (q.CorrectOption)
                        {
                            case "1":
                                correctOptionChar = "A";
                                break;
                            case "2":
                                correctOptionChar = "B";
                                break;
                            case "3":
                                correctOptionChar = "C";
                                break;
                            case "4":
                                correctOptionChar = "D";
                                break;
                            default:
                                throw new Exception("Invalid correct option index");
                        }

                        cmd.Parameters.AddWithValue("@CorrectOption", correctOptionChar);

                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        protected void btnClearAll_Click(object sender, EventArgs e)
        {
            Questions = new List<QuestionModel>(); // Clear ViewState list
            BindQuestionsRepeater();               // Refresh repeater
            Response.Write("<script>alert('All questions have been cleared.');</script>");
        }


        protected void btnUploadExcel_Click(object sender, EventArgs e)
        {
            if (!fileExcelUpload.HasFile)
            {
                Response.Write("<script>alert('Please select a valid Excel file to upload.');</script>");
                return;
            }

            if (!fileExcelUpload.FileName.EndsWith(".xlsx", StringComparison.OrdinalIgnoreCase))
            {
                Response.Write("<script>alert('Only .xlsx files are supported.');</script>");
                return;
            }

            int successCount = 0;
            int skippedCount = 0;
            var qList = new List<QuestionModel>(Questions); // Retain previously added questions

            try
            {
                using (var workbook = new XLWorkbook(fileExcelUpload.PostedFile.InputStream))
                {
                    var worksheet = workbook.Worksheet(1); // First worksheet
                    var rows = worksheet.RangeUsed().RowsUsed().Skip(1); // Skip header row

                    foreach (var row in rows)
                    {
                        string questionText = row.Cell(2).GetString().Trim();
                        string option1 = row.Cell(3).GetString().Trim();
                        string option2 = row.Cell(4).GetString().Trim();
                        string option3 = row.Cell(5).GetString().Trim();
                        string option4 = row.Cell(6).GetString().Trim();
                        string correctOptionRaw = row.Cell(7).GetString().Trim().ToUpper();

                        // Basic validation
                        if (string.IsNullOrWhiteSpace(questionText) ||
                            string.IsNullOrWhiteSpace(option1) ||
                            string.IsNullOrWhiteSpace(option2) ||
                            string.IsNullOrWhiteSpace(option3) ||
                            string.IsNullOrWhiteSpace(option4) ||
                            string.IsNullOrWhiteSpace(correctOptionRaw))
                        {
                            skippedCount++;
                            continue;
                        }

                        // Ensure options are unique
                        var options = new[] { option1, option2, option3, option4 };
                        if (new HashSet<string>(options, StringComparer.OrdinalIgnoreCase).Count < 4)
                        {
                            skippedCount++;
                            continue;
                        }

                        // Normalize correct option (1-4 or A-D)
                        string correctOption = null;
                        switch (correctOptionRaw)
                        {
                            case "A": correctOption = "1"; break;
                            case "B": correctOption = "2"; break;
                            case "C": correctOption = "3"; break;
                            case "D": correctOption = "4"; break;
                            case "1":
                            case "2":
                            case "3":
                            case "4":
                                correctOption = correctOptionRaw;
                                break;
                            default:
                                skippedCount++;
                                continue;
                        }

                        qList.Add(new QuestionModel
                        {
                            QuestionText = questionText,
                            Option1 = option1,
                            Option2 = option2,
                            Option3 = option3,
                            Option4 = option4,
                            CorrectOption = correctOption
                        });

                        successCount++;
                    }

                    Questions = qList;
                    BindQuestionsRepeater();

                    string message = $"✅ Uploaded {successCount} question(s).";
                    if (skippedCount > 0)
                        message += $" ⚠️ Skipped {skippedCount} row(s) due to invalid or duplicate data.";

                    Response.Write($"<script>alert('{message}');</script>");
                }
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error reading Excel file: {ex.Message}');</script>");
            }
        }



    }
}
