<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Module"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    ArrayList<Module> modules = (ArrayList<Module>) request.getAttribute("modules");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Library</title>
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
            <div id="structure">
                <div id="sTitle">
                    My Modules
                    
                    <button id="Button" style="padding: 6px 10px; margin-top: 10px" onclick="location.href = 'statistics';" class="pull-right">
                        Statistics
                    </button>
                </div>
                <div id="sMore">
                </div>
                <div id="sDisp">
                    <ul class="list-inline list-unstyled">

                        <%
                            for (int i = 0; i < modules.size(); i++) {
                        %>
                        <li id="sFrame">
                            <a href="editmodule?mid=<%=modules.get(i).getModuleID()%>">
                                <div class="frame">
                                        <div>
                                            <img src="module/<%=modules.get(i).getModuleID()%>/thumbnail" onerror="this.onerror = null; this.src='resource/thumbnail.png'; " alt="<%=modules.get(i).getModuleName()%>">
                                        </div>
                                </div>
                            </a>
                        </li>
                        <%
                            }
                        %>
                        <li id="sFrame">
                            <a href="addmodule">
                                <div class="frame">
                                    <div id="addModule">
                                        <span id='addModulePlus' class="glyphicon glyphicon-plus"></span>
                                        Add New Module
                                    </div>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>