<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="Model.Achievement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    ArrayList<Module> modules = (ArrayList<Module>) request.getAttribute("modules");

    String type = request.getParameter("type");
    String search = request.getParameter("search");

    String title = (String) request.getAttribute("title");

%>
<!DOCTYPE>
<html>
    <head>
        <title><%=title%></title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/aStruc.css">
        <link rel="stylesheet" type="text/css" href="css/color1/mStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="structure">
                <div id="sTitle">
                    <%=title%>
                </div>
                <div id="sMore">
                </div>
                <div id="aSDisp">
                    <%
                        for (Module m : modules) {
                    %>
                    <div id="aSFrame" onclick="location.href = 'module?mid=<%=m.getModuleID()%>';" style="cursor: pointer">
                        <div style="display: flex; flex-direction: row; padding: 20px; position:relative">
                            <div id="sFrame" style='margin: 5px 5px; flex: 0 0 200px;'>
                                <div class="frame">
                                    <div>
                                        <img src="module/<%=m.getModuleID()%>/thumbnail" onerror="this.onerror = null; this.src='resource/thumbnail.png'; " alt="<%=m.getModuleName()%>">
                                    </div>
                                </div>
                            </div>
                            <div style="margin-left: 20px; margin-top: 5px">
                                <span style="font-size: 25px"><b><%=m.getModuleName()%></b></span>
                                <p style="font-size: 18px; margin: 10px"><%=m.getModuleDescription()%></p>
                            </div>
                            <div style="position: absolute; bottom: 10px; right: 20px; font-size: 18px">
                                <span>
                                    <%=m.getReleaseTimeFormatted()%>
                                </span>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <div id="footer">
                Powered by ZeeTech
            </div>
    </body>
</html>
