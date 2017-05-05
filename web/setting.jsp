<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");
%>

<!DOCTYPE>
<html>
    <head>
        <title>Setting</title>
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/color1/coreF.css">
        <link rel="stylesheet" type="text/css" href="css/color1/seStruc.css">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp"></jsp:include>
        <div id="container">
            <div id="seStructure">
                <!--<div id="seSidebar">
                        <div id="seSidebarComponent">
                                Settings
                        </div>
                        <div id="seSidebarComponent">
                                Themes
                        </div>
                        <div id="seSidebarComponent">
                                About
                        </div>
                </div>-->
                <div id="seAlertBox">
                    <div class="alert alert-warning fade in alert-dismissable">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
                        <strong>Warning!</strong> Indicates a warning that might need attention.
                    </div>
                </div>
                <div id="seContent">
                    <div id="teBox">
                        <table id="setting">
                            <tr id="setting">
                                <th id="setting" colspan="2">My Account information</th>
                            </tr>
                            <tr id="setting">
                                <td id="setting">Profile Name</td>
                                <td id="setting"><% out.print(loggedUser.getUsername()); %></td>
                            </tr>
                            <tr id="setting">
                                <td id="setting">User ID</td>
                                <td id="setting"><% out.print(loggedUser.getUserID()); %></td>
                            </tr>
                        </table>
                    </div>

<!--                    <div id="seBox">
                        <div id="seAvatarBox">
                            <table>
                                <tr><td id="avatar">Avatar Icon</td></tr>
                                <tr><td id="avatar">							
                                        <div id="seAvatarDisp">
                                            <div class="avatar"><img src="resource/avates.png" alt="a1" id="team"></div>
                                        </div>
                                    </td></tr>
                            </table>
                        </div>
                        <div id="seAvatarSelect">
                            This is Avatar Selection Container
                        </div>
                    </div>-->
                    <div id="seBoxUnderline">
                        UPDATE YOUR EMAIL
                    </div>
                    <div id="seBox2">
                        <form action="changeemail" method="post">
                            <table id="form">
                                <tr>
                                    <td>
                                        <b>Email Address (must be valid):</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input type="text" class="form-control" placeholder="email@domain.com" value="<% out.print(loggedUser.getEmail()); %>" name="emailSetting" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Your Account Password:</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input type="password" class="form-control" placeholder="Password" name="passwordSetting" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <button id="Button" type="submit" class="btn btn-default">Update</button>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                    <div id="seBoxUnderline">
                        CHANGE PASSWORD
                    </div>
                    <div id="seBox2">
                        <form action="changepassword" method="post">
                            <table id="form">
                                <tr>
                                    <td>
                                        <b>Current Password:</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input type="password" class="form-control" placeholder="Old Password" name="oldPasswordSetting" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>New Password:</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input type="password" class="form-control" placeholder="New Password" name="newPassword1Setting" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" id="form">
                                        At least 8 characters long including 1 uppercase, 1 lowercase and 1 number.
                                    </td>                               
                                </tr>
                                <tr>
                                    <td>
                                        <b>Confirm New Password:</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input type="password" class="form-control" placeholder="New Password" name="newPassword2Setting" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" id="form">
                                        Re-type your new password
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                            <button id="Button" type="submit" class="btn btn-default">Change</button>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div id="footer">
            Powered by ZeeTech
        </div>
    </body>
</html>