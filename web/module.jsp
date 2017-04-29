<%@page import="Model.ModuleImage"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    Module module = (Module) request.getAttribute("module");
    ArrayList<ModuleImage> moduleImages = (ArrayList<ModuleImage>) request.getAttribute("moduleImages");
%>

<!DOCTYPE>
<html>
    <head>
        <title><% out.print(module.getModuleName()); %></title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/mStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container">
            <div id="descSeparator"></div>
            <div id="descTitle"><% out.print(module.getModuleName()); %></div>
            <div id="descImg">
                <div id="myCarousel" class="carousel slide" data-ride="carousel">
                    <!-- Indicators -->
                    <ol class="carousel-indicators">
                        <%
                            for (int i = 0; i < moduleImages.size(); i++) {
                                if (i == 0) {
                        %>
                        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                        <%   
                                } else {
                        %>
                        <li data-target="#myCarousel" data-slide-to="<% out.print(i); %>"></li>
                        <%            
                                }
                            }
                        %>
                    </ol>

                    <!-- Wrapper for slides -->
                    <div class="carousel-inner" role="listbox">
                        <%
                            for (int i = 0; i < moduleImages.size(); i++) {
                                if (i == 0) {
                        %>
                        <div class="item active">
                            <img src="<% out.print(moduleImages.get(i).getImagePath()); %>" alt="">
                        </div>
                        <%
                                } else {
                        %>
                        <div class="item">
                            <img src="<% out.print(moduleImages.get(i).getImagePath()); %>" alt="">
                        </div>
                        <%
                                }
                        %>
                        
                        <%
                            }
                        %>
                    </div>

                    <!-- Left and right controls -->
                    <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
                        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                    </a>
                    <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
                        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                    </a>
                </div>
            </div>
            <div id="descBox">
                <p style="font-size:30px">Module Version</p>
                <p style="font-size:25px"><% out.print(module.getModuleVersion()); %></p>
                <p style="font-size:30px">Release Date</p>
                <p style="font-size:25px"><% out.print(module.getReleaseTimeFormatted()); %></p>
                <p style="font-size:30px">Last Updated</p>
                <p style="font-size:25px"><% out.print(module.getLastUpdatedFormatted()); %></p>
                <p style="font-size:30px">Module Description</p>
                <p style="font-size:25px"><% out.print(module.getModuleDescription()); %></p>
                <div id="descButtonBox">
                    <table>
                        <tr>
                            <td><a href="<% out.print(url + "achievement?mid=" + module.getModuleID()); %>"><div id="buttonBox"><button id="Button" type="button" class="btn btn-default" style="font-weight: bold; width: 100%; font-size: 1vw;">Achievements</button></div></a></td>
                            <td style="padding-left: 15px;"><a href="<% out.print(url + "leaderboard?mid=" + module.getModuleID()); %>"><div id="buttonBox"><button id="Button" type="button" class="btn btn-default" style="font-weight: bold; width: 100%; font-size: 1vw;">Leaderboards</button></div></a></td>
                            <td></td>
                            <td></td>
                            <td><div id="buttonBox"><button id="Button" type="button" class="btn btn-default" style="font-weight: bold; width: 50%; font-size: 1vw;">Play</button></div></td>
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