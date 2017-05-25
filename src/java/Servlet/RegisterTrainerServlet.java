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
import Model.MailAdmin;
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
public class RegisterTrainerServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String fullName = request.getParameter("fullname");
        String organization = request.getParameter("organization");
        String email = request.getParameter("email");
        String username = request.getParameter("username");

        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null || !loggedUser.getUserType().equals("admin")) {
            response.sendRedirect("login");
            return;
        }

        if (username == null) {
            username = fullName.replaceAll("[^A-Za-z0-9]", "");
        }

        String password = fullName.charAt(0) + "" + organization.charAt(0) + "" + ("" + (int) (Math.floor(Math.random() * 90000) + 10000)) + email.charAt(0);

        if (Pattern.compile("[^a-zA-Z0-9]").matcher(username).find()) {
            String error = "Username should be alphanumeric with no spaces.";
            request.setAttribute("error", error);
            request.setAttribute("username", username);
            request.setAttribute("type", "username");
            request.getRequestDispatcher("registertrainer.jsp").forward(request, response);
            return;
        }

        if (DBAdmin.isUsernameTaken(username)) {
            String error = "Username already used, Please use other username";
            request.setAttribute("error", error);
            request.setAttribute("username", username);
            request.setAttribute("type", "username");
            request.getRequestDispatcher("registertrainer.jsp").forward(request, response);
            return;
        }

        if (DBAdmin.register(username, email, password, "trainer", fullName, organization)) {
            User user = new User(0, username, password, email, "trainer", fullName, organization);
            user.setActivationLink(getURLWithContextPath(request) + "/login");
            MailAdmin.sendAccountConfirmedMail(user);

            DirectoryAdmin.prepNewUserDirectory(request, username);
            request.setAttribute("type", "success");
            request.setAttribute("username", username);
            request.getRequestDispatcher("registertrainer.jsp").forward(request, response);
        } else {
            String error = "Failed to create new account";

            request.setAttribute("error", error);
            request.setAttribute("username", username);
            request.setAttribute("type", "error");
            request.getRequestDispatcher("registertrainer.jsp").forward(request, response);
        }
    }

    public static String getURLWithContextPath(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
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
