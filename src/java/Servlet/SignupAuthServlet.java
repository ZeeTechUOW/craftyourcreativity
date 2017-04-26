package Servlet;

import Model.DBAdmin;
import Model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignupAuthServlet extends HttpServlet {

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

        String username = request.getParameter("usernameRegister");
        String password = request.getParameter("passwordRegister");
        String email = request.getParameter("emailRegister");
        
        if (DBAdmin.isUsernameTaken(username)) {
            String error = "Username already used, Please user other username";

            response.sendRedirect("signup?em=" + error);
        }

        User user = new User(0, username, password, email, "");

        if (!user.isEmailValid()) {
            String error = "Please use valid email address";

            response.sendRedirect("signup?em=" + error);
        } else if (!user.isPasswordValid()) {
            String error = "Password must be 8 chars long, contain at least 1 number, and no whitespace allowed";

            response.sendRedirect("signup?em=" + error);
        } else if (DBAdmin.register(username, email, password, "player")) {
            user = DBAdmin.login(username, username, password);

            request.getSession().setAttribute("loggedUser", user);

            response.sendRedirect("main");
        } else {
            String error = "Failed to create new account";

            response.sendRedirect("signup?em=" + error);
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
