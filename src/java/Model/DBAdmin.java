package Model;

import com.mysql.jdbc.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBAdmin {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/cyc";
    private static final String DB_USER = "root";
//    private static final String DB_PASS = ""; // Local machine DB Pass
    private static final String DB_PASS = "uvUqdU9n"; // DENI GCP machine DB Pass
//    private static final String DB_PASS = "cK3rMeyG"; // Andree GCP machine DB Pass

    // <editor-fold defaultstate="collapsed" desc="Query String. Click + sign on the left to expand the code">
    // User Query
    private static final String LAST_ID = "SELECT LAST_INSERT_ID();";

    private static final String LOGIN
            = "SELECT * "
            + "FROM `user` "
            + "WHERE (username=? OR email=?) AND password=SHA1(?)";
    private static final String REGISTER
            = "INSERT INTO `user` (`userID`, `username`, `password`, `email`, `userType`, `fullname`, `organization`) "
            + "VALUES (NULL, ?, SHA1(?), ?, ?, ?, ?)";
    private static final String REGISTER_FACEBOOK_ID
            = "INSERT INTO `userfacebook` (`userID`, `facebookID`) "
            + "VALUES (?, ?)";
    private static final String REGISTER_TWITTER_ID
            = "INSERT INTO `usertwitter` (`userID`, `twitterID`) "
            + "VALUES (?, ?)";
    private static final String GET_ALL_USERS
            = "SELECT * "
            + "FROM `user` ";
    private static final String GET_USER_FROM_USERNAME
            = "SELECT * "
            + "FROM `user` "
            + "WHERE username=?";
    private static final String GET_USER_FROM_USER_ID
            = "SELECT * "
            + "FROM `user` "
            + "WHERE userID=?";
    private static final String UPDATE_USER_EMAIL
            = "UPDATE `user` "
            + "SET email=? "
            + "WHERE userID=? AND password=SHA1(?)";
    private static final String UPDATE_USER_PASSWORD
            = "UPDATE `user` "
            + "SET password=SHA1(?) "
            + "WHERE userID=? AND password=SHA1(?)";
    private static final String RESET_USER_PASSWORD
            = "UPDATE `user` "
            + "SET password=SHA1(?) "
            + "WHERE userID=?";
    private static final String GET_ADMIN_EMAIL
            = "SELECT `email` FROM `user` "
            + "WHERE userType = 'admin'";
    private static final String GET_USER_FROM_FACEBOOK_ID
            = "SELECT u.userID, u.username, u.email, u.userType, u.fullname, u.organization "
            + "FROM user u, userfacebook uf "
            + "WHERE u.userID = uf.userID AND uf.facebookID=?";
    private static final String GET_USER_FROM_TWITTER_ID
            = "SELECT u.userID, u.username, u.email, u.userType, u.fullname, u.organization "
            + "FROM user u, usertwitter ut "
            + "WHERE u.userID = ut.userID AND ut.twitterID=?";

    // Thread Query
    private static final String CREATE_NEW_THREAD
            = "INSERT INTO `thread` (`threadID`, `userID`, `threadTitle`, `threadType`) "
            + "VALUES (NULL, ?, ?, ?)";
    private static final String GET_THREAD_FROM_THREAD_ID
            = "SELECT * "
            + "FROM `thread` "
            + "WHERE threadID=?";
    private static final String GET_THREAD_POST_COUNT_FROM_THREAD_ID
            = "SELECT COUNT(postID) "
            + "FROM `post` "
            + "WHERE threadID=?";

    private static final String GET_TYPE_THREAD_SORT_BY_NEWEST_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType LIKE ? "
            + "GROUP BY p.threadID "
            + "ORDER BY p.timestamp DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_TODAY_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType LIKE ? AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 DAY) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_WEEK_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType LIKE ? AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 WEEK) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_MONTH_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType LIKE ? AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_ALL_TIME_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType LIKE ? "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT ?, ?";

    // Post Query
    private static final String CREATE_NEW_POST
            = "INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) "
            + "VALUES (NULL, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
    private static final String CREATE_OPENING_POST
            = "INSERT INTO `post` (`postID`, `threadID`, `userID`, `openingPost`, `message`, `timestamp`) "
            + "VALUES (NULL, (SELECT threadID FROM thread WHERE userID=? ORDER BY threadID DESC LIMIT 1), ?, ?, ?, CURRENT_TIMESTAMP)";
    private static final String GET_POST_FROM_THREAD_ID_LIMIT_BY_X
            = "SELECT *, "
            + "(SELECT COUNT(*) "
            + "FROM `postuserdata` d "
            + "WHERE p.postID = d.postID "
            + "AND d.mKey = 'lstate' "
            + "AND d.mValue = 'like') "
            + "AS likes, "
            + "(SELECT COUNT(*) "
            + "FROM `postuserdata` d "
            + "WHERE p.postID = d.postID "
            + "AND d.mKey = 'lstate' "
            + "AND d.mValue = 'dislike') "
            + "AS dislikes "
            + "FROM `post` p "
            + "WHERE p.threadID = ? "
            + "LIMIT ?, ?";
    private static final String GET_POST_FROM_THREAD_ID_WITH_USER_LIKES_LIMIT_BY_X
            = "SELECT *, "
            + "(SELECT COUNT(*) "
            + "FROM `postuserdata` d "
            + "WHERE p.postID = d.postID "
            + "AND d.mKey = 'lstate' "
            + "AND d.mValue = 'like') "
            + "AS likes, "
            + "(SELECT COUNT(*) "
            + "FROM `postuserdata` d "
            + "WHERE p.postID = d.postID "
            + "AND d.mKey = 'lstate' "
            + "AND d.mValue = 'dislike') "
            + "AS dislikes, "
            + "(SELECT mValue "
            + "FROM `postuserdata` d "
            + "WHERE p.postID = d.postID "
            + "AND d.mKey = 'lstate' "
            + "AND d.userID = ?) "
            + "AS userLikes "
            + "FROM `post` p "
            + "WHERE p.threadID = ? "
            + "LIMIT ?, ?";
    private static final String DELETE_POST_BY_ID 
            = "DELETE FROM `post` "
            + "WHERE `postID` = ?";
    // Module Query
    private static final String CREATE_NEW_MODULE
            = "INSERT INTO `module` (`moduleID`, `userID`, `moduleName`, `moduleDescription`, `releaseTime`, `lastEdited`) "
            + "VALUES (NULL, ?, ?, ?, NULL, CURRENT_TIMESTAMP);";
    private static final String GET_ALL_MODULE_SORT_BY_POPULAR_VIEW
            = "SELECT m.moduleID, m.userID, m.moduleName, m.moduleDescription, m.releaseTime, m.lastEdited, COUNT(v.moduleID) AS viewCount "
            + "FROM module m, views v "
            + "WHERE m.moduleID = v.moduleID "
            + "AND m.releaseTime > 0 "
            + "GROUP BY m.moduleID "
            + "ORDER BY viewCount DESC";
    private static final String GET_ALL_MODULE_SORT_BY_NEWEST_RELEASE
            = "SELECT * "
            + "FROM `module` "
            + "WHERE releaseTime > 0 "
            + "ORDER BY `releaseTime` DESC";
    private static final String GET_ALL_MODULE_SORT_BY_NEWEST_UPDATE
            = "SELECT * "
            + "FROM `module` "
            + "WHERE releaseTime > 0 "
            + "ORDER BY `lastEdited` DESC";
    private static final String GET_ALL_MODULE_BY_USER_ID
            = "SELECT * "
            + "FROM `module` "
            + "WHERE userID = ? "
            + "ORDER BY `lastEdited` DESC";
    private static final String GET_MODULE_FROM_MODULE_ID
            = "SELECT *, "
            + "(SELECT COUNT(*) "
            + "FROM `moduleuserdata` d "
            + "WHERE m.moduleID = d.moduleID "
            + "AND d.mKey = 'lstate' "
            + "AND d.mValue = 'like') "
            + "AS likes, "
            + "(SELECT COUNT(*) "
            + "FROM `moduleuserdata` d "
            + "WHERE m.moduleID = d.moduleID "
            + "AND d.mKey = 'lstate' "
            + "AND d.mValue = 'dislike') "
            + "AS dislikes "
            + "FROM `module` m "
            + "WHERE m.moduleID=?";
    private static final String ADD_VIEW_TO_MODULE
            = "INSERT INTO `views` (`userID`, `moduleID`, `time`) "
            + "VALUES (?, ?, CURRENT_TIMESTAMP)";
    private static final String MODULE_UPDATED
            = "UPDATE `module` "
            + "SET `lastEdited` = CURRENT_TIMESTAMP "
            + "WHERE `moduleID` = ?";
    private static final String MODULE_RELEASED
            = "UPDATE `module` "
            + "SET `releaseTime` = CURRENT_TIMESTAMP "
            + ", `lastEdited` = CURRENT_TIMESTAMP "
            + "WHERE `moduleID` = ?";
    private static final String UPDATE_MODULE
            = "UPDATE `module` "
            + "SET `moduleName` = ? "
            + ", `moduleDescription` = ? "
            + "WHERE `moduleID` = ?";
    private static final String DELETE_MODULE_BY_ID
            = "DELETE FROM `module` "
            + "WHERE `moduleID` = ?";

    // Genre Query
    private static final String SET_MODULE_GENRE
            = "INSERT INTO `genre` (`moduleID`, `genre`) "
            + "VALUES (?, ?)";

    private static final String GET_MODULE_GENRE_FROM_MODULE_ID
            = "SELECT `genre` "
            + "FROM `genre` "
            + "WHERE moduleID=?";

    private static final String DELETE_ALL_GENRE_FROM_MODULE_ID
            = "DELETE FROM `genre` "
            + "WHERE moduleID=?";

    // Achievement Query
    private static final String GET_ALL_ACHIEVEMENTS_FROM_MODULE_ID
            = "SELECT * "
            + "FROM `achievement` "
            + "WHERE moduleID=?";

    private static final String GET_ALL_USER_ACHIEVEMENT_FROM_USER_ID
            = "SELECT * "
            + "FROM `userachievement` "
            + "WHERE userID=?";
    private static final String UPDATE_ACHIEVEMENT
            = "UPDATE `achievement` "
            + "SET `achievementName` = ? "
            + ", `achievementDescription` = ? "
            + "WHERE `achievementID` = ? "
            + "AND `moduleID` = ?;";
    private static final String DELETE_ACHIEVEMENT_BY_ID
            = "DELETE FROM `achievement` "
            + "WHERE `achievementID` = ? "
            + "AND `moduleID` = ?;";
    private static final String ADD_ACHIEVEMENT
            = "INSERT INTO `achievement` (`moduleID`, `achievementName`, `achievementDescription`) "
            + "VALUES (?, ?, ?)";
    private static final String UNLOCK_ACHIEVEMENT
            = "INSERT INTO `userachievement` (`userID`, `achievementID`, `time`) "
            + "VALUES (?, ?, CURRENT_TIMESTAMP)";
    private static final String CHECK_ACHIEVEMENT
            = "SELECT * FROM `userachievement` "
            + "WHERE `userID` = ? "
            + "AND `achievementID` = ? ";
    private static final String GET_ACHIEVEMENT
            = "SELECT * FROM `achievement` WHERE `achievementID` = ?";

    // Module user data Query
    private static final String GET_ALL_USER_DATA_FROM_MODULE_ID
            = "SELECT * "
            + "FROM `moduleuserdata` "
            + "WHERE moduleID=? AND mKey=?";

    private static final String GET_USER_DATA_FROM_MODULE_ID
            = "SELECT * "
            + "FROM `moduleuserdata` "
            + "WHERE userID=?";

    private static final String GET_ALL_END_DATAS_FROM_MODULE_ID
            = "SELECT * "
            + "FROM `moduleenddata` "
            + "WHERE moduleID=?";

    private static final String UPDATE_USER_MODULE_DATA
            = "INSERT INTO `moduleuserdata` (`userID`, `moduleID`, `mKey`, `mValue`, `timestamp`) "
            + "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP) "
            + "ON DUPLICATE KEY UPDATE "
            + "mValue = VALUES(mValue)";

    private static final String SET_LIKE_TO_MODULE
            = "INSERT INTO `moduleuserdata` (`userID`, `moduleID`, `mKey`, `mValue`) "
            + "VALUES (?, ?, 'lstate', ?) "
            + "ON DUPLICATE KEY UPDATE "
            + "mValue = ?";
    private static final String SET_LIKE_TO_POST
            = "INSERT INTO `postuserdata` (`userID`, `postID`, `mKey`, `mValue`) "
            + "VALUES (?, ?, 'lstate', ?) "
            + "ON DUPLICATE KEY UPDATE "
            + "mValue = ?";
    private static final String GET_MODULE_USER_DATA
            = "SELECT * FROM `moduleuserdata` "
            + "WHERE moduleID = ? "
            + "AND userID = ? "
            + "AND mKey = ?";
    private static final String GET_POST_USER_DATA
            = "SELECT * FROM `postuserdata` "
            + "WHERE postID = ? "
            + "AND userID = ? "
            + "AND mKey = ?";
    // </editor-fold>

    // User method
    public static User login(String username, String email, String password) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(LOGIN);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, password);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _userID = resultSet.getInt("userID");
                String _username = resultSet.getString("username");
                String _email = resultSet.getString("email");
                String _userType = resultSet.getString("userType");
                String _fullName = resultSet.getString("fullname");
                String _organization = resultSet.getString("organization");
                return new User(_userID, _username, "", _email, _userType, _fullName, _organization);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    
    public static boolean register(String username, String email, String password, String userType, String fullName, String organization) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(REGISTER);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, userType);
            preparedStatement.setString(5, fullName);
            preparedStatement.setString(6, organization);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean registerFacebook(String facebookID, String username, String email, String password, String userType, String fullName, String organization) {
        Connection connection = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement1 = connection.prepareStatement(REGISTER);
            preparedStatement1.setString(1, username);
            preparedStatement1.setString(2, password);
            preparedStatement1.setString(3, email);
            preparedStatement1.setString(4, userType);
            preparedStatement1.setString(5, fullName);
            preparedStatement1.setString(6, organization);

            if (preparedStatement1.executeUpdate() > 0) {
                resultSet = connection.createStatement().executeQuery(LAST_ID);
                resultSet.next();
                int userID = resultSet.getInt(1);

                preparedStatement2 = connection.prepareStatement(REGISTER_FACEBOOK_ID);
                preparedStatement2.setInt(1, userID);
                preparedStatement2.setString(2, facebookID);

                return preparedStatement2.executeUpdate() > 0;
            } else {
                return false;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement1);
            closePreparedStatement(preparedStatement2);
            closeResultSet(resultSet);
        }
    }
    
    public static boolean registerTwitter(String twitterID, String username, String email, String password, String userType, String fullName, String organization) {
        Connection connection = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement1 = connection.prepareStatement(REGISTER);
            preparedStatement1.setString(1, username);
            preparedStatement1.setString(2, password);
            preparedStatement1.setString(3, email);
            preparedStatement1.setString(4, userType);
            preparedStatement1.setString(5, fullName);
            preparedStatement1.setString(6, organization);

            if (preparedStatement1.executeUpdate() > 0) {
                resultSet = connection.createStatement().executeQuery(LAST_ID);
                resultSet.next();
                int userID = resultSet.getInt(1);

                preparedStatement2 = connection.prepareStatement(REGISTER_TWITTER_ID);
                preparedStatement2.setInt(1, userID);
                preparedStatement2.setString(2, twitterID);

                return preparedStatement2.executeUpdate() > 0;
            } else {
                return false;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement1);
            closePreparedStatement(preparedStatement2);
            closeResultSet(resultSet);
        }
    }
    
    public static boolean isUsernameTaken(String username) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_USER_FROM_USERNAME);
            preparedStatement.setString(1, username);

            resultSet = preparedStatement.executeQuery();

            return resultSet.next();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return true;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    public static ArrayList<User> getAllUsers() {
        ArrayList<User> users = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_ALL_USERS);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _userID = resultSet.getInt("userID");
                String _username = resultSet.getString("username");
                String _email = resultSet.getString("email");
                String _userType = resultSet.getString("userType");
                String _fullName = resultSet.getString("fullname");
                String _organization = resultSet.getString("organization");

                users.add(new User(_userID, _username, "", _email, _userType, _fullName, _organization));
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return users;
    }
    
    public static User getUser(int userID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_USER_FROM_USER_ID);
            preparedStatement.setInt(1, userID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _userID = resultSet.getInt("userID");
                String _username = resultSet.getString("username");
                String _email = resultSet.getString("email");
                String _userType = resultSet.getString("userType");
                String _fullName = resultSet.getString("fullname");
                String _organization = resultSet.getString("organization");

                return new User(_userID, _username, "", _email, _userType, _fullName, _organization);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    
    public static boolean updateUserEmail(int userID, String password, String email) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(UPDATE_USER_EMAIL);
            preparedStatement.setString(1, email);
            preparedStatement.setInt(2, userID);
            preparedStatement.setString(3, password);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }
    
    public static boolean updateUserPassword(int userID, String password, String newPassword) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(UPDATE_USER_PASSWORD);
            preparedStatement.setString(1, newPassword);
            preparedStatement.setInt(2, userID);
            preparedStatement.setString(3, password);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }
    
    public static boolean resetUserPassword(int userID, String newPassword) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(RESET_USER_PASSWORD);
            preparedStatement.setString(1, newPassword);
            preparedStatement.setInt(2, userID);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static User getFacebookUser(String facebookID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_USER_FROM_FACEBOOK_ID);
            preparedStatement.setString(1, facebookID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _userID = resultSet.getInt("userID");
                String _username = resultSet.getString("username");
                String _email = resultSet.getString("email");
                String _userType = resultSet.getString("userType");
                String _fullName = resultSet.getString("fullname");
                String _organization = resultSet.getString("organization");

                return new User(_userID, _username, "", _email, _userType, _fullName, _organization);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    
    public static User getTwitterUser(String twitterID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_USER_FROM_TWITTER_ID);
            preparedStatement.setString(1, twitterID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _userID = resultSet.getInt("userID");
                String _username = resultSet.getString("username");
                String _email = resultSet.getString("email");
                String _userType = resultSet.getString("userType");
                String _fullName = resultSet.getString("fullname");
                String _organization = resultSet.getString("organization");

                return new User(_userID, _username, "", _email, _userType, _fullName, _organization);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }

    // Thread method
    public static int createNewThread(int userID, String threadTitle, String threadType, String message) {
        Connection connection = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement1 = connection.prepareStatement(CREATE_NEW_THREAD);
            preparedStatement1.setInt(1, userID);
            preparedStatement1.setString(2, threadTitle);
            preparedStatement1.setString(3, threadType);

            preparedStatement2 = connection.prepareStatement(CREATE_OPENING_POST);
            preparedStatement2.setInt(1, userID);
            preparedStatement2.setInt(2, userID);
            preparedStatement2.setInt(3, 1);
            preparedStatement2.setString(4, message);

            preparedStatement1.executeUpdate();
            
            resultSet = connection.createStatement().executeQuery(LAST_ID);
            resultSet.next();
            int threadID = resultSet.getInt(1);

            preparedStatement2.executeUpdate();

            return threadID;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return -1;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement1);
            closePreparedStatement(preparedStatement2);
            closeResultSet(resultSet);
        }
    }
    
    public static Thread getThread(int threadID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            preparedStatement = connection.prepareStatement(GET_THREAD_FROM_THREAD_ID);
            preparedStatement.setInt(1, threadID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _threadID = resultSet.getInt("threadID");
                int _userID = resultSet.getInt("userID");
                String _threadTitle = resultSet.getString("threadTitle");
                String _threadType = resultSet.getString("threadType");

                return new Thread(_threadID, _userID, _threadTitle, _threadType);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    
    public static int getThreadPostCount(int threadID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_THREAD_POST_COUNT_FROM_THREAD_ID);
            preparedStatement.setInt(1, threadID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                return -1;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return -1;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    
    public static ArrayList<Thread> getXForumSortedBy(String type, String sort, int size, int page) {
        ArrayList<Thread> threads = new ArrayList<>();

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            if (sort.equalsIgnoreCase("new")) {
                preparedStatement = connection.prepareStatement(GET_TYPE_THREAD_SORT_BY_NEWEST_WITH_TIMESTAMP_LIMIT_BY_X);
            } else if (sort.equalsIgnoreCase("today")) {
                preparedStatement = connection.prepareStatement(GET_TYPE_THREAD_SORT_BY_POPULAR_TODAY_WITH_TIMESTAMP_LIMIT_BY_X);
            } else if (sort.equalsIgnoreCase("month")) {
                preparedStatement = connection.prepareStatement(GET_TYPE_THREAD_SORT_BY_POPULAR_MONTH_WITH_TIMESTAMP_LIMIT_BY_X);
            } else if (sort.equalsIgnoreCase("all")) {
                preparedStatement = connection.prepareStatement(GET_TYPE_THREAD_SORT_BY_POPULAR_ALL_TIME_WITH_TIMESTAMP_LIMIT_BY_X);
            } else {
                preparedStatement = connection.prepareStatement(GET_TYPE_THREAD_SORT_BY_POPULAR_WEEK_WITH_TIMESTAMP_LIMIT_BY_X);
            }
            preparedStatement.setString(1, type + "%");
            preparedStatement.setInt(2, size * (page - 1));
            preparedStatement.setInt(3, size);

            resultSet = preparedStatement.executeQuery();
            
            while (resultSet.next()) {
                int _threadID = resultSet.getInt("threadID");
                int _userID = resultSet.getInt("userID");
                String _threadTitle = resultSet.getString("threadTitle");
                String _threadType = resultSet.getString("threadType");
                LocalDateTime _threadTime = resultSet.getTimestamp("timestamp").toLocalDateTime();
                int _replyCount = resultSet.getInt("reply");

                threads.add(new Thread(_threadID, _userID, _threadTitle, _threadType, _threadTime, _replyCount));
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return threads;
    }

    // Post method
    public static boolean createNewPost(int threadID, int userID, String message) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(CREATE_NEW_POST);
            preparedStatement.setInt(1, threadID);
            preparedStatement.setInt(2, userID);
            preparedStatement.setInt(3, 0);
            preparedStatement.setString(4, message);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }
    
    public static ArrayList<Post> getThreadPost(int threadID, int page) {
        ArrayList<Post> posts = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_POST_FROM_THREAD_ID_LIMIT_BY_X);
            preparedStatement.setInt(1, threadID);
            preparedStatement.setInt(2, 10 * (page - 1));
            preparedStatement.setInt(3, 10);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _postID = resultSet.getInt("postID");
                int _threadID = resultSet.getInt("threadID");
                int _userID = resultSet.getInt("userID");
                int _openingPost = resultSet.getInt("openingPost");
                int _likes = resultSet.getInt("likes");
                int _dislikes = resultSet.getInt("dislikes");
                String _message = resultSet.getString("message");
                LocalDateTime _postTime = resultSet.getTimestamp("timestamp").toLocalDateTime();

                posts.add(new Post(_postID, threadID, _userID, _message, _postTime, _likes, _dislikes));
            }

            return posts;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return posts;
    }

    public static ArrayList<Post> getThreadPost(int userID, int threadID, int page) {
        ArrayList<Post> posts = new ArrayList<>();

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_POST_FROM_THREAD_ID_WITH_USER_LIKES_LIMIT_BY_X);
            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, threadID);
            preparedStatement.setInt(3, 10 * (page - 1));
            preparedStatement.setInt(4, 10);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _postID = resultSet.getInt("postID");
                int _threadID = resultSet.getInt("threadID");
                int _userID = resultSet.getInt("userID");
                int _openingPost = resultSet.getInt("openingPost");
                int _likes = resultSet.getInt("likes");
                int _dislikes = resultSet.getInt("dislikes");
                String _userLikes = resultSet.getString("userLikes");
                String _message = resultSet.getString("message");
                LocalDateTime _postTime = resultSet.getTimestamp("timestamp").toLocalDateTime();

                Post p = new Post(_postID, threadID, _userID, _message, _postTime, _likes, _dislikes);
                p.setUserLikes(_userLikes);
                posts.add(p);
            }

            return posts;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return posts;
    }
    
    public static boolean deletePost(int postID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(DELETE_POST_BY_ID);
            preparedStatement.setInt(1, postID);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    // Module method
    public static int createNewModule(int userID, String moduleName, String moduleDescription) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(CREATE_NEW_MODULE);
            preparedStatement.setInt(1, userID);
            preparedStatement.setString(2, moduleName);
            preparedStatement.setString(3, moduleDescription);

            preparedStatement.execute();

            resultSet = connection.createStatement().executeQuery(LAST_ID);
            resultSet.next();
            return resultSet.getInt(1);

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return -1;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    
    public static ArrayList<Module> getModuleSortBy(String sort) {
        ArrayList<Module> modules = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            if (sort.equalsIgnoreCase("popular")) {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_POPULAR_VIEW);
            } else if (sort.equalsIgnoreCase("release")) {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_NEWEST_RELEASE);
            } else if (sort.equalsIgnoreCase("update")) {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_NEWEST_UPDATE);
            } else {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_NEWEST_RELEASE);
            }

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                int _userID = resultSet.getInt("userID");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();

                Timestamp t = resultSet.getTimestamp("releaseTime");

                if (t != null) {
                    LocalDateTime _releaseTime = t.toLocalDateTime();
                    modules.add(new Module(_moduleID, _userID, _moduleName, _moduleDescription, _releaseTime, _lastEdited, 0, 0));
                } else {
                    modules.add(new Module(_moduleID, _userID, _moduleName, _moduleDescription, null, _lastEdited, 0, 0));
                }

            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
             closeConnection(connection);
             closePreparedStatement(preparedStatement);
             closeResultSet(resultSet);
        }

        return modules;
    }

    public static Module getModule(int moduleID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_MODULE_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                int _userID = resultSet.getInt("userID");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();
                int _likes = resultSet.getInt("likes");
                int _dislikes = resultSet.getInt("dislikes");
                Timestamp t = resultSet.getTimestamp("releaseTime");

                if (t != null) {
                    LocalDateTime _releaseTime = t.toLocalDateTime();
                    return new Module(_moduleID, _userID, _moduleName, _moduleDescription, _releaseTime, _lastEdited, _likes, _dislikes);
                } else {
                    return new Module(_moduleID, _userID, _moduleName, _moduleDescription, null, _lastEdited, _likes, _dislikes);
                }

            }

            return null;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }
    
    public static boolean setModuleGenre(int moduleID, ArrayList<String> genres) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            int statementExecuteCount = 0;
            
            preparedStatement = connection.prepareStatement(DELETE_ALL_GENRE_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            statementExecuteCount += preparedStatement.executeUpdate();

            for (String genre : genres) {
                preparedStatement = connection.prepareStatement(SET_MODULE_GENRE);
                preparedStatement.setInt(1, moduleID);
                preparedStatement.setString(2, genre);

                statementExecuteCount += preparedStatement.executeUpdate();
            }

            return statementExecuteCount > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static ArrayList<String> getModuleGenre(int moduleID) {
        ArrayList<String> genres = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_MODULE_GENRE_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                genres.add(resultSet.getString("genre"));
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return genres;
    }

    // Achievement method
    public static ArrayList<Achievement> getAllAchievement(int moduleID) {
        ArrayList<Achievement> achievements = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_ALL_ACHIEVEMENTS_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _achievementID = resultSet.getInt("achievementID");
                int _moduleID = resultSet.getInt("moduleID");
                String _achievementName = resultSet.getString("achievementName");
                String _achievementDescription = resultSet.getString("achievementDescription");

                achievements.add(new Achievement(_achievementID, moduleID, _achievementName, _achievementDescription, ""));
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return achievements;
    }
    
    public static ArrayList<Achievement> getAllAchievement(int moduleID, int userID) {
        ArrayList<Achievement> achievements = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement1 = connection.prepareStatement(GET_ALL_ACHIEVEMENTS_FROM_MODULE_ID);
            preparedStatement1.setInt(1, moduleID);

            preparedStatement2 = connection.prepareStatement(GET_ALL_USER_ACHIEVEMENT_FROM_USER_ID);
            preparedStatement2.setInt(1, userID);

            resultSet = preparedStatement1.executeQuery();

            while (resultSet.next()) {
                int _achievementID = resultSet.getInt("achievementID");
                int _moduleID = resultSet.getInt("moduleID");
                String _achievementName = resultSet.getString("achievementName");
                String _achievementDescription = resultSet.getString("achievementDescription");

                achievements.add(new Achievement(_achievementID, moduleID, _achievementName, _achievementDescription, ""));
            }

            resultSet = preparedStatement2.executeQuery();

            while (resultSet.next()) {
                for (Achievement a : achievements) {
                    if (a.getAchievementID() == resultSet.getInt("achievementID")) {
                        a.setUnlocked(true);
                        a.setUnlockTime(resultSet.getTimestamp("time").toLocalDateTime());
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement1);
            closePreparedStatement(preparedStatement2);
            closeResultSet(resultSet);
        }

        return achievements;
    }

    // Module user data method
    public static ArrayList<ModuleUserData> getModuleHighScore(int moduleID) {
        ArrayList<ModuleUserData> userDatas = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_ALL_USER_DATA_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);
            preparedStatement.setString(2, "score");

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleId");
                int _userID = resultSet.getInt("userID");
                String _mKey = resultSet.getString("mKey");
                String _mValue = resultSet.getString("mValue");

                userDatas.add(new ModuleUserData(_moduleID, _userID, _mKey, _mValue));
            }

            Collections.sort(userDatas, ModuleUserData.sortByScoreDesc);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return userDatas;
    }

    public static ArrayList<ModuleUserData> getModuleProgress(int userID) {
        ArrayList<ModuleUserData> userDatas = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareCall(GET_USER_DATA_FROM_MODULE_ID);
            preparedStatement.setInt(1, userID);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleId");
                int _userID = resultSet.getInt("userID");
                String _mKey = resultSet.getString("mKey");
                String _mValue = resultSet.getString("mValue");

                userDatas.add(new ModuleUserData(_moduleID, _userID, _mKey, _mValue));
            }

            Collections.sort(userDatas, ModuleUserData.sortByModuleIDAsc);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return userDatas;
    }

    public static boolean addView(int moduleID) {
        return DBAdmin.addView(-1, moduleID);
    }

    public static boolean addView(int userID, int moduleID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(ADD_VIEW_TO_MODULE);
            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, moduleID);

            return preparedStatement.executeUpdate() == 1;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static ArrayList<Module> getModulesByUserID(int userID) {
        ArrayList<Module> modules = new ArrayList<>();

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_ALL_MODULE_BY_USER_ID);
            preparedStatement.setInt(1, userID);
            
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                int _userID = resultSet.getInt("userID");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();

                Timestamp ts = resultSet.getTimestamp("releaseTime");
                if (ts != null) {
                    LocalDateTime _releaseTime = resultSet.getTimestamp("releaseTime").toLocalDateTime();
                    modules.add(new Module(_moduleID, _userID, _moduleName, _moduleDescription, _releaseTime, _lastEdited, 0, 0));
                } else {
                    modules.add(new Module(_moduleID, _userID, _moduleName, _moduleDescription, null, _lastEdited, 0, 0));
                }

            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return modules;
    }

    public static boolean removeAchievement(int moduleID, int achievementID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(DELETE_ACHIEVEMENT_BY_ID);
            preparedStatement.setInt(1, achievementID);
            preparedStatement.setInt(2, moduleID);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean editAchievement(int moduleID, int achievementID, String newName, String newDescription) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            preparedStatement = connection.prepareStatement(UPDATE_ACHIEVEMENT);
            preparedStatement.setString(1, newName);
            preparedStatement.setString(2, newDescription);
            preparedStatement.setInt(3, achievementID);
            preparedStatement.setInt(4, moduleID);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean addAchievement(int moduleID, String newName, String newDescription) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(ADD_ACHIEVEMENT);
            preparedStatement.setInt(1, moduleID);
            preparedStatement.setString(2, newName);
            preparedStatement.setString(3, newDescription);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean unlockAchievement(int achievementID, int userID) {
        Connection connection = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement1 = connection.prepareStatement(CHECK_ACHIEVEMENT);
            preparedStatement1.setInt(1, userID);
            preparedStatement1.setInt(2, achievementID);

            resultSet = preparedStatement1.executeQuery();
            if (resultSet.next()) {
                return false;
            }

            preparedStatement2 = connection.prepareStatement(UNLOCK_ACHIEVEMENT);
            preparedStatement2.setInt(1, userID);
            preparedStatement2.setInt(2, achievementID);

            preparedStatement2.execute();
            return true;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement1);
            closePreparedStatement(preparedStatement2);
            closeResultSet(resultSet);
        }
    }

    public static boolean moduleUpdated(int moduleID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(MODULE_UPDATED);
            preparedStatement.setInt(1, moduleID);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean moduleReleased(int moduleID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(MODULE_RELEASED);
            preparedStatement.setInt(1, moduleID);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static Achievement getAchievement(int achievementID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_ACHIEVEMENT);
            preparedStatement.setInt(1, achievementID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                String _achievementName = resultSet.getString("achievementName");
                String _achievementDescription = resultSet.getString("achievementDescription");

                return new Achievement(achievementID, _moduleID, _achievementName, _achievementDescription, "");
            }

            return null;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }

    public static boolean editModule(int moduleID, String newName, String newDescription) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(UPDATE_MODULE);
            preparedStatement.setString(1, newName);
            preparedStatement.setString(2, newDescription);
            preparedStatement.setInt(3, moduleID);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean deleteModule(int moduleID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(DELETE_MODULE_BY_ID);
            preparedStatement.setInt(1, moduleID);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean updateUserModuleData(int userID, int moduleID, String dataKey, String dataValue) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(UPDATE_USER_MODULE_DATA);
            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, moduleID);
            preparedStatement.setString(3, dataKey);
            preparedStatement.setString(4, dataValue);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static String getAdminEmail() {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_ADMIN_EMAIL);
            
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getString("email");
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return null;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }

    public static boolean setLikeToPost(int userID, int postID, String value) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(SET_LIKE_TO_POST);
            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, postID);
            preparedStatement.setString(3, value);
            preparedStatement.setString(4, value);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static boolean setLikeToModule(int userID, int moduleID, String value) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(SET_LIKE_TO_MODULE);
            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, moduleID);
            preparedStatement.setString(3, value);
            preparedStatement.setString(4, value);

            return preparedStatement.execute();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return false;
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
        }
    }

    public static String getUserModuleData(int userID, int moduleID, String key) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_MODULE_USER_DATA);
            preparedStatement.setInt(1, moduleID);
            preparedStatement.setInt(2, userID);
            preparedStatement.setString(3, key);

            resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getString("mValue");
            } else {
                return "";
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            
            return "";
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }

    public static String getUserPostData(int userID, int postID, String key) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_POST_USER_DATA);
            preparedStatement.setInt(1, postID);
            preparedStatement.setInt(2, userID);
            preparedStatement.setString(3, key);

            resultSet = preparedStatement.executeQuery();
            resultSet.next();
            
            return resultSet.getString("mValue");
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }
    }

    public static ArrayList<String> getAllEndData(int moduleID) {
        ArrayList<String> endDatas = new ArrayList<>();
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            preparedStatement = connection.prepareStatement(GET_ALL_END_DATAS_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                String _endData = resultSet.getString("endData");

                endDatas.add(_endData);
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection(connection);
            closePreparedStatement(preparedStatement);
            closeResultSet(resultSet);
        }

        return endDatas;
    }
    
    private static void closeConnection(Connection connection) {
        try {
            connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private static void closePreparedStatement(PreparedStatement preparedStatement) {
        try {
            preparedStatement.close();
        } catch (SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private static void closeResultSet(ResultSet resultSet) {
        try {
            resultSet.close();
        } catch (SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}

//        try {
//            Class.forName("com.mysql.jdbc.Driver");
//            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER,DB_PASS);
//        } catch (ClassNotFoundException | SQLException ex) {
//            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
//        }
