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

function Edit(ext) {
    
}

Edit.addEntityEdit = function () {
    var edit = new Edit("Add ");
};
Edit.editEntityEdit = function () {
    
};
Edit.deleteEntityEdit = function () {
    
};

Edit.addNodeEdit = function () {
    
};
Edit.editNodeEdit = function () {
    
};
Edit.deleteNodeEdit = function () {
    
};

Edit.addFlowEdit = function () {
    
};
Edit.editFlowEdit = function () {
    
};
Edit.deleteFlowEdit = function () {
    
};

Edit.addActionEdit = function () {
    
};
Edit.editActionEdit = function () {
    
};
Edit.deleteActionEdit = function () {
    
};

Edit.addEventEdit = function () {
    
};
Edit.editEventEdit = function () {
    
};
Edit.deleteEventEdit = function () {
    
};

Edit.addFrameEdit = function () {
    
};
Edit.editFrameEdit = function () {
    
};
Edit.deleteFrameEdit = function () {
    
};

Edit.addSceneEdit = function () {
    
};
Edit.editSceneEdit = function () {
    
};
Edit.deleteSceneEdit = function () {
    
};

Edit.addVariableEdit = function () {
    
};
Edit.editVariableEdit = function () {
    
};
Edit.deleteVariableEdit = function () {
    
};
