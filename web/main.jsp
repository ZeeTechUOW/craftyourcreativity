<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Module"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    ArrayList<Module> modulesPopular = (ArrayList<Module>) request.getAttribute("modulesPopular");
    ArrayList<Module> modulesNewest = (ArrayList<Module>) request.getAttribute("modulesNewest");
    ArrayList<Module> modulesUpdate = (ArrayList<Module>) request.getAttribute("modulesUpdate");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Craft Your Creativity</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/mStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        
        <div id="container" style='position: absolute; min-height: calc(100% - 78px);'>
            <div id="structure">
                <div id="sTitle">
                    Popular
                </div>
                <div id="sMore">
                    <button id="sButton">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <%
                                for (Module m : modulesPopular) {
                            %>
                            <td>
                                <a href="">
                                    <div id="sFrame">
                                        <a href="<% out.print(url + "module?mid=" + m.getModuleID()); %>"><div class="frame"><img src="<% out.print(m.getThumbnailPath()); %>" alt="<% out.print(m.getModuleName()); %>" id="team"></div></a>
                                    </div>
                                </a>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="structure">
                <div id="sTitle">
                    New Release
                </div>
                <div id="sMore">
                    <button id="sButton">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <%
                                for (Module m : modulesNewest) {
                            %>
                            <td>
                                <a href="">
                                    <div id="sFrame">
                                        <a href="<% out.print(url + "module?mid=" + m.getModuleID()); %>"><div class="frame"><img src="<% out.print(m.getThumbnailPath()); %>" alt="<% out.print(m.getModuleName()); %>" id="team"></div></a>
                                    </div>
                                </a>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="structure">
                <div id="sTitle">
                    Recently Updated
                </div>
                <div id="sMore">
                    <button id="sButton">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <%
                                for (Module m : modulesUpdate) {
                            %>
                            <td>
                                <a href="">
                                    <div id="sFrame">
                                        <a href="<% out.print(url + "module?mid=" + m.getModuleID()); %>"><div class="frame"><img src="<% out.print(m.getThumbnailPath()); %>" alt="<% out.print(m.getModuleName()); %>" id="team"></div></a>
                                    </div>
                                </a>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>