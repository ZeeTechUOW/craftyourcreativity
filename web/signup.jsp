<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
    <head>
        <title>Sign Up</title>
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
            <form action="signupauth" method="post" style="margin-bottom: 0em">
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="Username" name="usernameRegister" style="width: 100%;"/>
                </div>
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="Full Name" name="fullName" style="width: 100%;"/>
                </div>
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="Email" name="emailRegister" style="width: 100%;"/>
                </div>
                <div class="input-lg">
                    <input type="password" class="form-control" placeholder="Password" name="passwordRegister" style="width: 100%;"/>
                </div>
                <div id="buttonBox" style="margin-top: 10px">
                    <button id="Button" type="submit" class="btn btn-default" name="userType" value="player">Create Account</button>
                    <!--<button id="Button" type="submit" class="btn btn-default" name="userType" value="trainer">Create Account As Trainer</button>-->
                </div>
            </form>
<!--            <div id="util">
                <table id="subs">
                    <tr>
                        <td id="subs"><input type="checkbox" name="subscribe" value="yes"></td>
                        <td id="subs">Receive our weekly news and updates</td>
                    </tr>
                </table>
            </div>-->
            <div style="margin: 10px auto; width: 60%; border-top: solid #aaa 1px; height: 1px;"></div>
            <div id="buttonBox">
                <button id="Button" type="submit" class="btn btn-default" onclick="location= 'signup?as=trainer';">Sign Up as Trainer</button>
            </div>
            <div id="buttonBox">
                <button id="Button" type="submit" class="btn btn-default" onclick="location= 'login';">Already have an account?</button>
            </div>
        </div>
    </body>
</html>