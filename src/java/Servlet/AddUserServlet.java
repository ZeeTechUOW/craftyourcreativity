/*
 * Copyright 2017 Andree Yosua.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package Servlet;

import Model.DBAdmin;
import Model.DirectoryAdmin;
import Model.User;
import java.io.IOException;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Deni Barasena
 */
public class AddUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        User loggedUser = (User) request.getSession().getAttribute("loggedUser");

        if (loggedUser == null || !"admin".equalsIgnoreCase(loggedUser.getUserType())) {
            response.sendRedirect("login");
            return;
        }

        String username = request.getParameter("usernameRegister");
        String password = request.getParameter("passwordRegister");
        String email = request.getParameter("emailRegister");
        String fullName = request.getParameter("fullName");
        String userType = request.getParameter("userType");
        String organization = request.getParameter("organization");

        if (username == null
                || password == null
                || email == null
                || fullName == null
                || organization == null
                || userType == null) {
            request.getRequestDispatcher("adduser.jsp").forward(request, response);
            return;
        }
        if (username.isEmpty()
                || password.isEmpty()
                || email.isEmpty()
                || fullName.isEmpty()
                || organization.isEmpty()
                || userType.isEmpty()) {
            request.getRequestDispatcher("adduser.jsp?error=empty").forward(request, response);
            return;
        }

        User user = new User(0, username, password, email, userType, fullName, organization);

        if (!user.isEmailValid()) {
            request.getRequestDispatcher("adduser.jsp?error=invalidemail").forward(request, response);
            return;
        }

        if (Pattern.compile("[^a-zA-Z0-9]").matcher(username).find()) {
            request.getRequestDispatcher("adduser.jsp?error=invaliduser").forward(request, response);
            return;
        }

        if (DBAdmin.isUsernameTaken(username)) {
            request.getRequestDispatcher("adduser.jsp?error=usertaken").forward(request, response);
            return;
        }

        if (!user.isPasswordValid()) {
            request.getRequestDispatcher("adduser.jsp?error=invalidpass").forward(request, response);
            return;
        }

        if (DBAdmin.register(username, email, password, userType, fullName, organization)) {
            DirectoryAdmin.prepNewUserDirectory(request, username);
        } else {
            request.getRequestDispatcher("adduser.jsp?error=general").forward(request, response);
            return;
        }

        response.sendRedirect("setting");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
