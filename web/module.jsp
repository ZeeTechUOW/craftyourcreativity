<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    Module module = (Module) request.getAttribute("module");
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
            <div id="descTitle" style="padding-left: 10%"><% out.print(module.getModuleName());%></div>


            <div id="descImg"  class="aFrame" style="text-align: center; border: solid white .4vw; border-radius: .4vw;">
                <img style="height: 400px; width: 400px;"src="module/<%=module.getModuleID()%>/thumbnail" alt="">
                <div class="overlay" style="width: 400px; height: 400px;">
                        <div class="text">
                            <button onclick="location.href = 'nowplaying?mid=<%=module.getModuleID()%>';" id="Button" class="btn btn-default" style="font-size: 40px">
                                Play
                            </button>
                        </div>
                    </div>
            </div>   


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
                    <%if (isCertificated) {%>
                    <a href="users/<%=loggedUser.getUsername()%>/certs/<%=module.getModuleID()%>.pdf" download="<%=module.getModuleName()%> Certificate.pdf"> <div id="buttonBox" style='float: left'><button id="Button" type="button" class="btn btn-default">Certificate</button></div></a>
                    <%}%>
                    <a href="nowplaying?mid=<%=module.getModuleID()%>"> <div id="buttonBox" style='float: right'><button id="Button" type="button" class="btn btn-default" style="font-weight: bold;">Play</button></div></a>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>

        <script>
            
            function animate() {
                requestAnimationFrame(animate);
                
                var left = ($("#container").width() - $("#descImg").width())/2;
                $("#descImg").css("margin-left", left + "px");
            }
            
            animate();
            
        </script>
    </body>
</html>