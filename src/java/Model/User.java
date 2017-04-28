package Model;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author Andree Yosua
 */
public class User {

    private int userID;
    private String username;
    private String password;
    private String email;
    private String userType;

    /**
     *
     * @param userID
     * @param username
     * @param password
     * @param email
     * @param userType
     */
    public User(int userID, String username, String password, String email, String userType) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.email = email;
        this.userType = userType;
    }

    /**
     * Check whether the email pattern is valid or not.
     *
     * @return true if pattern is valid; otherwise false.
     */
    public boolean isEmailValid() {
//        String regex = "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$";
        String regex = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^-]+(?:\\.[a-zA-Z0-9_!#$%&'*+/=?`{|}~^-]+)*@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$";

        Pattern pattern = Pattern.compile(regex);

        Matcher matcher = pattern.matcher(email);
        return matcher.matches();
    }

    /**
     * Check whether the password pattern is valid or not. The password must be at least 8 characters long, contain at least 1 number, and no whitespace.
     *
     * @return true if pattern is valid; otherwise false.
     */
    public boolean isPasswordValid() {
        String regex = "^(?=.*[0-9])(?=\\S+$).{8,}$";
        Pattern pattern = Pattern.compile(regex);

        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">

    /**
     *
     * @return
     */
    public int getUserID() {
        return userID;
    }

    /**
     *
     * @param userID
     */
    public void setUserID(int userID) {
        this.userID = userID;
    }

    /**
     *
     * @return
     */
    public String getUsername() {
        return username;
    }

    /**
     *
     * @param username
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     *
     * @return
     */
    public String getPassword() {
        return password;
    }

    /**
     *
     * @param password
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     *
     * @return
     */
    public String getEmail() {
        return email;
    }

    /**
     *
     * @param email
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     *
     * @return
     */
    public String getUserType() {
        return userType;
    }

    /**
     *
     * @param userType
     */
    public void setUserType(String userType) {
        this.userType = userType;
    }// </editor-fold>
}
