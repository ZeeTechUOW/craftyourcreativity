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
    
    int pageNum;
    int lastPage;

    try {
        pageNum = Integer.parseInt(request.getParameter("page"));
    } catch (NumberFormatException ex) {
        pageNum = 1;
    }

    lastPage = (int) request.getAttribute("lastPage");
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
        <script src="https://cdn.quilljs.com/1.2.3/quill.js"></script>
        <script src="https://cdn.quilljs.com/1.2.3/quill.min.js"></script>

        <link href="https://cdn.quilljs.com/1.2.3/quill.snow.css" rel="stylesheet">
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
                <div id="quillBox">
                    <div  id="quill">
                    </div>
                </div>

                <script>
                    var toolbarOptions = [
                        ['bold', 'italic', 'underline', 'strike'], // toggled buttons
                        ['blockquote', 'code-block'],

                        [{'header': 1}, {'header': 2}], // custom button values
                        [{'list': 'ordered'}, {'list': 'bullet'}],
                        [{'script': 'sub'}, {'script': 'super'}], // superscript/subscript
                        [{'indent': '-1'}, {'indent': '+1'}], // outdent/indent
                        [{'direction': 'rtl'}], // text direction

                        [{'size': ['small', false, 'large', 'huge']}], // custom dropdown
                        [{'header': [1, 2, 3, 4, 5, 6, false]}],

                        [{'color': []}, {'background': []}], // dropdown with defaults from theme
                        [{'font': []}],
                        [{'align': []}],

                        ['clean']                                         // remove formatting button
                    ];
                    var quill = new Quill('#quill', {
                        modules: {
                            toolbar: toolbarOptions
                        },
                        placeholder: 'Compose your comment ...',
                        theme: 'snow'});
                </script>
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
