<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Create Thread</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/ctStruc.css">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="js/bootstrap.min.js"></script>

        <link rel="stylesheet" href="css/bootstrap.css">
        <script src="jquery/jquery-3.2.1.js"></script>
        <script src="js/bootstrap.js"></script>

        <link rel="stylesheet" href="summernote/0.8.3/summernote.css">
        <script src="summernote/0.8.3/summernote.js">

        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container">
            <div id="ctStructure">
                    <div id="ctTitle">
                        Create Thread
                    </div>
                    <div id="ctContent">
                        <form action="addthread" method="post" id="myForm">
                            <table>
                                <tr>
                                    <td>
                                        Thread Title
                                    </td>
                                    <td>
                                        <div class="input-lg">
                                            <input type="text" class="form-control" placeholder="Thread Title" name="threadTitle" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Thread Type
                                    </td>
                                    <td style="padding-left:15px;">
                                        <select id="colorOverride" name="threadType" class="selectpicker">
                                        <option value="general">General</option>
                                        <option value="module">Module</option>
                                        <option value="discussion">Discussion</option>
                                        <option value="bug">Bug</option>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            <div id="summernote"></div>
                            <script>
                                $(document).ready(function() {
                                    $('#summernote').summernote({
                                        height: 300,
                                        width: 1300,
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
                            <input type="hidden" name="threadID" value="asd">
                            <textarea id="summerNoteTextID" name="threadPost" style="display: none;"></textarea>
                            <button id="colorOverride" type="button" class="btn btn-default" onclick="submitPost()" style="font-family: tahoma; font-size: 1vw;">Create New Thread</button>
                        </form>
                    </div>
                </div>
        </div>

        <div id="footer">
        Powered by ZeeTech
        </div>
    </body>
</html>