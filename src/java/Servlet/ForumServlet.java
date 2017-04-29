package Servlet;

import Model.DBAdmin;
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
public class ForumServlet extends HttpServlet {

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
        String type;
        String sort;
        String sortFormatted;
        int pageNum;
        int threadCount;
        int lastPage;
        ArrayList<Thread> threads = new ArrayList<>();
        ArrayList<User> userList = new ArrayList<>();
        ArrayList<String> pageCount;
        ArrayList<String> pageCountUrl;

        // Parse all parameter
        type = (String) request.getParameter("type");
        if (type == null) {
            type = "default";
        }

        sort = (String) request.getParameter("sort");
        if (sort == null) {
            sort = "new";
        }

        if (sort.equalsIgnoreCase("new")) {
            sortFormatted = "Newest";
        } else if (sort.equalsIgnoreCase("today")) {
            sortFormatted = "Popular today";
        } else if (sort.equalsIgnoreCase("week")) {
            sortFormatted = "Popular this week";
        } else if (sort.equalsIgnoreCase("month")) {
            sortFormatted = "Popular this month";
        } else {
            sortFormatted = "Popular all time";
        }

        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ex) {
            pageNum = 1;
        }

        // Retrieve thread
        if (type.equalsIgnoreCase("default")) {
            threads.addAll(DBAdmin.getXForumSortedBy("general", "new", 5, 1));
            threads.addAll(DBAdmin.getXForumSortedBy("module", "new", 5, 1));
            threads.addAll(DBAdmin.getXForumSortedBy("discussion", "new", 5, 1));
            threads.addAll(DBAdmin.getXForumSortedBy("bug", "new", 5, 1));
        } else {
            threads.addAll(DBAdmin.getXForumSortedBy(type, sort, 10, pageNum));
        }

        // Get username for every thread
        for (Thread t : threads) {
            userList.add(DBAdmin.getUser(t.getUserID()));
        }

        // Calculating total page
        threadCount = threads.size();
        if (threadCount % 10 == 0) {
            lastPage = threadCount / 10;
        } else {
            lastPage = (int) Math.floorDiv(threadCount, 10) + 1;
        }

        // Create forum page url
        pageCount = generatePageCount(pageNum, lastPage);
        pageCountUrl = generatePageCountUrl(pageCount, type, sort, pageNum, lastPage);

        // Set Attribute
        request.setAttribute("type", type);
        request.setAttribute("sort", sort);
        request.setAttribute("sortFormatted", sortFormatted);
        request.setAttribute("pageNum", pageNum);
        request.setAttribute("threads", threads);
        request.setAttribute("userList", userList);
        request.setAttribute("pageCount", pageCount);
        request.setAttribute("pageCountUrl", pageCountUrl);

        // Forward to view
        request.getRequestDispatcher("forum.jsp").forward(request, response);
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

    private ArrayList<String> generatePageCountUrl(ArrayList<String> pageCount, String type, String sort, int page, int lastPage) {
        ArrayList<String> pageCountUrl = new ArrayList<>();

        for (String s : pageCount) {
            if (s.equalsIgnoreCase("<<")) {
                pageCountUrl.add(DBAdmin.WEB_URL + "forum?type=" + type + "&sort=" + sort + "&page=" + Integer.toString(1));
            } else if (s.equalsIgnoreCase("<")) {
                pageCountUrl.add(DBAdmin.WEB_URL + "forum?type=" + type + "&sort=" + sort + "&page=" + Integer.toString(page - 1));
            } else if (s.equalsIgnoreCase(">")) {
                pageCountUrl.add(DBAdmin.WEB_URL + "forum?type=" + type + "&sort=" + sort + "&page=" + Integer.toString(page + 1));
            } else if (s.equalsIgnoreCase(">>")) {
                pageCountUrl.add(DBAdmin.WEB_URL + "forum?type=" + type + "&sort=" + sort + "&page=" + Integer.toString(lastPage));
            } else {
                pageCountUrl.add(DBAdmin.WEB_URL + "forum?type=" + type + "&sort=" + sort + "&page=" + s);
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
