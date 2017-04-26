<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Thread"%>
<%@page import="com.sun.xml.internal.ws.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    String type = (String) request.getAttribute("type");
    String sort = (String) request.getAttribute("sort");
    String sortFormatted = (String) request.getAttribute("sortFormatted");
    int pageNum = (int) request.getAttribute("pageNum");
    
    ArrayList<Thread> threads = (ArrayList<Thread>) request.getAttribute("threads");
    ArrayList<User> userList = (ArrayList<User>) request.getAttribute("userList");
    ArrayList<String> pageCount = (ArrayList<String>) request.getAttribute("pageCount");
    ArrayList<String> pageCountUrl = (ArrayList<String>) request.getAttribute("pageCountUrl");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Forums</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/fStruc.css">
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
                                <ul class="dropdown-menu" role="menu" style="background-color: #4fa78b;">
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
                                    <li style="padding-right: 5%"><button class="button" type="button" style="float: right; background-color: #4fa78b;"><span class="glyphicon glyphicon-cog"></span></button></a></li>
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
            <div id="fStructure">
                <%
                    if (type.equalsIgnoreCase("default")) {
                %>
                <div id="fSTitle">
                    <B>Forums</b>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>Discussion</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("discussion")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=discussion"); %>">See All Threads</a></td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>Funny</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("funny")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=funny"); %>">See All Threads</td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>Bug</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("bug")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=bug"); %>">See All Threads</td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>Other</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("other")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=other"); %>">See All Threads</td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <%
                } else {
                %>
                <div id="fSTitle">
                    <div>
                        <% out.println("<B>" + StringUtils.capitalize(type) + "</b>"); %>
                    </div>
                    <div class="dropdown" style="">
                        <button class="btn dropdown-toggle" type="button" data-toggle="dropdown" style="background-color: #4fa78b;">Sort by <% out.print(sortFormatted); %>
                            <span class="caret"></span></button>
                        <ul class="dropdown-menu">
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=new"); %>">Newest</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=today"); %>">Popular today</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=week"); %>">Popular this week</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=month"); %>">Popular this month</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=all"); %>">Popular all time</a></li>
                        </ul>
                    </div>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th><a href="<% out.print(url + "forum"); %>">Forum</a> ►  <a href="<% out.print(url + "forum?type=" + type); %>"><% out.print(StringUtils.capitalize(type)); %></a></th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                out.println("<tr>");
                                out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                out.println("</tr>");
                            }
                        %>
                        <tr>
                            <td></td><td>
                            <%
                                for (int p = 0; p < pageCount.size(); p++) {
                            %>
                            <a style='text-decoration: none;' href="<% out.print(pageCountUrl.get(p)); %>"><% out.print(pageCount.get(p)); %></a>
                            <%
                                }
                            %>
                            </td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <%
                    }
                %>
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