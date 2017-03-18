
package Model;

import com.mysql.jdbc.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBAdmin {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/cyc";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "cK3rMeyG";
    
    // <editor-fold defaultstate="collapsed" desc="Query String. Click + sign on the left to expand the code">
    private static final String LOGIN_QUERY 
            = "SELECT * FROM `user` WHERE (username='%s' OR email='%s') AND password=SHA1('%s')";
    private static final String REGISTER_QUERY 
            = "INSERT INTO `user` (`userID`, `username`, `password`, `email`, `userType`, `receiveUpdates`) "
            + "VALUES (NULL, '%s', SHA1('%s'), '%s', '%s', '0')";
    
    private static final String GET_USER_FROM_USERNAME 
            = "SELECT * FROM `user` WHERE username='%s'";
    private static final String GET_USER_FROM_USER_ID 
            = "SELECT * FROM `user` WHERE userID='%d'";
    
    private static final String CREATE_NEW_THREAD 
            = "INSERT INTO `thread` (`threadID`, `userID`, `threadTitle`, `threadType`) "
            + "VALUES (NULL, '%d', '%s', '%s')";
    private static final String GET_THREAD_FROM_THREAD_ID = "SELECT * FROM `thread` WHERE threadID='%d'";
    private static final String GET_THREAD_POST_COUNT_FROM_THREAD_ID = "SELECT COUNT(postID) FROM `post` WHERE threadID=1";
    private static final String GET_THREAD_SORT_BY_NEWEST_WITH_TIMESTAMP_LIMIT_BY_X 
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID "
            + "GROUP BY p.threadID "
            + "ORDER BY p.timestamp DESC "
            + "LIMIT %d, %d";
    private static final String GET_THREAD_SORT_BY_POPULAR_TODAY_WITH_TIMESTAMP_LIMIT_BY_X 
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 DAY) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT %d, %d";
    private static final String GET_THREAD_SORT_BY_POPULAR_WEEK_WITH_TIMESTAMP_LIMIT_BY_X 
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 WEEK) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT %d, %d";
    private static final String GET_THREAD_SORT_BY_POPULAR_MONTH_WITH_TIMESTAMP_LIMIT_BY_X 
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT %d, %d";
    private static final String GET_THREAD_SORT_BY_POPULAR_ALL_TIME_WITH_TIMESTAMP_LIMIT_BY_X 
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT %d, %d";

    private static final String CREATE_NEW_POST
            = "INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) "
            + "VALUES (NULL, '%d', '%d', %d, '%s', CURRENT_TIMESTAMP)";
    private static final String CREATE_OPENING_POST
            = "INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) "
            + "VALUES (NULL, (SELECT threadID FROM thread WHERE userID='%d' ORDER BY threadID DESC LIMIT 1), '%d', %d, '%s', CURRENT_TIMESTAMP)";
    private static final String GET_POST_FROM_THREAD_ID_LIMIT_BY_X 
            = "SELECT * FROM `post` WHERE threadID='%d' LIMIT %d, %d";
    // </editor-fold>
    
    public static User login(String username, String email, String password) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(LOGIN_QUERY, username, email, password);
            ResultSet rs = statement.executeQuery(query);
            
            if(rs.next()) {
                int _userID = rs.getInt("userID");
                String _username = rs.getString("username");
                String _email = rs.getString("email");
                String _userType = rs.getString("userType");
                
                return new User(_userID, _username, "", _email, _userType);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    public static boolean register(String username, String email, String password, String userType) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(REGISTER_QUERY, username, password, email, userType);
            
            return statement.executeUpdate(query) > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        }
    }
    
    public static boolean isUsernameTaken(String username) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(GET_USER_FROM_USERNAME, username);
            ResultSet rs = statement.executeQuery(query);
            
            return rs.next();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return true;
        }
    }
    
    public static User getUserFromUserID(int userID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(GET_USER_FROM_USER_ID, userID);
            ResultSet rs = statement.executeQuery(query);
            
            if(rs.next()) {
                int _userID = rs.getInt("userID");
                String _username = rs.getString("username");
                String _email = rs.getString("email");
                String _userType = rs.getString("userType");
                
                return new User(_userID, _username, "", _email, _userType);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    public static boolean createNewThread(int userID, String threadTitle, String threadType, String message) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query1 = String.format(CREATE_NEW_THREAD, userID, threadTitle, threadType);
            String query2 = String.format(CREATE_OPENING_POST, userID, userID, 1, message);
            
            return statement.executeUpdate(query1) + statement.executeUpdate(query2) > 1;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        }
    }
    
    public static Thread getThreadFromThreadID(int threadID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(GET_THREAD_FROM_THREAD_ID, threadID);
            ResultSet rs = statement.executeQuery(query);
            
            if(rs.next()) {
                int _threadID = rs.getInt("threadID");
                int _userID = rs.getInt("userID");
                String _threadTitle = rs.getString("threadTitle");
                String _threadType = rs.getString("threadType");
                
                return new Thread(_threadID, _userID, _threadTitle, _threadType);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return null;
        }
    }
    
    public static int getThreadPostCountFromThreadID(int threadID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(GET_THREAD_POST_COUNT_FROM_THREAD_ID);
            ResultSet rs = statement.executeQuery(query);
            
            if(rs.next()) {
                return rs.getInt(1);
            } else {
                return -1;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return -1;
        }
    }
    
    public static ArrayList<Thread> getThreadListSortedBy(String sort, int page) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query;
            if(sort.equalsIgnoreCase("newest")) {
                query = String.format(GET_THREAD_SORT_BY_NEWEST_WITH_TIMESTAMP_LIMIT_BY_X, 10 * (page - 1), 10);
            } else if(sort.equalsIgnoreCase("populartoday")) {
                query = String.format(GET_THREAD_SORT_BY_POPULAR_TODAY_WITH_TIMESTAMP_LIMIT_BY_X, 10 * (page - 1), 10);
            } else if(sort.equalsIgnoreCase("popularmonth")) {
                query = String.format(GET_THREAD_SORT_BY_POPULAR_MONTH_WITH_TIMESTAMP_LIMIT_BY_X, 10 * (page - 1), 10);
            } else if(sort.equalsIgnoreCase("popularalltime")) {
                query = String.format(GET_THREAD_SORT_BY_POPULAR_ALL_TIME_WITH_TIMESTAMP_LIMIT_BY_X, 10 * (page - 1), 10);
            } else {
                query = String.format(GET_THREAD_SORT_BY_POPULAR_WEEK_WITH_TIMESTAMP_LIMIT_BY_X, 10 * (page - 1), 10);
            }
            ResultSet rs = statement.executeQuery(query);
            
            ArrayList<Thread> threads = new ArrayList<>();
            while(rs.next()) {
                int _threadID = rs.getInt("threadID");
                int _userID = rs.getInt("userID");
                String _threadTitle = rs.getString("threadTitle");
                String _threadType = rs.getString("threadType");
                LocalDateTime _threadTime = rs.getTimestamp("timestamp").toLocalDateTime();
                int _replyCount = rs.getInt("reply");
                
                threads.add(new Thread(_threadID, _userID, _threadTitle, _threadType, _threadTime, _replyCount));
            }
            
            return threads;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return new ArrayList<>();
        }
    }
    
    public static boolean createNewPost(int threadID, int userID, String message) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(CREATE_NEW_POST, threadID, userID, 0, message);
            
            return statement.executeUpdate(query) > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        }
    }
    
    public static ArrayList<Post> getPostFromThreadIDByPage(int threadID, int page) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            Statement statement = con.createStatement();
            
            String query = String.format(GET_POST_FROM_THREAD_ID_LIMIT_BY_X, threadID, 10 * (page - 1), 10);
            ResultSet rs = statement.executeQuery(query);
            
            ArrayList<Post> posts = new ArrayList<>();
            while(rs.next()) {
                int _postID = rs.getInt("postID");
                int _threadID = rs.getInt("threadID");
                int _userID = rs.getInt("userID");
                int _openingPost = rs.getInt("openingPost");
                String _message = rs.getString("message");
                LocalDateTime _postTime = rs.getTimestamp("timestamp").toLocalDateTime();
                
                posts.add(new Post(_postID, threadID, _userID, _message, _postTime));
            }
            
            return posts;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
}