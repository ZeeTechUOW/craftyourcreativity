<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Post"%>
<%@page import="Model.Thread"%>
<%@page import="com.sun.xml.internal.ws.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    int pageNum = (int) request.getAttribute("pageNum");
    int lastPage = (int) request.getAttribute("lastPage");
    ArrayList<String> pageCount = (ArrayList<String>) request.getAttribute("pageCount");
    ArrayList<String> pageCountUrl = (ArrayList<String>) request.getAttribute("pageCountUrl");

    Thread thread = (Thread) request.getAttribute("thread");
    ArrayList<Post> posts = (ArrayList<Post>) request.getAttribute("posts");
    ArrayList<User> userList = (ArrayList<User>) request.getAttribute("userList");
%>

<!DOCTYPE html>
<html>
    <head>
        <title><% out.print(thread.getThreadTitle()); %> | Page <% out.print(lastPage); %></title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/tStruc.css">
        
        <link rel="stylesheet" href="css/bootstrap.css">
        <script src="jquery/jquery-3.2.1.js"></script>
        <script src="js/bootstrap.js"></script>
        
        <link rel="stylesheet" href="summernote/0.8.3/summernote.css">
        <script src="summernote/0.8.3/summernote.js">
            
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
                                        if (loggedUser != null && !loggedUser.getUserType().equalsIgnoreCase("player")) {
                                    %>
                                    <li><a href="#">My modules</a></li>
                                    <%
                                        }
                                    %>
                                    <li><a href="forum">Forums</a></li>
                                    <%
                                        if (loggedUser != null) {
                                    %>
                                    <li><a href="logoutauth">Logout</a></li>
                                    <%
                                        }
                                    %>
                                    <li style="padding-right: 5%"><a href="setting"><button id="colorOverride" class="button" type="button" style="float: right;"><span class="glyphicon glyphicon-cog"></span></button></a></li>
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
            <div id="tStructure">
                <div id="tSTitle">
                    <% out.print(thread.getThreadTitle());%>
                </div>
                <%
                    for (int i = 0; i < posts.size(); i++) {
                %>
                <div id="tThreadCore">
                    <%
                        if (i == 0) {
                    %>
                    <div id="tThreadHeader">
                        <div id="tHead">
                            <a style='text-decoration: none;' href=<% out.print(url + "forum"); %>>Forum</a> ►  <a style='text-decoration: none;' href='<% out.print(url + "forum?type=" + thread.getThreadType()); %>'><% out.print(StringUtils.capitalize(thread.getThreadType())); %></a> ►  <a style='text-decoration: none;' href="<% out.print(url + "thread?tid=" + Integer.toString(thread.getThreadID())); %>"><% out.print(thread.getThreadTitle()); %></a> 
                        </div>

                        <div id="tHeadPage">
                            <%
                                for (int p = 0; p < pageCount.size(); p++) {
                            %>
                            <a style='text-decoration: none;' href="<% out.print(pageCountUrl.get(p)); %>"><% out.print(pageCount.get(p)); %></a>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <%
                        }
                    %>
                    <div id="tPostHeader">
                        <table>
                            <tr><td><% out.print(userList.get(i).getUsername()); %></td><td><% out.print(posts.get(i).getPostTimeFormatted()); %></td></tr>
                        </table>
                    </div>
                    <div id="tPostContent">
                        <% out.print(posts.get(i).getPostMessage()); %>
                    </div>
                </div>
                <%
                    }
                %>
                <div id="tThreadBot">
                    <div id="tBot">
                        <a style='text-decoration: none;' href=<% out.print(url + "forum"); %>>Forum</a> ►  <a style='text-decoration: none;' href='<% out.print(url + "forum?type=" + thread.getThreadType()); %>'><% out.print(StringUtils.capitalize(thread.getThreadType())); %></a> ►  <a style='text-decoration: none;' href="<% out.print(url + "thread?tid=" + Integer.toString(thread.getThreadID())); %>"><% out.print(thread.getThreadTitle()); %></a> 
                    </div>
                    <div id="tBotPage">
                        <%
                            for (int p = 0; p < pageCount.size(); p++) {
                        %>
                        <a style='text-decoration: none;' href="<% out.print(pageCountUrl.get(p)); %>"><% out.print(pageCount.get(p)); %></a>
                        <%
                            }
                        %>
                    </div>
                </div>
                <div id="summernote"></div>
                <script>
                    $(document).ready(function() {
                        $('#summernote').summernote({
                            height: 300,
                            width: 1500,
                            minHeight: null,
                            maxHeight: null,
                            focus: true
                        });
                    });
                    
                    function submitPost () {
                        $('#summerNoteTextID').html($('#summernote').summernote('code'));
                        $('#myForm').submit();
                    }
                </script>
                <form action="createpost" method="post" id="myForm">
                    <input type="hidden" name="threadID" value="<% out.print(thread.getThreadID()); %>">
                    <textarea id="summerNoteTextID" name="summerNoteText" style="display: none;"></textarea>
                    <button type="button" onclick="submitPost()">Submit</button>
                </form>
            </div>
        </div>
        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>
