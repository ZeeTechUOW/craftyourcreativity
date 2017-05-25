/*
 * Copyright 2017 Andree Yosua.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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

    public boolean isModuleThread() {
        return threadType.startsWith("module_");
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
        return threadType.replace("module_", "");
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

    public String getThreadTimeFormatted() {
        return p.format(Date.from(threadTime.atZone(ZoneId.systemDefault()).toInstant()));
    }// </editor-fold>\    
}
