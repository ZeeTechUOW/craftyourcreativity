<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="Model.Achievement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    Module module = (Module) request.getAttribute("module");
    ArrayList<Achievement> achievements = (ArrayList<Achievement>) request.getAttribute("achievements");
    int unlockedModuleCount = (int) request.getAttribute("unlockedModuleCount");
%>
<!DOCTYPE>
<html>
    <head>
        <title><% out.print(module.getModuleName());%> Achievements</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/aStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
            <div id="container">
                <div id="aStructure">
                    <div id="aSTitle">Game: <a style="text-decoration: none;" href="module?mid=<%=module.getModuleID()%>"><% out.print(module.getModuleName()); %></a></div>
                <div id="aSList"><% out.print(unlockedModuleCount); %> of <% out.print(achievements.size()); %> unlocked</div>
                <div id="aSDisp">
                    <%
                        for (Achievement a : achievements) {
                    %>
                    <div id="aSFrame">
                        <table>
                            <tr>
                                <td>
                                    <div id="aSpic">
                                        <div class="aFrame">
                                            <%
                                                if (a.getUnlockTime() == LocalDateTime.MIN) {
                                            %>
                                            <img src="resource/lock.png" alt="a1">
                                            <%
                                            } else {
                                            %>
                                            <img src="achievementThumbs/<% out.print(a.getAchievementID());%>thumbnail" onerror="this.onerror = null; this.src = 'resource/trophy.png';" alt="a1">
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </td>
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
    </body>
</html>
