<%@page import="java.util.ArrayList"%>
<%@page import="Model.DBAdmin"%>
<%@page import="Model.User"%>
<%@page import="Model.Module"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    ArrayList<Module> modules = (ArrayList<Module>) request.getAttribute("modules");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Statistics</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/mStruc.css">
        <style>

            #stats  {
                padding: 1% 5%;
                margin: 10px 0px;
            }

            #stats > Table {
                padding: 5px 0px;
                table-layout: initial;
                border: none;
                border-collapse: collapse;
                padding-left: 10px;
                text-align: left;
            }

            #stats > table td, 
            #stats > table th {
                padding: 5px;
                width: auto;
            }
            #stats > table #Button {
                padding: 4px;
                font-size: smaller;
            }

            #stats > table > thead > tr {
                background-color: #458e77;
            }

            #stats > table > tbody >  tr:nth-child(odd) {
                background-color: #b2c3af;

            }
            #stats > table > tbody >  tr:nth-child(even) {
                background-color: #a3b79f;
            }
        </style>
        <script src="jquery/jquery-3.2.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="descSeparator"></div>
            <div id="structure">

                <div id="sTitle"><a href="my_modules">My Modules</a>: Statistics</div>
                <div id="stats">
                    <table>
                        <thead>
                            <tr>
                                <th>Module Name</th>
                                <th>Views</th>
                                <th>Likes</th>
                                <th>Dislikes</th>
                                <th>Last Updated</th>
                                <th>Release Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Module m : modules) {
                            %>
                            <tr>
                                <td><a href="editmodule?mid=<%=m.getModuleID()%>"><%=m.getModuleName()%></a></td>
                                <td><%=m.getViews()%></td>
                                <td><%=m.getLikes()%></td>
                                <td><%=m.getDislikes()%></td>
                                <td><%=m.getLastUpdatedFormatted()%></td>
                                <td><%=m.getReleaseTimeFormatted()%></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>