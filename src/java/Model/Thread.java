package Model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import org.ocpsoft.prettytime.PrettyTime;

/**
 *
 * @author Andree Yosua
 */
public class Thread {

    private int threadID;
    private int userID;
    private String threadTitle;
    private String threadType;
    private LocalDateTime threadTime;
    private int replyCount;
    private PrettyTime p = new PrettyTime();

    /**
     *
     * @param threadID
     * @param threadUserID
     * @param threadTitle
     * @param threadType
     */
    public Thread(int threadID, int threadUserID, String threadTitle, String threadType) {
        this.threadID = threadID;
        this.userID = threadUserID;
        this.threadTitle = threadTitle;
        this.threadType = threadType;
        this.threadTime = null;
        replyCount = -1;
    }

    /**
     *
     * @param threadID
     * @param userID
     * @param threadTitle
     * @param threadType
     * @param threadTime
     * @param replyCount
     */
    public Thread(int threadID, int userID, String threadTitle, String threadType, LocalDateTime threadTime, int replyCount) {
        this.threadID = threadID;
        this.userID = userID;
        this.threadTitle = threadTitle;
        this.threadType = threadType;
        this.threadTime = threadTime;
        this.replyCount = replyCount;
    }

    public boolean isModuleThread() {
        return threadType.startsWith("module_");
    }
    
    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">

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

    /**
     *
     * @return
     */
    public String getThreadTitle() {
        
        return threadTitle;
    }

    /**
     *
     * @param threadTitle
     */
    public void setThreadTitle(String threadTitle) {
        this.threadTitle = threadTitle;
    }

    /**
     *
     * @return
     */
    public String getThreadType() {
        return threadType.replace("module_", "");
    }

    /**
     *
     * @param threadType
     */
    public void setThreadType(String threadType) {
        this.threadType = threadType;
    }

    /**
     *
     * @return
     */
    public LocalDateTime getThreadTime() {
        return threadTime;
    }

    /**
     *
     * @param threadTime
     */
    public void setThreadTime(LocalDateTime threadTime) {
        this.threadTime = threadTime;
    }

    /**
     *
     * @return
     */
    public int getReplyCount() {
        return replyCount;
    }

    /**
     *
     * @param replyCount
     */
    public void setReplyCount(int replyCount) {
        this.replyCount = replyCount;
    }

    /**
     *
     * @return
     */
    public String getThreadTimeFormatted() {
        return p.format(Date.from(threadTime.atZone(ZoneId.systemDefault()).toInstant()));
    }// </editor-fold>\    
}
