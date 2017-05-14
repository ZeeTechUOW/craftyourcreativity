package Servlet;

import Model.DBAdmin;
import Model.DirectoryAdmin;
import Model.MailAdmin;
import Model.User;
import java.io.IOException;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Andree Yosua
 */
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
        String fullName = request.getParameter("fullName");

        if (username.isEmpty() || password.isEmpty() || email.isEmpty() || fullName.isEmpty()) {
            response.sendRedirect("signup?error=empty");
            return;
        }
        
        User user = new User(0, username, password, email, "player", fullName, "Unaffliated");

        if (!user.isEmailValid()) {
            response.sendRedirect("signup?error=invalidemail");
            return;
        }

        if (Pattern.compile("[^a-zA-Z0-9]").matcher(username).find()) {
            response.sendRedirect("signup?error=invaliduser");
            return;
        }

        if (DBAdmin.isUsernameTaken(username)) {
            response.sendRedirect("signup?error=usertaken");
            return;
        }

        if (!user.isPasswordValid()) {
            response.sendRedirect("signup?error=invalidpass");
            return;
        }

        if (DBAdmin.register(username, email, password, "player", fullName, "Unaffliated")) {
            user = DBAdmin.login(username, username, password);

            request.getSession().setAttribute("loggedUser", user);

            DirectoryAdmin.prepNewUserDirectory(request, username);

            response.sendRedirect("main");
        } else {
            response.sendRedirect("signup?error=general");
        }

    }

    public static String getURLWithContextPath(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
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
