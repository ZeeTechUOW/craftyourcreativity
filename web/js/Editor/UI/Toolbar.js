/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Deni Barasena
 */

function Toolbar(context) {
    this.context = context;
    var scene;

    this.onSceneChanged = function (scene) {
        this.scene = scene;
    };

    this.update = function () {

    };
}
