/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Editor;

import Model.DBAdmin;
import Model.User;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;

/**
 *
 * @author Deni Barasena
 */
public class SaveServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String username;
        int moduleID;
        int userID;
        
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser != null) {
            username = loggedUser.getUsername();
        } else {
            response.sendRedirect("error?code=404");
            return;
        }
        
        StringBuilder data = new StringBuilder();
        String line;
        try {
            BufferedReader reader = request.getReader();
            moduleID = Integer.parseInt(reader.readLine());
            userID = Integer.parseInt(reader.readLine());
            while ((line = reader.readLine()) != null) {
                data.append(line);
            }
        } catch (IOException | NumberFormatException e) {
            response.sendError(404, e.getMessage());
            return;
        }

        if (userID != loggedUser.getUserID() || "player".equals(loggedUser.getUserType())) {
            response.sendRedirect("error?code=404");
            return;
        }

        String path = getServletContext().getRealPath("/") + "module/"+ moduleID + "/save.json";

        File outputFile = new File(path);
        FileWriter fout = new FileWriter(outputFile);
        fout.write(data.toString() + "\n");
        fout.close();
        
        DBAdmin.moduleUpdated(moduleID);

        PrintWriter out = response.getWriter();
        try {
            out.write(path);
        } finally {
            out.close();
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
