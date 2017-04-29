<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Module"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    ArrayList<Module> modules = (ArrayList<Module>) request.getAttribute("modules");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Library</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/mStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container"  style='position: absolute; min-height: calc(100% - 78px);'>
            <div id="structure">
                <div id="sTitle">
                    My Library
                </div>
                <div id="sMore">
                </div>
                <div id="sDisp">
                    <table>
                        <%
                            for (int i = 0; i < modules.size(); i++) {
                                if(i % 6 == 0) {
                        %>
                        <tr>
                        <%
                                }
                        %>
                            <td>
                                <div id="sFrame">
                                    <a href="<% out.print(url + "module?mid=" + modules.get(i).getModuleID()); %>"><div class="frame"><img src="<% out.print(modules.get(i).getThumbnailPath()); %>" alt="f1" id="team"></div></a>
                                </div>
                            </td>
                        <%
                                if(i % 6 == 5) {
                        %>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </table>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>