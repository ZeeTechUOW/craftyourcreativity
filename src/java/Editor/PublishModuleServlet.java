/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Editor;

import Model.DBAdmin;
import Model.DirectoryAdmin;
import Model.Module;
import Model.User;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Deni Barasena
 */
public class PublishModuleServlet extends HttpServlet {

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
        
        int moduleID;
        int userID;
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            return;
        }

        // Parse all parameter
        try {
            moduleID = Integer.parseInt(request.getParameter("mid"));
            userID = Integer.parseInt(request.getParameter("uid"));
        } catch (NumberFormatException ex) {
            return;
        }
        
        Module module = DBAdmin.getModule(moduleID);
        
        if( userID == loggedUser.getUserID() && userID == module.getUserID() ) {
            if( module.getReleaseTime() == null ) {
                System.out.println(module.getModuleName() + " RELEASED");
                DBAdmin.moduleReleased(moduleID);
            } else {
                System.out.println(module.getModuleName() + " UPDATED");
                DBAdmin.moduleUpdated(moduleID);
            }

            File f = new File(getServletContext().getRealPath("/module/" + moduleID + "/save.json"));
            File f2 = new File(getServletContext().getRealPath("/module/" + moduleID + "/Assets"));
            File f3 = new File(getServletContext().getRealPath("/module/" + moduleID));
            File f4 = new File(getServletContext().getRealPath("/module/" + moduleID + "/Published"));
            DirectoryAdmin.deleteDirectory(f4);
            DirectoryAdmin.createNewDirectory(f3, "Published");
            DirectoryAdmin.copyAndRenameFile(f, "publishedSave.json");
            
            f4 = new File(getServletContext().getRealPath("/module/" + moduleID + "/Published"));
            DirectoryAdmin.copyFiles(f2, f4);
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
