<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String error = request.getParameter("error");
    
    String fbAuthURL = (String) request.getAttribute("fbAuthURL");
    String twitAuthURL = (String) request.getAttribute("twitAuthURL");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Log in</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/logup.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="headerlogin.jsp"/>
        <div id="container">
            <div id="container2">
                <div id="logo">
                    <img class="img-responsive" src="resource/blogo.png" alt="logo">
                </div>
                <%
                    if (error != null) {
                        if (error.equalsIgnoreCase("empty")) {
                %>
                <div class="alert alert-warning fade in alert-dismissable">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>Warning!</strong> Please fill both username and password.
                </div>
                <%
                    }

                    if (error.equalsIgnoreCase("invalid")) {
                %>
                <div class="alert alert-danger fade in alert-dismissable">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>Login error!</strong> Username or password is invalid.
                </div>
                <%
                        }
                    }
                %>
                <form action="loginauth" method="post">
                    <div class="input-lg">
                        <input id="usernameLogin" type="text" class="form-control" placeholder="Username" name="usernameLogin" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input id="passwordLogin" type="password" class="form-control" placeholder="Password" name="passwordLogin" style="width: 100%;"/>
                    </div>
                    <div id="buttonBox" style="margin-top: 10px">
                        <button id="Button" type="submit" class="btn btn-default" style="margin-bottom: 0px">Login</button>
                    </div>
                </form>
                <form action="signup" method="post">
                    <div id="buttonBox">
                        <button id="Button" type="submit" class="btn btn-default">Create new Account</button>
                    </div>
                </form>
                <div id="util">
                    <a href="<% out.print(fbAuthURL); %>">
                        <button type="submit" style="border: 0; background: transparent">
                            <img style='width: 100%' class="img-responsive" src="resource/fb.png" alt="fbLogo">
                        </button>    
                    </a>
                        <a href="<% out.print(twitAuthURL); %>">
                            <button type="submit" style="border: 0; background: transparent">
                                <img style='width: 100%' class="img-responsive" src="resource/tw.png" alt="twLogo">
                            </button>   
                        </a>       
                </div>
            </div>
        </div>
    </body>
</html>
