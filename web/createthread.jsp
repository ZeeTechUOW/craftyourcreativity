<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
    String threadType = request.getParameter("type");

    if (loggedUser == null) {
        response.sendRedirect("login");
        return;
    }
    if (threadType == null) {
        response.sendRedirect("main");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Create Thread</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/ctStruc.css">

        <link rel="stylesheet" href="css/bootstrap.css">
        <script src="jquery/jquery-3.2.1.js"></script>
        <script src="js/bootstrap.js"></script>

        <link rel="stylesheet" href="summernote/0.8.3/summernote.css">
        <script src="summernote/0.8.3/summernote.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div id="container">
            <div id="ctStructure">
                <div id="ctTitle" style="padding: 20px"><b>Create Thread - <%=threadType%></b></div>
                <div id="ctContent">
                    <form action="addthread" method="post" id="myForm">
                        <table>
                            <tr>
                                <td style="padding-top: 10px;">
                                    Thread Title
                                </td>
                                <td>
                                    <div class="input-lg">
                                        <input type="text" class="form-control" placeholder="Thread Title" name="threadTitle" style="width: 100%;"/>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <div id="summernote"></div>
                        <input type="hidden" name="threadType" value="<%=threadType%>">
                        <textarea id="summerNoteTextID" name="threadPost" style="display: none;"></textarea>
                        <button id="Button" type="button" class="btn btn-default pull-right" onclick="submitPost()">Create New Thread</button>
                    </form>
                </div>
            </div>
        </div>

        <div id="footer">
            Powered by ZeeTech
        </div>
        <script>
            $(document).ready(function () {
                $('#summernote').summernote({
                    height: 300,
                    minHeight: null,
                    maxHeight: null,
                    focus: true
                });
            });

            function submitPost() {
                $('#summerNoteTextID').html($('#summernote').summernote('code'));
                $('#myForm').submit();
            }
        </script>
    </body>
</html>