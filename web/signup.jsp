<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String error = request.getParameter("error");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Sign Up</title>
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
                    <strong>Warning!</strong> Please fill all required field.
                </div>
                <%
                    }

                    if (error.equalsIgnoreCase("invalidemail")) {
                %>
                <div class="alert alert-warning fade in alert-dismissable">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>Warning!</strong> Email format must be valid.
                </div>
                <%
                    }

                    if (error.equalsIgnoreCase("invaliduser")) {
                %>
                <div class="alert alert-warning fade in alert-dismissable">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>Warning!</strong> Only alphanumeric char without space allowed for username.
                </div>
                <%
                    }

                    if (error.equalsIgnoreCase("usertaken")) {
                %>
                <div class="alert alert-warning fade in alert-dismissable">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>Warning!</strong> Username already taken.
                </div>
                <%
                    }

                    if (error.equalsIgnoreCase("invalid.pass")) {
                %>
                <div class="alert alert-warning fade in alert-dismissable">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>Warning!</strong> Pass must be 8 char long with uppercase, lowercase, and number.
                </div>
                <%
                    }

                    if (error.equalsIgnoreCase("general")) {
                %>
                <div class="alert alert-danger fade in alert-dismissable">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                    <strong>General Error!</strong> Contact the admin. The server might be down.
                </div>
                <%
                        }
                    }
                %>
                <form action="signupauth" method="post" style="margin-bottom: 0em">
                    <div class="input-lg">
                        <input type="text" class="form-control" placeholder="Username" name="usernameRegister" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input type="text" class="form-control" placeholder="Full Name" name="fullName" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input id="emailField" type="text" class="form-control" placeholder="Email" name="emailRegister" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input type="password" class="form-control" placeholder="Password" name="passwordRegister" style="width: 100%;"/>
                    </div>
                    <div id="buttonBox" style="margin-top: 10px">
                        <button id="Button" type="submit" class="btn btn-default" name="userType" value="player">Create Account</button>
                        <!--<button id="Button" type="submit" class="btn btn-default" name="userType" value="trainer">Create Account As Trainer</button>-->
                    </div>
                </form>
                <div style="margin: 10px auto; width: 60%; border-top: solid #aaa 1px; height: 1px;"></div>
                <div id="buttonBox">
                    <button id="Button" type="submit" class="btn btn-default" onclick="location = 'signup?as=trainer'">Sign Up as Trainer</button>
                </div>
                <div id="buttonBox">
                    <button id="Button" type="submit" class="btn btn-default" onclick="location = 'login';">Already have an account?</button>
                </div>
            </div>
        </div>
    </body>
</html>