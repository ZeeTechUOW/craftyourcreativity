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

import Model.DirectoryAdmin;
import Model.User;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author Deni Barasena
 */
public class UploadImageServlet extends HttpServlet {

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

        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        String uploadType = request.getParameter("uploadType");

        if (uploadType == null) {
            response.sendRedirect("main");
            return;
        }

        String path;

        switch (uploadType) {
            case "MODULE_THUMBNAIL":
                path = "/module/" + request.getParameter("mid") + "/thumbnail";
                break;
            case "ACHIEVEMENT_THUMBNAIL":
                path = "/achievementThumbs/" + request.getParameter("aid") + "thumbnail";
                break;
            default:
                response.sendRedirect("main");
                return;
        }

        Part imageFile = request.getPart("imageUpload");
        if (imageFile == null) {
            response.sendRedirect("main");
            return;
        }

        File file = new File(DirectoryAdmin.getPath(request, path));
        Files.copy(imageFile.getInputStream(), file.toPath(), StandardCopyOption.REPLACE_EXISTING);

        switch (uploadType) {
            case "MODULE_THUMBNAIL":
                response.sendRedirect("editmodule?mid=" + request.getParameter("mid"));
                break;
            case "ACHIEVEMENT_THUMBNAIL":
                response.sendRedirect("editachievement?mid=" + request.getParameter("mid"));
                break;
            default:
                response.sendRedirect("main");
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
