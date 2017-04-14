
package Model;

import java.time.LocalDateTime;

public class Achievement {
    private int achievementID;
    private int moduleID;
    private String achievementName;
    private String achievementDescription;
    private String imagePath;
    private boolean unlocked;
    private LocalDateTime unlockTime;

    public Achievement(int achievementID, int moduleID, String achievementName, String achievementDescription, String imagePath) {
        this.achievementID = achievementID;
        this.moduleID = moduleID;
        this.achievementName = achievementName;
        this.achievementDescription = achievementDescription;
        this.imagePath = imagePath;
        unlocked = false;
        unlockTime = LocalDateTime.MIN;
    }

    public int getAchievementID() {
        return achievementID;
    }

    public void setAchievementID(int achievementID) {
        this.achievementID = achievementID;
    }

    public int getModuleID() {
        return moduleID;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public String getAchievementName() {
        return achievementName;
    }

    public void setAchievementName(String achievementName) {
        this.achievementName = achievementName;
    }

    public String getAchievementDescription() {
        return achievementDescription;
    }

    public void setAchievementDescription(String achievementDescription) {
        this.achievementDescription = achievementDescription;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public boolean isUnlocked() {
        return unlocked;
    }

    public void setUnlocked(boolean unlocked) {
        this.unlocked = unlocked;
    }

    public LocalDateTime getUnlockTime() {
        return unlockTime;
    }

    public void setUnlockTime(LocalDateTime unlockTime) {
        this.unlockTime = unlockTime;
    }    
}
