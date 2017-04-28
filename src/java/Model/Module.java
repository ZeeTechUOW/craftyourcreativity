package Model;

import java.time.LocalDateTime;

public class Module {

    private int moduleID;
    private String moduleVersion;
    private String moduleName;
    private String moduleDescription;
    private String thumbnailPath;
    private LocalDateTime releaseTime;
    private LocalDateTime lastEdited;

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
    public int getModuleID() {
        return moduleID;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public String getModuleVersion() {
        return moduleVersion;
    }

    public void setModuleVersion(String moduleVersion) {
        this.moduleVersion = moduleVersion;
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

    public String getThumbnailPath() {
        return thumbnailPath;
    }

    public void setThumbnailPath(String thumbnailPath) {
        this.thumbnailPath = thumbnailPath;
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
        return releaseTime.getDayOfMonth() + " " + releaseTime.getMonth().toString() + " " + releaseTime.getYear();
    }

    public String getLastUpdatedFormatted() {
        return lastEdited.getDayOfMonth() + " " + lastEdited.getMonth().toString() + " " + lastEdited.getYear();
    }// </editor-fold>\
}
