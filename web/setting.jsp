<%@page import="java.util.ArrayList"%>
<%@page import="Model.User"%>
<%@page import="Model.DBAdmin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User loggedUser = (User) request.getSession().getAttribute("loggedUser");

    String error = request.getParameter("error");
    String c = request.getParameter("c");
    
    ArrayList<User> users = (ArrayList<User>) request.getAttribute("users");
    if( users == null ) {
        users = new ArrayList<>();
    }
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
                    <div id="alertBox1" class="seAlertBox">
                    <%
                        if (error != null && error.equalsIgnoreCase("invalidemail")) {
                    %>
                    <div class="alert alert-danger fade in alert-dismissable"> 
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                        <strong>Error!</strong> Invalid email format!
                    </div>
                    <%
                        }

                        if (error != null && error.equalsIgnoreCase("invalidpass")) {
                    %>
                    <div class="alert alert-danger fade in alert-dismissable"> 
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                        <strong>Error!</strong> Invalid password format! Password must be at least 8 char long contains uppercase, lowercase, and number!
                    </div>
                    <%
                        }

                        if (error != null && error.equalsIgnoreCase("wrongpass")) {
                    %>
                    <div class="alert alert-danger fade in alert-dismissable"> 
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                        <strong>Warning!</strong> Wrong password!
                    </div>
                    <%
                        }

                        if (error != null && error.equalsIgnoreCase("notmatchpass")) {
                    %>
                    <div class="alert alert-danger fade in alert-dismissable"> 
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                        <strong>Warning!</strong> Confirm new password input doesn't match with new password input!
                    </div>
                    <%
                        }

                        if (c != null && c.equalsIgnoreCase("pass")) {
                    %>
                    <div class="alert alert-success fade in alert-dismissable"> 
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                        <strong>Success!</strong> Password is changed!
                    </div>
                    <%
                        }

                        if (c != null && c.equalsIgnoreCase("email")) {
                    %>
                    <div class="alert alert-success fade in alert-dismissable"> 
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                        <strong>Success!</strong> Email is changed!
                    </div>
                    <%
                        }
                    %>
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
                            <tr id="setting">
                                <td id="setting">Full Name</td>
                                <td id="setting"><% out.print(loggedUser.getFullName()); %></td>
                            </tr>
                            <%if ("trainer".equalsIgnoreCase(loggedUser.getUserType())) {%>
                            <tr id="setting">
                                <td id="setting">Organization</td>
                                <td id="setting"><% out.print(loggedUser.getOrganization()); %></td>
                            </tr>
                            <%}%>
                        </table>
                    </div>
                    <div id="seBoxUnderline">
                        UPDATE YOUR EMAIL
                    </div>
                    <div id="alertBox2" class="seAlertBox">
                    </div>
                    <div id="seBox2">
                        <form action="changeemail" method="post" onsubmit="return checkEmailInput();">
                            <table id="form">
                                <tr>
                                    <td>
                                        <b>Email Address (must be valid):</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input id="emailSetting" type="text" class="form-control" placeholder="email@domain.com" value="<% out.print(loggedUser.getEmail());%>" name="emailSetting" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Your Account Password:</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input id="passwordSetting" type="password" class="form-control" placeholder="Password" name="passwordSetting" style="width: 100%;"/>
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
                    <div id="alertBox3" class="seAlertBox">
                    </div>
                    <div id="seBox2">
                        <form action="changepassword" method="post" onsubmit="return checkPasswordInput();">
                            <table id="form">
                                <tr>
                                    <td>
                                        <b>Current Password:</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input id="oldPasswordSetting" type="password" class="form-control" placeholder="Old Password" name="oldPasswordSetting" style="width: 100%;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>New Password:</b>
                                    </td>
                                    <td colspan="2">
                                        <div class="input-lg">
                                            <input id="newPassword1Setting" type="password" class="form-control" placeholder="New Password" name="newPassword1Setting" style="width: 100%;"/>
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
                                            <input id="newPassword2Setting" type="password" class="form-control" placeholder="New Password" name="newPassword2Setting" style="width: 100%;"/>
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

                    <%
                        if ("admin".equalsIgnoreCase(loggedUser.getUserType())) {
                    %>
                    <div id="seBoxUnderline" style="display: block;">
                        USER CONTROL
                        <button id="Button" class="pull-right" onclick="location.href = 'AddUserServlet';" style="padding: 6px 10px">Add User</button>
                    </div>
                    <div id="userControl">
                        <table>
                            <thead>
                                <tr>
                                    <th>User ID</th>
                                    <th>Username</th>
                                    <th>User Type</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>

                            </thead>
                            <tbody>
                                <%for (int i = 0; i < users.size(); i++) {
                                        User user = users.get(i);
                                        if( user.getUserID() < 0 ) continue;
                                        if( "null".equalsIgnoreCase(user.getEmail()) ) continue;
                                        if( "admin".equalsIgnoreCase(user.getUserType()) ) continue;
                                        if( user.getEmail() == null || user.getEmail().length() < 1 ) continue;
                                %>
                                <tr>
                                    <td><%=user.getUserID()%></td>
                                    <td><%=user.getUsername()%></td>
                                    <td><%=user.getUserType()%></td>
                                    <td><%=user.getEmail()%></td>
                                    <td>
                                        <button id="Button" onclick="location.href = 'ResetPasswordServlet?uid=<%=user.getUserID()%>'">Reset Password</button>
                                        <button id="Button" onclick="location.href = 'DeleteUserServlet?uid=<%=user.getUserID()%>'">Delete User</button>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                    <%}%>
                </div>
            </div>
        </div>
        <div id="footer">
            Powered by ZeeTech
        </div>
        <div class="hidden">
            <div id="blankEmailError">
                <div class="alert alert-warning fade in alert-dismissable"> 
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                    <strong>Warning!</strong> Email field cannot be blank.
                </div>
            </div>
        </div>
        <div class="hidden">
            <div id="blankPasswordError">
                <div class="alert alert-warning fade in alert-dismissable"> 
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">×</a> 
                    <strong>Warning!</strong> Password field cannot be blank.
                </div>
            </div>
        </div>
        <script>
            function checkEmailInput() {
                var value = $('#emailSetting').val();
                if (value.length > 0) {
                    value = $("#passwordSetting").val();

                    if (value.length > 0) {
                        return true;
                    } else {
                        $("#alertBox2").html($("#blankPasswordError").html());
                        return false;
                    }
                } else {
                    $("#alertBox2").html($("#blankEmailError").html());
                    return false;
                }
            }

            function checkPasswordInput() {
                var value = $('#oldPasswordSetting').val();
                if (value.length > 0) {
                    value = $("#newPassword1Setting").val();

                    if (value.length > 0) {
                        value = $("newPassword2Setting").val();

                        if (value.length > 0) {
                            return true;
                        } else {
                            $("#alertBox3").html($("#blankPasswordError").html());
                            return false;
                        }

                        return true;
                    } else {
                        $("#alertBox3").html($("#blankPasswordError").html());
                        return false;
                    }
                } else {
                    $("#alertBox3").html($("#blankPasswordError").html());
                    return false;
                }
            }
        </script>
    </body>
</html>