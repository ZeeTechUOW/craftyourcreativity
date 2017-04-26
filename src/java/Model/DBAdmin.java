package Model;

import com.mysql.jdbc.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBAdmin {

    public static final String WEB_URL = "http://localhost:8084/cycfrontend/"; // Local machine web url
//    public static final String WEB_URL = "http://localhost:8084/cycfrontend/"; // GCP machine web url
    private static final String DB_URL = "jdbc:mysql://localhost:3306/cyc";
    private static final String DB_USER = "root";
    private static final String DB_PASS = ""; // Local machine DB Pass
//    private static final String DB_PASS = "cK3rMeyG"; // GCP machine DB Pass

    // <editor-fold defaultstate="collapsed" desc="Query String. Click + sign on the left to expand the code">
    // Login, Register Query
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
            + "WHERE p.threadID = t.threadID AND t.threadType=? "
            + "GROUP BY p.threadID "
            + "ORDER BY p.timestamp DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_TODAY_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType=? AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 DAY) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_WEEK_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType=? AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 WEEK) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_MONTH_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType=? AND p.timestamp BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND TIMESTAMP(NOW()) "
            + "GROUP BY p.threadID "
            + "ORDER BY reply DESC "
            + "LIMIT ?, ?";
    private static final String GET_TYPE_THREAD_SORT_BY_POPULAR_ALL_TIME_WITH_TIMESTAMP_LIMIT_BY_X
            = "SELECT t.threadID, t.userID, t.threadTitle, t.threadType, p.timestamp, COUNT(p.threadID) AS reply "
            + "FROM thread t, post p "
            + "WHERE p.threadID = t.threadID AND t.threadType=? "
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
            = "INSERT INTO `module` (`moduleID`, `moduleVersion`, `moduleName`, `moduleDescription`, `thumbnailPath`, `releaseTime`, `lastEdited`) "
            + "VALUES (NULL, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
    private static final String GET_ALL_MODULE_SORT_BY_POPULAR_VIEW
            = "SELECT m.moduleID, m.moduleVersion, m.moduleName, m.moduleDescription, m.thumbnailPath, m.releaseTime, m.lastEdited, COUNT(v.moduleID) AS viewCount "
            + "FROM module m, views v "
            + "WHERE m.moduleID = v.moduleID "
            + "GROUP BY m.moduleID "
            + "ORDER BY viewCount DESC";
    private static final String GET_ALL_MODULE_SORT_BY_NEWEST_RELEASE
            = "SELECT * "
            + "FROM `module` "
            + "ORDER BY `releaseTime` DESC";
    private static final String GET_ALL_MODULE_SORT_BY_NEWEST_UPDATE
            = "SELECT * "
            + "FROM `module` "
            + "ORDER BY `lastEdited` DESC";
    private static final String GET_MODULE_FROM_MODULE_ID
            = "SELECT * "
            + "FROM `module` "
            + "WHERE moduleID=?";

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

    // Module user data Query
    private static final String GET_ALL_USER_DATA_FROM_MODULE_ID
            = "SELECT * "
            + "FROM `moduleuserdata` "
            + "WHERE moduleID=? AND mKey=?";

    private static final String GET_USER_DATA_FROM_MODULE_ID
            = "SELECT * "
            + "FROM `moduleuserdata` "
            + "WHERE userID=? AND mKey=?";
    // </editor-fold>

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

    public static boolean createNewThread(int userID, String threadTitle, String threadType, String message) {
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

            return preparedStatement1.executeUpdate() + preparedStatement2.executeUpdate() > 1;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        }
    }

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
            preparedStatement.setString(1, type);
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

    public static ArrayList<Post> getThreadPost(int threadID, int page) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_POST_FROM_THREAD_ID_LIMIT_BY_X);
            preparedStatement.setInt(1, threadID);
            preparedStatement.setInt(2, 10 * (page - 1));
            preparedStatement.setInt(3, 10);

            ResultSet resultSet = preparedStatement.executeQuery();

            ArrayList<Post> posts = new ArrayList<>();
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

        return null;
    }

    public static boolean createNewModule(String moduleVersion, String moduleName, String moduleDescription, String moduleImgPath) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(CREATE_NEW_MODULE);
            preparedStatement.setString(1, moduleVersion);
            preparedStatement.setString(2, moduleName);
            preparedStatement.setString(3, moduleDescription);
            preparedStatement.setString(4, moduleImgPath);

            return preparedStatement.executeUpdate() == 1;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return false;
        }
    }

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
                String _moduleVersion = resultSet.getString("moduleVersion");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                String _thumbnailPath = resultSet.getString("thumbnailPath");
                LocalDateTime _releaseTime = resultSet.getTimestamp("releaseTime").toLocalDateTime();
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();

                modules.add(new Module(_moduleID, _moduleVersion, _moduleName, _moduleDescription, _thumbnailPath, _releaseTime, _lastEdited));
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
        }

        return modules;
    }

    public static Module getModule(int moduleID) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareStatement(GET_MODULE_FROM_MODULE_ID);
            preparedStatement.setInt(1, moduleID);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int _moduleID = resultSet.getInt("moduleID");
                String _moduleVersion = resultSet.getString("moduleVersion");
                String _moduleName = resultSet.getString("moduleName");
                String _moduleDescription = resultSet.getString("moduleDescription");
                String _thumbnailPath = resultSet.getString("thumbnailPath");
                LocalDateTime _releaseTime = resultSet.getTimestamp("releaseTime").toLocalDateTime();
                LocalDateTime _lastEdited = resultSet.getTimestamp("lastEdited").toLocalDateTime();

                return new Module(_moduleID, _moduleVersion, _moduleName, _moduleDescription, _thumbnailPath, _releaseTime, _lastEdited);
            }

            return null;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);

            return null;
        }
    }

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

    public static ArrayList<Achievement> getAchievement(int moduleID) {
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

    public static ArrayList<Achievement> getAchievement(int moduleID, int userID) {
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

    public static ArrayList<ModuleUserData> getModuleProgress(int userID) {
        ArrayList<ModuleUserData> userDatas = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            PreparedStatement preparedStatement = connection.prepareCall(GET_USER_DATA_FROM_MODULE_ID);
            preparedStatement.setInt(1, userID);
            preparedStatement.setString(2, "progress");

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
}

//        try {
//            Class.forName("com.mysql.jdbc.Driver");
//            Connection connection = (Connection) DriverManager.getConnection(DB_URL, DB_USER,DB_PASS);
//        } catch (ClassNotFoundException | SQLException ex) {
//            Logger.getLogger(DBAdmin.class.getName()).log(Level.SEVERE, null, ex);
//        }
