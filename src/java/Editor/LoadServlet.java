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
package Editor;

import Model.DirectoryAdmin;
import Model.User;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Deni Barasena
 */
public class LoadServlet extends HttpServlet {

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

        int projectID;
        int userID;
        String username;

        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser != null) {
            username = loggedUser.getUsername();
        } else {
            response.sendError(500, "NO USER");
            return;
        }

        try {
            projectID = Integer.parseInt(request.getParameter("mid"));
            userID = Integer.parseInt(request.getParameter("uid"));
        } catch (NumberFormatException ex) {
            response.sendError(500, "NO PARAMS " + request.getParameter("mid") + " | " + request.getParameter("uid"));
            return;
        }

        if (userID != loggedUser.getUserID() || "player".equals(loggedUser.getUserType())) {
            response.sendError(500, "User Not Matched " + userID + " | " + loggedUser.getUserID());
            return;
        }

        try (PrintWriter out = response.getWriter()) {
//            File inputFile = new File(getServletContext().getRealPath("/") + "module/" + projectID + "/save.json");
            File inputFile = new File(DirectoryAdmin.getPath(request, "module/" + projectID + "/save.json"));

            if (inputFile.exists()) {
                try (Scanner scanner = new Scanner(inputFile)) {
                    while (scanner.hasNextLine()) {
                        out.println(scanner.nextLine());
                    }
                }
            }
        }
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
