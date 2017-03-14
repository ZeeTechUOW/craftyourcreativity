
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String errorMessage = request.getParameter("em");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
    </head>
    <body>
        <form action="registerServlet" method="post">
            <table border="0">
                <tr>
                    <td>
                        Username
                    </td>
                    <td>
                        : <input type="text" name="usernameRegister" placeholder="username" size="50">
                    </td>
                </tr>
                <tr>
                    <td>
                        Email
                    </td>
                    <td>
                        : <input type="text" name="emailRegister" placeholder="email@something.com" size="50">
                    </td>
                </tr>
                <tr>
                    <td>
                        Password
                    </td>
                    <td>
                        : <input type="password" name="passwordRegister" placeholder="password" size="50">
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" name="register" value="Register">
                    </td>
                    <td>
                        <%
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
