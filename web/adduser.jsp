<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String error = request.getParameter("error");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Sign Up</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/logup.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="container2">
                <h1>
                    Add User
                </h1>
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
                <form action="AddUserServlet" method="post" style="margin-bottom: 0em" autocomplete="false">
                    <input type="text" style="display:none">
                    <input type="password" style="display:none">
                    <div class="input-lg">
                        <input type="text" class="form-control" placeholder="Username" name="usernameRegister" autocomplete="new-user" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input type="text" class="form-control" placeholder="Full Name" name="fullName" autocomplete="off" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input id="emailField" type="text" class="form-control" placeholder="Email" name="emailRegister" autocomplete="off" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input id="organizationField" type="text" class="form-control" placeholder="Organization" name="organization" autocomplete="off" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <input type="password" class="form-control" placeholder="Password" name="passwordRegister" autocomplete="new-password" style="width: 100%;"/>
                    </div>
                    <div class="input-lg">
                        <select name="userType" class="form-control" style="width: 100%" autocomplete="off" >
                            <option value="player" selected>Player</option>
                            <option value="trainer">Trainer</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    <div id="buttonBox" style="margin-top: 10px">
                        <button id="Button" type="submit" class="btn btn-default" >Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>