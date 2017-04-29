package Servlet;

import Model.DBAdmin;
import Model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Andree Yosua
 */
public class AddThreadServlet extends HttpServlet {

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
        User loggedUser;
        String threadTitle;
        String threadType;
        String threadPost;
        Model.Thread thread;

        // Get user session
        loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Parse all parameters
        threadTitle = request.getParameter("threadTitle");
        threadType = request.getParameter("threadType");
        threadPost = request.getParameter("threadPost");
        
        System.out.println(threadTitle);
        System.out.println(threadType);
        System.out.println(threadPost);

        // Create Thread
        if (DBAdmin.createNewThread(loggedUser.getUserID(), threadTitle, threadType, threadPost)) {
            response.sendRedirect("forum");
        } else {
            // Internal server error
            response.sendError(500);
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
