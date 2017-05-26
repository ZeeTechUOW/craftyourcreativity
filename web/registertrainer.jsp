<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String fullName = request.getParameter("fullName");
    String organization = request.getParameter("organization");
    String email = request.getParameter("email");
    String username = (String) request.getAttribute("username");
    String type = (String) request.getAttribute("type");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Approve Trainer <%=fullName%></title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/logup.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <div id="upSpacer">
        </div>
        <div id="container2" style="width: 600px; border: solid gray 1px; border-radius: 10px; text-align: center; height: auto; min-height: 0;">
            <% 
            switch (type) {
                case "success":
            %>
            <h2>Approve Successful</h2>
            <p>An email will be regarding the new account details will be sent to <%=email%></p>
            <%      
                    break;
                case "username": 
            %>
            <h2>Approving Account</h2>
            <p>
                <%=( error != null ? "Error : " + error : " (" + username + ")")%>
            </p>
            <p>Please enter a username for the new account</p>
            <form action="RegisterTrainerServlet" method="post">
                <input type="hidden" name="fullname" value="<%=fullName%>">
                <input type="hidden" name="organization" value="<%=organization%>">
                <input type="hidden" name="email" value="<%=email%>">
                
                <div class="input-lg">
                    <input type="text" class="form-control" placeholder="<%=username%>" name="username" style="width: 100%;"/>
                </div>
                
                <div class="input-lg">
                    <input type="submit" value="Submit"/>
                </div>
            </form>
            <%      
                    break;
                case "error": 
            %>
            <h2>Something went wrong</h2>
            <p>
                <%=( error != null ? "Error : " + error : " (" + username + ")")%>
            </p>
            <%      
                    break;
            }
            %>
        </div>
    </body>
</html>