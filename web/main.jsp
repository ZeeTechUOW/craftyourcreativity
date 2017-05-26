<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Module"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    ArrayList<Module> modulesPopular = (ArrayList<Module>) request.getAttribute("modulesPopular");
    ArrayList<Module> modulesNewest = (ArrayList<Module>) request.getAttribute("modulesNewest");
    ArrayList<Module> modulesUpdate = (ArrayList<Module>) request.getAttribute("modulesUpdate");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Craft Your Creativity</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/mStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <style >
            #sTitle {
                border: none;
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>

            <div id="container">
                <div id="structure">
                    <div id="sTitle">
                        Popular
                    </div>
                    <div id="sMore">
                        <button onclick="location.href = 'modulelist?type=popular'" id="Button" class="btn btn-default">See More</button>
                    </div>
                    <div id="sDisp">
                        <table>
                            <tr>
                            <%
                                for (Module m : modulesPopular) {
                            %>
                            <td>
                                <div id="sFrame" style='margin: 13px 5px;'>
                                    <a href="module?mid=<%=m.getModuleID()%>">
                                        <div>
                                            <img src="module/<%=m.getModuleID()%>/thumbnail" onerror="this.onerror = null; this.src='resource/thumbnail.png'; " alt="<%=m.getModuleName()%>">
                                        </div>
                                    </a>
                                </div>
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
                    <button onclick="location.href = 'modulelist?type=newest'" id="Button" class="btn btn-default">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <%
                                for (Module m : modulesNewest) {
                            %>
                            <td>
                                <div id="sFrame" style='margin: 13px 5px;'>
                                    <a href="module?mid=<%=m.getModuleID()%>">
                                        <div>
                                            <img src="module/<%=m.getModuleID()%>/thumbnail" onerror="this.onerror = null; this.src='resource/thumbnail.png'; " alt="<%=m.getModuleName()%>">
                                        </div>
                                    </a>
                                </div>
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
                    <button onclick="location.href = 'modulelist?type=update'" id="Button" class="btn btn-default">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <%
                                for (Module m : modulesUpdate) {
                            %>
                            <td>
                                <div id="sFrame" style='margin: 13px 5px;'>
                                    <a href="module?mid=<%=m.getModuleID()%>">
                                        <div>
                                            <img src="module/<%=m.getModuleID()%>/thumbnail" onerror="this.onerror = null; this.src='resource/thumbnail.png'; " alt="<%=m.getModuleName()%>">
                                        </div>
                                    </a>
                                </div>
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