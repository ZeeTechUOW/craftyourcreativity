<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="Model.Achievement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    Module module = (Module) request.getAttribute("module");
    ArrayList<Achievement> achievements = (ArrayList<Achievement>) request.getAttribute("achievements");
    int unlockedModuleCount = (int) request.getAttribute("unlockedModuleCount");
%>
<!DOCTYPE>
<html>
    <head>
        <title>Achievements</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/aStruc.css">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <div id="headerSeparator">
        </div>
        <nav class="navbar navbar-findcond navbar-fixed-top" style="height: 78px">
            <div class="container" style="margin-top: 10px; position: relative; width: 80%;">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <div class="logo"><img src="resource/blogo.png" class="img-responsive" style="margin: auto; margin-top: 5px;" alt="front logo"></div>
                </div>
                <div class="collapse navbar-collapse" id="navbar">
                    <ul class="nav navbar-nav navbar-left">
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="glyphicon glyphicon-menu-hamburger"></span> Menu 
                                <ul id="colorOverride" class="dropdown-menu" role="menu">
                                    <li><a href="main">Main Menu</a></li>
                                    <li><a href="library">Library</a></li>
                                    <%
                                        if (loggedUser != null && loggedUser.getUserType() != "player") {
                                    %>
                                    <li><a href="#">My modules</a></li>
                                    <%
                                        }
                                    %>
                                    <li><a href="#">Achievements</a></li>
                                    <li><a href="#">Leaderboards</a></li>
                                    <li><a href="forum">Forums</a></li>
                                    <%
                                        if (loggedUser != null && loggedUser.getUserType() != "player") {
                                    %>
                                    <li><a href="logoutauth">Logout</a></li>
                                    <%
                                        }
                                    %>
                                    <li style="padding-right: 5%"><button id="colorOverride" class="button" type="button" style="float: right;"><span class="glyphicon glyphicon-cog"></span></button></a></li>
                                </ul>
                        </li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <%
                            if (loggedUser == null) {
                        %>
                        <li class="active"><a href="login">Log in <span class="sr-only">(current)</span></a></li>
                        <li class="active"><a href="signup">Sign up <span class="sr-only">(current)</span></a></li>
                        <%
                            } else {
                        %>
                        <li class="active"><a href="#"><% out.print(loggedUser.getUsername()); %><span class="sr-only">(current)</span></a></li>
                        <%
                            }
                        %>
                    </ul>
                    <form class="navbar-form navbar-left search-form" role="search" style="position: absolute; left: 30%; right: 30%">
                        <input type="text" class="form-control" placeholder="Search" style="width: 100%;" />
                    </form>
                </div>
            </div>
        </nav>
        <div id="container">
            <div id="aStructure">
                <div id="aSTitle">Game: <% out.print(module.getModuleName()); %></div>
                <div id="aSList"><% out.print(unlockedModuleCount); %> of <% out.print(achievements.size()); %> unlocked</div>
                <div id="aSDisp">
                    <%
                        for (Achievement a : achievements) {
                    %>
                    <div id="aSFrame">
                        <table>
                            <tr>
                                <td><div id="aSpic"><div class="aFrame"><img src="<% out.print(a.getImagePath()); %>" alt="a1"></div></div></td>
                                <td><b><% out.print(a.getAchievementName()); %></b><br><% out.print(a.getAchievementDescription()); %></td>
                                <%
                                    if (a.getUnlockTime() == LocalDateTime.MIN) {
                                %>
                                <td>Locked</td>
                                <%
                                    } else {
                                %>
                                <td>Unlocked <% out.print(a.getUnlockTime().getDayOfMonth() + "/" + a.getUnlockTime().getMonthValue() + "/" + a.getUnlockTime().getYear()); %></td>
                                <%
                                    }
                                %>
                            </tr>
                        </table>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
        <!--<a href="main.html">Main Menu</a>
        <br><a href="library.html">Library</a>
        <br><a href="my_modules.html">My Modules</a>
        <br><a href="achievement.html">Achievements</a>
        <br><a href="leaderboard.html">Leaderboards</a>
        <br><a href="forum.html">Forums</a>
        <br><a href="setting.html">Setting</a>
        
        <br>Sign In
        <br>Log In-->
    </body>
</html>
