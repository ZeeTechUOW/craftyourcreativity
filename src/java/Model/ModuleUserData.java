/*
 * Copyright 2017 Andree Yosua.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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

    public ModuleUserData(int moduleID, int userID, String mKey, String mValue) {
        this.moduleID = moduleID;
        this.userID = userID;
        this.mKey = mKey;
        this.mValue = mValue;
    }

    // <editor-fold defaultstate="collapsed" desc="Getter and Setter. Click + sign on the left to expand the code">
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
    }// </editor-fold>\

    public static Comparator<ModuleUserData> sortByScoreDesc = new Comparator<ModuleUserData>() {
        @Override
        public int compare(ModuleUserData o1, ModuleUserData o2) {
            return Integer.valueOf(o2.getmValue()).compareTo(Integer.valueOf(o1.getmValue()));
        }
    };

    public static Comparator<ModuleUserData> sortByModuleIDAsc = new Comparator<ModuleUserData>() {
        @Override
        public int compare(ModuleUserData o1, ModuleUserData o2) {
            return Integer.compare(o1.getModuleID(), o2.getModuleID());
        }
    };
}
