/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import Model.DBAdmin;
import Model.DirectoryAdmin;
import Model.Module;
import Model.User;
import java.io.File;
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
public class EditModuleServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        User loggedUser = (User) request.getSession().getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }
        // Initialize variable
        int moduleID;
        int userID;
        Module module;
        String op = request.getParameter("op");

        // Parse all parameter
        try {
            moduleID = Integer.parseInt(request.getParameter("mid"));
        } catch (NumberFormatException ex) {
            return;
        }

        // Get Module
        module = DBAdmin.getModule(moduleID);
        if (module == null) {
            // Redirect to 404
            response.sendRedirect("main");
            return;
        }

        if (loggedUser.getUserID() != module.getUserID()) {
            response.sendRedirect("main");
            return;
        }

        System.out.println("AAA " + op);
        if ("publish".equalsIgnoreCase(op)) {
            if (loggedUser.getUserID() == module.getUserID()) {
                if( module.getReleaseTime() == null ) {
                    DBAdmin.moduleReleased(moduleID);
                } else {
                    DBAdmin.moduleUpdated(moduleID);
                }
                module = DBAdmin.getModule(moduleID);

                DirectoryAdmin.prepPublishProject(request, moduleID);
            }
        } else if ("unpublish".equalsIgnoreCase(op)) {
            System.out.println("Unpub");
            if (loggedUser.getUserID() == module.getUserID()) {
                System.out.println("unrel");
                DBAdmin.moduleUnreleased(moduleID);       
                System.out.println("unrel2");         
                module.setReleaseTime(null);
            }
        } else if ("edit".equalsIgnoreCase(op)) {
            String newName = request.getParameter("moduleName");
            String newDescription = request.getParameter("moduleDescription");

            DBAdmin.editModule(moduleID, newName, newDescription);

            module.setModuleName(newName);
            module.setModuleDescription(newDescription);

        } else if ("del".equalsIgnoreCase(op)) {
            DBAdmin.deleteModule(moduleID);
            DirectoryAdmin.deleteDirectory(new File(DirectoryAdmin.getPath(request, "/module/" + moduleID)));

            response.sendRedirect("my_modules");
            return;
        }

        boolean isSaveExist = new File(DirectoryAdmin.getPath(request, "/module/" + moduleID + "/save.json")).exists();
        boolean isPublishedSaveExist = module.getReleaseTime() != null;

        // Get Module Image
        
        int views = DBAdmin.getViews(moduleID);
        int thumbsUp = DBAdmin.getThumbsUp(moduleID);
        int thumbsDown = DBAdmin.getThumbsDown(moduleID);

        // Set Attribute
        request.setAttribute("module", module);
        request.setAttribute("isPublished", isPublishedSaveExist);
        request.setAttribute("isSaved", isSaveExist);
        request.setAttribute("views", views);
        request.setAttribute("thumbsUp", thumbsUp);
        request.setAttribute("thumbsDown", thumbsDown);

        request.getRequestDispatcher("editmodule.jsp").forward(request, response);
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
