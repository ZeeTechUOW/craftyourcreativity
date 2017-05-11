<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User user = (User) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login");
        return;
    }

%>

<!DOCTYPE>
<html>
    <head>
        <title>Sign Up As Trainer</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/logup.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <div id="upSpacer">
        </div>
        <div id="container" style="width: 500px; text-align: center">
            <h2>Trainer Registration Request Sent</h2>
            <div style="height: 5px"></div>
            <p>An email will be sent to <%=user.getEmail()%> when our team have approved the application.</p>
            <div style="height: 40px"></div>
            <div id="buttonBox">
                <button id="Button" type="submit" class="btn btn-default" onclick="location = 'login';">Login</button>
            </div>
        </div>
    </body>
</html>