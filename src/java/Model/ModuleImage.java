package Model;

/**
 *
 * @author Andree Yosua
 */
public class ModuleImage {

    private int moduleID;
    private String imagePath;

    /**
     * Class used to store the image path of the module.
     * @param moduleID Module ID
     * @param imagePath Module image path
     */
    public ModuleImage(int moduleID, String imagePath) {
        this.moduleID = moduleID;
        this.imagePath = imagePath;
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
     * Return this <code>ModuleImage</code> image path in <code>String</code> format.
     * @return ModuleImage image path.
     */
    public String getImagePath() {
        return imagePath;
    }

    /**
     * Set this <code>ModuleImage</code> image path to specified <code>String</code>.
     * @param imagePath ModuleImagePath new image path
     */
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }// </editor-fold>\
}
