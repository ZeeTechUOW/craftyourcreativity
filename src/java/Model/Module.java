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

/**
 *
 * @author Andree Yosua
 */
public class Module {

    private int moduleID;
    private int userID;
    private String moduleName;
    private String moduleDescription;
    private LocalDateTime releaseTime;
    private LocalDateTime lastEdited;
    private int likes;
    private int dislikes;
    private int views;

    public Module(int moduleID, int userID, String moduleName, String moduleDescription, LocalDateTime releaseTime, LocalDateTime lastEdited, int likes, int dislikes) {
        this.moduleID = moduleID;
        this.userID = userID;
        this.moduleName = moduleName;
        this.moduleDescription = moduleDescription;
        this.releaseTime = releaseTime;
        this.lastEdited = lastEdited;
        this.likes = likes;
        this.dislikes = dislikes;
    }

    public Module(int moduleID, int userID, String moduleName, String moduleDescription, LocalDateTime releaseTime, LocalDateTime lastEdited, int likes, int dislikes, int views) {
        this.moduleID = moduleID;
        this.userID = userID;
        this.moduleName = moduleName;
        this.moduleDescription = moduleDescription;
        this.releaseTime = releaseTime;
        this.lastEdited = lastEdited;
        this.likes = likes;
        this.dislikes = dislikes;
        this.views = views;
    }

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">
    public int getModuleID() {
        return moduleID;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public int getDislikes() {
        return dislikes;
    }

    public int getViews() {
        return views;
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

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public String getModuleDescription() {
        return moduleDescription;
    }

    public void setModuleDescription(String moduleDescription) {
        this.moduleDescription = moduleDescription;
    }

    public LocalDateTime getReleaseTime() {
        return releaseTime;
    }

    public void setReleaseTime(LocalDateTime releaseTime) {
        this.releaseTime = releaseTime;
    }

    public LocalDateTime getLastEdited() {
        return lastEdited;
    }

    public void setLastEdited(LocalDateTime lastEdited) {
        this.lastEdited = lastEdited;
    }

    public String getReleaseTimeFormatted() {
        if (releaseTime == null) {
            return "Unpublished";
        }
        return releaseTime.getDayOfMonth() + " " + releaseTime.getMonth().toString() + " " + releaseTime.getYear();
    }

    public String getLastUpdatedFormatted() {
        return lastEdited.getDayOfMonth() + " " + lastEdited.getMonth().toString() + " " + lastEdited.getYear();
    }// </editor-fold>\
}
