<%@page import="Model.User"%>
<%@page import="Model.ModuleUserData"%>
<%@page import="Model.Module"%>
<%@page import="Model.DBAdmin"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    
    Module module = (Module) request.getAttribute("module");
    ArrayList<ModuleUserData> userDatas = (ArrayList<ModuleUserData>) request.getAttribute("userDatas");
    ArrayList<User> userList = (ArrayList<User>) request.getAttribute("userList");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Leaderboards</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/lStruc.css">
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container">
            <div id="lStructure">
                <div id="lSTitle">Game: <a style="text-decoration: none;" href="module?mid=<%=module.getModuleID()%>"><% out.print(module.getModuleName()); %></a></div>
                <div id="lSDisp">
                    <table><tr><td><b>Rank</b></td><td><b>Online ID</b></td><td><b>Score</b></td></tr></table>
                    <%
                        for (int i = 0; i < userDatas.size() && i < 20; i++) {
                    %>
                    <div id="lSFrame"><table><tr><b><td><% out.print(i + 1); %></td><td><% out.print(userList.get(i).getUsername()); %></td><td><% out.print(userDatas.get(i).getmValue()); %></td></b></tr></table></div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>