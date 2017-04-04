package Model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import org.ocpsoft.prettytime.PrettyTime;

public class Thread {

    private int threadID;
    private int userID;
    private String threadTitle;
    private String threadType;
    private LocalDateTime threadTime;
    private int replyCount;
    private PrettyTime p = new PrettyTime();

    public Thread(int threadID, int threadUserID, String threadTitle, String threadType) {
        this.threadID = threadID;
        this.userID = threadUserID;
        this.threadTitle = threadTitle;
        this.threadType = threadType;
        this.threadTime = null;
        replyCount = -1;
    }

    public Thread(int threadID, int userID, String threadTitle, String threadType, LocalDateTime threadTime, int replyCount) {
        this.threadID = threadID;
        this.userID = userID;
        this.threadTitle = threadTitle;
        this.threadType = threadType;
        this.threadTime = threadTime;
        this.replyCount = replyCount;
    }

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">
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

    public String getThreadTitle() {
        return threadTitle;
    }

    public void setThreadTitle(String threadTitle) {
        this.threadTitle = threadTitle;
    }

    public String getThreadType() {
        return threadType;
    }

    public void setThreadType(String threadType) {
        this.threadType = threadType;
    }

    public LocalDateTime getThreadTime() {
        return threadTime;
    }

    public void setThreadTime(LocalDateTime threadTime) {
        this.threadTime = threadTime;
    }

    public int getReplyCount() {
        return replyCount;
    }

    public void setReplyCount(int replyCount) {
        this.replyCount = replyCount;
    }

    public String getThreadTimeFormatted(){
        return p.format(Date.from(threadTime.atZone(ZoneId.systemDefault()).toInstant()));
    }// </editor-fold>\    
}
