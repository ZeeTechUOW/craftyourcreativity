package Model;

import java.time.LocalDateTime;

/**
 *
 * @author Andree Yosua
 */
public class Module {

    private int moduleID;
    private String moduleVersion;
    private String moduleName;
    private String moduleDescription;
    private String thumbnailPath;
    private LocalDateTime releaseTime;
    private LocalDateTime lastEdited;

    /**
     * Class to represent the module details and information
     *
     * @param moduleID Module ID
     * @param moduleVersion Module version
     * @param moduleName Module name
     * @param moduleDescription Module description
     * @param thumbnailPath Module thumbnail image path
     * @param releaseTime Module release time
     * @param lastEdited Module last edited time
     */
    public Module(int moduleID, String moduleVersion, String moduleName, String moduleDescription, String thumbnailPath, LocalDateTime releaseTime, LocalDateTime lastEdited) {
        this.moduleID = moduleID;
        this.moduleVersion = moduleVersion;
        this.moduleName = moduleName;
        this.moduleDescription = moduleDescription;
        this.thumbnailPath = thumbnailPath;
        this.releaseTime = releaseTime;
        this.lastEdited = lastEdited;
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

    /**
     * Return this <code>Module</code> version detail in <code>String</code> format.
     * @return Module version.
     */
    public String getModuleVersion() {
        return moduleVersion;
    }

    /**
     * Set this <code>Module</code> version to specified <code>String</code>.
     * @param moduleVersion Module new version
     */
    public void setModuleVersion(String moduleVersion) {
        this.moduleVersion = moduleVersion;
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
     * Return this <code>Module</code> thumbnail image path in <code>String</code> format.
     * @return Module thumbnail image path.
     */
    public String getThumbnailPath() {
        return thumbnailPath;
    }

    /**
     * Set this <code>Module</code> thumbnail image path to specified <code>String</code>.
     * @param thumbnailPath Module new thumbnail image path.
     */
    public void setThumbnailPath(String thumbnailPath) {
        this.thumbnailPath = thumbnailPath;
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
