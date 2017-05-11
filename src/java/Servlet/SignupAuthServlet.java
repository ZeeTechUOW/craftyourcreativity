package Servlet;

import Model.DBAdmin;
import Model.DirectoryAdmin;
import Model.MailAdmin;
import Model.User;
import java.io.IOException;
import java.util.Properties;
import java.util.regex.Pattern;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
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

        String username = request.getParameter("usernameRegister");
        String password = request.getParameter("passwordRegister");
        String email = request.getParameter("emailRegister");
        String fullName = request.getParameter("fullName");
        String as = request.getParameter("as");
        String organization = request.getParameter("organization");

        User user = new User(0, username, password, email, "trainer", fullName, organization);

        if (!user.isEmailValid()) {
            String error = "Please use valid email address";

            response.sendRedirect("signup?em=" + error);
            return;
        }

        if ("trainer".equals(as)) {
            user.setActivationLink(getURLWithContextPath(request) + "/RegisterTrainerServlet");

            MailAdmin.sendAccountRequestMail(user);
            request.setAttribute("user", user);

            request.getRequestDispatcher("signuptrainerwait.jsp").forward(request, response);

        } else {
            if (Pattern.compile("[^a-zA-Z0-9]").matcher(username).find()) {
                String error = "Username should be alphanumeric with no spaces.";

                response.sendRedirect("signup?em=" + error);
                return;
            }

            if (DBAdmin.isUsernameTaken(username)) {
                String error = "Username already used, Please use other username";

                response.sendRedirect("signup?em=" + error);
                return;
            }

            if (!user.isPasswordValid()) {
                String error = "Password must be 8 chars long, contain at least 1 number, and no whitespace allowed";

                response.sendRedirect("signup?em=" + error);
                return;
            }

            if (DBAdmin.register(username, email, password, "player", fullName, "Unaffliated")) {
                user = DBAdmin.login(username, username, password);

                request.getSession().setAttribute("loggedUser", user);

                DirectoryAdmin.prepNewUserDirectory(request.getServletContext().getRealPath("/users/" + username));

                response.sendRedirect("main");
            } else {
                String error = "Failed to create new account";

                response.sendRedirect("signup?em=" + error);
            }
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
