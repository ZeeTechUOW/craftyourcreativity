
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String message = request.getParameter("me");
    String errorMessage = request.getParameter("em");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <form action="loginServlet" method="post">
            <table border="0">
                <tr>
                    <td>
                        Username
                    </td>
                    <td>
                        : <input type="text" name="usernameLogin" placeholder="Enter your username or email" size="50">
                    </td>
                </tr>
                <tr>
                    <td>
                        Password
                    </td>
                    <td>
                        : <input type="password" name="passwordLogin" placeholder="Enter your password" size="50">
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" value="Login">
                    </td>
                    <td>
                        <%
                            if(message != null) {
                                out.println(message);
                            }

                            if(errorMessage != null) {
                                out.println(errorMessage);
                            }
                        %>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
