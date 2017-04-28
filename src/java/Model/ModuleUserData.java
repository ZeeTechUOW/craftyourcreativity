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
     *
     * @param moduleID
     * @param userID
     * @param mKey
     * @param mValue
     */
    public ModuleUserData(int moduleID, int userID, String mKey, String mValue) {
        this.moduleID = moduleID;
        this.userID = userID;
        this.mKey = mKey;
        this.mValue = mValue;
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
    public int getUserID() {
        return userID;
    }

    /**
     *
     * @param userID
     */
    public void setUserID(int userID) {
        this.userID = userID;
    }

    /**
     *
     * @return
     */
    public String getmKey() {
        return mKey;
    }

    /**
     *
     * @param mKey
     */
    public void setmKey(String mKey) {
        this.mKey = mKey;
    }

    /**
     *
     * @return
     */
    public String getmValue() {
        return mValue;
    }

    /**
     *
     * @param mValue
     */
    public void setmValue(String mValue) {
        this.mValue = mValue;
    }

    /**
     *
     */
    public static Comparator<ModuleUserData> sortByScoreDesc = new Comparator<ModuleUserData>() {
        @Override
        public int compare(ModuleUserData o1, ModuleUserData o2) {
            return Integer.valueOf(o2.getmValue()).compareTo(Integer.valueOf(o1.getmValue()));
        }
    };

    /**
     *
     */
    public static Comparator<ModuleUserData> sortByModuleIDAsc = new Comparator<ModuleUserData>() {
        @Override
        public int compare(ModuleUserData o1, ModuleUserData o2) {
            return Integer.compare(o1.getModuleID(), o2.getModuleID());
        }
    };
}
