<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="Model.Achievement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    Module module = (Module) request.getAttribute("module");
    ArrayList<Achievement> achievements = (ArrayList<Achievement>) request.getAttribute("achievements");
    int unlockedModuleCount = (int) request.getAttribute("unlockedModuleCount");
%>
<!DOCTYPE>
<html>
    <head>
        <title><% out.print(module.getModuleName()); %> Achievements</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/aStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="aStructure">
                <div id="aSTitle" style="width: 100%">Game: <a style="text-decoration: none;" href="editmodule?mid=<%=module.getModuleID()%>"><% out.print(module.getModuleName()); %></a></div>
                <div id="aSDisp">
                    <%
                        for (Achievement a : achievements) {
                    %>
                    <div id="aSFrame">
                        <table>
                            <tr>
                                <td>
                                    <div id="aSpic">
                                        <div class="aFrame">
                                            <img src="achievementThumbs/<% out.print(a.getAchievementID());%>thumbnail" onerror="this.onerror = null; this.src = 'resource/trophy.png';" alt="a1">
                                            <div class="overlay">
                                                <div class="text">
                                                    <button onclick="$('#uploadAchievementID').val('<%=a.getAchievementID()%>'); $('#uploadImageFile').click();"  id="Button" class="btn btn-default">
                                                        Edit
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td><b><% out.print(a.getAchievementName()); %></b><br><% out.print(a.getAchievementDescription());%></td>
                                <td style="width: 10%;">
                                    <button onclick="location.href = 'editachievement?op=del&mid=<%=module.getModuleID()%>&aid=<%=a.getAchievementID()%>';" id="Button" class="btn btn-default deleteAchievementButton"><span class="glyphicon glyphicon-trash"></span></button>
                                    <button id="Button" class="btn btn-default" onclick="
                                            $('#hiddenAchievementID').val('<%=a.getAchievementID()%>');
                                            $('#editAchievementNameField').val('<%=a.getAchievementName()%>');
                                            $('#editAchievementDescriptionTextArea').html('<%=a.getAchievementDescription()%>');
                                            $('#editModal').modal('show');
                                            ">Edit</button>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <%
                        }
                    %>
                    <button id="Button" class="btn btn-default" onclick="$('#addModal').modal('show');">Add Achievement</button>
                </div>
            </div>
        </div>

        <div class="modal" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form method="post" action="editachievement">
                        <input type="hidden" name="op" value="add">
                        <input type="hidden" name="mid" value="<%=module.getModuleID()%>">
                        <div class="modal-header">
                            <h3 class="modal-title"> 
                                <span id="addModalLabel">Add Achievement</span>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </h3>
                        </div>
                        <div class="modal-body">
                            <div>
                                <label>Achievement Name</label>
                            </div>
                            <div>
                                <input name="achievementName" type="text" style="width: 100%">
                            </div>
                            <div>
                                <label style='margin-top: 20px;'>Achievement Description</label>
                            </div>
                            <div>
                                <textarea name="achievementDescription"  style="width: 100%;max-width: 100%;min-width: 100%"></textarea>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <div class="pull-right">
                                <input id="Button" type="submit" class="btn btn-default" value="Add">    
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="modal" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form method="post" action="editachievement">
                        <input type="hidden" name="op" value="edit">
                        <input type="hidden" name="mid" value="<%=module.getModuleID()%>">
                        <input id="hiddenAchievementID" type="hidden" name="aid" value="">
                        <div class="modal-header">
                            <h3 class="modal-title"> 
                                <span id="editModalLabel">Edit Achievement</span>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </h3>
                        </div>
                        <div class="modal-body">
                            <div>
                                <label>Achievement Name</label>
                            </div>
                            <div>
                                <input id="editAchievementNameField" name="achievementName" type="text" style="width: 100%">
                            </div>
                            <div>
                                <label style='margin-top: 20px;'>Achievement Description</label>
                            </div>
                            <div>
                                <textarea id="editAchievementDescriptionTextArea" name="achievementDescription"  style="width: 100%;max-width: 100%;min-width: 100%"></textarea>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <div class="pull-right">
                                <input id="Button" type="submit" class="btn btn-default" value="Edit">   
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="hidden">
            <form id="imageUploadForm" action="UploadImageServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="mid" value="<%=module.getModuleID()%>">
                <input type="hidden" id="uploadAchievementID" name="aid" value="">
                <input type="hidden" name="uploadType" value="ACHIEVEMENT_THUMBNAIL">
                <input id="uploadImageFile" type="file" name="imageUpload" onchange="document.getElementById('imageUploadForm').submit();">
            </form>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>
