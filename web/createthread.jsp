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
                <div id="ctAlertBox">
                </div>
                <div id="ctContent">
                    <form action="addthread" method="post" id="myForm" onsubmit="return checkInput();">
                        <table>
                            <tr>
                                <td style="padding-top: 10px;">
                                    Thread Title
                                </td>
                                <td>
                                    <div class="input-lg">
                                        <input id="titleValue" type="text" class="form-control" placeholder="Thread Title" name="threadTitle" style="width: 100%;"/>
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
                    focus: true,
                    dialogsInBody: true
                });
            });
            
            function checkInput() {
                var value = $('#titleValue').val();
                if (value.length > 0) {
                    return true;
                } else {
                    $("#ctAlertBox").html($("#blankTitleError").html());
                    return false;
                }
            }

            function submitPost() {
                var value = $('#summernote').summernote('code');
                var noWhiteSpace = value.replace(" ", "").replace(/&nbsp;/gi, "");

                if (value && $(noWhiteSpace).text().length > 0) {
                    $('#summerNoteTextID').html(value);
                    $('#myForm').submit();
                } else {
                    $("#ctAlertBox").html($("#blankPostError").html());
                }
            }
        </script>
        <div class="hidden">
            <div id="blankTitleError">
                <div class="alert alert-warning fade in alert-dismissable"> 
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                    <strong>Warning!</strong> Your thread title cannot be blank. 
                </div>
            </div>
        </div>
        <div class="hidden">
            <div id="blankPostError">
                <div class="alert alert-warning fade in alert-dismissable"> 
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                    <strong>Warning!</strong> Your thread post cannot be blank. 
                </div>
            </div>
        </div>
    </body>
</html>