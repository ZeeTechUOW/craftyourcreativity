package Model;

/**
 *
 * @author Andree Yosua
 */
public class ModuleImage {

    private int moduleID;
    private String imagePath;

    /**
     *
     * @param moduleID
     * @param imagePath
     */
    public ModuleImage(int moduleID, String imagePath) {
        this.moduleID = moduleID;
        this.imagePath = imagePath;
    }

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
    public String getImagePath() {
        return imagePath;
    }

    /**
     *
     * @param imagePath
     */
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}
