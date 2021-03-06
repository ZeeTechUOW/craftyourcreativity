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
import Model.Module;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Andree Yosua
 */
public class MainServlet extends HttpServlet {

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

        // Initialize variable
        ArrayList<Module> modulesPopular = new ArrayList<>();
        ArrayList<Module> modulesNewest = new ArrayList<>();
        ArrayList<Module> modulesUpdate = new ArrayList<>();

        // Retrieve main module
        modulesPopular.addAll(DBAdmin.getModuleSortBy("popular"));
        modulesNewest.addAll(DBAdmin.getModuleSortBy("newest"));
        modulesUpdate.addAll(DBAdmin.getModuleSortBy("update"));

        // Remove newest module if releasedate = lastedited
        for (int i = (modulesUpdate.size() - 1); i >= 0; i--) {
            if (modulesUpdate.get(i).getLastEdited().isEqual(modulesUpdate.get(i).getReleaseTime())) {
                modulesUpdate.remove(i);
            }
        }

        // Limit module to 6
        while (modulesPopular.size() > 6) {
            modulesPopular.remove(6);
        }
        while (modulesNewest.size() > 6) {
            modulesNewest.remove(6);
        }
        while (modulesUpdate.size() > 6) {
            modulesUpdate.remove(6);
        }

        // Set Attribute
        request.setAttribute("modulesPopular", modulesPopular);
        request.setAttribute("modulesNewest", modulesNewest);
        request.setAttribute("modulesUpdate", modulesUpdate);

        // Forward to view
        request.getRequestDispatcher("main.jsp").forward(request, response);
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
