<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int errorID = (int) request.getAttribute("errorID");
    String message = (String) request.getAttribute("message");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error <% out.print(errorID); %></title>
    </head>
    <body>
        <h1>Error <% out.print(errorID); %> - <% out.print(message); %></h1>
    </body>
</html>
