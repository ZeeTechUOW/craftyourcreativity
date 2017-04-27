<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
%>

<!DOCTYPE>
<!-- saved from url=(0014)about:internet -->
<html>
    <head>
        <title>Setting</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/seStruc.css">
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
                    <div id="teBox">
                        <table id="setting">
                            <tr id="setting">
                                <th id="setting" colspan="2">My Account information</th>
                            </tr>
                            <tr id="setting">
                                <td id="setting">Profile Name</td>
                                <td id="setting">Metafalls_</td>
                            </tr>
                            <tr id="setting">
                                <td id="setting">User ID</td>
                                <td id="setting">420</td>
                            </tr>
                        </table>
                    </div>

                    <div id="seBox">
                        <div id="seAvatarBox">
                            <table>
                                <tr><td id="avatar">Avatar Icon</td></tr>
                                <tr><td id="avatar">							
                                        <div id="seAvatarDisp">
                                            <div class="avatar"><img src="resource/avates.png" alt="a1" id="team"></div>
                                        </div>
                                    </td></tr>
                            </table>
                        </div>
                        <div id="seAvatarSelect">
                            This is Avatar Selection Container
                        </div>
                    </div>

                    <div id="seBoxUnderline">
                        UPDATE YOUR EMAIL
                    </div>
                    <div id="seBox2">
                        <table id="form">
                            <tr><td><b>Email Address (must be valid):</b></td><td>INPUT HERE</td> </tr>
                            <tr><td><b>Your Account Password:</b></td><td>INPUT HERE</td></tr>
                            <tr><td colspan="2" id="form">Update Your Email BUTTON</td></tr>
                        </table>
                    </div>

                    <div id="seBoxUnderline">
                        CHANGE PASSWORD
                    </div>
                    <div id="seBox2">
                        <table id="form">
                            <tr><td><b>Current Password</b></td><td>INPUT HERE</td> </tr>
                            <tr><td><b>New Password:</b></td><td>INPUT HERE</td></tr>
                            <tr><td colspan="2" id="form">At least 6 Characters long</td></tr>
                            <tr><td><b>Confirm New Password:</b></td><td>INPUT HERE</td></tr>
                            <tr><td colspan="2" id="form">Re-type your new password</td></tr>
                            <tr><td colspan="2" id="form">Change Password BUTTON</td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>