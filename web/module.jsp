<%@page import="Model.ModuleImage"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    Module module = (Module) request.getAttribute("module");
    ArrayList<ModuleImage> moduleImages = (ArrayList<ModuleImage>) request.getAttribute("moduleImages");
    boolean isCertificated = (Boolean) request.getAttribute("isCertificated");
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
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="descSeparator"></div>
            <div id="descTitle" style="padding-left: 10%"><% out.print(module.getModuleName()); %></div>
            
            <%
                if( moduleImages != null && moduleImages.size() > 0 ) {
            %>
            
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
            
            <%
                }
            %>
            
            <div style="text-align: left; padding: 0px 10%">
                <button id="Button" onclick="location.href = 'achievement?mid=<%=module.getModuleID()%>'" type="button" class="btn btn-default">Achievements</button>
                <button id="Button" onclick="location.href = 'leaderboard?mid=<%=module.getModuleID()%>'" type="button" class="btn btn-default">Leaderboards</button>
                <button id="Button" onclick="location.href = 'forum?type=<%=module.getModuleName()%>'" type="button" class="btn btn-default">Forums</button>
            </div>

            <div id="descBox">
                <div id='moduleReleaseDate' style='width: 50%; display: inline-block;'>
                    <p style="font-size:30px">Release Date</p>
                    <p style="font-size:25px"><% out.print(module.getReleaseTimeFormatted()); %></p>
                </div>

                <p style="font-size:30px; margin-top: 30px">Module Description</p>
                <p style="font-size:25px"><% out.print(module.getModuleDescription());%></p>
                <div id="descButtonBox">
                    <%if( isCertificated ) {%>
                    <a href="users/<%=loggedUser.getUsername()%>/certs/<%=module.getModuleID()%>.pdf" download="<%=module.getModuleName()%> Certificate.pdf"> <div id="buttonBox" style='float: left'><button id="Button" type="button" class="btn btn-default">Certificate</button></div></a>
                    <%}%>
                    <a href="nowplaying?mid=<%=module.getModuleID()%>"> <div id="buttonBox" style='float: right'><button id="Button" type="button" class="btn btn-default" style="font-weight: bold;">Play</button></div></a>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>