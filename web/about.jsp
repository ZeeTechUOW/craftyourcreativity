<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>About</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/seStruc.css">
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
            <!--<div id="seStructure">
                    <div id="seSidebar">
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
                <div id="abt">
                    <div id="abtTitle">
                        About Us
                    </div>

                    <div id="abtContent">
                        ZeeTech is a group with the purpose of fulfilling the requirements given by the University of Wollongong with the course of CSIT321 Project. The project is based on a client specification in which that it is required to have a innovation, creativity and ingenuity. This organization would then use these aspects to create a framework suited for the requirements. The members of the organization consist of separate individuals whom has different area of study meant to incorporate interdisciplinary thinking.
                        <br><br>
                        For the actual project, we are to endorse e-learning through the means of gamification. The system is built through the importance that the group will fulfill these conditions. In addition from the main goal, each members would also provide various technical and logical skills to contribute to the overall framework.
                    </div>

                    <div id="abtTeam">
                        <div id="abtMember">
                            <div id="abtPhoto">
                                <div class="team"><img src="resource/placeholder.png" alt="p1" id="team"></div>
                            </div>
                            <div id="abtName">
                                Muhammad Harits Abiyyudo
                            </div>
                            <div id="abtPosition">
                                Project Leader
                            </div>
                            <div id="abtSum">
                                Music enthusiast and experienced game designer. Have lead several IT project and enjoyed it for the most part. Have a love-hate relationship with programming.
                            </div>
                        </div>

                        <div id="abtMember">
                            <div id="abtPhoto">
                                <div class="team"><img src="resource/placeholder.png" alt="p2" id="team"></div>
                            </div>
                            <div id="abtName">
                                Deni Barasena
                            </div>
                            <div id="abtPosition">
                                Technical Developer
                            </div>
                            <div id="abtSum">
                                Proficient programmer and 3D designer. Have worked on lots of IT related project of various kind. Constantly learning and getting better each time.	
                            </div>
                        </div>

                        <div id="abtMember">
                            <div id="abtPhoto">
                                <div class="team"><img src="resource/placeholder.png" alt="p3" id="team"></div>
                            </div>
                            <div id="abtName">
                                Huy Tuan Anh Nguyen
                            </div>
                            <div id="abtPosition">
                                Information System and Marketing
                            </div>
                            <div id="abtSum">
                                Business Information Systems student with in-depth knowledge of information systems general and in business in particular. Have ability to conduct business operations to ensure the product will successful.	
                            </div>
                        </div>

                        <div id="abtSpacer">
                        </div>

                        <div id="abtMember">
                            <div id="abtPhoto">
                                <div class="team"><img src="resource/placeholder.png" alt="p3" id="team"></div>
                            </div>
                            <div id="abtName">
                                Ananda Rasyid Soedarmo
                            </div>
                            <div id="abtPosition">
                                Asset Design and Steno
                            </div>
                            <div id="abtSum">
                                Often works on the aspects of design and assets for a project. have also proficient note taking documentation skills. Love to learn new things.	
                            </div>
                        </div>

                        <div id="abtMember">
                            <div id="abtPhoto">
                                <div class="team"><img src="resource/placeholder.png" alt="p3" id="team"></div>
                            </div>
                            <div id="abtName">
                                Andree Yosua
                            </div>
                            <div id="abtPosition">
                                Technical Developer
                            </div>
                            <div id="abtSum">
                                Programmer and amateur 3D designer. Game developer wannabe. Interested in cartoon and game.	
                            </div>
                        </div>

                        <div id="abtSpacer">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="footer">
        Powered by ZeeTech
    </div>
</body>
</html>
