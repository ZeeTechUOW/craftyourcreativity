/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//function EditAction(opt, do_, undo) {
//    this.opt = opt;
//    this.name = opt.name;
//    this.focus = opt.focus;
//    this._do = do_;
//    this._undo = undo;
//
//    this.do = function () {
//        return this._do(opt);
//    };
//
//    this.undo = function () {
//        return this._undo(opt);
//    };
//
//    this.setFocus = function () {
//
//    };
//}

function Edit(name, scene, frame, action) {
    this.isAnEdit = true;

    this.scene = scene;
    this.frame = frame;
    this.action = action;

    this.changeToTargetEnv = function () {
        if (this.scene) {
            if (editor.activeScene !== this.scene) {
                editor.changeScene(scene);
            }
            if (editor.activeScene && this.frame !== undefined && editor.activeScene.activeFrame !== this.frame) {
                editor.activeScene.changeFrame(this.frame);
            }
            if (editor.activeScene && editor.activeScene.activeFrame && this.action !== undefined && editor.activeScene.activeFrame.activeAction !== this.action) {
                editor.activeScene.activeFrame.selectAction(this.action);
            }
        } else if (this.isDiagram) {
            if (!editor.isInDiagram) {
                editor.toDiagram();
            }
        }
    };

    this.redoEdit = function () {
        this.changeToTargetEnv();

        this.doEdit();

    };

    this.doEdit = function () {

    };

    this.undoEdit = function () {
        this.changeToTargetEnv();

        this._undoEdit();
    };

    this._undoEdit = function () {

    };

    this.getName = function () {
        return name;
    };

    this.reverse = function (nameCallback) {
        var undo = this._undoEdit;
        this._undoEdit = this.doEdit;
        this.doEdit = undo;

        if (nameCallback) {
            this.getName = nameCallback;
        }

        return this;
    };
    
    this.changeName = function (getName) {
        this.getName = getName;
        return this;
    };
}

Edit.addEntityEdit = function (entity, targetScene) {
    var edit = new Edit("Add", targetScene);
    edit.entity = entity;

    edit.getName = function () {
        return "Add " + entity.name;
    };

    edit.doEdit = function () {
        edit.scene.addEntityToScene(edit.entity);
    };
    edit._undoEdit = function () {
        edit.scene.removeEntityFromScene(edit.entity);
        editor.viewport.setSelected(null);
    };

    return edit;
};
Edit.editEntityEdit = function (entity, targetScene, targetFrame, stateData, label, prevStateData) {
    if (!label) {
        label = "Edit ";
    }

    var edit = new Edit("Edit", targetScene, targetFrame);
    edit.entity = entity;
    edit.stateData = stateData;

    edit.prevStateData = prevStateData;
    if (!edit.prevStateData) {
        edit.prevStateData = {};

        for (var k in stateData) {
            edit.prevStateData[k] = edit.entity.getFlat(k);
        }
    }
    edit.getName = function () {
        return label + " " + entity.name;
    };

    edit.doEdit = function () {
        for (var k in edit.stateData) {
            edit.entity.setFlat(k, edit.stateData[k]);
        }
    };

    edit._undoEdit = function () {
        for (var k in edit.prevStateData) {
            edit.entity.setFlat(k, edit.prevStateData[k]);
        }
    };
    

    return edit;
};
Edit.reorderEntityEdit = function (entity, targetScene, value, value2) {
    var edit = new Edit("Reorder", targetScene);
    edit.entity = entity;
    edit.value = value;
    edit.value2 = value2;

    edit.getName = function () {
        return "Reorder " + entity.name;
    };

    edit.doEdit = function () {
        edit.entity.sprite.zIndex = edit.value;
        editor.viewport.updateLayerOrder();
        editor.sceneContentPanel.updateSceneContent();
    };

    edit._undoEdit = function () {
        edit.entity.sprite.zIndex = edit.value2;
        editor.viewport.updateLayerOrder();
        editor.sceneContentPanel.updateSceneContent();
    };

    return edit;
};
Edit.deleteEntityEdit = function (entity, targetScene, targetFrame) {
    var edit = Edit.addEntityEdit(entity, targetScene).reverse(function () {
        return "Delete " + entity.name;
    });
    edit.frame = targetFrame;

    return edit;
};

Edit.addNodeEdit = function (node) {
    var edit = new Edit("Add");
    edit.isDiagram = true;

    edit.getName = function () {
        return "Add " + node.nodeName;
    };

    edit.doEdit = function () {
        editor.diagramPanel.addNodeToDiagram(edit.node);
    };

    edit._undoEdit = function () {
        editor.diagramPanel.deleteNodeFromDiagram(edit.node);
    };
    
    return edit;
};
Edit.editNodeEdit = function (node, stateData, label, prevStateData) {
    var edit = new Edit("Edit");
    edit.isDiagram = true;

    edit.node = node;
    edit.stateData = stateData;
    edit.prevStateData = prevStateData;
    if (!edit.prevStateData) {
        edit.prevStateData = {content: {}};
        
        if( stateData.x ) {
            edit.prevStateData.x = node.x;
        }
        if( stateData.y ) {
            edit.prevStateData.y = node.y;
        }

        if (stateData.flowOutput !== undefined) {
            edit.prevStateData.flowOutput = {};
            for(var k in stateData.flowOutput) {
                edit.prevStateData.flowOutput[k] = node.flowOutput[k];
            }
        }

        for (var k in stateData.content) {
            var c = stateData.content[k];

            var pc = {};
            if (c.value !== undefined) {
                pc.value = node.content[k].value;
            }
            if (c.dataInput !== undefined) {
                pc.dataInput = node.content[k].dataInput;
            }
            
            edit.prevStateData.content[k] = pc;
        }
    }
    
    console.log(stateData);
    console.log(edit.prevStateData);

    edit.getName = function () {
        return label + " " + node.nodeName;
    };

    edit.doEdit = function () {
        edit.copyDataToNode(edit.stateData);
        editor.diagramPanel.updateDiagramPanel();
    };

    edit._undoEdit = function () {
        edit.copyDataToNode(edit.prevStateData);
        editor.diagramPanel.updateDiagramPanel();
    };
    
    edit.copyDataToNode = function (data) {
        if( data.x ) {
            edit.node.x = data.x;
        }
        if( data.y ) {
            edit.node.y = data.y;
        }
        
        if (data.flowOutput !== undefined) {
            for( var k in data.flowOutput ) {
                edit.node.flowOutput[k] = data.flowOutput[k];
            }
        }

        for (var k in data.content) {
            var c = data.content[k];

            if (c.value !== undefined) {
                edit.node.content[k].value = c.value;
            }
            if (c.dataInput !== undefined) {
                edit.node.content[k].dataInput = c.dataInput;
            }
        }
        
        console.log(edit.node);
    };
    
    return edit;
};
Edit.deleteNodeEdit = function (node) {
    var edit = Edit.addNodeEdit(node).reverse(function () {
        return "Delete " + node.nodeName;
    });

    return edit;
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

Edit.startRecordingEdit = function () {

};
Edit.finishRecordingEdit = function () {

};
