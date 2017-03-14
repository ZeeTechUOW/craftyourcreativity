
<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    
    if(loggedUser == null) {
        String errorMessage = "Please Login";
        response.sendRedirect("login.jsp?em=" + errorMessage);
        return;
    }
    
    int userID = loggedUser.getUserID();
    String username = loggedUser.getUsername();
    String email = loggedUser.getEmail();
    String userType = loggedUser.getUserType();
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Main</title>
    </head>
    <body>
        <table border="0">
            <tr>
                <td>
                    ID
                </td>
                <td>
                    : <%=userID%>
                </td>
            </tr>
            <tr>
                <td>
                    Username
                </td>
                <td>
                    : <%=username%>
                </td>
            </tr>
            <tr>
                <td>
                    Email
                </td>
                <td>
                    : <%=email%>
                </td>
            </tr>
            <tr>
                <td>
                    Role
                </td>
                <td>
                    : <%=userType%>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>
                    
                </td>
                <td>
                    <form action="logoutServlet" method="get">
                        <input type="submit" value="Logout">
                    </form>
                </td>
            </tr>
            <tr>
                <td>
                    
                </td>
                <td>
                    <form action="createThread.jsp" method="get">
                        <input type="submit" value="Create Thread">
                    </form>
                </td>
            </tr>
            <tr>
                <form action="thread.jsp" method="get">
                    <td>
                        <input type="text" name="t" placeholder="Insert Thread ID">
                    </td>
                    <td>
                        <input type="submit" value="Go to Thread">
                    </td>
                </form>
            </tr>
            <tr>
                <td>
                    
                </td>
                <td>
                    <form action="browseThread.jsp" method="get">
                        <input type="submit" value="Browse Thread">
                    </form>
                </td>
            </tr>
        </table>
        
    </body>
</html>
