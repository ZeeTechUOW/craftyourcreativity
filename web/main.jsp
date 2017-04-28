<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Module"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    ArrayList<Module> modulesPopular = (ArrayList<Module>) request.getAttribute("modulesPopular");
    ArrayList<Module> modulesNewest = (ArrayList<Module>) request.getAttribute("modulesNewest");
    ArrayList<Module> modulesUpdate = (ArrayList<Module>) request.getAttribute("modulesUpdate");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Craft Your Creativity</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/mStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
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
            <div id="structure">
                <div id="sTitle">
                    Popular
                </div>
                <div id="sMore">
                    <button id="sButton" class="col-xs-offset-11">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <% 
                                for(Module m : modulesPopular) {
                            %>
                            <td>
                                <a href="">
                                    <div id="sFrame">
                                        <a href="<% out.print(url + "module?mid=" + m.getModuleID()); %>"><div class="frame"><img src="<% out.print(m.getThumbnailPath()); %>" alt="<% out.print(m.getModuleName()); %>" id="team"></div></a>
                                    </div>
                                </a>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="structure">
                <div id="sTitle">
                    New Release
                </div>
                <div id="sMore">
                    <button id="sButton" class="col-xs-offset-11">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <% 
                                for(Module m : modulesNewest) {
                            %>
                            <td>
                                <a href="">
                                    <div id="sFrame">
                                        <a href="<% out.print(url + "module?mid=" + m.getModuleID()); %>"><div class="frame"><img src="<% out.print(m.getThumbnailPath()); %>" alt="<% out.print(m.getModuleName()); %>" id="team"></div></a>
                                    </div>
                                </a>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="structure">
                <div id="sTitle">
                    Recently Updated
                </div>
                <div id="sMore">
                    <button id="sButton" class="col-xs-offset-11">See More</button>
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <% 
                                for(Module m : modulesUpdate) {
                            %>
                            <td>
                                <a href="">
                                    <div id="sFrame">
                                        <a href="<% out.print(url + "module?mid=" + m.getModuleID()); %>"><div class="frame"><img src="<% out.print(m.getThumbnailPath()); %>" alt="<% out.print(m.getModuleName()); %>" id="team"></div></a>
                                    </div>
                                </a>
                            </td>
                            <%
                                }
                            %>
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