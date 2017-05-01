<%@page import="Model.ModuleImage"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Module"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    Module module = (Module) request.getAttribute("module");
    ArrayList<ModuleImage> moduleImages = (ArrayList<ModuleImage>) request.getAttribute("moduleImages");
%>

<!DOCTYPE html><!DOCTYPE>
<html>
    <head>
        <title>Now Playing: <%=module.getModuleName()%></title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/gStruc.css">
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="structure" style="padding-top: 40px">
                <div id="gTitle">
                    Now Playing: <a href="module?mid=<%=module.getModuleID()%>"><%=module.getModuleName()%></a>
                </div>

                <div id="gDisp">
                    <canvas id="gameCanvas" width="800" height="600">
                    </canvas>
                    <div id="canvasLoader">
                        <span class="glyphicon glyphicon-repeat glyphicon-spin"></span>
                        Loading Game
                    </div>
                </div>
            </div>

        </div>


        <div id="footer">
            Powered by ZeeTech
        </div>

        <script src="jquery/jquery-3.2.1.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/pixi.js"></script>
        <script src="js/pixi-multistyle-text.js"></script>
        <script src="js/notify.js"></script>
        <script src="js/howler.js"></script>
        <script src="js/tween.js"></script>
        <script src="js/commons.js"></script>
        <script src="js/Player/Time.js"></script>
        <script src="js/Player/Game.js"></script>
        <script src="js/Player/player.js"></script>
        <script>
            var moduleID = <%=module.getModuleID()%>;
            var userID = <%=(loggedUser == null ? -1 : loggedUser.getUserID())%>;

            var player = new GamePlayer(moduleID, userID);

            player.startGame(function () {
                hideLoader();
            });

            function hideLoader() {
                $("#canvasLoader").fadeOut(500);
            }

            <%
                if (loggedUser != null) {
            %>
            var _UNLOCK_ACHIEVEMENT = true;

            function _notifyAchievement(json) {
                $.notify("Achievement Unlocked " + json.name, {position: "bottom right", className: "success"});
            }
            <%
                }
            %>
        </script>
    </body>
</html>