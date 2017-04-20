
package Model;

import java.util.Comparator;

public class ModuleUserData {
    private int moduleID;
    private int userID;
    private String mKey;
    private String mValue;

    public ModuleUserData(int moduleID, int userID, String mKey, String mValue) {
        this.moduleID = moduleID;
        this.userID = userID;
        this.mKey = mKey;
        this.mValue = mValue;
    }

    public int getModuleID() {
        return moduleID;
    }

    public void setModuleID(int moduleID) {
        this.moduleID = moduleID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getmKey() {
        return mKey;
    }

    public void setmKey(String mKey) {
        this.mKey = mKey;
    }

    public String getmValue() {
        return mValue;
    }

    public void setmValue(String mValue) {
        this.mValue = mValue;
    }
    
    public static Comparator<ModuleUserData> sortByScoreDesc = new Comparator<ModuleUserData>() {
        @Override
        public int compare(ModuleUserData o1, ModuleUserData o2) {
            return Integer.valueOf(o2.getmValue()).compareTo(Integer.valueOf(o1.getmValue()));
        }
    };
}
