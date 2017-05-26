<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Theme</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/seStruc.css">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container">
            <div id="seStructure">
                <!--<div id="seSidebar">
                        <div id="seSidebarComponent">
                                Settings
                        </div>
                        <div id="seSidebarComponent">
                                Themes
                        </div>
                        <div id="seSidebarComponent">
                                About
                        </div>
                </div>-->
                <div id="seContent">
                    <div id="thm">
                        <div id="thmTitle">
                            Themes
                        </div>
                        <div id="thmDisp">
                            <img src="resource/tema.png" alt="tema">
                        </div>
                        <div id="thmSelection">
                            <table>
                                <tr>
                                    <td>
                                        <div class="tema"><img src="resource/tema1.png" alt="tema1"></div>
                                    </td>
                                    <td>
                                        <div class="tema"><img src="resource/tema2.png" alt="tema2"></div>
                                    </td>
                                    <td>
                                        <div class="tema"><img src="resource/tema3.png" alt="tema3"></div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="thmButtonContainer">
                            <table>
                                <tr>
                                    <td>
                                        Save Changes Button
                                    <td>
                                    <td>
                                        Restore Default Button
                                    <td>
                                    <td>
                                        Cancel Button
                                    <td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>