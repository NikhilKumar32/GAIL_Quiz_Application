using System;
using System.Web.UI;
using MySql.Data.MySqlClient;
using System.Configuration;

namespace GAIL_QUIZ1
{
    public partial class Loginpage : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string empNoText = txtEmpNo.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role = ddlRole.SelectedValue;

            if (string.IsNullOrEmpty(empNoText) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(role))
            {
                lblMessage.Text = "All fields are required.";
                return;
            }

            if (!int.TryParse(empNoText, out int empNo))
            {
                lblMessage.Text = "Employee Number must be numeric.";
                return;
            }

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT EMP_NAME FROM erp_hr_dat WHERE EMP_NO = @EmpNo AND PASSWORD = @Password";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmpNo", empNo);
                    cmd.Parameters.AddWithValue("@Password", password);

                    object empNameResult = cmd.ExecuteScalar();

                    if (empNameResult != null)
                    {
                        // Store only EMP_NO and EMP_NAME
                        Session["EMP_NO"] = empNo;
                        Session["EMP_NAME"] = empNameResult.ToString();

                        // Redirect based on selected role (but not stored)
                        if (role == "admin")
                            Response.Redirect("~/admin_dashboard.aspx");
                        else if (role == "quizadmin")
                            Response.Redirect("~/quizadmin_dashboard.aspx");
                        else if (role == "user")
                            Response.Redirect("~/user_dashboard.aspx");
                        else
                            lblMessage.Text = "Invalid role selected.";
                    }
                    else
                    {
                        lblMessage.Text = "Invalid Employee Number or Password.";
                    }
                }
            }
        }
    }
}
