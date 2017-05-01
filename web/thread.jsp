<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.Post"%>
<%@page import="Model.Thread"%>
<%@page import="com.sun.xml.internal.ws.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String url = DBAdmin.WEB_URL;
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    int pageNum = (int) request.getAttribute("pageNum");
    int lastPage = (int) request.getAttribute("lastPage");
    ArrayList<String> pageCount = (ArrayList<String>) request.getAttribute("pageCount");
    ArrayList<String> pageCountUrl = (ArrayList<String>) request.getAttribute("pageCountUrl");

    Thread thread = (Thread) request.getAttribute("thread");
    ArrayList<Post> posts = (ArrayList<Post>) request.getAttribute("posts");
    ArrayList<User> userList = (ArrayList<User>) request.getAttribute("userList");
%>

<!DOCTYPE html>
<html>
    <head>
        <title><% out.print(thread.getThreadTitle()); %> | Page <% out.print(lastPage); %></title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/tStruc.css">
        
        <link rel="stylesheet" href="css/bootstrap.css">
        <script src="jquery/jquery-3.2.1.js"></script>
        <script src="js/bootstrap.js"></script>
        
        <link rel="stylesheet" href="summernote/0.8.3/summernote.css">
        <script src="summernote/0.8.3/summernote.js">
            
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container" style='position: absolute; min-height: calc(100% - 78px);'>
            <div id="tStructure">
                <div id="tSTitle">
                    <% out.print(thread.getThreadTitle());%>
                </div>
                <%
                    for (int i = 0; i < posts.size(); i++) {
                %>
                <div id="tThreadCore">
                    <%
                        if (i == 0) {
                    %>
                    <div id="tThreadHeader">
                        <div id="tHead">
                            <a style='text-decoration: none;' href=<% out.print(url + "forum"); %>>Forum</a> ►  <a style='text-decoration: none;' href='<% out.print(url + "forum?type=" + thread.getThreadType()); %>'><% out.print(StringUtils.capitalize(thread.getThreadType())); %></a> ►  <a style='text-decoration: none;' href="<% out.print(url + "thread?tid=" + Integer.toString(thread.getThreadID())); %>"><% out.print(thread.getThreadTitle()); %></a> 
                        </div>

                        <div id="tHeadPage">
                            <%
                                for (int p = 0; p < pageCount.size(); p++) {
                            %>
                            <a style='text-decoration: none;' href="<% out.print(pageCountUrl.get(p)); %>"><% out.print(pageCount.get(p)); %></a>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <%
                        }
                    %>
                    <div id="tPostHeader">
                        <table>
                            <tr><td><% out.print(userList.get(i).getUsername()); %></td><td><% out.print(posts.get(i).getPostTimeFormatted()); %></td></tr>
                        </table>
                    </div>
                    <div id="tPostContent">
                        <% out.print(posts.get(i).getPostMessage()); %>
                    </div>
                </div>
                <%
                    }
                %>
                <div id="tThreadBot">
                    <div id="tBot">
                        <a style='text-decoration: none;' href=<% out.print(url + "forum"); %>>Forum</a> ►  <a style='text-decoration: none;' href='<% out.print(url + "forum?type=" + thread.getThreadType()); %>'><% out.print(StringUtils.capitalize(thread.getThreadType())); %></a> ►  <a style='text-decoration: none;' href="<% out.print(url + "thread?tid=" + Integer.toString(thread.getThreadID())); %>"><% out.print(thread.getThreadTitle()); %></a> 
                    </div>
                    <div id="tBotPage">
                        <%
                            for (int p = 0; p < pageCount.size(); p++) {
                        %>
                        <a style='text-decoration: none;' href="<% out.print(pageCountUrl.get(p)); %>"><% out.print(pageCount.get(p)); %></a>
                        <%
                            }
                        %>
                    </div>
                </div>
                <div id="summernote"></div>
                <script>
                    $(document).ready(function() {
                        $('#summernote').summernote({
                            height: 300,
                            width: 1500,
                            minHeight: null,
                            maxHeight: null,
                            focus: true
                        });
                    });
                    
                    function submitPost () {
                        $('#summerNoteTextID').html($('#summernote').summernote('code'));
                        $('#myForm').submit();
                    }
                </script>
                <form action="createpost" method="post" id="myForm">
                    <input type="hidden" name="threadID" value="<% out.print(thread.getThreadID()); %>">
                    <textarea id="summerNoteTextID" name="summerNoteText" style="display: none;"></textarea>
                    <button id="Button" class="btn btn-default pull-right" type="button" onclick="submitPost()">Add Post</button>
                </form>
            </div>
        </div>
        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>
