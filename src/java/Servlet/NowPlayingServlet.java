/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import Model.DBAdmin;
import Model.Module;
import Model.ModuleImage;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Deni Barasena
 */
public class NowPlayingServlet extends HttpServlet {

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
        
        // Initialize variable
        int moduleID;
        Module module;
        ArrayList<ModuleImage> moduleImages = new ArrayList<>();

        // Parse all parameter
        try {
            moduleID = Integer.parseInt(request.getParameter("mid"));
        } catch (NumberFormatException ex) {
            // Redirect to 404
            response.sendRedirect("error?code=404");
            return;
        }

        // Get Module
        module = DBAdmin.getModule(moduleID);
        if (module == null) {
            // Redirect to 404
            response.sendRedirect("error?code=404");
            return;
        }

        // Get Module Image
        moduleImages.addAll(DBAdmin.getModuleImage(moduleID));

        // Set Attribute
        request.setAttribute("module", module);
        request.setAttribute("moduleImages", moduleImages);
        
        
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if( loggedUser != null ) {
            DBAdmin.addView(loggedUser.getUserID(), module.getModuleID());
        } else {
            DBAdmin.addView(module.getModuleID());
        }
        

        request.getRequestDispatcher("nowplaying.jsp").forward(request, response);
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
