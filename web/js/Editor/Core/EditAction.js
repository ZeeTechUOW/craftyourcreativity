/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function EditAction(opt, do_, undo) {
    this.opt = opt;
    this.name = opt.name;
    this.focus = opt.focus;
    this._do = do_;
    this._undo = undo;

    this.do = function () {
        return this._do(opt);
    };

    this.undo = function () {
        return this._undo(opt);
    };

    this.setFocus = function () {

    };
}