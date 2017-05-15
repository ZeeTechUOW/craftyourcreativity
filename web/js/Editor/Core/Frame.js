/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Frame(scene) {
    this.context = scene.context;
    this.scene = scene;

    this.frameLabel = "";
    this.nextFrameOptions = "Automatic";
    this.actions = [];

    this.activeAction;
    
    this.getSelectedActionNo = function () {
        if( this.activeAction ) {
            for( var k in this.actions ) {
                for( var j in this.actions[k] ) {
                    if( this.actions[k][j] === this.activeAction ) {
                        return k;
                    }
                }
            } 
        }
        return -1;
    };

    this.addAction = function (action, actionNo, inBetween) {

        if ((actionNo || actionNo === 0) && actionNo < this.actions.length) {
            if (inBetween) {
                var as = [];
                as.push(action);
                this.actions.splice(actionNo, 0, as);
            } else {
                this.actions[actionNo].push(action);
            }
        } else {
            var as = [];
            as.push(action);
            this.actions.push(as);
        }

        this.context.editor.sequencePanel.updateSequencePanel();
    };
    this.removeAction = function (actionNo, simulNo) {
        if (simulNo) {
            this.actions[actionNo].splice(simulNo, 1);

            if (this.actions[actionNo].length <= 0) {
                this.actions.splice(actionNo, 1);
            }
        } else {
            this.actions.splice(actionNo, 1);
        }
    };
    this.selectAction = function (action, skipRerender) {
        if(action) {
            var isActionFound = false;
            
            for( var k in this.actions ) {
                for( var j in this.actions[k] ) {
                    if(this.actions[k][j] === action) {
                        isActionFound = true;
                        break;
                    }
                }
                if( isActionFound ) break;
            }
            
            if( !isActionFound ) {
                return;
            }
        }
        
        this.activeAction = action;

        this.context.editor.sequencePanel.updateSequencePanel();

        if (this.activeAction) {
            this.context.changeToActionModelContext(this.activeAction);
            this.scene.setSceneStateOnAction(action);
            $("#recordTool").prop("disabled", false);
        } else {
            this.context.changeToFrameModelContext(this);
            this.scene.setSceneStateOnFrame(this);
        }
        
        this.context.editor.toScene(true);
        
        $("#recordTool").removeClass("recording");
        $("#recordToolBadge").html("");
        this.context['recorded' + "Actions"] = {};
    };
    this.removeCurrentAction = function (skipUpdate) {
        if (this.activeAction) {
            this.removeActionByObject(this.activeAction, skipUpdate);
            this.selectAction(null);
        }
    };
    this.removeActionByObject = function (action, skipUpdate) {
        for (var k in this.actions) {
            for (var j in this.actions[k]) {
                if (this.actions[k][j] === action) {
                    this.removeAction(k, j);
                    if (!skipUpdate)
                        this.context.editor.sequencePanel.updateSequencePanel();
                }
            }
        }
    };

    this.serialize = function () {
        var s = this;

        var actions = {};
        for (var a in s.actions) {
            actions[a] = [];
            for (var b in s.actions[a]) {
                actions[a][b] = s.actions[a][b].serialize();
            }
        }

        var res = {};
        res.actions = actions;
        for (var k in Frame.serializable) {
            var kk = Frame.serializable[k];
            res[kk] = s[kk];
        }

        return res;
    };

    setupListener(this);
}


Frame.serializable = ["frameLabel", "nextFrameOptions"];

Frame.deserialize = function (scene, input) {
    var frame = new Frame(scene);

    for (var k in Frame.serializable) {
        var kk = Frame.serializable[k];
        frame[kk] = input[kk];
    }

    for (var e in input.actions) {
        frame.actions[e] = [];
        for (var f in input.actions[e]) {
            frame.actions[e][f] = Action.deserialize(frame, input.actions[e][f]);
        }
    }

    return frame;
};

Frame.nextFrameOptions = ["Automatic", "User Input", "User Input Forced", "Wait Indefinitely"];