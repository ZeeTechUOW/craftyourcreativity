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
    }

    public String getPostTimeFormatted() {
        return p.format(Date.from(postTime.atZone(ZoneId.systemDefault()).toInstant()));
    }// </editor-fold>\
}
