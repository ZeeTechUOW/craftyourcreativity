
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Thread</title>
    </head>
    <body>
        <form action="createThreadServlet">
            <table>
                <tr>
                    <td>
                        Title
                    </td>
                    <td>
                        <input type="text" name="threadTitle" placeholder="Thread Title" size="50">
                    </td>
                </tr>
                <tr>
                    <td>
                        Post
                    </td>
                    <td>
                        <textarea name="threadPost" placeholder="Post" cols="50" row="5"></textarea>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" name="create" value="Create">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
