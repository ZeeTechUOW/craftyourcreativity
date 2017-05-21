package Servlet;

import Model.DBAdmin;
import Model.DirectoryAdmin;
import Model.FBApp;
import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.Version;
import com.restfb.json.Json;
import com.restfb.json.JsonObject;
import com.restfb.types.User;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FacebookAuthServlet extends HttpServlet {

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
        
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect("login");
            return;
        }
        
        code += "#_=_";
        
        String redirectURL = DirectoryAdmin.getURLContextPath(request) + "/facebookauth";
        String authURL 
                = "https://graph.facebook.com/v2.9/oauth/access_token?"
                + "client_id=" + FBApp.APP_ID
                + "&redirect_uri=" + redirectURL
                + "&client_secret=" + FBApp.APP_SECRET
                + "&code=" + code;
        
        URL url = new URL(authURL);
        
        HttpURLConnection con =(HttpURLConnection) url.openConnection();
        con.connect();
        
        JsonObject j = Json.parse(new InputStreamReader(con.getInputStream())).asObject();
        
        String accessToken = j.getString("access_token", null);
        
        FacebookClient fbClient = new DefaultFacebookClient(accessToken, FBApp.APP_SECRET, Version.LATEST);
        User me = fbClient.fetchObject("me", User.class, Parameter.with("fields", "id,name,email"));
        
        Model.User loggedUser = DBAdmin.getFacebookUser(me.getId());
        
        if (loggedUser == null) {
            String username = me.getName().replaceAll(" ", "");
            
            if (DBAdmin.isUsernameTaken(username)) {
                int i = 1;
                while (DBAdmin.isUsernameTaken(username + i)) {
                    i++;
                }
                username += i;
            }
            
            DBAdmin.registerFacebook(me.getId(), username, "null", "", "player", me.getName(), "unaffliated");
            DirectoryAdmin.prepNewUserDirectory(request, username);

            
            loggedUser = DBAdmin.getFacebookUser(me.getId());
        }
        
        request.getSession().setAttribute("loggedUser", loggedUser);
        
        response.sendRedirect("main");
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
