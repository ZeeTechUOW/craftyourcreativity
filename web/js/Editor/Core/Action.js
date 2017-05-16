/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Action(context, opt) {
    this.context = context;
    if (!opt)
        opt = {};

    this.actionID = uid();
    this.actionName = "Action name";
    this.targetID = 0;
    this.stateMatrix = {};
    this.offset = 0;
    this.duration = 1000;

    for (var k in Action.serializable) {
        var kk = Action.serializable[k];
        if (opt[kk])
            this[kk] = opt[kk];
    }
    if (opt.easing)
        this.easing = opt.easing;
    if (opt.stateMatrix)
        this.stateMatrix = opt.stateMatrix;

    this.printAction = function () {

        if (this.isLinkAction) {
            return  "<div class='row actionRow actionObject'>" + this.actionName + "</div>" +
                    "<div class='row actionRow actionVal'>" + this.stateMatrix.link + "</div>";
        } else if (this.isDataAction) {
            return  "<div class='row actionRow actionObject'>" + this.actionName + "</div>" +
                    "<div class='row actionRow actionVal'>" + this.stateMatrix.dvarName + " to " + this.stateMatrix.dvalue + "</div>";
        } else if (this.isAudioAction) {
            return  "<div class='row actionRow actionObject'>" + this.actionName + "</div>" +
                    "<div class='row actionRow actionVal'>" + this.stateMatrix.audioSrc + (this.stateMatrix.loop ? " - Looped" : "") + "</div>";

        } else if (this.isEntityAction) {
            var newValues = "";

            for (var k in this.stateMatrix) {
                if (newValues !== "")
                    newValues += ", ";

                if( isNaN(+this.stateMatrix[k]) ) {
                    newValues += this.stateMatrix[k];
                    
                } else {
                    var val = Math.round(parseFloat(+this.stateMatrix[k]) * 100) / 100;
                    newValues += "" + val;
                }
            }

            return  "   <div class='row actionRow actionObject'>" + this.getTargetID() + "</div>" +
                    "   <div class='row actionRow actionOp'>" + this.actionName + " - " + this.easing.name + "</div>" +
                    "   <div class='row actionRow actionVal'>" + newValues + "</div>";
        }

        return "<div class='row actionRow actionOp'>Unsupported Action</div>";

    };

    this.doState = function (state) {
        if (this.isEntityAction) {
            for (var k in this.stateMatrix) {
                if (state["ss" + this.targetID]) {
                    state["ss" + this.targetID][k] = this.stateMatrix[k];
                } else {

                }
            }
        }
    };
    this.stepAction = function (t) {

    };
    this.startAction = function (f) {

    };
    this.endAction = function (f) {

    };

    this.getTargetID = function () {
        return this.context.editor.getEntityNameByID(this.targetID);
    };
    
    this.getLinkName = function () {
        var link = this.context.editor.resolveValue(this.stateMatrix.link);
        if ( link && link.startsWith("#") && link.length > 1) {
            return link.substring(1);
        }
        return null;
    };

    this.serialize = function () {
        var s = this;
        
        var res = {};
        for (var k in Action.serializable) {
            var kk = Action.serializable[k];
            res[kk] = s[kk];
        }
        if(this.isEntityAction) res.easing = s.easing;
        res.stateMatrix = s.stateMatrix;

        return res;
    };

    setupListener(this);

    var callback = function (newValue, res) {
        res.context.editor.sequencePanel.updateSequencePanel();
    };

    this.addListener(this, "actionName", callback);
    this.addListener(this, "targetID", callback);
    this.addListener(this, "duration", callback);
    this.addListener(this, "offset", callback);
    this.addListener(this, "easing", callback);
    this.addListener(this, "stateMatrix", callback);
}

Action.entityAction = function (ad) {
    var stateMatrix = {};

    for (var k in ad.op.values) {
        var v = ad.op.values[k];
        stateMatrix[ v.value ] = v.targetValue;
    }

    var opt = {
        actionName: "Change " + ad.op.name,
        targetID: ad.target.entityID,
        offset: ad.offset,
        duration: ad.duration,
        easing: ad.graph,
        stateMatrix: stateMatrix
    };

    var changePropAction = new Action(editor.context, opt);
    changePropAction.isEntityAction = true;

    return changePropAction;
};

Action.linkAction = function (link) {
    var opt = {
        actionName: "Go to",
        stateMatrix: {link: link}
    };

    var linkAction = new Action(editor.context, opt);
    linkAction.isLinkAction = true;

    return linkAction;
};

Action.dataAction = function (varName, value) {
    if (!varName || varName.length <= 0) {
        return;
    }
    if (!varName.startsWith("@") && !varName.startsWith("#")) {
        varName = "@" + varName;
    }

    var action = new Action(editor.context, {
        actionName: "Set Variable",
        stateMatrix: {dvarName: varName, dvalue: value}
    });

    action.isDataAction = true;

    return action;
};

Action.audioAction = function (audioData) {
    var action = new Action(editor.context, {
        actionName: "Play Audio",
        stateMatrix: {
            audioSrc: audioData.audioSrc,
            loop: audioData.loop,
            waitAudio: audioData.waitAudio,
            frameStop: audioData.frameStop,
            volume: audioData.volume,
            channel: audioData.channel
        }
    });

    action.isAudioAction = true;

    return action;
};

Action.basicAction = function (target, data) {
    var stateMatrix = {};
    var name = "";

    for (var k in data) {
        stateMatrix[ k ] = data[k];
        name += " " + k;
    }

    setDefault(data, {
        offset: 0,
        duration: 1000,
        easing: Action.LinearGraph
    });

    var opt = {
        actionName: "Change" + name,
        targetID: target.entityID,
        offset: data.offset,
        duration: data.duration,
        easing: data.easing,
        stateMatrix: stateMatrix
    };

    var action = new Action(editor.context, opt);
    action.isEntityAction = true;
    return action;
};

Action.serializable = ["actionID", "actionName", "targetID", "offset", "duration", "isLinkAction", "isEntityAction", "isDataAction", "isAudioAction"];

Action.deserialize = function (frame, input) {
    var action = new Action(frame.context);

    for (var k in Action.serializable) {
        var kk = Action.serializable[k];
        action[kk] = input[kk];
    }

    if (input.isEntityAction) {
        action.easing = Action.getEasingByName(input.easing.name);
        if (!action.easing) {
            action.easing = Action.LinearGraph;
        }
    }
    if(input.isLinkAction) {
        
    }

    action.stateMatrix = input.stateMatrix;

    return action;
};


Action.LinearGraph = {
    name: "Linear",
    calc: function (x) {
        return x;
    }
};

Action.Easings = [Action.LinearGraph];

for (var k in TWEEN.Easing) {
    if (k === "Linear")
        continue;

    Action.Easings.push({
        name: k + " In",
        calc: TWEEN.Easing[k].In
    });
    Action.Easings.push({
        name: k + " Out",
        calc: TWEEN.Easing[k].Out
    });
    Action.Easings.push({
        name: k + " InOut",
        calc: TWEEN.Easing[k].InOut
    });
}

Action.getEasingByName = function (name) {
    for (var k in Action.Easings) {
        if (Action.Easings[k].name === name) {
            return Action.Easings[k];
        }
    }
};
