package Model;

import java.util.Comparator;

/**
 *
 * @author Andree Yosua
 */
public class ModuleUserData {

    private int moduleID;
    private int userID;
    private String mKey;
    private String mValue;

    /**
     * Class to represent variety user data from <code>Module</code>.
     * @param moduleID Module ID
     * @param userID User ID
     * @param mKey Key data
     * @param mValue Value of key data
     */
    public ModuleUserData(int moduleID, int userID, String mKey, String mValue) {
        this.moduleID = moduleID;
        this.userID = userID;
        this.mKey = mKey;
        this.mValue = mValue;
    }

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">
    /**
     * Return the <code>Module</code> ID tied to this <code>ModuleUserData</code> in <code>int</code> format.
     * @return Module ID.
     */
    public int getModuleID() {
        return moduleID;
    }

    /**
     * Set the <code>Module</code> ID tied to this <code>ModuleUserData</code> to specified <code>int</code>.
     * @param moduleID Module new ID
     */
    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    /**
     * Return the <code>User</code> ID tied to this <code>ModuleUserData</code> in <code>int</code> format.
     * @return User ID.
     */
    public int getUserID() {
        return userID;
    }

    /**
     * Set the <code>User</code> ID tied to this <code>ModuleUserData</code> to specified <code>int</code>.
     * @param userID User new ID
     */
    public void setUserID(int userID) {
        this.userID = userID;
    }

    /**
     * Return the key of <code>ModuleUserData</code> in <code>String</code> format.
     * @return Key.
     */
    public String getmKey() {
        return mKey;
    }

    /**
     * Set the <code>ModuleUserData</code> key to specified <code>String</code>.
     * @param mKey New key data
     */
    public void setmKey(String mKey) {
        this.mKey = mKey;
    }

    /**
     * Return the key value of <code>ModuleUserData</code> in <code>String</code> format.
     * @return Value of key
     */
    public String getmValue() {
        return mValue;
    }

    /**
     * Set the <code>ModuleUserData</code> key value to specified <code>String</code>.
     * @param mValue New value of key
     */
    public void setmValue(String mValue) {
        this.mValue = mValue;
    }// </editor-fold>\

    /**
     * Sort <code>ModuleUserData</code> by <code>mValue</code> descending for high score.
     * For this Comparator, <code>mValue</code> must contain number only as the <code>mValue</code> would be converted to <code>int</code> for sorting.
     */
    public static Comparator<ModuleUserData> sortByScoreDesc = new Comparator<ModuleUserData>() {
        @Override
        public int compare(ModuleUserData o1, ModuleUserData o2) {
            return Integer.valueOf(o2.getmValue()).compareTo(Integer.valueOf(o1.getmValue()));
        }
    };

    /**
     * Sort <code>ModuleUserData</code> by <code>moduleID</code>  ascending for listing user library.
     */
    public static Comparator<ModuleUserData> sortByModuleIDAsc = new Comparator<ModuleUserData>() {
        @Override
        public int compare(ModuleUserData o1, ModuleUserData o2) {
            return Integer.compare(o1.getModuleID(), o2.getModuleID());
        }
    };
}
