package Model;

public class ModuleImage {

    private int moduleID;
    private String imagePath;

    public ModuleImage(int moduleID, String imagePath) {
        this.moduleID = moduleID;
        this.imagePath = imagePath;
    }

    public int getModuleID() {
        return moduleID;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}
