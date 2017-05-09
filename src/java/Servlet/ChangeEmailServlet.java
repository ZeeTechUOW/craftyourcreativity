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
public class ChangeEmailServlet extends HttpServlet {

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
        String email;
        String password;

        // Get user session
        loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        // Get email and password field
        email = request.getParameter("emailSetting");
        password = request.getParameter("passwordSetting");

        // Email validation
        User temp = new User(0, "", "", email, "");
        System.out.println(temp.isEmailValid());
        if (!temp.isEmailValid()) {
            response.sendRedirect("setting?error=invalidemail");
            return;
        }

        // Change user email
        if (DBAdmin.updateUserEmail(loggedUser.getUserID(), password, email)) {
            // Get updated user
            loggedUser = (User) DBAdmin.getUser(loggedUser.getUserID());

            // Set loggedUser to session
            request.getSession().setAttribute("loggedUser", loggedUser);

            // Redirect to setting page
            response.sendRedirect("setting");
        } else {
            // Wrong password
            response.sendRedirect("setting?error=wrongpass");
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
