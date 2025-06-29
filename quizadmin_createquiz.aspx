<%@ Page Title="" Language="C#" MasterPageFile="~/quizadmin.master" AutoEventWireup="true" CodeBehind="quizadmin_createquiz.aspx.cs" Inherits="GAIL_QUIZ1.quizadmin_createquiz" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <asp:HiddenField ID="hiddenRequestId" runat="server" />

    <div style="display: flex; justify-content: space-between; padding: 15px 40px 40px 40px; font-family: 'Segoe UI', sans-serif; background-color: #f9f9f9; height: calc(110vh - 80px); box-sizing: border-box;">
        <!-- Left Panel: Add Question -->
        <div style="width: 48%; background-color: #fff; padding: 15px 25px 25px 25px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); box-sizing: border-box;">

            <asp:Panel runat="server" style="margin-bottom: 12px;">
                <label style="display: block; margin-bottom: 6px;">Question:</label>
                <asp:TextBox ID="txtQuestion" runat="server" placeholder="Enter your question here..." 
                    TextMode="MultiLine" Rows="3"
                    style="width: 100%; padding: 10px; font-size: 15px; border: 1px solid #ccc; border-radius: 6px;" MaxLength="300" />
            </asp:Panel>

            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 6px;">Options:</label>

                <!-- Option 1 -->
                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                    <span style="width: 20px; font-weight: bold;">1.</span>
                    <asp:TextBox ID="txtOption1" runat="server" placeholder="Option 1"
                        style="flex: 1; padding: 10px; border-radius: 6px; border: 1px solid #ccc;" MaxLength="100" />
                    <asp:RadioButton ID="rbtnOption1" runat="server" GroupName="CorrectOption" CssClass="correctOptionRadio" style="margin-left: 15px;" />
                </div>

                <!-- Option 2 -->
                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                    <span style="width: 20px; font-weight: bold;">2.</span>
                    <asp:TextBox ID="txtOption2" runat="server" placeholder="Option 2"
                        style="flex: 1; padding: 10px; border-radius: 6px; border: 1px solid #ccc;" MaxLength="100"/>
                    <asp:RadioButton ID="rbtnOption2" runat="server" GroupName="CorrectOption" CssClass="correctOptionRadio" style="margin-left: 15px;" />
                </div>

                <!-- Option 3 -->
                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                    <span style="width: 20px; font-weight: bold;">3.</span>
                    <asp:TextBox ID="txtOption3" runat="server" placeholder="Option 3"
                        style="flex: 1; padding: 10px; border-radius: 6px; border: 1px solid #ccc;" MaxLength="100"/>
                    <asp:RadioButton ID="rbtnOption3" runat="server" GroupName="CorrectOption" CssClass="correctOptionRadio" style="margin-left: 15px;" />
                </div>

                <!-- Option 4 -->
                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                    <span style="width: 20px; font-weight: bold;">4.</span>
                    <asp:TextBox ID="txtOption4" runat="server" placeholder="Option 4"
                        style="flex: 1; padding: 10px; border-radius: 6px; border: 1px solid #ccc;" MaxLength="100"/>
                    <asp:RadioButton ID="rbtnOption4" runat="server" GroupName="CorrectOption" CssClass="correctOptionRadio" style="margin-left: 15px;" />
                </div>
            </div>

            <div style="display: flex; gap: 15px; margin-bottom: 20px;">
                <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" OnClick="btnAddQuestion_Click"
                    style="flex: 1; padding: 12px 20px; background-color: #007bff; color: white; font-weight: bold; border: none; border-radius: 6px; cursor:pointer;" />

                <!-- File Upload Control -->
                <asp:FileUpload ID="fileExcelUpload" runat="server" style="margin-bottom: 10px;" />

                <!-- Upload Button -->
                <asp:Button ID="btnUploadExcel" runat="server" Text="Upload using Excel" OnClick="btnUploadExcel_Click"
                    style="flex: 1; padding: 12px 20px; background-color: #28a745; color: white; font-weight: bold; border: none; border-radius: 6px; cursor:pointer;" />

            </div>

            <asp:HyperLink ID="lnkDownloadSample" runat="server" NavigateUrl="/sample format.xlsx"
                style="font-size: 14px; color: #007bff; text-decoration: none;">
                ⬇ Download Sample Excel Format
            </asp:HyperLink>

            <!-- Random Question Count Input -->
            <div style="margin-top: 15px;">
                <label for="txtRandomCount">Enter number of random questions (optional):</label>
                <asp:TextBox ID="txtRandomCount" runat="server"
                    placeholder="Leave empty to include all questions"
                    style="width: 50%; padding: 8px; border-radius: 5px; border: 1px solid #ccc;" />
            </div>

        </div>

        

        <!-- Right Panel: Questions Added -->
        <div style="width: 48%; background-color: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); box-sizing: border-box; display: flex; flex-direction: column; height: 100%;">
            <h2 style="margin-bottom: 20px; color: #333;">Questions Added</h2>
            

            <div style="flex: 1 1 auto; overflow-y: auto; padding-right: 5px;">
                <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                    <ItemTemplate>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                            <div style="flex: 1; padding-right: 10px;">
                                <b>Q:</b> <%# Eval("QuestionText") %><br />
                                A: <%# Eval("Option1") %> | B: <%# Eval("Option2") %> | C: <%# Eval("Option3") %> | D: <%# Eval("Option4") %> | Correct: <%# Eval("CorrectOption") %>
                            </div>
                            <asp:Button 
                                ID="btnDeleteQuestion" 
                                runat="server" 
                                Text="Delete" 
                                CommandName="DeleteQuestion" 
                                CommandArgument='<%# Container.ItemIndex %>' 
                                OnClientClick="return confirm('Delete this question?');" />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div style="display: flex; gap: 10px; margin-top: 15px;">
                <asp:Button ID="btnConfirmSubmit" runat="server" Text="Confirm to Submit" OnClick="btnConfirmSubmit_Click"
                    style="padding: 14px 30px; font-size: 16px; background-color: #343a40; color: white; border: none; border-radius: 6px; cursor:pointer;" />

                <asp:Button ID="btnClearAll" runat="server" Text="Clear All Questions"
                    CssClass="btn btn-danger" OnClick="btnClearAll_Click" />
            </div>

        </div>
    </div>
</asp:Content>

