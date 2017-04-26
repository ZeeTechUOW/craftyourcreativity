package Servlet;

import Model.DBAdmin;
import Model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CreatePostServlet extends HttpServlet {

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

        int threadID;
        
        try {
            threadID = Integer.parseInt(request.getParameter("threadID"));
        } catch (NumberFormatException ex) {
            response.sendError(404);
            return;
        }
        
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        String message = request.getParameter("summerNoteText");

        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        if (DBAdmin.createNewPost(threadID, loggedUser.getUserID(), message)) {
            // Calculating Last Page
            int postCount = DBAdmin.getThreadPostCount(threadID);
            int lastPage;
            
            if (postCount % 10 == 0) {
                lastPage = postCount / 10;
            } else {
                lastPage = (int) Math.floorDiv(postCount, 10) + 1;
            }
            response.sendRedirect("thread?tid=" + threadID + "&page=" + lastPage);
        } else {
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