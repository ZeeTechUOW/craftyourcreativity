<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Create Thread</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/ctStruc.css">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="js/bootstrap.min.js"></script>

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
            <div id="ctStructure">
                    <div id="ctTitle">
                        Create Thread
                    </div>
                    <div id="ctContent">
                        <form action="addthread" method="post" id="myForm">
                            <table>
                                <tr>
                                    <td>
                                        Thread Title
                                    </td>
                                    <td>
                                        <div class="input-lg">
                                            <input type="text" class="form-control" placeholder="Thread Title" name="threadTitle" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Thread Type
                                    </td>
                                    <td style="padding-left:15px;">
                                        <select id="colorOverride" name="threadType" class="selectpicker">
                                        <option value="general">General</option>
                                        <option value="module">Module</option>
                                        <option value="discussion">Discussion</option>
                                        <option value="bug">Bug</option>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            <div id="summernote"></div>
                            <script>
                                $(document).ready(function() {
                                    $('#summernote').summernote({
                                        height: 300,
                                        width: 1300,
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
                            <input type="hidden" name="threadID" value="asd">
                            <textarea id="summerNoteTextID" name="threadPost" style="display: none;"></textarea>
                            <button id="colorOverride" type="button" class="btn btn-default" onclick="submitPost()" style="font-family: tahoma; font-size: 1vw;">Create New Thread</button>
                        </form>
                    </div>
                </div>
        </div>

        <div id="footer">
        Powered by ZeeTech
        </div>
    </body>
</html>