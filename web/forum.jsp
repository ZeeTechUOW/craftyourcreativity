<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Thread"%>
<%@page import="com.sun.xml.internal.ws.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    String type = (String) request.getAttribute("type");
    String sort = (String) request.getAttribute("sort");
    String sortFormatted = (String) request.getAttribute("sortFormatted");
    int pageNum = (int) request.getAttribute("pageNum");
    
    ArrayList<Thread> threads = (ArrayList<Thread>) request.getAttribute("threads");
    ArrayList<User> userList = (ArrayList<User>) request.getAttribute("userList");
    ArrayList<String> pageCount = (ArrayList<String>) request.getAttribute("pageCount");
    ArrayList<String> pageCountUrl = (ArrayList<String>) request.getAttribute("pageCountUrl");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Forums</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/fStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container" style='position: absolute; min-height: calc(100% - 78px);'>
            <div id="fStructure">
                <%
                    if (type.equalsIgnoreCase("default")) {
                %>
                <div id="fSTitle">
                    <B>Forums</b>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>General</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("general")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=general"); %>">See All Threads</a></td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>Module</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("module")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=module"); %>">See All Threads</td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>Discussion</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("discussion")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=discussion"); %>">See All Threads</td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th>Bug</th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                if (threads.get(i).getThreadType().equalsIgnoreCase("bug")) {
                                    out.println("<tr>");
                                    out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                    out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                    out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                    out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                    out.println("</tr>");
                                }
                            }
                        %>
                        <tr>
                            <td></td><td><a href="<% out.println(url + "forum?type=bug"); %>">See All Threads</td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <%
                } else {
                %>
                <div id="fSTitle">
                    <div>
                        <% out.println("<B>" + StringUtils.capitalize(type) + "</b>"); %>
                    </div>
                    <div class="dropdown" style="">
                        <button id="colorOverride" class="btn dropdown-toggle" type="button" data-toggle="dropdown">Sort by <% out.print(sortFormatted); %>
                            <span class="caret"></span></button>
                        <ul id="colorOverride" class="dropdown-menu">
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=new"); %>">Newest</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=today"); %>">Popular today</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=week"); %>">Popular this week</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=month"); %>">Popular this month</a></li>
                            <li><a href="<% out.print(url + "forum?type=" + type + "&sort=all"); %>">Popular all time</a></li>
                        </ul>
                    </div>
                </div>
                <div id="fListContainer">
                    <table>
                        <tr><th><a href="<% out.print(url + "forum"); %>">Forum</a> ►  <a href="<% out.print(url + "forum?type=" + type); %>"><% out.print(StringUtils.capitalize(type)); %></a></th><th></th><th></th><th></th><th></th></tr>
                        <tr>
                            <td>Topic</td></td><td>
                            <td>Created By</td>
                            <td>Posts</td>
                            <td>Time</td>
                        </tr>
                        <%
                            for (int i = 0; i < threads.size(); i++) {
                                out.println("<tr>");
                                out.println("<td><a href=\"" + url + "thread?tid=" + threads.get(i).getThreadID() + "\">" + threads.get(i).getThreadTitle() + "</a></td></td><td>");
                                out.println("<td>" + userList.get(i).getUsername() + "</td>");
                                out.println("<td>" + threads.get(i).getReplyCount() + "</td>");
                                out.println("<td>" + threads.get(i).getThreadTimeFormatted()+ "</td>");
                                out.println("</tr>");
                            }
                        %>
                        <tr>
                            <td></td><td>
                            <%
                                for (int p = 0; p < pageCount.size(); p++) {
                            %>
                            <a style='text-decoration: none;' href="<% out.print(pageCountUrl.get(p)); %>"><% out.print(pageCount.get(p)); %></a>
                            <%
                                }
                            %>
                            </td><td></td><td></td><td></td>
                        </tr>
                    </table>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>