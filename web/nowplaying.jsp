<%@page import="java.util.ArrayList"%>
<%@page import="Model.Module"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    String userLikeState = (String) request.getAttribute("likeState");
    Module module = (Module) request.getAttribute("module");

%>

<!DOCTYPE html><!DOCTYPE>
<html>
    <head>
        <title>Now Playing: <%=module.getModuleName()%></title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/gStruc.css">
        <script src="jquery/jquery-3.2.1.js"></script>

        <style>
            .thumbsUp,.thumbsDown {
                color: black;
            }

            <%if (loggedUser != null) {%>
            .thumbsUp.active,.thumbsDown.active {
                color: #398439;
            }
            .thumbsUp:hover,.thumbsDown:hover{
                color: #105a14;
            }
            <%} else {%>
            .thumbsUp,.thumbsDown {
                pointer-events: none;
            }
            .thumbsUp:hover,.thumbsDown:hover{
                color: black;
            }
            <%}%>
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="structure" style="padding-top: 40px">
                <div id="gTitle">
                    Now Playing: <a href="module?mid=<%=module.getModuleID()%>"><%=module.getModuleName()%></a>
                </div>

                <div id="buttonBar" class="text-center" style="width: 100%; margin: -20px 0px;">
                    <div style="width: 90%; display: inline-block; max-width: 800px; margin-top: 15px;">
                        <div class="pull-right">
                            <span style="margin: 2px 5px; font-size: 28px;"><span id="likeAmount"><%=module.getLikes()%></span> <a id='thumbsUp' href="#" onclick="if (likeClicked)
                                        likeClicked()" class="thumbsUp <%=("like".equals(userLikeState) ? "active" : "")%>"><span class="glyphicon glyphicon-thumbs-up"></span></a>
                            </span>
                                        <span style="margin: 2px 5px; font-size: 28px;"><span id="dislikeAmount"><%=module.getDislikes()%></span> <a id='thumbsDown' href="#" onclick="if (dislikeClicked)
                                        dislikeClicked()" class="thumbsDown <%=("dislike".equals(userLikeState) ? "active" : "")%>"><span class="glyphicon glyphicon-thumbs-down"></span></a>
                            </span>
                            <button id="Button" class="btn btn-default pull-right" style="margin-left: 5px;">Share</button>
                        </div>
                    </div>
                </div>
                <div id="gDisp">
                    <canvas id="gameCanvas" width="800" height="600">
                    </canvas>
                    <div id="canvasLoader">
                        <span class="glyphicon glyphicon-repeat glyphicon-spin"></span>
                        Loading Game
                    </div>
                </div>
                <div class="hidden">
                    <canvas id="certCanvas" width="800" height="600"></canvas>
                </div>

            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>

        <script src="js/bootstrap.min.js"></script>
        <script src="js/jspdf.js"></script>
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

                                var username = {type: "TEXT", value: '<%=(loggedUser == null ? "Anonymous" : loggedUser.getUsername())%>'};
                                var fullname = {type: "TEXT", value: '<%=(loggedUser == null ? "Anonymous" : loggedUser.getFullName())%>'};

                                var likeAmount = <%=module.getLikes()%>;
                                var dislikeAmount = <%=module.getDislikes()%>;

                                var player = new GamePlayer(moduleID, userID);

                                player.startGame(function () {
                                    player.game.dataVariables.username = username;
                                    player.game.dataVariables.fullname = fullname;
                                    
                                    hideLoader();

                                    $("#buttonBar>div").css("max-width", player.game.windowSize.x + "px");
                                });

                                function hideLoader() {
                                    $("#canvasLoader").fadeOut(500);
                                }



            <%
                if (loggedUser != null) {
            %>
            <%=("like".equals(userLikeState) ? "likeAmount--;" : "")%>
            <%=("dislike".equals(userLikeState) ? "dislikeAmount--;" : "")%>

                                function likeClicked() {
                                    var $thumbsUp = $("#thumbsUp");
                                    var $thumbsDown = $("#thumbsDown");
                                    var $likeAmount = $("#likeAmount");
                                    var $dislikeAmount = $("#dislikeAmount");
                                    if ($thumbsUp.hasClass("active")) {
                                        $thumbsUp.removeClass("active");
                                        $likeAmount.html(likeAmount);

                                        $.ajax({url: "LikeServlet?mid=<%=module.getModuleID()%>&value=none"});

                                    } else {
                                        $likeAmount.html(likeAmount + 1);
                                        $thumbsUp.addClass("active");

                                        if ($thumbsDown.hasClass("active")) {
                                            $thumbsDown.removeClass("active");
                                            $dislikeAmount.html(dislikeAmount);
                                        }
                                        $.ajax({url: "LikeServlet?mid=<%=module.getModuleID()%>&value=like"});
                                    }
                                }
                                function dislikeClicked() {
                                    var $thumbsUp = $("#thumbsUp");
                                    var $thumbsDown = $("#thumbsDown");
                                    var $likeAmount = $("#likeAmount");
                                    var $dislikeAmount = $("#dislikeAmount");

                                    if ($thumbsDown.hasClass("active")) {
                                        $thumbsDown.removeClass("active");
                                        $dislikeAmount.html(dislikeAmount);
                                        $.ajax({url: "LikeServlet?mid=<%=module.getModuleID()%>&value=none"});

                                    } else {
                                        $dislikeAmount.html(dislikeAmount + 1);
                                        $thumbsDown.addClass("active");

                                        if ($thumbsDown.hasClass("active")) {
                                            $thumbsUp.removeClass("active");
                                            $likeAmount.html(likeAmount);
                                        }
                                        $.ajax({url: "LikeServlet?mid=<%=module.getModuleID()%>&value=dislike"});
                                    }
                                }

                                var _UNLOCK_ACHIEVEMENT = true;
                                var _isCertified = false;
                                function _notifyAchievement(json) {
                                    $.notify("Achievement Unlocked " + json.name, {position: "bottom right", className: "success"});
                                }

                                function _ON_GAME_FINISHED(data) {
                                    var otherData = "";
                                    for( var k in data ) {
                                        if( k !== "score" ) {
                                            otherData += "&" + encodeURIComponent(k) + "=" + encodeURIComponent(data[k]);
                                        }
                                    }
                                    
                                    data._isCertified = _isCertified;
                                    data._moduleID = <%=module.getModuleID()%>;
                                    location.href = "GameFinishedServlet?mid=<%=module.getModuleID()%>&score=" + data.score + (_isCertified ? "&certs=true" : "") + otherData;
                                }

                                function _RENDER_TO_PDF(imageData, w, h) {
                                    var pdf = new jsPDF('l', 'px', [w, h]);

                                    pdf.addImage(imageData, 'JPEG', 0, 0, w, h);
                                    pdf.save("download.pdf");

                                    $.ajax({
                                        method: "POST",
                                        url: "UploadPDFServlet?mid=<%=module.getModuleID()%>&uid=<%=loggedUser.getUserID()%>",
                                        data: {data: btoa(pdf.output())}
                                    });
                                    _isCertified = true;
                                }
            <%
                }
            %>
        </script>
    </body>
</html>