<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    Module module = (Module) request.getAttribute("module");
    boolean isPublished = (Boolean) request.getAttribute("isPublished");
    boolean isSaved = (Boolean) request.getAttribute("isSaved");

    int views = (Integer) request.getAttribute("views");
    int thumbsUp = (Integer) request.getAttribute("thumbsUp");
    int thumbsDown = (Integer) request.getAttribute("thumbsDown");
    
    String imageFileString = (String) request.getAttribute("imageFileString");
%>

<!DOCTYPE>
<html>
    <head>
        <title>My Module: <% out.print(module.getModuleName()); %></title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/mStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="descSeparator"></div>
            <div id="descTitle" style="margin: 20px 8%"> <a href="my_modules">My Modules</a>:
                <b>
                    <%if (isPublished) {%>
                    <a href="module?mid=<%=module.getModuleID()%>"><% out.print(module.getModuleName());%></a>
                    <%} else {
                            out.print(module.getModuleName());
                        }%>
                </b>
            </div>
            <div style="text-align: center; padding: 0px 10%">
                <button id="Button" onclick="location.href = 'editachievement?mid=<%=module.getModuleID()%>'" type="button" class="btn btn-default pull-left">Edit Achievements</button>
                <button id="Button" onclick="$('#editModuleModal').modal('show');" type="button" class="btn btn-default pull-left" style="margin-left: 20px">Edit Details</button>
                <%if (isSaved) {%>
                <button id="Button" onclick="$('#publishModal').modal('show');" type="button" class="btn btn-default pull-right">Publish</button>
                <%}%>
                <%if (isPublished) {%>
                <button id="Button" onclick="$('#unpublishModal').modal('show');" type="button" class="btn btn-default pull-right" style="margin: 0px 8px">Unpublish</button>
                <%}%>
            </div>
            <div id="descBox" >
                <div id="sFrame" class="aFrame" style="display: inline-block; width: 200px; height: 200px;">
                    <img src="<%=(imageFileString == null?"module/" + module.getModuleID() + "/thumbnail" : "data:image/jpeg;base64," + imageFileString) %>" onerror="this.onerror = null; this.src='resource/thumbnail.png'; " alt="<%=module.getModuleName()%>">
                    <div class="overlay" style="width: 200px; height: 200px;">
                        <div class="text">
                            <button onclick="$('#uploadImageFile').click();" id="Button" class="btn btn-default">
                                Edit
                            </button>
                        </div>
                    </div>
                </div>
                <div style="display: inline-block; vertical-align: top; margin-top: 8px;">
                    <div id='moduleReleaseDate' style='display: block;'>
                        <p style="font-size:30px">Release Date</p>
                        <p style="font-size:25px"><% out.print(module.getReleaseTimeFormatted()); %></p>
                    </div>
                    <div id='moduleLastUpdated' style='display: block; margin-top: 20px'>
                        <p style="font-size:30px">Last Updated</p>
                        <p style="font-size:25px"><% out.print(module.getLastUpdatedFormatted()); %></p>
                    </div>
                </div>

                <%
                        if (isPublished) {%>
                <div style="display: inline-block; float: right; padding: 10px;">

                    <div id='viewCount' style='display: inline-block;'>
                        <p style="font-size:25px"><%=views%><span class="glyphicon glyphicon-eye-open"></span></p>
                    </div>
                </div>
                <div style="display: inline-block; float: right; padding: 10px;">
                    <div id='thumbsUp' style='display: inline-block;'>
                        <p style="font-size:25px"><%=thumbsUp%><span class="glyphicon glyphicon-thumbs-up"></span></p>
                    </div>
                </div>
                <div style="display: inline-block; float: right; padding: 10px;">
                    <div id='thumbsDown' style='display: inline-block;'>
                        <p style="font-size:25px"><%=thumbsDown%><span class="glyphicon glyphicon-thumbs-down"></span></p>
                    </div>
                </div>
                <%}
                %>


                <p style="font-size:30px; margin-top: 30px">Module Description</p>
                <p style="font-size:25px"><% out.print(module.getModuleDescription());%></p>
                <div id="descButtonBox">
                    <button onclick="location.href = 'editmodule?op=del&mid=<%=module.getModuleID()%>';" id="Button" class="btn btn-default pull-left"><span class="glyphicon glyphicon-trash"></span></button>

                    <a href="<%="editor?mid=" + module.getModuleID()%>"> <div id="buttonBox" style='float: right; margin-left: 10px'><button id="Button" type="button" class="btn btn-default" style="font-weight: bold;">Module Editor</button></div></a>
                    <%
                        if (isPublished) {
                    %>
                    <a href="<%="nowplaying?mid=" + module.getModuleID()%>"> <div id="buttonBox" style='float: right'><button id="Button" type="button" class="btn btn-default" style="font-weight: bold;">Play</button></div></a>
                    <%
                        }
                    %>

                </div>
            </div>
        </div>

        <div class="modal" id="editModuleModal" tabindex="-1" role="dialog" aria-labelledby="editModuleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form method="post" action="editmodule">
                        <input type="hidden" name="op" value="edit">
                        <input type="hidden" name="mid" value="<%=module.getModuleID()%>">
                        <div class="modal-header">
                            <h3 class="modal-title"> 
                                <span id="editModalLabel">Edit Module</span>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </h3>
                        </div>
                        <div class="modal-body">
                            <div>
                                <label>Module Name</label>
                            </div>
                            <div>
                                <input name="moduleName" type="text" value="<%=module.getModuleName()%>" style="width: 100%">
                            </div>
                            <div>
                                <label style='margin-top: 20px;'>Module Description</label>
                            </div>
                            <div>
                                <textarea name="moduleDescription"  style="width: 100%;max-width: 100%;min-width: 100%"><%=module.getModuleDescription()%></textarea>

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
        <div class="modal" id="publishModal" tabindex="-1" role="dialog" aria-labelledby="publishModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form method="post" action="editmodule">
                        <input type="hidden" name="op" value="publish">
                        <input type="hidden" name="mid" value="<%=module.getModuleID()%>">
                        <div class="modal-header">
                            <h3 class="modal-title"> 
                                <span id="publishModalLabel">Publish Module</span>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </h3>
                        </div>
                        <div class="modal-body">
                            <h3>
                                Are you sure you want to publish <%=module.getModuleName()%>?
                            </h3>
                        </div>
                        <div class="modal-footer">
                            <div class="pull-right">
                                <input id="Button" type="submit" class="btn btn-default" value="Yes">   
                                <button id="Button" type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">No</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="modal" id="unpublishModal" tabindex="-1" role="dialog" aria-labelledby="unpublishModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form method="post" action="editmodule">
                        <input type="hidden" name="op" value="unpublish">
                        <input type="hidden" name="mid" value="<%=module.getModuleID()%>">
                        <div class="modal-header">
                            <h3 class="modal-title"> 
                                <span id="publishModalLabel">Unpublish Module</span>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </h3>
                        </div>
                        <div class="modal-body">
                            <h3>
                                Are you sure you want to unpublish <%=module.getModuleName()%>?
                            </h3>
                        </div>
                        <div class="modal-footer">
                            <div class="pull-right">
                                <input id="Button" type="submit" class="btn btn-default" value="Yes">   
                                <button id="Button" type="button" class="btn btn-default" data-dismiss="modal" aria-label="Close">No</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="hidden">
            <form id="imageUploadForm" action="UploadImageServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="mid" value="<%=module.getModuleID()%>">
                <input type="hidden" name="uploadType" value="MODULE_THUMBNAIL">
                <input id="uploadImageFile" type="file" name="imageUpload" onchange="document.getElementById('imageUploadForm').submit();">
            </form>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>