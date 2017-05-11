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
            <div class="alert alert-warning fade in alert-dismissable">
                <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                <strong>Warning!</strong> Indicates a warning that might need attention.
            </div>
            <form action="loginauth" method="post">
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="Username" name="usernameLogin" style="width: 100%;"/>
                </div>
                <div class="input-lg">
                    <input type="password" class="form-control" placeholder="Password" name="passwordLogin" style="width: 100%;"/>
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
                <button type="submit" style="border: 0; background: transparent">
                    <img src="resource/fb.png" alt="fbLogo">
                </button>
                <button type="submit" style="border: 0; background: transparent">
                    <img src="resource/tw.png" alt="twLogo">
                </button>                        
            </div>
        </div>
    </body>
</html>
