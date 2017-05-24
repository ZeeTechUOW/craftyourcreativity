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
import Model.ModuleUserData;
import Model.User;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Deni Barasena
 */
public class ListModuleServlet extends HttpServlet {

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

        String type = request.getParameter("type");
        String search = request.getParameter("search");
        String title = "";
        ArrayList<Module> modules = new ArrayList<>();

        if ("lib".equalsIgnoreCase(type)) {
            User loggedUser = (User) request.getSession().getAttribute("loggedUser");

            if (loggedUser == null) {
                response.sendRedirect("login");
                return;
            }
            // Fetch all user module library
            ArrayList<ModuleUserData> userDatas = DBAdmin.getModuleProgress(loggedUser.getUserID());

            // Get all module information
            for (ModuleUserData ud : userDatas) {
                boolean isFound = false;
                for (Module m : modules) {
                    if (m.getModuleID() == ud.getModuleID()) {
                        isFound = true;
                        break;
                    }
                }
                if (!isFound) {
                    modules.add(DBAdmin.getModule(ud.getModuleID()));
                }
            }

            title = "My Library";
        } else if ("popular".equalsIgnoreCase(type)) {
            modules.addAll(DBAdmin.getModuleSortBy("popular"));
            title = "Popular Modules";
        } else if ("newest".equalsIgnoreCase(type)) {
            modules.addAll(DBAdmin.getModuleSortBy("newest"));
            title = "Newest Release";
        } else if ("update".equalsIgnoreCase(type)) {
            modules.addAll(DBAdmin.getModuleSortBy("update"));
            title = "Modules Sorted By Latest Update";
        } else {
            modules.addAll(DBAdmin.getModuleSortBy("newest"));
        }

        if (search != null && search.length() >= 1) {
            title = "Search - " + search;

            for (int i = 0; i < modules.size(); i++) {
                Module module = modules.get(i);

                if (!module.getModuleName().toUpperCase().contains(search.toUpperCase())) {
                    modules.remove(i);
                    i--;
                }
            }
        }

        request.setAttribute("title", title);
        request.setAttribute("modules", modules);
        request.getRequestDispatcher("moduleList.jsp").forward(request, response);
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
