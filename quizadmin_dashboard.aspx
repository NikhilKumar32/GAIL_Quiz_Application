<%@ Page Title="" Language="C#" MasterPageFile="~/quizadmin.master" AutoEventWireup="true" CodeBehind="quizadmin_dashboard.aspx.cs" Inherits="GAIL_QUIZ1.quizadmin_dashboard" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
    /* === BASE LAYOUT === */
    body {
        background: linear-gradient(to right, #eef1f5, #f5f7fa);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #2c3e50;
        margin: 0;
        padding: 0px;
    }

    h4 {
        font-size: 30px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 10px;
        letter-spacing: 0.5px;
        animation: fadeIn 1s ease-out;
    }

    /* === FILTER DROPDOWN === */
    .filter-dropdown {
        width: 230px;
        padding: 10px 14px;
        font-size: 15px;
        border: 1px solid #ced4da;
        border-radius: 10px;
        background: #ffffff;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
        margin-bottom: 10px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
    }

        .filter-dropdown:focus {
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
            outline: none;
        }

    /* === GRID CONTAINER === */
    .grid-container {
        background: #ffffff;
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
        animation: slideFade 0.8s ease;
        overflow-x: auto;
    }

    /* === TABLE STYLING === */
    .table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0 10px;
        margin-top: 10px;
    }

        .table th {
            background-color: #f1f3f9;
            color: #2c3e50;
            text-align: left;
            padding: 14px 16px;
            font-size: 15px;
            border-bottom: 2px solid #dee2e6;
        }

        .table td {
            background-color: #fff;
            padding: 14px 16px;
            font-size: 14px;
            border-bottom: 1px solid #f0f2f5;
            transition: all 0.2s ease;
        }

        .table tr {
            transition: all 0.3s ease;
            border-radius: 12px;
        }

            .table tr:hover td {
                background-color: #f8fbfe;
                transform: scale(1.005);
                box-shadow: 0 2px 8px rgba(52, 152, 219, 0.08);
            }

    /* === DESCRIPTION === */
    .desc-ellipsis {
        display: block;
        max-width: 140px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        cursor: pointer;
        color: #3498db;
        font-style: italic;
        transition: color 0.3s ease;
    }

        .desc-ellipsis:hover {
            color: #21618c;
        }

    .desc-expanded {
        white-space: normal !important;
        overflow: visible !important;
        background-color: #eef3f8;
        border: 1px solid #d1d9e6;
        padding: 8px 12px;
        border-radius: 8px;
        max-width: 420px;
        word-wrap: break-word;
    }

    /* === BUTTONS === */
    .btn {
        padding: 8px 18px;
        font-size: 14px;
        font-weight: 600;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.25s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.08);
    }

    .btn-sm {
        padding: 7px 14px;
    }

    .btn-success {
        background: linear-gradient(135deg, #28a745, #218838);
        color: #fff;
    }

        .btn-success:hover {
            background: linear-gradient(135deg, #218838, #1e7e34);
            transform: scale(1.03);
        }

    .btn-danger {
        background: linear-gradient(135deg, #dc3545, #c82333);
        color: #fff;
    }

        .btn-danger:hover {
            background: linear-gradient(135deg, #c82333, #bd2130);
            transform: scale(1.03);
        }

    /* === REJECT TEXTBOX === */
    .reject-reason {
        margin-bottom: 8px;
        width: 100%;
        padding: 9px 12px;
        border-radius: 6px;
        border: 1px solid #ced4da;
        font-size: 14px;
        background: #fdfdfd;
        transition: border 0.3s ease, box-shadow 0.3s ease;
    }

        .reject-reason:focus {
            border-color: #dc3545;
            box-shadow: 0 0 6px rgba(220, 53, 69, 0.3);
            outline: none;
        }

    /* === STATUS LABELS === */
    .status-label {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 13px;
        text-align: center;
        transition: transform 0.2s;
    }

        .status-label:hover {
            transform: scale(1.05);
        }

    .status-approved {
        background-color: #d4edda;
        color: #155724;
    }

    .status-rejected {
        background-color: #f8d7da;
        color: #721c24;
    }

    /* === ANIMATIONS === */
    @keyframes slideFade {
        from {
            opacity: 0;
            transform: translateY(25px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }

        to {
            opacity: 1;
        }
    }
    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 30px; /* horizontal padding */
        margin-bottom: 10px;
    }



</style>
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <script type="text/javascript">
        function toggleReason(id) {
            var div = document.getElementById(id);
            div.style.display = (div.style.display === "none" || div.style.display === "") ? "block" : "none";
        }

        function toggleDescription(id) {
            var div = document.getElementById(id);
            div.classList.toggle("desc-expanded");
        }
    </script>

    <div class="section-header">
    <h4 style="padding-top: 5px;">Your Quiz Requests Status</h4>

    <asp:DropDownList ID="ddlStatusFilter" runat="server"
        AutoPostBack="true"
        OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged"
        CssClass="filter-dropdown">
        <asp:ListItem Text=" All " Value=""></asp:ListItem>
        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
    </asp:DropDownList>
</div>
        <div class="grid-container">
        <asp:GridView ID="gvRequests" runat="server" AutoGenerateColumns="False" CssClass="table"

            OnRowCommand="gvRequests_RowCommand" EmptyDataText="No quiz requests found.">
            <Columns>
                <asp:TemplateField HeaderText="S.No" ItemStyle-Width="40px">
                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Title" HeaderText="Quiz Title" />

                <asp:TemplateField HeaderText="Quiz Description" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <div 
                            id='desc_<%# Eval("Id") %>' 
                            class="desc-ellipsis" 
                            onclick="toggleDescription('desc_<%# Eval("Id") %>')"
                            title="Click to expand/collapse">
                            <%# Eval("Description") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="StartTime" HeaderText="Start Time" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                <asp:BoundField DataField="EndTime" HeaderText="End Time" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                <asp:BoundField DataField="Duration" HeaderText="Duration (min)" />
                <asp:BoundField DataField="SubmittedOn" HeaderText="Submitted On" DataFormatString="{0:dd MMM yyyy}" />
                <asp:BoundField DataField="ReviewedOn" HeaderText="Reviewed On" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                <asp:BoundField DataField="ReviewedBy" HeaderText="Reviewed By" />
                <asp:BoundField DataField="Reason" HeaderText="Admin Comments" />

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnProceed" runat="server"
                            CommandName="Proceed"
                            CommandArgument='<%# Eval("Id") %>'
                            Text="Proceed to Create" CssClass="proceed-btn"
                            Visible='<%# Eval("Status").ToString() == "Approved" && Convert.ToInt32(Eval("QuestionCount")) == 0 %>' />

                        <asp:Label ID="lblQuizCreated" runat="server" Text="✅ Quiz Created"
                            ForeColor="Green"
                            Visible='<%# Eval("Status").ToString() == "Approved" && Convert.ToInt32(Eval("QuestionCount")) > 0 %>' />

                        <asp:LinkButton ID="btnToggle" runat="server"
                            OnClientClick='<%# $"toggleReason(\"reason_{Eval("Id")}\"); return false;" %>'
                            Visible='<%# Eval("Status").ToString() == "Rejected" && !string.IsNullOrEmpty(Eval("Reason").ToString()) %>'
                            CssClass="arrow-btn">View Reason</asp:LinkButton>

                        <div id='<%# "reason_" + Eval("Id") %>' class="decline-reason" style="display:none;">
                            Reason: <%# Eval("Reason") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>
        </div>
    
</asp:Content>
