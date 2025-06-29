<%@ Page Title="" Language="C#" MasterPageFile="~/quizadmin.master" AutoEventWireup="true" CodeBehind="quizadmin_request.aspx.cs" Inherits="GAIL_QUIZ1.quizadmin_request" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="quizadmin_request.css" rel="stylesheet" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <script type="text/javascript">
        function toggleCityTextbox() {
            var rbl = document.getElementById('<%= rblLocationType.ClientID %>');
            var groupDiv = document.getElementById('<%= txtCitiesGroup.ClientID %>');
            var selected = rbl.querySelector('input:checked');

            if (selected && selected.value === "Citywise") {
                groupDiv.style.display = "flex";
            } else {
                groupDiv.style.display = "none";
            }
        }



        window.onload = function () {
            toggleCityTextbox();
        };
    </script>

    <div class="request-card">
        <h2 class="card-header">Send New Quiz Request</h2>

        <div class="form-grid">
            <div class="form-group">
                <label for="txtQuizTitle">Quiz Title</label>
                <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="input-text" MaxLength="100"/>
            </div>

            <div class="form-group">
                <label for="txtDepartment">Department</label>
                <asp:TextBox ID="txtDepartment" runat="server" CssClass="input-text" MaxLength="50"/>
            </div>

            <div class="form-group" style="grid-column: span 2;">
                <label for="txtQuizDescription">Quiz Description</label>
                <asp:TextBox ID="txtQuizDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="input-text" MaxLength="200"/>
            </div>

            <!-- Location full width -->
            <div class="form-group" style="grid-column: span 2;">
                <label>Location</label>
                <asp:RadioButtonList ID="rblLocationType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rblLocationType_SelectedIndexChanged">
                    <asp:ListItem Value="Global" Selected="True">Global</asp:ListItem>
                    <asp:ListItem Value="Citywise">Citywise</asp:ListItem>
                </asp:RadioButtonList>

            </div>

            <asp:Panel ID="txtCitiesGroup" runat="server" CssClass="form-group">
                <label for="ddlCities">Cities (if City-wise)</label>
                <asp:DropDownList ID="ddlCities" runat="server" CssClass="input-text" />
            </asp:Panel>


            <div class="form-group">
                <label for="txtStartDateTime">Start Time</label>
                <asp:TextBox ID="txtStartDateTime" runat="server" TextMode="DateTimeLocal" CssClass="input-text" />
            </div>

            <div class="form-group">
                <label for="txtEndDateTime">End Time</label>
                <asp:TextBox ID="txtEndDateTime" runat="server" TextMode="DateTimeLocal" CssClass="input-text" />
            </div>

            <div class="form-group">
                <label for="ddlHours">Duration Hours</label>
                <asp:DropDownList ID="ddlHours" runat="server" CssClass="input-text" />
            </div>

            <div class="form-group">
                <label for="ddlMinutes">Duration Minutes</label>
                <asp:DropDownList ID="ddlMinutes" runat="server" CssClass="input-text" />
            </div>

            <div class="button-group">
                <asp:Button ID="btnSendRequest" runat="server" CssClass="reqbtn" Text="Send Request" OnClick="btnSendRequest_Click" />
            </div>
        </div>
    </div>
</asp:Content>

