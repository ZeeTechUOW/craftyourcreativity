/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Deni Barasena
 */
public class DirectoryAdmin {

    public static void prepNewUserDirectory(String userPath) {
        File f = new File(userPath);
        f.mkdir();
        createNewDirectory(f, "certs");
    }

    public static void prepNewProjectDirectory(String modulePath, String moduleID, File templateFolder) {
        File f = new File(modulePath);

        if (!f.exists()) {
            f.mkdir();
        }

        copyFiles(templateFolder, f);
        renameFile(new File(f, templateFolder.getName()), moduleID);
    }

    public static void createNewDirectory(File folder, String newName) {
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

    public static void copyAndRenameFile(File file, String newName) throws IOException {
        OutputStream outStream;
        try (InputStream inStream = new FileInputStream(file)) {
            outStream = new FileOutputStream(new File(file.getParentFile(), newName));
            
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inStream.read(buffer)) > 0) {
                outStream.write(buffer, 0, length);
            }
            
            outStream.close();
        } catch (FileNotFoundException ex) {
            Logger.getLogger(DirectoryAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void moveFiles(File from, File to) {
        moveCopyFiles(from, to, true);
    }

    public static void copyFiles(File from, File to) {
        moveCopyFiles(from, to, false);
    }

    public static void moveCopyFiles(File from, File to, boolean isMoving) {
        if (!to.toPath().equals(from.toPath())) {
            String newName = from.getName();

            String baseName = newName;
            String extension = "";
            int i = 1;
            int n = newName.lastIndexOf('.');
            if (n > 0) {
                extension = newName.substring(n);
                baseName = newName.substring(0, n);
            }
            while (true) {
                File newFile = new File(to.toPath().toString(), newName);

                if (!newFile.exists()) {
                    moveCopyFile(from, newFile, isMoving);

                    break;
                }
                newName = baseName + " (" + i + ")" + extension;
                i++;
            }
        }
    }

    public static void deleteFile(File file) {
        if (file.isDirectory()) {
            deleteDirectory(file);
        } else {
            file.delete();
        }
    }

    public static void renameFile(File file, String newName) {
        if (!file.getName().equals(newName)) {
            String baseName = newName;
            String extension = "";
            int i = 1;
            int n = newName.lastIndexOf('.');
            if (n > 0) {
                extension = newName.substring(n);
                baseName = newName.substring(0, n);
            }
            while (true) {
                File newFile = new File(file.getParent(), newName);

                if (!newFile.exists()) {
                    moveFile(file, newFile);
                    break;
                }
                newName = baseName + " (" + i + ")" + extension;
                i++;
            }
        }
    }

    public static String listDirectoryToJSON(File folder, String path, String type) {
        if (!path.startsWith("/")) {
            path = "/" + path;
        }

        String jsonArray = "";

        String[] filter = null;
        if ("IMAGE".equals(type)) {
            filter = new String[]{".PNG", ".JPG"};
        } else if ("AUDIO".equals(type)) {
            filter = new String[]{".WAV", ".MP3"};
        }

        for (File file : folder.listFiles()) {
            if (file.isDirectory()) {
                if (!"".equals(jsonArray)) {
                    jsonArray += " ,";
                }
                jsonArray += "{\"resPath\":\"" + quote(path + file.getName()) + "\", \"fileName\":\"" + file.getName() + "\", \"isDirectory\":true}";
            }
        }
        for (File file : folder.listFiles()) {
            if (!file.isDirectory()) {
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
        return jsonArray;
    }

    public static void moveFile(File from, File to) {
        moveCopyFile(from, to, true);
    }

    public static void copyFile(File from, File to) {
        moveCopyFile(from, to, false);
    }

    private static void moveCopyFile(File from, File to, boolean isMoving) {
        if (from.getAbsolutePath().equals(to.getAbsolutePath())) {
            return;
        }

        if (from.isDirectory()) {
            to.mkdir();

            for (File f : from.listFiles()) {
                moveCopyFile(f, new File(to, f.getName()), isMoving);
            }

            if (isMoving) {
                from.delete();
            }
        } else {
            try {
                OutputStream outStream;
                try (InputStream inStream = new FileInputStream(from)) {
                    outStream = new FileOutputStream(to);
                    byte[] buffer = new byte[1024];
                    int length;
                    while ((length = inStream.read(buffer)) > 0) {
                        outStream.write(buffer, 0, length);
                    }
                }
                outStream.close();

                if (isMoving) {
                    from.delete();
                }
            } catch (IOException e) {
            }
        }
    }

    public static void deleteDirectory(File folder) {
        for (File f : folder.listFiles()) {
            if (f.isDirectory()) {
                deleteDirectory(f);
            } else {
                f.delete();
            }
        }
        folder.delete();
    }

    private static String quote(String string) {
        if (string == null || string.length() == 0) {
            return "\"\"";
        }

        char c;
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
                        sb.append("\\u").append(t.substring(t.length() - 4));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }

}
