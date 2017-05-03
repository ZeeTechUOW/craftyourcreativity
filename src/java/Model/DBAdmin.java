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

/**
 *
 * @author Andree Yosua
 */
public class DBAdmin {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/cyc";
    private static final String DB_USER = "root";
    private static final String DB_PASS = ""; // Local machine DB Pass
//    private static final String DB_PASS = "uvUqdU9n"; // DENI GCP machine DB Pass
//    private static final String DB_PASS = "cK3rMeyG"; // GCP machine DB Pass

    // <editor-fold defaultstate="collapsed" desc="Query String. Click + sign on the left to expand the code">
    // User Query
    private static final String LAST_ID = "SELECT LAST_INSERT_ID();";

    private static final String LOGIN_QUERY
            = "SELECT * "
            + "FROM `user` "
            + "WHERE (username=? OR email=?) AND password=SHA1(?)";
    private static final String REGISTER_QUERY
            = "INSERT INTO `user` (`userID`, `username`, `password`, `email`, `userType`, `receiveUpdates`) "
            + "VALUES (NULL, ?, SHA1(?), ?, ?, '0')";
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
            = "SELECT * "
            + "FROM `post` "
            + "WHERE threadID=? "
            + "LIMIT ?, ?";

    // Module Query
    private static final String CREATE_NEW_MODULE
            = "INSERT INTO `module` (`moduleID`, `userID`, `moduleVersion`, `moduleName`, `moduleDescription`, `releaseTime`, `lastEdited`) "
            + "VALUES (NULL, ?, ?, ?, ?, NULL, CURRENT_TIMESTAMP);";
    private static final String GET_ALL_MODULE_SORT_BY_POPULAR_VIEW
            = "SELECT m.moduleID, m.userID, m.moduleVersion, m.moduleName, m.moduleDescription, m.releaseTime, m.lastEdited, COUNT(v.moduleID) AS viewCount "
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
            = "SELECT * "
            + "FROM `module` "
            + "WHERE moduleID=?";
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
            = "INSERT INTO `achievement` (`moduleID`, `achievementName`, `achievementDescription`, `imagePath`) "
            + "VALUES (?, ?, ?, 'resource/placeholder1.png')";
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
            + "WHERE userID=? AND mKey=?";

    private static final String UPDATE_SCORE
            = "INSERT INTO `moduleuserdata` (`userID`, `moduleID`, `mKey`, `mValue`) "
            + "VALUES (?, ?, 'score', ?) "
            + "ON DUPLICATE KEY UPDATE "
            + "mValue = GREATEST(mValue, VALUES(mValue))";
    // </editor-fold>

    // User method
    /**
     * Login method which use username/email and password as credentials and
     * return <code>User</code> object.
     *
     * @param username User's username
     * @param email User's email
     * @param password User's password
     * @return <code>User</code> with corresponding login credentials if found,
     * otherwise <code>null</code>.
     */
    public static User login(String username, String email, String password) {
        try {
            Class.forName("com.mysql.jdbc.Driver");

            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(LOGIN_QUERY);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, password);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _userID = resultSet.getInt("userID");
                String _username = resultSet.getString("username");
                String _email = resultSet.getString("email");
                String _userType = resultSet.getString("userType");

                return new User(_userID, _username, "", _email, _userType);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Register the current <code>User</code> to the database with corresponding
     * credentials.
     *
     * @param username User's username
     * @param email User's email
     * @param password User's password
     * @param userType User's user type
     * @return <code>true</code> if user successfully registered to the
     * database, otherwise <code>false</code>.
     */
    public static boolean register(String username, String email, String password, String userType) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(REGISTER_QUERY);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, userType);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        }
    }

    /**
     * Check <code>User</code> with the corresponding username is already exist
     * in database or not.
     *
     * @param username username target
     * @return true if username is taken, otherwise false.
     */
    public static boolean isUsernameTaken(String username) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_USER_FROM_USERNAME);
            preparedStatement.setString(1, username);

            ResultSet resultSet = preparedStatement.executeQuery();

            return resultSet.next();
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return true;
        }
    }

    /**
     * Return the corresponding <code>User</code> object from user ID.
     *
     * @param userID user ID target
     * @return <code>User</code> if user exist, otherwise <code>null</code>.
     */
    public static User getUser(int userID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_USER_FROM_USER_ID);
            preparedStatement.setInt(1, userID);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _userID = resultSet.getInt("userID");
                String _username = resultSet.getString("username");
                String _email = resultSet.getString("email");
                String _userType = resultSet.getString("userType");

                return new User(_userID, _username, "", _email, _userType);
            } else {
                return null;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Update <code>User</code> email to the new email.
     *
     * @param userID User's ID
     * @param password User's password
     * @param email User's email
     * @return <code>true</code> if operation success, otherwise
     * <code>false</code>.
     */
    public static boolean updateUserEmail(int userID, String password, String email) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_USER_EMAIL);
            preparedStatement.setString(1, email);
            preparedStatement.setInt(2, userID);
            preparedStatement.setString(3, password);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        }
    }

    /**
     * Update <code>User</code> password to the new password.
     *
     * @param userID User's ID
     * @param password User's old password
     * @param newPassword User's new password.
     * @return <code>true</code> if operation success, otherwise
     * <code>false</code>.
     */
    public static boolean updateUserPassword(int userID, String password, String newPassword) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_USER_PASSWORD);
            preparedStatement.setString(1, newPassword);
            preparedStatement.setInt(2, userID);
            preparedStatement.setString(3, password);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        }
    }

    // Thread method
    /**
     * Create a new <code>Thread</code> and attach an opening <code>Post</code>
     * to the <code>Thread</code> as opening <code>Post</code>.
     *
     * @param userID User's ID
     * @param threadTitle Thread title
     * @param threadType Thread type
     * @param message Thread opening post
     * @return <code>true</code> if operation success, otherwise
     * <code>false</code>.
     */
    public static int createNewThread(int userID, String threadTitle, String threadType, String message) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement1 = connection.prepareStatement(CREATE_NEW_THREAD);
            preparedStatement1.setInt(1, userID);
            preparedStatement1.setString(2, threadTitle);
            preparedStatement1.setString(3, threadType);

            PreparedStatement preparedStatement2 = connection.prepareStatement(CREATE_OPENING_POST);
            preparedStatement2.setInt(1, userID);
            preparedStatement2.setInt(2, userID);
            preparedStatement2.setInt(3, 1);
            preparedStatement2.setString(4, message);

            preparedStatement1.executeUpdate();
            ResultSet rs = connection.createStatement().executeQuery(LAST_ID);
            rs.next();
            int threadID = rs.getInt(1);

            preparedStatement2.executeUpdate();

            return threadID;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return -1;
        }
    }

    /**
     * Return corresponding <code>Thread</code> from specified ID
     *
     * @param threadID target ID
     * @return <code>Thread</code> if found, otherwise <code>null</code>.
     */
    public static Thread getThread(int threadID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            PreparedStatement preparedStatement = connection.prepareStatement(GET_THREAD_FROM_THREAD_ID);
            preparedStatement.setInt(1, threadID);

            ResultSet resultSet = preparedStatement.executeQuery();

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
        }
    }

    /**
     * Return the <code>Post</code> that attached to the corresponding
     * <code>Thread</code> ID as <code>int</code> object.
     *
     * @param threadID target ID
     * @return <code>Post</code> count if <code>Thread</code> exist, otherwise
     * -1.
     */
    public static int getThreadPostCount(int threadID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_THREAD_POST_COUNT_FROM_THREAD_ID);
            preparedStatement.setInt(1, threadID);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                return -1;
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return -1;
        }
    }

    /**
     * Return a set of <code>Thread</code> specified by type, sort, size, and
     * target page.
     *
     * @param type <code>Thread</code> type
     * @param sort sorting Algorithm used
     * @param size size of <code>Thread</code> per page
     * @param page target page
     * @return a non-empty <code>ArrayList</code> of <code>Thread</code> if
     * operation success, otherwise empty <code>ArrayList</code> of
     * <code>Thread</code>.
     */
    public static ArrayList<Thread> getXForumSortedBy(String type, String sort, int size, int page) {
        ArrayList<Thread> threads = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement;

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

            ResultSet resultSet = preparedStatement.executeQuery();
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
        }

        return threads;
    }

    // Post method
    /**
     * Create and attach a non-opening <code>Post</code> to specified
     * <code>Thread</code> ID.
     *
     * @param threadID Thread target ID
     * @param userID User target ID
     * @param message User post
     * @return <code>true</code> if operation success, otherwise
     * <code>false</code>.
     */
    public static boolean createNewPost(int threadID, int userID, String message) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(CREATE_NEW_POST);
            preparedStatement.setInt(1, threadID);
            preparedStatement.setInt(2, userID);
            preparedStatement.setInt(3, 0);
            preparedStatement.setString(4, message);

            return preparedStatement.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        }
    }

    /**
     * Return an <code>ArrayList</code> of <code>Post</code> which attached to
     * certain <code>Thread</code> ID.
     *
     * @param threadID Thread target ID
     * @param page target page
     * @return a non-empty <code>ArrayList</code> of <code>Post</code> if
     * operation success, otherwise empty <code>ArrayList</code> of
     * <code>Post</code>.
     */
    public static ArrayList<Post> getThreadPost(int threadID, int page) {
        ArrayList<Post> posts = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_POST_FROM_THREAD_ID_LIMIT_BY_X);
            preparedStatement.setInt(1, threadID);
            preparedStatement.setInt(2, 10 * (page - 1));
            preparedStatement.setInt(3, 10);

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _postID = resultSet.getInt("postID");
                int _threadID = resultSet.getInt("threadID");
                int _userID = resultSet.getInt("userID");
                int _openingPost = resultSet.getInt("openingPost");
                String _message = resultSet.getString("message");
                LocalDateTime _postTime = resultSet.getTimestamp("timestamp").toLocalDateTime();

                posts.add(new Post(_postID, threadID, _userID, _message, _postTime));
            }

            return posts;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }

        return posts;
    }

    // Module method
    /**
     * Create new <code>Module</code> into database.
     *
     * @param userID Module owner
     * @param moduleVersion Module version
     * @param moduleName Module name
     * @param moduleDescription Module Description
     * @return <code>true</code> if operation success, otherwise
     * <code>false</code>.
     */
    public static int createNewModule(int userID, String moduleVersion, String moduleName, String moduleDescription) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(CREATE_NEW_MODULE);
            preparedStatement.setInt(1, userID);
            preparedStatement.setString(2, moduleVersion);
            preparedStatement.setString(3, moduleName);
            preparedStatement.setString(4, moduleDescription);

            preparedStatement.execute();

            ResultSet resultSet = connection.createStatement().executeQuery(LAST_ID);
            resultSet.next();
            return resultSet.getInt(1);

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return -1;
        }
    }

    /**
     * Return an <code>ArrayList</code> of <code>Module</code> sorted by certain
     * method (popular, release, or update).
     *
     * @param sort Sort method
     * @return a non-empty <code>ArrayList</code> of <code>Module</code> if
     * operation success, otherwise empty <code>ArrayList</code> of
     * <code>Module</code>.
     */
    public static ArrayList<Module> getModuleSortBy(String sort) {
        ArrayList<Module> modules = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement;
            if (sort.equalsIgnoreCase("popular")) {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_POPULAR_VIEW);
            } else if (sort.equalsIgnoreCase("release")) {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_NEWEST_RELEASE);
            } else if (sort.equalsIgnoreCase("update")) {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_NEWEST_UPDATE);
            } else {
                preparedStatement = connection.prepareStatement(GET_ALL_MODULE_SORT_BY_NEWEST_RELEASE);
            }

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                int _userID = resultSet.getInt("userID");
                String _moduleVersion = resultSet.getString("moduleVersion");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();

                Timestamp t = resultSet.getTimestamp("releaseTime");

                if (t != null) {
                    LocalDateTime _releaseTime = t.toLocalDateTime();
                    modules.add(new Module(_moduleID, _userID, _moduleVersion, _moduleName, _moduleDescription, _releaseTime, _lastEdited));
                } else {
                    modules.add(new Module(_moduleID, _userID, _moduleVersion, _moduleName, _moduleDescription, null, _lastEdited));
                }
                
                
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }

        return modules;
    }

    /**
     * Return specified <code>Module</code> object.
     *
     * @param moduleID target ID
     * @return <code>Module</code> if exist, otherwise <code>null</code>.
     */
    public static Module getModule(int moduleID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_MODULE_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                int _userID = resultSet.getInt("userID");
                String _moduleVersion = resultSet.getString("moduleVersion");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();
                Timestamp t = resultSet.getTimestamp("releaseTime");

                if (t != null) {
                    LocalDateTime _releaseTime = t.toLocalDateTime();
                    return new Module(_moduleID, _userID, _moduleVersion, _moduleName, _moduleDescription, _releaseTime, _lastEdited);
                } else {
                    return new Module(_moduleID, _userID, _moduleVersion, _moduleName, _moduleDescription, null, _lastEdited);
                }

            }

            return null;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        }
    }

    /**
     * Specify a set of genre to <code>Module</code> object.
     *
     * @param moduleID target ID
     * @param genres <code>ArrayList</code> of genre
     * @return <code>true</code> if operation success, otherwise
     * <code>false</code>.
     */
    public static boolean setModuleGenre(int moduleID, ArrayList<String> genres) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            int statementExecuteCount = 0;
            PreparedStatement preparedStatement;

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
        }
    }

    /**
     * Return a set of genre from specified <code>Module</code> ID.
     *
     * @param moduleID target ID
     * @return a non-empty <code>Arraylist</code> of genres in
     * <code>String</code> format, otherwise empty <code>Arraylist</code> of
     * <code>String</code>.
     */
    public static ArrayList<String> getModuleGenre(int moduleID) {
        ArrayList<String> genres = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_MODULE_GENRE_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                genres.add(resultSet.getString("genre"));
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }

        return genres;
    }


    // Achievement method
    /**
     * Return an <code>ArrayList</code> of <code>Achievement</code> from
     * specified <code>Module</code> ID.
     *
     * @param moduleID target ID
     * @return a non-empty <code>ArrayList</code> of <code>Achievement</code> if
     * operation success, otherwise empty <code>ArrayList</code> of
     * <code>Achievement</code>.
     */
    public static ArrayList<Achievement> getAllAchievement(int moduleID) {
        ArrayList<Achievement> achievements = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_ACHIEVEMENTS_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _achievementID = resultSet.getInt("achievementID");
                int _moduleID = resultSet.getInt("moduleID");
                String _achievementName = resultSet.getString("achievementName");
                String _achievementDescription = resultSet.getString("achievementDescription");
                String _imagePath = resultSet.getString("imagePath");

                achievements.add(new Achievement(_achievementID, moduleID, _achievementName, _achievementDescription, _imagePath));
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }

        return achievements;
    }

    /**
     * an <code>ArrayList</code> of <code>Achievement</code> from specified
     * <code>Module</code> ID and <code>User</code> ID.
     *
     * @param moduleID Module target ID
     * @param userID User target ID
     * @return a non-empty <code>ArrayList</code> of <code>Achievement</code> if
     * operation success, otherwise empty <code>ArrayList</code> of
     * <code>Achievement</code>.
     */
    public static ArrayList<Achievement> getAllAchievement(int moduleID, int userID) {
        ArrayList<Achievement> achievements = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement1 = connection.prepareStatement(GET_ALL_ACHIEVEMENTS_FROM_MODULE_ID);
            preparedStatement1.setInt(1, moduleID);

            PreparedStatement preparedStatement2 = connection.prepareStatement(GET_ALL_USER_ACHIEVEMENT_FROM_USER_ID);
            preparedStatement2.setInt(1, userID);

            ResultSet resultSet = preparedStatement1.executeQuery();

            while (resultSet.next()) {
                int _achievementID = resultSet.getInt("achievementID");
                int _moduleID = resultSet.getInt("moduleID");
                String _achievementName = resultSet.getString("achievementName");
                String _achievementDescription = resultSet.getString("achievementDescription");
                String _imagePath = resultSet.getString("imagePath");

                achievements.add(new Achievement(_achievementID, moduleID, _achievementName, _achievementDescription, _imagePath));
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
        }

        return achievements;
    }

    // Module user data method
    /**
     * Return an <code>ArrayList</code> of <code>ModuleUserData</code> that
     * represent set of high score of specified <code>Module</code> ID.
     *
     * @param moduleID Module target ID
     * @return a non-empty <code>ArrayList</code> of <code>ModuleUserData</code>
     * if operation success, otherwise empty <code>ArrayList</code> of
     * <code>ModuleUserData</code>.
     */
    public static ArrayList<ModuleUserData> getModuleHighScore(int moduleID) {
        ArrayList<ModuleUserData> userDatas = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_USER_DATA_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);
            preparedStatement.setString(2, "score");

            ResultSet resultSet = preparedStatement.executeQuery();

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
        }

        return userDatas;
    }

    /**
     * Return an <code>ArrayList</code> of <code>ModuleUserData</code> that
     * represent set of module progress of specified <code>User</code> ID.
     *
     * @param userID User target ID
     * @return a non-empty <code>ArrayList</code> of <code>ModuleUserData</code>
     * if operation success, otherwise empty <code>ArrayList</code> of
     * <code>ModuleUserData</code>.
     */
    public static ArrayList<ModuleUserData> getModuleProgress(int userID) {
        ArrayList<ModuleUserData> userDatas = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareCall(GET_USER_DATA_FROM_MODULE_ID);
            preparedStatement.setInt(1, userID);
            preparedStatement.setString(2, "score");

            ResultSet resultSet = preparedStatement.executeQuery();

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
        }

        return userDatas;
    }

    public static boolean addView(int moduleID) {
        return DBAdmin.addView(-1, moduleID);
    }

    public static boolean addView(int userID, int moduleID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(ADD_VIEW_TO_MODULE);
            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, moduleID);

            return preparedStatement.executeUpdate() == 1;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        }
    }

    public static ArrayList<Module> getModulesByUserID(int userID) {
        ArrayList<Module> modules = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_MODULE_BY_USER_ID);
            preparedStatement.setInt(1, userID);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                int _userID = resultSet.getInt("userID");
                String _moduleVersion = resultSet.getString("moduleVersion");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();

                Timestamp ts = resultSet.getTimestamp("releaseTime");
                if (ts != null) {
                    LocalDateTime _releaseTime = resultSet.getTimestamp("releaseTime").toLocalDateTime();
                    modules.add(new Module(_moduleID, _userID, _moduleVersion, _moduleName, _moduleDescription, _releaseTime, _lastEdited));
                } else {
                    modules.add(new Module(_moduleID, _userID, _moduleVersion, _moduleName, _moduleDescription, null, _lastEdited));
                }

            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }

        return modules;
    }

    public static boolean removeAchievement(int moduleID, int achievementID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(DELETE_ACHIEVEMENT_BY_ID);
            preparedStatement.setInt(1, achievementID);
            preparedStatement.setInt(2, moduleID);

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static boolean editAchievement(int moduleID, int achievementID, String newName, String newDescription) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            System.out.println("MODULE ID " + moduleID);
            System.out.println("ACHIEVEMENT ID " + achievementID);
            System.out.println("NEWNAME " + newName);
            System.out.println("NEWDESC " + newDescription);
            PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_ACHIEVEMENT);
            preparedStatement.setString(1, newName);
            preparedStatement.setString(2, newDescription);
            preparedStatement.setInt(3, achievementID);
            preparedStatement.setInt(4, moduleID);

            System.out.println(preparedStatement.toString());

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static boolean addAchievement(int moduleID, String newName, String newDescription) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(ADD_ACHIEVEMENT);
            preparedStatement.setInt(1, moduleID);
            preparedStatement.setString(2, newName);
            preparedStatement.setString(3, newDescription);

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static boolean unlockAchievement(int achievementID, int userID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement1 = connection.prepareStatement(CHECK_ACHIEVEMENT);
            preparedStatement1.setInt(1, userID);
            preparedStatement1.setInt(2, achievementID);

            ResultSet rs = preparedStatement1.executeQuery();
            if (rs.next()) {
                return false;
            }

            PreparedStatement preparedStatement2 = connection.prepareStatement(UNLOCK_ACHIEVEMENT);
            preparedStatement2.setInt(1, userID);
            preparedStatement2.setInt(2, achievementID);

            preparedStatement2.execute();
            return true;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static boolean moduleUpdated(int moduleID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(MODULE_UPDATED);
            preparedStatement.setInt(1, moduleID);

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static boolean moduleReleased(int moduleID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(MODULE_RELEASED);
            preparedStatement.setInt(1, moduleID);

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static Achievement getAchievement(int achievementID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_ACHIEVEMENT);
            preparedStatement.setInt(1, achievementID);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                String _achievementName = resultSet.getString("achievementName");
                String _achievementDescription = resultSet.getString("achievementDescription");
                String _imagePath = resultSet.getString("imagePath");

                return new Achievement(achievementID, _moduleID, _achievementName, _achievementDescription, _imagePath);
            }

            return null;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        }

    }

    public static boolean editModule(int moduleID, String newName, String newDescription) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_MODULE);
            preparedStatement.setString(1, newName);
            preparedStatement.setString(2, newDescription);
            preparedStatement.setInt(3, moduleID);

            System.out.println(preparedStatement.toString());

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static boolean deleteModule(int moduleID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(DELETE_MODULE_BY_ID);
            preparedStatement.setInt(1, moduleID);

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static boolean updateUserModuleScore(int userID, int moduleID, int score) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_SCORE);
            preparedStatement.setInt(1, userID);
            preparedStatement.setInt(2, moduleID);
            preparedStatement.setInt(3, score);

            return preparedStatement.execute();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
}

//        try {
//            Class.forName("com.mysql.jdbc.Driver");
//            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER,DB_PASS);
//        } catch (ClassNotFoundException | SQLException ex) {
//            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
//        }
