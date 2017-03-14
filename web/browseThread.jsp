
<%@page import="Model.DBAdmin"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Thread"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String sort;
    if(request.getParameter("sort") != null) {
        sort = request.getParameter("sort");
        
        if(!sort.contains("popular") && !sort.equalsIgnoreCase("newest")) {
            sort = "popularweek";
        }
    } else {
        sort = "popularweek";
    }
    
    ArrayList<Thread> threadsList = DBAdmin.getThreadListSortedBy(sort, 1);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=threadsList.size()%></title>
    </head>
    <body>
        <table border="0">
            <tr>
                <td>
                    <form action="main.jsp">
                        <input type="submit" value="Main Page">
                    </form>
                </td>
                <td>
                    <form action="browseThread.jsp">
                        <input type="submit" value="Sort by popular today">
                        <input type="hidden" name="sort" value="populartoday">
                    </form>
                </td>
                <td>
                    <form action="browseThread.jsp">
                        <input type="submit" value="Sort by popular this week">
                        <input type="hidden" name="sort" value="popularweek">
                    </form>
                </td>
                <td>
                    <form action="browseThread.jsp">
                        <input type="submit" value="Sort by popular this month">
                        <input type="hidden" name="sort" value="popularmonth">
                    </form>
                </td>
                <td>
                    <form action="browseThread.jsp">
                        <input type="submit" value="Sort by popular all time">
                        <input type="hidden" name="sort" value="popularalltime">
                    </form>
                </td>
                <td>
                    <form action="browseThread.jsp">
                        <input type="submit" value="Sort by Newest">
                        <input type="hidden" name="sort" value="newest">
                    </form>
                </td>
            <tr>
                <td>
                    <%=sort%>
                </td>
            </tr>
            </tr>
        </table>
        <%
            for(int i = 0; i < threadsList.size(); i++) {
        %>
        <table border="1">
            <tr>
                <td>
                    <h2><a href="http://localhost:8084/craftyourcreativity/thread.jsp?t=<% out.print(threadsList.get(i).getThreadID()); %>"><% out.print(threadsList.get(i).getThreadTitle()); %></a></h2>
                </td>
                <td>
                    <h3><% out.print(threadsList.get(i).getThreadType()); %></h3>
                </td>
            </tr>
            <tr>
                <td>
                    <h4>created by <% out.print(DBAdmin.getUserFromUserID(threadsList.get(i).getUserID()).getUsername()); %></h4>
                </td>
                <td>
                    <h4><% out.print(threadsList.get(i).getThreadTime()); %></h4>
                </td>
            </tr>
            <tr>
                <td>
                    <h4><% out.print(threadsList.get(i).getReplyCount()); %> reply</h4>
                </td>
            </tr>
        </table>
        <%
            }
        %>
    </body>
</html>
