/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Editor;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Deni Barasena
 */
public class DirectoryServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String op = request.getParameter("op");
        String path = request.getParameter("path");

        if (!path.startsWith("/")) {
            path = "/" + path;
        }
        System.out.println(path);
        File folder = new File(request.getSession().getServletContext().getRealPath(path));

        if ("list".equals(op)) {
            String type = request.getParameter("filter");
            System.out.println("TYPE " + type);
            String jsonArray = "";

            String[] filter = null;
            if ("IMAGE".equals(type)) {
                filter = new String[]{".PNG", ".JPG"};
            } else if ("AUDIO".equals(type)) {
                filter = new String[]{".WAV", ".MP3"};
            }

            for (File file : folder.listFiles()) {
                System.out.println(file.getName());
                if (file.isDirectory()) {
                    if (!"".equals(jsonArray)) {
                        jsonArray += " ,";
                    }
                    jsonArray += "{\"resPath\":\"" + quote(path + file.getName()) + "\", \"fileName\":\"" + file.getName() + "\", \"isDirectory\":true}";
                }
            }
            for (File file : folder.listFiles()) {

                if (!file.isDirectory()) {
                    System.out.println(file.getName());
                    boolean isValid = true;
                    if (filter != null) {
                        isValid = false;
                        for (String s : filter) {
                            if (file.getName().toUpperCase().endsWith(s)) {
                                System.out.println(file.getName() + " is valid | " + s);
                                isValid = true;
                                break;
                            }
                        }
                    }

                    if (isValid) {
                        if (!"".equals(jsonArray)) {
                            jsonArray += " ,";
                        }
                        jsonArray += "{\"resPath\":\"" + quote(path + file.getName()) + "\", \"fileName\":\"" + file.getName() + "\", \"isDirectory\":false}";
                    }
                }
            }

            out.print(String.format("{\"files\": [%s]}", jsonArray));
        } else if ("move".equals(op)) {
            String to = request.getParameter("to");

            if (!to.startsWith("/")) {
                to = "/" + to;
            }

            if (!request.getSession().getServletContext().getRealPath(to).equals(folder.toPath())) {
                String newName = folder.getName();

                String baseName = newName;
                String extension = "";
                int i = 1;
                int n = newName.lastIndexOf('.');
                if (n > 0) {
                    extension = newName.substring(n);
                    baseName = newName.substring(0, n);
                }
                while (true) {
                    File newFile = new File(request.getSession().getServletContext().getRealPath(to), newName);

                    if (!newFile.exists()) {
                        moveFile(folder, newFile);

                        break;
                    }
                    newName = baseName + " (" + i + ")" + extension;
                    i++;
                }
            }
        } else if ("rename".equals(op)) {
            String newName = request.getParameter("newName");

            if (!folder.getName().equals(newName)) {
                String baseName = newName;
                String extension = "";
                int i = 1;
                int n = newName.lastIndexOf('.');
                if (n > 0) {
                    extension = newName.substring(n);
                    baseName = newName.substring(0, n);
                }
                while (true) {
                    File newFile = new File(folder.getParent(), newName);

                    if (!newFile.exists()) {
                        moveFile(folder, newFile);
                        break;
                    }
                    newName = baseName + " (" + i + ")" + extension;
                    i++;
                }
            }
        } else if ("delete".equals(op)) {
            out.print("Delete Folder " + folder.getAbsolutePath());

            if (folder.isDirectory()) {
                deleteDirectory(folder);
            } else {
                folder.delete();
            }
        } else if ("newFolder".equals(op)) {
            String newName = request.getParameter("newName");

            String baseName = newName;
            String extension = "";
            int i = 1;
            int n = newName.lastIndexOf('.');
            if (n > 0) {
                extension = newName.substring(n);
                baseName = newName.substring(0, n);
            }

            while (true) {
                File newFile = new File(folder, newName);

                if (!newFile.exists()) {
                    newFile.mkdir();
                    break;
                }
                newName = baseName + " (" + i + ")" + extension;
                i++;
            }
        }

        out.flush();
    }

    private void moveFile(File from, File to) {
        if (from.getAbsolutePath().equals(to.getAbsolutePath())) {
            return;
        }

        if (from.isDirectory()) {
            to.mkdir();

            for (File f : from.listFiles()) {
                moveFile(f, new File(to, f.getName()));
            }

            from.delete();
        } else {
            try {
                InputStream inStream = new FileInputStream(from);
                OutputStream outStream = new FileOutputStream(to);

                byte[] buffer = new byte[1024];

                int length;
                while ((length = inStream.read(buffer)) > 0) {
                    outStream.write(buffer, 0, length);
                }

                inStream.close();
                outStream.close();

                from.delete();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    private void deleteDirectory(File folder) {
        for (File f : folder.listFiles()) {
            if (f.isDirectory()) {
                deleteDirectory(f);
            } else {
                f.delete();
            }
        }
        folder.delete();
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

    public static String quote(String string) {
        if (string == null || string.length() == 0) {
            return "\"\"";
        }

        char c = 0;
        int i;
        int len = string.length();
        StringBuilder sb = new StringBuilder(len + 4);
        String t;

        for (i = 0; i < len; i += 1) {
            c = string.charAt(i);
            switch (c) {
                case '\\':
                case '"':
                    sb.append('\\');
                    sb.append(c);
                    break;
                case '/':
                    //                if (b == '<') {
                    sb.append('\\');
                    //                }
                    sb.append(c);
                    break;
                case '\b':
                    sb.append("\\b");
                    break;
                case '\t':
                    sb.append("\\t");
                    break;
                case '\n':
                    sb.append("\\n");
                    break;
                case '\f':
                    sb.append("\\f");
                    break;
                case '\r':
                    sb.append("\\r");
                    break;
                default:
                    if (c < ' ') {
                        t = "000" + Integer.toHexString(c);
                        sb.append("\\u" + t.substring(t.length() - 4));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}
