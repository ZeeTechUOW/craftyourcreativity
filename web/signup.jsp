<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
    <head>
        <title>Sign Up</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/logup.css">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <div id="upSpacer">
        </div>
        <div id="container">
            <div id="logo">
                <div class="logo"><img src="resource/blogo.png" alt="logo"></div>
            </div>
            <div id="title">Sign Up</div>
            <form action="signupauth" method="post" style="margin-bottom: 0em">
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="Username" name="usernameRegister" style="width: 100%;"/>
                </div>
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="Email" name="emailRegister" style="width: 100%;"/>
                </div>
                <div class="input-lg">
                    <input type="password" class="form-control" placeholder="Password" name="passwordRegister" style="width: 100%;"/>
                </div>
                <div id="buttonBox">
                    <button id="Button" type="submit" class="btn btn-default">Sign me up!</button>
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
            <form action="login" method="post" style="margin-bottom: 0em">
                <div id="buttonBox">
                    <button id="Button" type="submit" class="btn btn-default">You have an acoount!</button>
                </div>
            </form>
        </div>
    </body>
</html>