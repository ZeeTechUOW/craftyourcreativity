package Model;

import java.time.LocalDateTime;

/**
 *
 * @author Andree Yosua
 */
public class Achievement {

    private int achievementID;
    private int moduleID;
    private String achievementName;
    private String achievementDescription;
    private String imagePath;
    private boolean unlocked;
    private LocalDateTime unlockTime;

    /**
     * Class used to represent achievement details of the user from specific module.
     * Provides method set and get to modify the achievement details.
     * @param achievementID the <code>Achievement</code> ID
     * @param moduleID the <code>Module</code> ID this <code>Achievement</code> associate with
     * @param achievementName the <code>Achievement</code> name
     * @param achievementDescription the <code>Achievement</code> description
     * @param imagePath the <code>Achievement</code> thumbnail image path
     */
    public Achievement(int achievementID, int moduleID, String achievementName, String achievementDescription, String imagePath) {
        this.achievementID = achievementID;
        this.moduleID = moduleID;
        this.achievementName = achievementName;
        this.achievementDescription = achievementDescription;
        this.imagePath = imagePath;
        unlocked = false;
        unlockTime = LocalDateTime.MIN;
    }

    /**
     * Return the ID of this <code>Achievement</code> object in <code>int</code> format.
     * @return the <code>Achievement</code> ID
     */
    public int getAchievementID() {
        return achievementID;
    }

    /**
     * Set the ID of this <code>Achievement</code> object.
     * @param achievementID ID of the <code>Achievement</code>
     */
    public void setAchievementID(int achievementID) {
        this.achievementID = achievementID;
    }

    /**
     * Return the ID of the <code>Module</code> that this <code>Achievement</code> associates with in <code>int</code> format.
     * @return the <code>Module</code> ID
     */
    public int getModuleID() {
        return moduleID;
    }

    /**
     * Set the ID of the <code>Module</code> that this <code>Achievement</code> associates with.
     * @param moduleID ID of the <code>Module</code>
     */
    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    /**
     * Return the name of this <code>Achievement</code> object in <code>String</code> format.
     * @return the <code>Achievement</code> name
     */
    public String getAchievementName() {
        return achievementName;
    }

    /**
     * Set the name of this <code>Achievement</code> object.
     * @param achievementName the <code>Achievement</code> name
     */
    public void setAchievementName(String achievementName) {
        this.achievementName = achievementName;
    }

    /**
     * Return the description of this <code>Achievement</code> object in <code>String</code> format.
     * @return the <code>Achievement</code> description
     */
    public String getAchievementDescription() {
        return achievementDescription;
    }

    /**
     * Set the description of this <code>Achievement</code> object.
     * @param achievementDescription the <code>Achievement</code> description
     */
    public void setAchievementDescription(String achievementDescription) {
        this.achievementDescription = achievementDescription;
    }

    /**
     * Return the thumbnail image path of the <code>Achievement</code> object in <code>String</code> format.
     * @return the <code>Achievement</code> image path
     */
    public String getImagePath() {
        return imagePath;
    }

    /**
     * Set the thumbnail image path of this <code>Achievement</code> object.
     * @param imagePath the <code>Achievement</code> image path
     */
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    /**
     * Return the state whether the user has already unlock this <code>Achievement</code> object in <code>boolean</code> format.
     * @return the <code>Achievement</code> state
     */
    public boolean isUnlocked() {
        return unlocked;
    }

    /**
     * Set the state whether the user has already unlock this <code>Achievement</code> object.
     * @param unlocked the state of <code>Achievement</code> unlocked.
     */
    public void setUnlocked(boolean unlocked) {
        this.unlocked = unlocked;
    }

    /**
     * Return the unlock time of this <code>Achievement</code> object in <code>LocalDateTime</code> format.
     * If the <code>Achievement</code> is not unlocked yet, this method will return the time at <code>LocalDateTime.MIN</code>
     * @return the unlock time of this <code>Achievement</code>
     */
    public LocalDateTime getUnlockTime() {
        return unlockTime;
    }

    /**
     * Set the unlock time of this <code>Achievement</code> object.
     * Only use this method if the <code>Achievement</code> state is unlocked.
     * @param unlockTime the unlock time of this <code>Achievement</code>
     */
    public void setUnlockTime(LocalDateTime unlockTime) {
        this.unlockTime = unlockTime;
    }
}
