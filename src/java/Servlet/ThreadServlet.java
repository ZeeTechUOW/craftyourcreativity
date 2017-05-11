package Servlet;

import Model.DBAdmin;
import Model.Post;
import Model.Thread;
import Model.User;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Andree Yosua
 */
public class ThreadServlet extends HttpServlet {

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

        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        
        // Initialize variable
        int id;
        int pageNum;
        int postCount;
        int lastPage;
        ArrayList<Post> posts;
        ArrayList<User> userList;
        ArrayList<String> pageCount;
        ArrayList<String> pageCountUrl;

        // Validate thread id and page parameter
        try {
            id = Integer.parseInt(request.getParameter("tid"));
        } catch (NumberFormatException ex) {
            // Send to 404
            response.sendRedirect("error?code=404");
            return;
        }

        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ex) {
            pageNum = 1;
        }

        // Calculating total page
        postCount = DBAdmin.getThreadPostCount(id);
        if (postCount % 10 == 0) {
            lastPage = postCount / 10;
        } else {
            lastPage = (int) Math.floorDiv(postCount, 10) + 1;
        }

        // Checking page
        if (pageNum < 1) {
            pageNum = 1;
        } else if (pageNum > lastPage) {
            pageNum = lastPage;
        }

        // Retrieve thread and posts
        Thread thread = DBAdmin.getThread(id);
        if (thread == null) {
            // Send to 404
            response.sendRedirect("error?code=404");
            return;
        }
        
        if( loggedUser != null ) {
            posts = DBAdmin.getThreadPost(loggedUser.getUserID(), id, pageNum);
        } else {
            posts = DBAdmin.getThreadPost(id, pageNum);
        }
        
        // Get username for every post
        userList = new ArrayList<>();
        for (Post p : posts) {
            userList.add(DBAdmin.getUser(p.getUserID()));
        }

        // Create thread page url
        pageCount = generatePageCount(pageNum, lastPage);
        pageCountUrl = generatePageCountUrl(pageCount, id, pageNum, lastPage);

        // Set attribute
        request.setAttribute("postCount", postCount);
        request.setAttribute("pageNum", pageNum);
        request.setAttribute("lastPage", lastPage);
        request.setAttribute("thread", thread);
        request.setAttribute("posts", posts);
        request.setAttribute("userList", userList);
        request.setAttribute("pageCount", pageCount);
        request.setAttribute("pageCountUrl", pageCountUrl);

        // Forward
        request.getRequestDispatcher("thread.jsp").forward(request, response);
    }

    private ArrayList<String> generatePageCount(int page, int lastPage) {
        ArrayList<String> pageCount = new ArrayList<>();

        if (lastPage <= 5) {
            for (int i = 1; i <= lastPage; i++) {
                pageCount.add(Integer.toString(i));
            }
        } else {
            if (page <= 3) {
                pageCount.add(Integer.toString(1));
                pageCount.add(Integer.toString(2));
                pageCount.add(Integer.toString(3));

                if (page + 10 < lastPage) {
                    pageCount.add(Integer.toString(page + 10));
                }
                pageCount.add(">");
                pageCount.add(">>");
            } else if (page >= lastPage - 2) {
                pageCount.add("<<");
                pageCount.add("<");
                if (page > 10) {
                    pageCount.add(Integer.toString(page - 10));
                }

                pageCount.add(Integer.toString(lastPage - 2));
                pageCount.add(Integer.toString(lastPage - 1));
                pageCount.add(Integer.toString(lastPage));
            } else {
                pageCount.add("<<");
                pageCount.add("<");
                if (page > 10) {
                    pageCount.add(Integer.toString(page - 10));
                }

                pageCount.add(Integer.toString(page - 1));
                pageCount.add(Integer.toString(page));
                pageCount.add(Integer.toString(page + 1));

                if (page + 10 < lastPage) {
                    pageCount.add(Integer.toString(page + 10));
                }
                pageCount.add(">");
                pageCount.add(">>");
            }
        }

        return pageCount;
    }

    private ArrayList<String> generatePageCountUrl(ArrayList<String> pageCount, int id, int page, int lastPage) {
        ArrayList<String> pageCountUrl = new ArrayList<>();

        for (String s : pageCount) {
            if (s.equalsIgnoreCase("<<")) {
                pageCountUrl.add("thread?tid=" + Integer.toString(id) + "&page=1");
            } else if (s.equalsIgnoreCase("<")) {
                pageCountUrl.add("thread?tid=" + Integer.toString(id) + "&page=" + Integer.toString(page - 1));
            } else if (s.equalsIgnoreCase(">")) {
                pageCountUrl.add("thread?tid=" + Integer.toString(id) + "&page=" + Integer.toString(page + 1));
            } else if (s.equalsIgnoreCase(">>")) {
                pageCountUrl.add("thread?tid=" + Integer.toString(id) + "&page=" + Integer.toString(lastPage));
            } else {
                pageCountUrl.add("thread?tid=" + Integer.toString(id) + "&page=" + s);
            }
        }

        return pageCountUrl;
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
