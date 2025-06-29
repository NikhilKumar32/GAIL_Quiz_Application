# GAIL_Quiz_Application
GAIL Quiz Application

A web-based quiz management system built using ASP.NET Web Forms and MySQL, developed for Gas Authority of India Limited (GAIL). This application provides functionalities for administrators to create and manage quizzes and for users to take quizzes and view their quiz status.

Table of Contents

Features

Technology Stack

Project Structure

Prerequisites

Installation

Configuration

Usage

Contributing

License

Features

Quiz Administration: Create, edit, and delete quizzes and questions via quizadmin.createquiz.aspx and its code-behind.

User Dashboard: Displays quizzes segmented into:

Active Quizzes: Ongoing quizzes with live icons, names, date, and time.

Completed Quizzes: Quizzes taken by the user, showing quiz name and score.

Missed Quizzes: Quizzes where the deadline has passed, showing quiz name with a deadline warning.

Role-Based Access: Admin and user roles managed to ensure proper access control.

MySQL Integration: All quiz data stored and retrieved from a MySQL database.

Responsive UI: Built with ASP.NET Web Forms for a consistent look and feel using shared header and navigation.

Technology Stack

Front-end: ASP.NET Web Forms (.aspx, .aspx.cs)

Back-end: C# (.NET Framework)

Database: MySQL

IDE: Visual Studio

Project Structure

/GailQuizApp
  ├─ /quizadmin
  │    ├─ createquiz.aspx
  │    └─ createquiz.aspx.cs
  ├─ /user
  │    └─ dashboard.aspx
  ├─ /shared
  │    ├─ header.ascx
  │    └─ navbar.ascx
  ├─ /App_Data
  │    └─ GailQuizDb.mdf
  ├─ /bin
  ├─ Web.config
  └─ README.md

Prerequisites

.NET Framework 4.x

Visual Studio

MySQL Server

MySQL Connector/NET

Installation

Clone the repository:

git clone https://github.com/YourUsername/GailQuizApp.git

Open the solution in Visual Studio (GailQuizApp.sln).

Restore NuGet packages if prompted.

Build the solution to ensure all dependencies are resolved.

Configuration

Update the connection string in Web.config:

<connectionStrings>
  <add name="GailQuizDb" connectionString="server=YOUR_HOST; user=YOUR_USER; password=YOUR_PASSWORD; database=GailQuizDb;" providerName="MySql.Data.MySqlClient" />
</connectionStrings>

Ensure your MySQL server is running and the GailQuizDb database is created. You can execute the provided SQL script App_Data/GailQuizDb.sql to set up tables.

Usage

Admin:

Navigate to quizadmin/createquiz.aspx.

Fill in quiz details (title, description, date, time).

Add questions and options.

Save to publish the quiz.

User:

Log in and navigate to user/dashboard.aspx.

View Active, Completed, and Missed quizzes in their respective sections.

Click on an active quiz to start taking it.

Contributing

Contributions are welcome! Please follow these steps:

Fork the repository.

Create a new branch: git checkout -b feature/YourFeature.

Commit your changes: git commit -m "Add new feature".

Push to the branch: git push origin feature/YourFeature.

Open a pull request.

License

This project is licensed under the MIT License. See the LICENSE file for details.

Developed by Nikhil Kumar
