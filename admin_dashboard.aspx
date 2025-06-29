<%@ Page Title="" Language="C#" MasterPageFile="~/admin.master" AutoEventWireup="true" CodeBehind="admin_dashboard.aspx.cs" Inherits="GAIL_QUIZ1.admin_dashboard" %>

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

    <script type="text/javascript">
        function validateReject(button) {
            var row = button.closest("tr");
            var txt = row.querySelector("input[type='text']");
            if (txt && txt.value.trim() === "") {
                alert("Please enter a reason for rejection.");
                return false;
            }
            return true;
        }

        function toggleDescription(id) {
            var div = document.getElementById(id);
            div.classList.toggle("desc-expanded");
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="section-header">
        <h4 style="padding-top: 5px;">Quiz Requests</h4>

        <asp:DropDownList 
            ID="ddlActionFilter" 
            runat="server" 
            CssClass="filter-dropdown" 
            AutoPostBack="true" 
            OnSelectedIndexChanged="ddlActionFilter_SelectedIndexChanged">
            <asp:ListItem Text=" All Requests " Value="All" />
            <asp:ListItem Text="Action Pending" Value="Pending" />
            <asp:ListItem Text="Action Taken" Value="Taken" />
        </asp:DropDownList>
    </div>



    <div class="grid-container">
        <asp:GridView ID="gvQuizRequests" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped"
            OnRowCommand="gvQuizRequests_RowCommand" DataKeyNames="QUIZ_ID">
            <Columns>
                <asp:TemplateField HeaderText="S.No">
                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="QUIZ_TITLE" HeaderText="Title" />
                <asp:TemplateField HeaderText="Quiz Description" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <div 
                            id='desc_<%# Eval("QUIZ_ID") %>' 
                            class="desc-ellipsis" 
                            onclick="toggleDescription('desc_<%# Eval("QUIZ_ID") %>')"
                            title="Click to expand/collapse">
                            <%# Eval("QUIZ_DESCRIPTION") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="QUIZ_START_TIME" HeaderText="Start Time" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                <asp:BoundField DataField="QUIZ_END_TIME" HeaderText="End Time" DataFormatString="{0:dd MMM yyyy HH:mm}" />
                <asp:BoundField DataField="QUIZ_DURATION" HeaderText="Duration (min)" />
                <asp:BoundField DataField="DEPARTMENT" HeaderText="Department" />
                <asp:BoundField DataField="DATE_SUBMITTED" HeaderText="Request Date" DataFormatString="{0:dd MMM yyyy }" />
                
                <asp:BoundField DataField="EMP_NAME" HeaderText="Requested By" />
                
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" 
                            Text='<%# Eval("QUIZ_STATUS") %>' 
                            CssClass='<%# "status-label " + (Eval("QUIZ_STATUS").ToString() == "Approved" ? "status-approved" : Eval("QUIZ_STATUS").ToString() == "Rejected" ? "status-rejected" : "") %>'>
                        </asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:TextBox ID="txtRejectReason" runat="server" CssClass="form-control reject-reason"
                            Placeholder="Enter reason..." 
                            Visible='<%# Eval("QUIZ_STATUS").ToString() == "Pending" %>' />
                        <asp:Button ID="btnAccept" runat="server" Text="Accept" CommandName="Accept" 
                            CommandArgument='<%# Eval("QUIZ_ID") %>' 
                            CssClass="btn btn-success btn-sm" 
                            Visible='<%# Eval("QUIZ_STATUS").ToString() == "Pending" %>' />
                        <asp:Button ID="btnReject" runat="server" Text="Reject" CommandName="Reject" 
                            OnClientClick="return validateReject(this);"
                            CommandArgument='<%# Eval("QUIZ_ID") %>' 
                            CssClass="btn btn-danger btn-sm" 
                            Visible='<%# Eval("QUIZ_STATUS").ToString() == "Pending" %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
