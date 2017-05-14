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

    /**
     * Class to represent the module details and information.
     *
     * @param moduleID Module ID
     * @param userID User ID
     * @param moduleVersion Module version
     * @param moduleName Module name
     * @param moduleDescription Module description
     * @param releaseTime Module release time
     * @param lastEdited Module last edited time
     * @param likes Amount of likes
     * @param dislikes Amount of dislikes
     */
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

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">
    /**
     * Return this <code>Module</code> ID in <code>int</code> format.
     * @return Module ID.
     */
    public int getModuleID() {
        return moduleID;
    }

    /**
     * Set this <code>Module</code> ID to specified <code>int</code>.
     * @param moduleID Module new ID
     */
    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
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
     * Return this <code>User</code> ID in <code>int</code> format.
     * @return User ID.
     */
    public int getUserID() {
        return userID;
    }

    /**
     * Set this <code>User</code> ID to specified <code>int</code>.
     * @param userID User new ID
     */
    public void setUserID(int userID) {
        this.userID = userID;
    }

    /**
     * Return this <code>Module</code> name in <code>String</code>format.
     * @return Module name.
     */
    public String getModuleName() {
        return moduleName;
    }

    /**
     * Set this <code>Module</code> name to specified <code>String</code>.
     * @param moduleName Module new name.
     */
    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    /**
     * Return this <code>Module</code> description in <code>String</code> format.
     * @return Module description.
     */
    public String getModuleDescription() {
        return moduleDescription;
    }

    /**
     * Set this <code>Module</code> description to specified <code>String</code>.
     * @param moduleDescription Module new description.
     */
    public void setModuleDescription(String moduleDescription) {
        this.moduleDescription = moduleDescription;
    }

    /**
     * Return this <code>Module</code> release time in <code>LocalDateTime</code> format.
     * @return Module release time.
     */
    public LocalDateTime getReleaseTime() {
        return releaseTime;
    }

    /**
     * Set this <code>Module</code> release time to specified <code>LocalDateTime</code>.
     * @param releaseTime Module new release time.
     */
    public void setReleaseTime(LocalDateTime releaseTime) {
        this.releaseTime = releaseTime;
    }

    /**
     * Return this <code>Module</code> last edited time in <code>LocalDateTime</code>.
     * @return Module last edited time.
     */
    public LocalDateTime getLastEdited() {
        return lastEdited;
    }

    /**
     * Set this <code>Module</code> last edited time to specified <code>LocalDateTime</code>
     * @param lastEdited Module new last edited time.
     */
    public void setLastEdited(LocalDateTime lastEdited) {
        this.lastEdited = lastEdited;
    }

    /**
     * Return a formatted release time with "DD MMMMM YYYY" format in <code>String</code>.
     * @return Formatted release time.
     */
    public String getReleaseTimeFormatted() {
        if(releaseTime == null) {
            return "Unpublished";
        }
        return releaseTime.getDayOfMonth() + " " + releaseTime.getMonth().toString() + " " + releaseTime.getYear();
    }

    /**
     * Return a formatted last edited time with "DD MMMMM YYYY" format in <code>String</code>.
     * @return Formatted last edited time.
     */
    public String getLastUpdatedFormatted() {
        return lastEdited.getDayOfMonth() + " " + lastEdited.getMonth().toString() + " " + lastEdited.getYear();
    }// </editor-fold>\
}
