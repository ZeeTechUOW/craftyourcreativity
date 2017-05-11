package Model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import org.ocpsoft.prettytime.PrettyTime;

/**
 *
 * @author Andree Yosua
 */
public class Post {

    private int postID;
    private int threadID;
    private int userID;
    private int likes;
    private int dislikes;
    private String postMessage;
    private LocalDateTime postTime;
    private PrettyTime p = new PrettyTime();

    private String userLikes;
    /**
     *
     * @param postID
     * @param threadID
     * @param userID
     * @param postMessage
     * @param postTime
     */
    public Post(int postID, int threadID, int userID, String postMessage, LocalDateTime postTime, int likes, int dislikes) {
        this.postID = postID;
        this.threadID = threadID;
        this.userID = userID;
        this.postMessage = postMessage;
        this.postTime = postTime;
        this.likes = likes;
        this.dislikes = dislikes;
    }

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">

    public String getUserLikes() {
        return userLikes;
    }

    public void setUserLikes(String userLikes) {
        this.userLikes = userLikes;
    }
    
    /**
     *
     * @return
     */
    public int getPostID() {
        return postID;
    }

    /**
     *
     * @param postID
     */
    public void setPostID(int postID) {
        this.postID = postID;
    }

    /**
     *
     * @return
     */
    public int getThreadID() {
        return threadID;
    }

    /**
     *
     * @param threadID
     */
    public void setThreadID(int threadID) {
        this.threadID = threadID;
    }

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

    public int getDislikes() {
        return dislikes;
    }

    public void setDislikes(int dislikes) {
        this.dislikes = dislikes;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }
    
    

    /**
     *
     * @return
     */
    public String getPostMessage() {
        return postMessage;
    }

    /**
     *
     * @param postMessage
     */
    public void setPostMessage(String postMessage) {
        this.postMessage = postMessage;
    }

    /**
     *
     * @return
     */
    public LocalDateTime getPostTime() {
        return postTime;
    }

    /**
     *
     * @param postTime
     */
    public void setPostTime(LocalDateTime postTime) {
        this.postTime = postTime;
    }

    /**
     *
     * @return
     */
    public String getPostTimeFormatted() {
        return p.format(Date.from(postTime.atZone(ZoneId.systemDefault()).toInstant()));
    }// </editor-fold>\
}
