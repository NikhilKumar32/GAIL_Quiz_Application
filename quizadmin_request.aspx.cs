using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace GAIL_QUIZ1
{
    public partial class quizadmin_request : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateDurationDropdowns();
            }
        }

        private void LoadDistinctCities()
        {
            ddlCities.Items.Clear(); // Clear previous items

            try
            {
                using (MySqlConnection conn = new MySqlConnection(
                    System.Configuration.ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString))
                {
                    conn.Open();

                    string query = "SELECT DISTINCT LOCATION FROM ERP_HR_DAT WHERE LOCATION IS NOT NULL AND LOCATION <> '' ORDER BY LOCATION";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string location = reader["LOCATION"].ToString();
                            ddlCities.Items.Add(new ListItem(location));
                        }
                    }
                }

                ddlCities.Items.Insert(0, new ListItem("-- Select City --", "")); // Optional default item
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading cities: " + ex.Message);
            }
        }


        protected void rblLocationType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblLocationType.SelectedValue == "Citywise")
            {
                LoadDistinctCities();
                ddlCities.Visible = true;
            }
            else
            {
                ddlCities.Items.Clear();
                ddlCities.Visible = false;
            }
        }


        private void PopulateDurationDropdowns()
        {
            ddlHours.Items.Clear();
            for (int i = 0; i < 24; i++)
                ddlHours.Items.Add(new ListItem(i.ToString("D2"), i.ToString()));

            ddlMinutes.Items.Clear();
            for (int i = 0; i < 60; i += 5)
                ddlMinutes.Items.Add(new ListItem(i.ToString("D2"), i.ToString()));
        }

        protected void btnSendRequest_Click(object sender, EventArgs e)
        {
            // Step 1: Trim and collect input values
            string quizTitle = txtQuizTitle.Text.Trim();
            string quizDescription = txtQuizDescription.Text.Trim();
            string department = txtDepartment.Text.Trim();
            string locationType = rblLocationType.SelectedValue;
            string selectedCity = ddlCities.SelectedValue.Trim();

            // Step 2: Validate basic input
            if (string.IsNullOrEmpty(quizTitle) || string.IsNullOrEmpty(department))
            {
                ShowAlert("Please enter both Quiz Title and Department.");
                return;
            }

            if (locationType == "Citywise" && string.IsNullOrEmpty(selectedCity))
            {
                ShowAlert("Please select a city for City-wise location.");
                return;
            }

            // Step 3: Validate and parse date/time
            if (!DateTime.TryParse(txtStartDateTime.Text, out DateTime startTime))
            {
                ShowAlert("Please enter a valid 'Active From' datetime.");
                return;
            }

            if (!DateTime.TryParse(txtEndDateTime.Text, out DateTime endTime))
            {
                ShowAlert("Please enter a valid 'Active Until' datetime.");
                return;
            }

            if (endTime <= startTime)
            {
                ShowAlert("'Active Until' must be after 'Active From'.");
                return;
            }

            DateTime now = DateTime.Now;

            if (startTime <= now)
            {
                ShowAlert("Quiz start time must be in the future.");
                return;
            }

            if (endTime <= now)
            {
                ShowAlert("Quiz end time must be in the future.");
                return;
            }

            if ((startTime - now).TotalHours < 48)
            {
                ShowAlert("Quiz request must be made at least 48 hours before the start time.");
                return;
            }

            // Step 4: Validate quiz duration
            int hours = int.Parse(ddlHours.SelectedValue);
            int minutes = int.Parse(ddlMinutes.SelectedValue);
            int totalDurationMinutes = (hours * 60) + minutes;

            int availableWindowMinutes = (int)(endTime - startTime).TotalMinutes;
            if (totalDurationMinutes <= 0)
            {
                ShowAlert("Quiz duration must be greater than 0.");
                return;
            }

            if (totalDurationMinutes > availableWindowMinutes)
            {
                ShowAlert($"Quiz duration ({totalDurationMinutes} min) exceeds available window ({availableWindowMinutes} min).");
                return;
            }

            // Step 5: Insert into database
            int requestedBy = GetCurrentUserId();

            try
            {
                using (MySqlConnection conn = new MySqlConnection(
                    System.Configuration.ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString))
                {
                    conn.Open();

                    string query = @"
                INSERT INTO QUIZ_REQUEST 
                (QUIZ_TITLE, QUIZ_DESCRIPTION, QUIZ_START_TIME, QUIZ_END_TIME, QUIZ_DATE, QUIZ_DURATION, QUIZ_STATUS, REQUESTED_BY, DATE_SUBMITTED, DEPARTMENT)
                VALUES
                (@title, @desc, @startTime, @endTime, @quizDate, @duration, 'Pending', @requestedBy, NOW(), @department)
            ";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@title", quizTitle);
                        cmd.Parameters.AddWithValue("@desc", quizDescription);
                        cmd.Parameters.AddWithValue("@startTime", startTime);
                        cmd.Parameters.AddWithValue("@endTime", endTime);
                        cmd.Parameters.AddWithValue("@quizDate", startTime.Date);
                        cmd.Parameters.AddWithValue("@duration", totalDurationMinutes);
                        cmd.Parameters.AddWithValue("@requestedBy", requestedBy);
                        cmd.Parameters.AddWithValue("@department", department);

                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Quiz request submitted successfully!");
                ClearForm();
            }
            catch (Exception ex)
            {
                ShowAlert($"Error submitting request: {ex.Message}");
            }
        }


        private void ShowAlert(string message)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{message}');", true);
        }

        private void ClearForm()
        {
            txtQuizTitle.Text = "";
            txtDepartment.Text = "";
            txtQuizDescription.Text = "";
            ddlCities.SelectedIndex = 0;


            txtStartDateTime.Text = "";
            txtEndDateTime.Text = "";

            ddlHours.SelectedIndex = 0;
            ddlMinutes.SelectedIndex = 0;

            rblLocationType.ClearSelection(); // Clear selection
            rblLocationType.SelectedIndex = 0; // Set to default (Global)

            // Register a client script to hide the city textbox again
            ScriptManager.RegisterStartupScript(this, this.GetType(), "toggleCity", "toggleCityTextbox();", true);
        }


        private int GetCurrentUserId()
        {
            return Convert.ToInt32(Session["EMP_NO"]); // assuming EmpNo is stored in session after login
        }
    }
}
