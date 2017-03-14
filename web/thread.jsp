
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.Post"%>
<%@page import="Model.Thread"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int threadID = Integer.parseInt(request.getParameter("t"));
    int threadPage;
    int threadPostCount = DBAdmin.getThreadPostCountFromThreadID(threadID);
    int threadLastPage = (int) Math.floorDiv(threadPostCount, 10) + 1;
    
    if(request.getParameter("p") != null) {
        threadPage = Integer.parseInt(request.getParameter("p"));
        
        if(threadPage < 1) {
            response.sendRedirect("thread.jsp?t=" + threadID + "&p=1");
            return;
        } else if(threadPage > threadLastPage) {
            response.sendRedirect("thread.jsp?t=" + threadID + "&p=" + threadLastPage);
            return;
        }
    } else {
        threadPage = 1;
    }
    
    if(DBAdmin.getThreadFromThreadID(threadID) == null) {
        // Send to 404
        response.sendRedirect("main.jsp");
        return;
    }
    
    Thread thread = DBAdmin.getThreadFromThreadID(threadID);
    ArrayList<Post> posts = DBAdmin.getPostFromThreadIDByPage(threadID, threadPage);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><% out.print(thread.getThreadTitle() +" | Page "+ threadPage); %></title>
    </head>
    <body>
        <table border="1" cellpadding="0" cellspacing="0">
            <tr>
                <td colspan="2">
                    <form action="main.jsp">
                        <input type="submit" value="Main Page">
                    </form>
                </td>
            </tr>
            <tr>
                <td>
                    <h3>Thread Title</h3>
                </td>
                <td>
                    <h3>Thread Type</h3>
                </td>
            </tr>
            <tr>
                <td>
                    <h1><% out.print(thread.getThreadTitle()); %></h1>
                </td>
                <td>
                    <h2><% out.print(thread.getThreadType()); %></h2>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <h3>created by <% out.print(DBAdmin.getUserFromUserID(thread.getUserID()).getUsername()); %></h3>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <h1>Post</h1>
                </td>
            </tr>
        <%
            for(int i = 0; i < posts.size(); i++) {
                out.print("<tr><td colspan=\"2\"></td></tr>");
                out.print("<tr>");
                out.print("<td colspan=\"2\">");
                out.print("#" + ((threadPage - 1) * 10 + i + 1));
                out.print("</td>");
                out.print("</tr>");
                out.print("<tr>");
                out.print("<td>");
                out.print("<h3>" + DBAdmin.getUserFromUserID(posts.get(i).getUserID()).getUsername() + "</h3>");
                out.print("</td>");
                out.print("<td>");
                out.print("<h3>" + posts.get(i).getPostTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) + "</h3>");
                out.print("</td>");
                out.print("<tr>");
                out.print("<td colspan=\"2\">");
                out.print("<h2>" + posts.get(i).getPostMessage() + "</h2>");
                out.print("</td>");
            }
            out.print("<tr><td colspan=\"2\"></td></tr>");
        %>
            <tr>
                <td colspan="2">
                    <h4>Page: <%=threadPage%></h4>
                </td>
            </tr>
            <tr>
                <td>
                    <form action="thread.jsp" method="get">
                        <input type="submit" value="<">
                        <input type="hidden" name="t" value="<%=threadID%>">
                        <input type="hidden" name="p" value="<%=(threadPage - 1)%>">
                    </form>
                </td>
                <td>
                    <form action="thread.jsp" method="get">
                        <input type="submit" value=">">
                        <input type="hidden" name="t" value="<%=threadID%>">
                        <input type="hidden" name="p" value="<%=(threadPage + 1)%>">
                    </form>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <form action="createPostServlet" method="post">
                        <input type="hidden" name="threadID" value="<%=threadID%>">
                        <textarea name="post" placeholder="Post" cols="50" row="5"></textarea>
                        <br>
                        <input type="submit" value="Post">
                    </form>
                </td>
            </tr>
        </table>
    </body>
</html>
