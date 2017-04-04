<%-- 
    Document   : main
    Created on : 29/03/2017, 6:32:21 PM
    Author     : Andree Yosua
--%>

<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");

    // TO DO: redirect to index.jsp with error message
    if (loggedUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int userID = loggedUser.getUserID();
    String username = loggedUser.getUsername();
    String email = loggedUser.getEmail();
    String userType = loggedUser.getUserType();
%>

<title>Craft Your Creativity</title>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/mStruc.css">
    </head>
    <body>
        <div id="headerSeparator">
        </div>
        <div id="header">
            <div id="hLogo">
                <div class="logo"><img src="resource/blogo.png" alt="front logo"></div>
            </div>
        </div>

        <div id="container">
            <div id="structure">
                <div id="sTitle">
                    TEST #1
                </div>
                <div id="sMore">
                    BUTTON POSITION
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f1" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f2" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f3" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f4" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f5" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f6" id="team"></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="structure">
                <div id="sTitle">
                    TEST #2
                </div>
                <div id="sMore">
                    BUTTON POSITION
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f1" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f2" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f3" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f4" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f5" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f6" id="team"></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="structure">
                <div id="sTitle">
                    TEST #3
                </div>
                <div id="sMore">
                    BUTTON POSITION
                </div>
                <div id="sDisp">
                    <table>
                        <tr>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f1" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f2" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f3" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f4" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder1.png" alt="f5" id="team"></div>
                                </div>
                            </td>
                            <td>
                                <div id="sFrame">
                                    <div class="frame"><img src="resource/placeholder2.png" alt="f6" id="team"></div>
                                </div>
                            </td>
                        </tr>
                    </table>
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