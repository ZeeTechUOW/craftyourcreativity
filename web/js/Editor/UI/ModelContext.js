/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Deni Barasena
 */

function ModelContext(data, initPaneling) {
    this.data = data;
    this.fieldList = [];
    this.initPaneling = initPaneling;

    this.init = function () {
        if (this.initPaneling) {
            this.initPaneling(this, InputRenderer);
        }
    };

    this.insert = function (index, panel) {
        if (!panel) {
            panel = index;

            this.fieldList.push(panel);
        } else {
            this.fieldList.splice(index, 0, panel);
        }
    };

    this.updateUI = function () {
        for (var k in this.fieldList) {
            var f = this.fieldList[k];
            if (f.updateUI)
                f.updateUI();
        }
    };
}