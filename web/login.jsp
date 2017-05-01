<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
    <head>
        <title>Log in</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/logup.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <div id="upSpacer">
        </div>
        <div id="container">
            <div id="logo">
                <div class="logo"><img src="resource/blogo.png" alt="logo"></div>
            </div>
            <form action="loginauth" method="post" style="margin-bottom: 0em">
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="Username" name="usernameLogin" style="width: 100%;"/>
                </div>
                <div class="input-lg">
                    <input type="password" class="form-control" placeholder="Password" name="passwordLogin" style="width: 100%;"/>
                </div>
                <div id="buttonBox">
                    <button id="Button" type="submit" class="btn btn-default">Login</button>
                </div>
            </form>
            <form action="signup" method="post" style="margin-bottom: 0em">
                <div id="buttonBox">
                    <button id="Button" type="submit" class="btn btn-default">Create new Account</button>
                </div>
            </form>
<!--            <div id="util">
                <button type="submit" style="border: 0; background: transparent">
                    <img src="resource/fb.png" alt="fbLogo">
                </button>
                <button type="submit" style="border: 0; background: transparent">
                    <img src="resource/tw.png" alt="twLogo">
                </button>                        
            </div>-->
        </div>
    </body>
</html>
