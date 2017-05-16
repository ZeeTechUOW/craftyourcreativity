/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function Edit(name, scene, frame, action) {
    this.isAnEdit = true;

    this.initDo = true;
    this.edits = [];
    this.scene = scene;
    this.frame = frame;
    this.action = action;
    this.combineSignal = null;

    this.onCompleted = null;

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

        if (this.onCompleted) {
            this.onCompleted();
        }
    };

    this.doEdit = function () {

    };

    this.undoEdit = function () {
        this.changeToTargetEnv();

        this._undoEdit();

        if (this.onCompleted) {
            this.onCompleted();
        }
    };

    this._undoEdit = function () {

    };

    this.getName = function () {
        return name;
    };

    this.setOnCompleted = function (onCompleted) {
        this.onCompleted = onCompleted;
        return this;
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

    this.dontInitDo = function () {
        this.initDo = false;
        return this;
    };

    this.combine = function (edit) {
        this.edits.push(edit);

        if (!this._ue) {
            this._ue = this.undoEdit;
        }
        this.undoEdit = function () {
            for (var k in this.edits) {
                var e = this.edits[k];
                e.undoEdit();
            }

            this._ue();
        };


        if (!this._re) {
            this._re = this.redoEdit;
        }
        this.redoEdit = function () {
            for (var k in this.edits) {
                var e = this.edits[k];
                e.redoEdit();
            }

            this._re();
        };

        return this;
    };

    this.setCombineSignal = function (signal) {
        this.combineSignal = signal;

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
    edit.node = node;
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

        if (stateData.x) {
            edit.prevStateData.x = node.x;
        }
        if (stateData.y) {
            edit.prevStateData.y = node.y;
        }

        if (stateData.flowOutput !== undefined) {
            edit.prevStateData.flowOutput = {};
            for (var k in stateData.flowOutput) {
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
        if (data.x) {
            edit.node.x = data.x;
        }
        if (data.y) {
            edit.node.y = data.y;
        }

        if (data.flowOutput !== undefined) {
            for (var k in data.flowOutput) {
                edit.node.flowOutput[k] = data.flowOutput[k];
            }
        }

        for (var k in data.content) {
            var c = data.content[k];

            if (c.value !== undefined) {
                if (!edit.node.content[k]) {
                    edit.node.content[k] = {};
                }
                edit.node.content[k].value = c.value;
            }
            if (c.dataInput !== undefined) {
                if (!edit.node.content[k]) {
                    edit.node.content[k] = {};
                }
                edit.node.content[k].dataInput = c.dataInput;
            }
        }
    };

    return edit;
};
Edit.deleteNodeEdit = function (node) {
    var edit = Edit.addNodeEdit(node).reverse(function () {
        return "Delete " + node.nodeName;
    });

    return edit;
};

Edit.addActionEdit = function (action, scene, frame) {
    var edit = new Edit("Add", scene, frame, action);

    edit.getName = function () {
        return "Add " + action.actionName;
    };

    edit.doEdit = function () {
        edit.frame.addAction(edit.action);
    };

    edit._undoEdit = function () {
        edit.frame.removeActionByObject(edit.action);
    };

    return edit;
};
Edit.moveAction = function (action, scene, from, to) {
    var edit = new Edit("Move", scene);
    edit.action = action;

    edit.getName = function () {
        return "Move " + action.actionName;
    };

    edit.doEdit = function () {

    };

    edit._undoEdit = function () {

    };

    return edit;
};
Edit.editActionEdit = function (action, scene, frame, stateData, label, prevStateData) {
    var edit = new Edit("Edit", scene);
    edit.action = action;

    edit.stateData = stateData;
    edit.prevStateData = prevStateData;
    if (!edit.prevStateData) {
        edit.prevStateData = {};


    }

    edit.getName = function () {
        return "Edit " + action.actionName;
    };

    edit.doEdit = function () {

    };

    edit._undoEdit = function () {

    };

    return edit;

};
Edit.deleteActionEdit = function (action, scene, frame) {
    var edit = Edit.addActionEdit(action, scene, frame).reverse(function () {
        return "Delete " + action.actionName;
    });

    return edit;
};


Edit.addEventEdit = function () {

};
Edit.editEventEdit = function () {

};
Edit.deleteEventEdit = function () {

};

Edit.addFrameEdit = function (frame, scene, frameNumber) {
    var edit = new Edit("Add", scene, frame);
    edit.frameNumber = frameNumber;
    edit.getName = function () {
        return "Add Frame";
    };

    edit.doEdit = function () {
        if( edit.frameNumber ) {
            edit.scene.addFrameAt(edit.frame, edit.frameNumber);
        } else {
            edit.scene.addFrame(edit.frame);
        }
    };

    edit._undoEdit = function () {
        editor.activeScene.removeCurrentFrame();
    };

    return edit;

};
Edit.editFrameEdit = function (frame, scene, key, newValue, oldValue) {
    var edit = new Edit("Edit", scene, frame);
    edit.key = key;
    edit.newValue = newValue;
    edit.oldValue = oldValue;
    
    edit.getName = function () {
        return "Edit Frame";
    };

    edit.doEdit = function () {
        edit.frame.set(edit.key, edit.newValue);
    };

    edit._undoEdit = function () {
        edit.frame.set(edit.key, edit.oldValue);
    };

    return edit;

};
Edit.deleteFrameEdit = function (frame, scene, frameNumber) {
    var i = 0;
    for( var k in scene.frames ) {
        if( scene.frames[k] === frame ) {
            frameNumber = i;
            break;
        }
        i++;
    }
    
    var edit = Edit.addFrameEdit(frame, scene).reverse(function () {
        return "Delete Frame";
    });
    edit.frameNumber = frameNumber;

    return edit;

};

Edit.addSceneEdit = function (scene) {
    var edit = new Edit("Add", scene);

    edit.getName = function () {
        return "Add " + scene.sceneName;
    };

    edit.affectedNodes = null;
    
    edit.setUpAffectedNodes = function () {
        edit.affectedNodes = [];
        for( var k in editor.diagramPanel.nodes ) {
            var node = editor.diagramPanel.nodes[k];
            
            if( node.content && node.content.sceneName && node.content.sceneName.value === edit.scene) {
                if(editor.project.scenes > 0) {
                    node.content.sceneName.value = editor.project.scenes[0];
                } else {
                    node.content.sceneName.value = null;
                }
                
                var flowOutput = {};
                var content = {};
                var otherNodes = [];
                
                for (var j in node.flowOutput ) {
                    flowOutput[j] = node.flowOutput[j];
                }
                for (var j in node.content ) {
                    if(j !== "sceneName") {
                        content[j] = {};
                        content[j].value = node.content[j].value;
                        content[j].dataInput = node.content[j].dataInput;
                    }
                }
                for( var j in editor.diagramPanel.nodes ) {
                    var oNode = editor.diagramPanel.nodes[j];
                    
                    var oNodeContent = null;
                    for( var i in oNode.content ) {
                        var dataInput = oNode.content[i].dataInput;
                        if( dataInput && dataInput !== true) {
                            if(dataInput.split("|")[0] === "" + node.nodeID) {
                                if( !oNodeContent ) {
                                    oNodeContent = {};
                                }
                                
                                oNodeContent[i] = {dataInput: dataInput};
                                oNode.content[i].dataInput = true;
                            }
                        }
                    }
                    
                    if( oNodeContent ) {
                        otherNodes.push({node: oNode, content: oNodeContent});
                    }
                }
                
                edit.affectedNodes.push({node: node, flowOutput: flowOutput, content: content, otherNodes: otherNodes});
            }
        }
    };
    
    edit.doEdit = function () {
        
        for( var k in edit.affectedNodes ) {
            var nodeData = edit.affectedNodes[k];
            var node = nodeData.node;
            
            node.content.sceneName.value = edit.scene;
            
            for( var j in nodeData.flowOutput ) {
                node.flowOutput[j] = nodeData.flowOutput[j];
            }
            for( var j in nodeData.content ) {
                if( !node.content[j] ) {
                    node.content[j] = {};
                }
                node.content[j].value = nodeData.content[j].value;
                node.content[j].dataInput = nodeData.content[j].dataInput;
            }
            for( var j in nodeData.otherNodes ) {
                var oNodeData = nodeData.otherNodes[j];
                
                for( var i in oNodeData.content ) {
                    oNodeData.node.content[i].dataInput = oNodeData.content[i].dataInput;
                }
            }
        }
        
        editor.project.addScene(edit.scene);
    };

    edit._undoEdit = function () {
        if(!edit.affectedNodes) {
            edit.setUpAffectedNodes();
        }
        
        editor.project.removeScene(edit.scene);
    };

    return edit;
};
Edit.editSceneEdit = function (scene, key, newValue, oldValue) {
    var edit = new Edit("Edit", scene);
    edit.key = key;
    edit.newValue = newValue;
    edit.oldValue = oldValue;
    
    edit.getName = function () {
        return "Edit " + scene.sceneName;
    };

    edit.doEdit = function () {
        edit.scene.set(edit.key, edit.newValue);
    };

    edit._undoEdit = function () {
        edit.scene.set(edit.key, edit.oldValue);
    };

    return edit;
};
Edit.deleteSceneEdit = function (scene) {
    var edit = Edit.addSceneEdit(scene).reverse(function () {
        return "Delete " + scene.sceneName;
    });

    return edit;
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
