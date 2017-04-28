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
     *
     * @param moduleID
     * @param moduleVersion
     * @param moduleName
     * @param moduleDescription
     * @param thumbnailPath
     * @param releaseTime
     * @param lastEdited
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
     *
     * @return
     */
    public int getModuleID() {
        return moduleID;
    }

    /**
     *
     * @param moduleID
     */
    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    /**
     *
     * @return
     */
    public String getModuleVersion() {
        return moduleVersion;
    }

    /**
     *
     * @param moduleVersion
     */
    public void setModuleVersion(String moduleVersion) {
        this.moduleVersion = moduleVersion;
    }

    /**
     *
     * @return
     */
    public String getModuleName() {
        return moduleName;
    }

    /**
     *
     * @param moduleName
     */
    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    /**
     *
     * @return
     */
    public String getModuleDescription() {
        return moduleDescription;
    }

    /**
     *
     * @param moduleDescription
     */
    public void setModuleDescription(String moduleDescription) {
        this.moduleDescription = moduleDescription;
    }

    /**
     *
     * @return
     */
    public String getThumbnailPath() {
        return thumbnailPath;
    }

    /**
     *
     * @param thumbnailPath
     */
    public void setThumbnailPath(String thumbnailPath) {
        this.thumbnailPath = thumbnailPath;
    }

    /**
     *
     * @return
     */
    public LocalDateTime getReleaseTime() {
        return releaseTime;
    }

    /**
     *
     * @param releaseTime
     */
    public void setReleaseTime(LocalDateTime releaseTime) {
        this.releaseTime = releaseTime;
    }

    /**
     *
     * @return
     */
    public LocalDateTime getLastEdited() {
        return lastEdited;
    }

    /**
     *
     * @param lastEdited
     */
    public void setLastEdited(LocalDateTime lastEdited) {
        this.lastEdited = lastEdited;
    }

    /**
     *
     * @return
     */
    public String getReleaseTimeFormatted() {
        return releaseTime.getDayOfMonth() + " " + releaseTime.getMonth().toString() + " " + releaseTime.getYear();
    }

    /**
     *
     * @return
     */
    public String getLastUpdatedFormatted() {
        return lastEdited.getDayOfMonth() + " " + lastEdited.getMonth().toString() + " " + lastEdited.getYear();
    }// </editor-fold>\
}
