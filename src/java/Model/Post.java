
package Model;

import java.time.LocalDateTime;

public class Post {
    private int postID;
    private int threadID;
    private int userID;
    private String postMessage;
    private LocalDateTime postTime;

    public Post(int postID, int threadID, int userID, String postMessage, LocalDateTime postTime) {
        this.postID = postID;
        this.threadID = threadID;
        this.userID = userID;
        this.postMessage = postMessage;
        this.postTime = postTime;
    }

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">
    public int getPostID() {
        return postID;
    }

    public void setPostID(int postID) {
        this.postID = postID;
    }

    public int getThreadID() {
        return threadID;
    }

    public void setThreadID(int threadID) {
        this.threadID = threadID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getPostMessage() {
        return postMessage;
    }

    public void setPostMessage(String postMessage) {
        this.postMessage = postMessage;
    }

    public LocalDateTime getPostTime() {
        return postTime;
    }

    public void setPostTime(LocalDateTime postTime) {
        this.postTime = postTime;
    }// </editor-fold>\
}
