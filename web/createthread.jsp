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
        <div id="headerSeparator">
        </div>
        <nav class="navbar navbar-findcond navbar-fixed-top" style="height: 78px">
            <div class="container" style="margin-top: 10px; position: relative; width: 80%;">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <div class="logo"><img src="resource/blogo.png" class="img-responsive" style="margin: auto; margin-top: 5px;" alt="front logo"></div>
                </div>
                <div class="collapse navbar-collapse" id="navbar">
                    <ul class="nav navbar-nav navbar-left">
                        <li class="dropdown" style="font-size: 25px">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="glyphicon glyphicon-menu-hamburger"></span> Menu 
                            <ul class="dropdown-menu" role="menu" style="background-color: #4fa78b;">
                                <li style="font-size: 25px"><a href="#">Main Menu</a></li>
                                <li style="font-size: 25px"><a href="#">Library</a></li>
                                <li style="font-size: 25px"><a href="#">My modules</a></li>
                                <li style="font-size: 25px"><a href="#">Achievements</a></li>
                                <li style="font-size: 25px"><a href="#">Leaderboards</a></li>
                                <li style="font-size: 25px"><a href="#">Forums</a></li>
                                <li style="font-size: 25px"><a href="#">Themes</a></li>
                                <li style="font-size: 25px"><a href="#">About</a></li>
                                <li style="padding-right: 5%; font-size: 25px;"><button class="button" type="button" style="float: right; background-color: #4fa78b;">
                                    <span class="glyphicon glyphicon-cog"></span></button></li>
                            </ul>
                        </li>
                    </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li class="active" style="font-size: 25px"><a href="#">Log in <span class="sr-only">(current)</span></a></li>
                            <li class="active" style="font-size: 25px"><a href="#">Sign up <span class="sr-only">(current)</span></a></li>
                        </ul>
                        <form class="navbar-form navbar-left search-form" role="search" style="position: absolute; left: 30%; right: 30%">
                            <input type="text" class="form-control" placeholder="Search" style="width: 100%;" />
                        </form>
                </div>
            </div>
        </nav>
        <div id="container">
            <div id="ctStructure">
                    <div id="ctTitle">
                        Create Thread
                    </div>
                    <div id="ctContent">
                        <table>
                            <tr>
                                <td>
                                    Thread Title
                                </td>
                                <td>
                                    <form class="navbar-form navbar-left search-form" role="search">
                                    <input type="text" class="form-control" style="font-size: 20px; width: 30vw;" />
                                    </form>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Thread Tag
                                </td>
                                <td style="padding-left:15px;">
                                    <select id="colorOverride" class="selectpicker">
                                    <option>A</option>
                                    <option>B</option>
                                    <option>C</option>
                                    <option>D</option>
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
                        <form action="createpost" method="post" id="myForm">
                            <input type="hidden" name="threadID" value="asd">
                            <textarea id="summerNoteTextID" name="summerNoteText" style="display: none;"></textarea>
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