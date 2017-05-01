/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

if (!PIXI) {
    var PIXI = {};
}
if (!TWEEN) {
    var TWEEN = {};
}
if (!Player) {
    function Player() {

    }
    ;
}

Player.Game = function (context, input) {
    this.context = context;
    this.context.game = this;
    this.gameName = input.projectName;
    this.gameID = input.projectID;
    this.version = input.version;
    this.description = input.description;
    this.author = input.author;

    this.windowSize = {x: input.windowSizeX, y: input.windowSizeY};
    this.lastUpdated = input.lastUpdated;

    this.stage;

    this.scenes = [];
    this.activeScene;
    this.initialScene;

    this.dataVariables = input.dataVariables;

    this.currentFrameIndex = -1;
    this.currentActionGroupIndex = -1;
    this.currentActionGroup;

    this.activeSounds = [];

    this.keyUps = [];
    this.keyDowns = [];
    this.keys = [];

    this.leftMouseDown = false;
    this.leftMouseUp = false;
    this.leftMouse = false;

    this.rightMouseDown = false;
    this.rightMouseUp = false;
    this.rightMouse = false;

    this.mousePos = {x: 0, y: 0};

    this.currentNode;

    this.init = function () {
        this.stage = new PIXI.Container();
        this.stage.position.x = this.windowSize.x / 2;
        this.stage.position.y = this.windowSize.y / 2;

        this.stage.interactive = true;
        this.stage.hitArea = new PIXI.Rectangle(-this.windowSize.x / 2, -this.windowSize.y / 2, this.windowSize.x, this.windowSize.y);

        var that = this;
        this.stage.mousedown = function (ev) {
            that.leftMouseDown = true;
            that.leftMouse = true;
        };
        this.stage.mouseup = function (ev) {
            that.leftMouseUp = true;
            that.leftMouse = false;
        };
        this.stage.mouseupoutside = function (ev) {
            that.leftMouseUp = true;
            that.leftMouse = false;
        };
        this.stage.rightdown = function (ev) {
            that.rightMouseDown = true;
            that.rightMouse = true;
        };
        this.stage.rightup = function (ev) {
            that.rightMouseUp = true;
            that.rightMouse = false;
        };
        this.stage.rightupoutside = function (ev) {
            that.rightMouseUp = true;
            that.rightMouse = false;
        };
        this.stage.mousemove = function (ev) {
            that.mousePos = ev.data.global;
        };
        //this.changeScene(this.initialScene.sceneID);
        this.startGame();
    };

    this.stop = function () {
        this.removeAllSounds();
    };

    this.update = function (deltaTime) {
        if (this.currentNode) {
            this.currentNode.updateNode(this);
        }
        if (this.activeScene) {
            var frame = this.activeScene.activeFrame;

            if (frame) {
                frame.update(deltaTime, this);
                if (this.currentActionGroupIndex < 0) {
                    this.currentActionGroupIndex = -1;

                    if (!this.nextActionGroup()) {

                        frame.onFrameEnded(this);
                    }
                }

                if (this.currentActionGroup) {
                    for (var k = 0; k < this.currentActionGroup.length; k++) {
                        var action = this.currentActionGroup[k];

                        if (!action.stepAction(deltaTime, this)) {
                            action.endAction(this);
                            this.currentActionGroup.splice(k, 1);
                        }
                    }
                    if (this.currentActionGroup.length <= 0) {
                        if (!this.nextActionGroup()) {

                            frame.onFrameEnded(this);
                        }
                    }
                }
            }

            for (var k = 0; k < this.currentGlobalActions.length; k++) {
                var action = this.currentGlobalActions[k];

                if (!action.stepAction(deltaTime, this)) {
                    action.endAction(this);
                    this.currentGlobalActions.splice(k, 1);
                }
            }
        }

        this.updateInput();
    };

    this.nextActionGroup = function () {
        if (this.activeScene && this.activeScene.activeFrame) {
            var frame = this.activeScene.activeFrame;
            if (this.currentActionGroupIndex < 0) {
                this.currentActionGroupIndex = 0;
            } else {
                this.currentActionGroupIndex++;
            }

            if (this.currentActionGroupIndex < frame.actions.length) {
                this.currentActionGroup = frame.cloneActionGroup(this.currentActionGroupIndex);

                for (var k in this.currentActionGroup) {
                    this.currentActionGroup[k].startAction(this);
                }
            } else {
                this.currentActionGroupIndex--;
                return false;
            }
        }
        return true;
    };

    this.nextFrame = function () {
        if (!this.goToFrame(this.currentFrameIndex + 1)) {
            if (this.currentNode) {
                this.currentNode.toNextNode = true;
            }
        }
    };

    this.goToFrame = function (index) {
        if (index < this.activeScene.frames.length) {

            this.removeFrameSounds();

            this.activeScene.activeFrame = this.activeScene.frames[index];
            this.currentFrameIndex = index;
            this.currentActionGroupIndex = -1;
            return true;
        }
        return false;
    };

    this.changeScene = function (scene) {
        this.removeAllSounds();

        if (this.activeScene) {
            this.stage.removeChild(this.activeScene.viewportContainer);
        }


        this.activeScene = scene;
        this.activeScene.setSceneState(this.activeScene.startState);

        this.stage.addChild(this.activeScene.viewportContainer);
        this.goToFrame(0);
        return;
    };

    this.cloneSceneByID = function (sceneID) {
        for (var k in this.scenes) {
            if (this.scenes[k].sceneID === sceneID) {
                return this.scenes[k].clone();
            }
        }
        return null;
    };

    this.gamePath = function (value) {
        return this.context.gamePath(value);
    };


    this.entityActionRegister = [];
    this.registerEntityAction = function (action) {
        if (action.isEntityAction) {

            for (var k in this.entityActionRegister) {
                var a = this.entityActionRegister[k];

                if (a.target === action.target) {
                    for (var j in action.stateMatrix) {
                        if (a.stateMatrix[ j ]) {
                            a.stopAction();
                            this.entityActionRegister.splice(k, 1);
                            break;
                        }
                    }
                }
            }

            this.entityActionRegister.push(action);
        }
    };

    this.currentGlobalActions = [];
    this.doActions = function (actions) {
        for (var k in actions) {
            actions[k].startAction(this);
            this.currentGlobalActions.push(actions[k]);
        }
    };

    this.getEntityByID = function (id) {
        if (this.activeScene) {
            for (var k in this.activeScene.entities) {
                if (this.activeScene.entities[k].entityID === id) {
                    return this.activeScene.entities[k];
                }
            }
        }

        for (var j in this.scenes) {
            for (var k in this.scenes[j].entities) {
                if (this.scenes[j] !== this.activeScene && this.scenes[j].entities[k].entityID === id) {
                    return this.scenes[j].entities[k];
                }
            }
        }
    };

    this.getSceneByName = function (name) {
        for (var k in this.scenes) {
            if (this.scenes[k].sceneName === name) {
                return this.scenes[k];
            }
        }
    };

    this.updateInput = function () {
        this.leftMouseDown = false;
        this.leftMouseUp = false;
        this.rightMouseDown = false;
        this.leftMouseUp = false;

        for (var k in this.keyDowns) {
            this.keyDowns[k] = false;
        }
        for (var k in this.keyUps) {
            this.keyUps[k] = false;
        }
    };

    this.userInput = function () {
        var b = this.keyDowns[32] || this.keyDowns[13] || this.leftMouseUp;
        if (b) {
            this.keyDowns[32] = false;
            this.keyDowns[13] = false;
            this.leftMouseUp = false;
        }
        return b;
    };

    this.resolveLink = function (link) {
        link = this.resolveValue(link);
        if (link.startsWith(">")) {
            var linkContent = link.substring(1);
            var scene = this.activeScene;
            var frame;

            if (linkContent === "Start") {
                this.activeScene.setSceneState(scene.startState);
                this.goToFrame(0);
            } else if (linkContent === "Next") {
                this.nextFrame();
            } else {
                frame = parseInt(linkContent) - 1;

                if (frame >= 0 && frame <= scene.frames.length) {
                    this.goToFrame(frame);
                } else if (frame === -1) {
                    this.activeScene.setSceneState(this.activeScene.startState);
                    this.goToFrame(0);
                }
            }
        } else if (link.startsWith("#")) {
            var linkContent = link.substring(1);
            if (this.currentNode) {
                this.currentNode.resolveLink(this, linkContent);
            }
        } else {
            window.open(link, "_blank");
        }
    };

    this.setGameVariable = function (varName, targetValue) {
        var projValues = this.dataVariables;
        var sceneValues = this.activeScene.dataVariables;


        if (varName) {
            targetValue = this.resolveValue(targetValue);
            var targetValues = sceneValues;

            if (varName.startsWith("#")) {
                varName = varName.substring(1);
                targetValues = projValues;
            } else if (varName.startsWith("@")) {
                varName = varName.substring(1);
            }

            if (targetValues[varName]) {
                targetValues[varName].value = targetValue;
            } else {
                targetValues[varName] = {
                    type: "TEXT",
                    value: targetValue
                };
            }
        }
    };

    this.resolveValue = function (value) {
        var projValues = this.dataVariables;
        var sceneValues;
        if (this.activeScene) {
            sceneValues = this.activeScene.dataVariables;
        } else {
            sceneValues = {};
        }

        var res = ("" + value).replace(/({=([@#a-z \-+\*\/0-9A-Z\?:'()]*)})/g, function (a, b, capture) {
            var str = capture.replace(/@([a-zA-Z0-9_]*)/g, function (a, e) {
                var v = (sceneValues[e] ? sceneValues[e].value : "");
                if (isNaN(v)) {
                    return "\"" + v + "\"";
                } else {
                    return v;
                }
            }).replace(/#([a-zA-Z0-9_]*)/g, function (a, e) {
                var v = (projValues[e] ? projValues[e].value : "");

                if (isNaN(v)) {
                    return "\"" + v + "\"";
                } else {
                    return v;
                }
            });
            try {
                return eval(str);
            } catch (e) {
                return "";
            }
        });

        return res;
    };

    this.playAudio = function (channel, audioSrc, volume, loop, onEnded, removedByEndOfFrame) {
        var that = this;

        for (var k in this.activeSounds) {
            var s = this.activeSounds[k];
            if (s.channel > 0 && s.channel === channel) {
                this.removeSound(s);
            }
        }

        var sound = new Howl({
            src: [that.gamePath(audioSrc)],
            loop: loop,
            autoplay: true,
            volume: volume,
            onend: function () {
                if (!this.loop) {
                    if (onEnded) {
                        onEnded();
                    }

                    that.removeSound(sound);
                }
            }
        });
        sound.channel = channel;
        if (removedByEndOfFrame) {
            sound.removedByEndOfFrame = true;
        }
        this.activeSounds.push(sound);


        return sound;
    };

    this.removeSound = function (sound) {
        var index = this.activeSounds.indexOf(sound);

        if (index >= 0) {
            sound.stop();
            sound.unload();
            this.activeSounds.splice(index, 1);

        }
    };

    this.removeAllSounds = function () {
        for (var k in this.activeSounds) {
            this.removeSound(this.activeSounds[k]);
        }
    };
    this.removeFrameSounds = function () {
        for (var k in this.activeSounds) {
            if (this.activeSounds[k].removedByEndOfFrame) {
                this.removeSound(this.activeSounds[k]);
            }
        }
    };

    this.startGame = function () {
        for (var k in this.nodes) {
            if (this.nodes[k].nodeName === "Start") {
                this.changeNode(this.nodes[k]);
                break;
            }
        }
    };

    this.changeNode = function (node) {

        this.currentNode = node;
        this.currentNode.startNode();
        this.currentNode.updateNode(this);
    };

    this.nextNode = function () {
        if (this.currentNode) {
            this.currentNode.toNextNode = true;
        }
    };

    this.getNode = function (id) {
        id = parseInt(id);
        for (var k in this.nodes) {
            if (this.nodes[k].nodeID === id) {
                return this.nodes[k];
            }
        }
        return null;
    };

    this.unlockAchievement = function (achievementID) {
        if (_UNLOCK_ACHIEVEMENT) {
            var xhr = new XMLHttpRequest();
            var that = this;

            xhr.open('GET', "UnlockAchievementServlet?aid=" + achievementID, true);
            xhr.onload = function () {
                console.log(xhr.responseText);
                if( xhr.responseText !== "" ) {
                    console.log("Achievement Unlocked! " );
                    if(_notifyAchievement) {
                        _notifyAchievement(JSON.parse(xhr.responseText));
                    } 
                }
            };
            xhr.send();
        }
    };
    this.printCertificate = function (scene) {
        var $certCanvas = $("#certCanvas");
        if ($certCanvas) {

        }
    };

    for (var s in input.scenes) {
        var scene = new Player.Scene(context, input.scenes[s]);
        this.scenes[s] = scene;

    }

    this.nodes = [];
    for (var k in input.nodes) {
        this.nodes.push(new Player.Node(context, input.nodes[k]));
    }

    this.init();

    var that = this;
    document.addEventListener("keydown", function (ev) {
        var k = ev.keyCode;
        that.keyDowns[k] = true;
        that.keys[k] = true;
    });
    document.addEventListener("keyup", function (ev) {
        var k = ev.keyCode;
        that.keyUps[k] = true;
        that.keys[k] = false;
    });
};

Player.Node = function (context, input) {

    this.context = context;

    this.nodeID = input.nodeID;
    this.nodeType = input.nodeTypeID;
    this.nodeName = input.nodeName;
    this.flowOutput = input.flowOutput;
    this.content = {};

    this.init = {};
    this.start = {};
    this.flow = {};
    this.calc = {};
    this.isFlown = false;
    this.toNextNode = false;
    this.calcGuard = false;

    for (var k in input.nodeTypeData) {
        var td = input.nodeTypeData[k];
        this.content[k] = {};
        this.content[k].value = td.value;

        if (td.dataInput && td.dataInput.split) {
            var data = td.dataInput.split("|");
            if (data.length > 1) {
                this.content[k].dataInputNodeID = data[0];
                this.content[k].dataInputDataTarget = data[1];
            }
        }
    }

    this.resolveLink = function (game, link) {
        if (this.flowOutput && this.flowOutput[link]) {
            var node = game.getNode(this.flowOutput[link]);
            if (node) {
                game.changeNode(node);
            }
        }
    };

    this.startNode = function (game) {
        this.isFlown = false;
        this.toNextNode = true;


        if (this.start[this.nodeType]) {
            this.start[this.nodeType]();
        }
    };

    this.updateNode = function (game) {
        if (!this.isFlown) {
            this.isFlown = true;
            if (this.flow[this.nodeType]) {
                this.flow[this.nodeType](game);
            }
        }

        if (this.toNextNode && this.flowOutput && this.flowOutput._def) {
            game.changeNode(game.getNode(this.flowOutput._def));
            this.toNextNode = false;
        }
    };

    var that = this;
    this.flow["playScene"] = function (game) {
        game.changeScene(that.scene);
        that.toNextNode = false;
    };

    this.flow["setProjectData"] = function (game) {
        for (var k in this.content) {
            var pd = this.content[k];

            if (pd.dataInputNodeID) {
                var value = game.getNode(pd.dataInputNodeID).calc(game, pd.dataInputDataTarget);
                if (!value || value.length <= 0) {
                    value = pd.value;
                }
                game.setGameVariable("#" + (k.substring("projVar_".length)), value);
            } else if (pd.value) {
                game.setGameVariable("#" + (k.substring("projVar_".length)), pd.value);
            }
        }
    };

    this.flow["condition"] = function (game) {
        var lhv = that.calc(game, "lhsCondition");
        var rhv = that.calc(game, "rhsCondition");

        var bool = false;
        switch (that.content.operator.value) {
            case "==":
                bool = lhv == rhv;
                break;
            case "<=":
                bool = parseFloat(lhv) <= parseFloat(rhv);
                break;
            case ">=":
                bool = parseFloat(lhv) >= parseFloat(rhv);
                break;
            case ">":
                bool = parseFloat(lhv) > parseFloat(rhv);
                break;
            case "<":
                bool = parseFloat(lhv) < parseFloat(rhv);
                break;
        }

        if (bool) {
            game.changeNode(game.getNode(that.flowOutput.True));

        } else {
            game.changeNode(game.getNode(that.flowOutput.False));
        }

    };

    this.flow["printCertificate"] = function (game) {
        game.printCertificate(that.content.sceneName.value);

    };

    this.flow["achievement"] = function (game) {
        game.unlockAchievement(that.content.achievementName.value);
    };

    this.calc = function (game, dataTarget) {
        if (that.content[dataTarget] && !that.calcGuard) {

            if (that.calc[that.nodeType]) {
                return that.calc[that.nodeType](game, dataTarget);
            } else {
                var dt = that.content[dataTarget];
                if (dt.dataInputNodeID) {
                    that.calcGuard = that;
                    var val = game.getNode(dt.dataInputNodeID).calc(game, dt.dataInputDataTarget);
                    that.calcGuard = false;

                    if (val) {
                        return val;
                    } else {
                        if (dt.value && dt.value.value) {
                            return dt.value.value;
                        } else {
                            return dt.value;
                        }
                    }
                } else {
                    if (dt.value && dt.value.value) {
                        return dt.value.value;
                    } else {
                        return dt.value;
                    }
                }
            }

        }
        return null;
    };

    this.calc["getProjectData"] = function (game, dataTarget) {
        return game.dataVariables[ dataTarget.replace("projVar_", "") ].value;
    };
    this.calc["playScene"] = function (game, dataTarget) {
        var dt = that.content[dataTarget];

        if (dt.dataInputNodeID) {
            that.calcGuard = that;
            var val = game.getNode(dt.dataInputNodeID).calc(game, dt.dataInputDataTarget);
            that.calcGuard = false;

            if (val) {
                return val;
            } else {
                return that.scene.dataVariables[ dataTarget.replace("sceneVar_", "") ].value;
            }
        } else {
            return that.scene.dataVariables[ dataTarget.replace("sceneVar_", "") ].value;
        }
    };

    this.init["playScene"] = function () {
        that.scene = context.game.cloneSceneByID(that.content.sceneName.value);
    };
    this.init["printCertificate"] = function () {
        that.scene = context.game.cloneSceneByID(that.content.sceneName.value);
    };
    this.start["playScene"] = function () {
        for (var k in that.content) {
            if (k.startsWith("sceneVar_")) {
                var svar = k.substring("sceneVar_".length);

                that.scene.dataVariables[svar].value = that.calc(context.game, k);
            }
        }
    };
    this.start["printCertificate"] = function () {
        for (var k in that.content) {
            if (k.startsWith("sceneVar_")) {
                var svar = k.substring("sceneVar_".length);

                that.scene.dataVariables[svar].value = that.calc(context.game, k);
            }
        }
    };


    if (this.init[this.nodeType]) {
        this.init[this.nodeType]();
    }
};

Player.Context = function (player, gamePath) {
    this.resources = {};

    this.propCallbacks = [];
    this.player = player;

    this.getResource = function (resourceName) {
        var c = this;

        if (!isDefined(c.resources, resourceName)) {
            c.resources[resourceName] = PIXI.Texture.fromImage(this.gamePath(resourceName));
        }
        return c.resources[resourceName];
    };

    this.gamePath = gamePath;
};

Player.Scene = function (context, input) {
    this.context = context;
    this.sceneID = input.sceneID;
    this.sceneName = input.sceneName;
    this.backgroundColor = input.backgroundColor;

    this.viewportContainer = new PIXI.Container();

    this.entities = [];
    this.frames = [];
    this.input = input;

    this.dataVariables = {};
    for (var k in input.dataVariables) {
        this.dataVariables[k] = {
            type: input.dataVariables[k].type,
            value: input.dataVariables[k].value
        };
    }

    this.activeFrame;
    this.startState = {};
    this.rootAttributes = {};

    this.changeFrame = function (frame, skipRerender) {
        this.activeFrame = frame;
        if (this.activeFrame)
            this.activeFrame.activeAction = null;

        if (skipRerender)
            return;

        if (this.activeFrame) {
            this.setSceneStateOnFrame(this.activeFrame);
        } else {
            this.setSceneState();
        }
    };

    this.goToFrame = function (frameNo, skipRerender) {
        if (frameNo < 0)
            this.changeFrame(null, skipRerender);
        else
            this.changeFrame(this.frames[frameNo], skipRerender);
    };


    this.addEntityToScene = function (entity) {
        this.entities.push(entity);
        entity.originalScene = this;

        var stateData = this.startState["ss" + entity.entityID];
        cpy(stateData, entity, Player.Entity.serializable);
        cpy(stateData, entity, Player.Entity.propSerializable);
        cpy(stateData, entity, Player.Entity.shadingSerializable);

        if (stateData.isAButton) {
            cpy(stateData, entity, Player.Button.serializable);
        } else if (stateData.isAQSprite) {
            cpy(stateData, entity, Player.QSprite.serializable);
        } else if (stateData.isAQText) {
            cpy(stateData, entity, Player.QText.serializable);
            cpy(stateData, entity, Player.QText.textAttributes);
        }

        var sprite = entity.getSprite();
        sprite.zIndex = this.viewportContainer.children.length;
        this.viewportContainer.addChild(sprite);
    };

    this.removeEntityFromScene = function (entity) {
        this.entities.splice(this.entities.indexOf(entity), 1);
        delete this.startState["ss" + entity.entityID];

        this.viewportContainer.removeChild(entity.sprite);
    };

    this.setSceneStateOnCurrent = function () {
        if (this.activeFrame) {
            if (this.activeFrame.activeAction) {
                this.setSceneStateOnAction(this.activeFrame.activeAction);
            } else {
                this.setSceneState(this.activeFrame);
            }
        } else {
            this.setSceneState();
        }
    };

    this.setSceneStateOnAction = function (action) {
        var state = JSON.parse(JSON.stringify(this.startState));

        for (var k in this.frames) {
            var frame = this.frames[k];

            for (var j in frame.actions) {
                var actionGroup = frame.actions[j];

                var breakFlag = false;
                for (var l in actionGroup) {
                    var act = actionGroup[l];
                    act.doState(state);

                    if (action === act)
                        breakFlag = true;
                }

                if (breakFlag) {
                    this.setSceneState(state);
                    return;
                }
            }
        }
    };

    this.setSceneStateOnFrame = function (frame) {
        var state = JSON.parse(JSON.stringify(this.startState));

        for (var k in this.frames) {
            var frm = this.frames[k];

            for (var j in frm.actions) {
                for (var l in frm.actions[j]) {
                    frm.actions[j][l].doState(state);
                }
            }

            if (frame === frm) {
                this.setSceneState(state);
                return;
            }
        }
    };

    this.setSceneState = function (state) {
        if (!state) {
            state = this.startState;
        }

        for (var k in this.entities) {
            var entity = this.entities[k];
            var eid = "ss" + entity.entityID;

            var stateData = state[eid];

            if (stateData && stateData.isAnEntity) {
                cpy(stateData, entity, Player.Entity.serializable);
                cpy(stateData, entity, Player.Entity.propSerializable);
                cpy(stateData, entity, Player.Entity.shadingSerializable);

                if (stateData.isAButton) {
                    cpy(stateData, entity, Player.Button.serializable);
                } else if (stateData.isAQSprite) {
                    cpy(stateData, entity, Player.QSprite.serializable);
                } else if (stateData.isAQText) {
                    cpy(stateData, entity, Player.QText.serializable);
                    cpy(stateData, entity, Player.QText.textAttributes);
                }
            }
        }
    };

    this.clone = function () {
        return new Player.Scene(this.context, this.input);
    };


    for (var e in input.startState) {
        this.startState[e] = input.startState[e];
    }
    for (var e in input.entities) {
        this.addEntityToScene(new Player.Entity(context, input.entities[e]));
    }
    for (var e in input.frames) {
        this.frames[e] = new Player.Frame(this, input.frames[e]);
    }
};

Player.Frame = function (scene, input) {
    this.context = scene.context;
    this.scene = scene;

    this.frameLabel = input.frameLabel;
    this.nextFrameOptions = input.nextFrameOptions;

    this.actions = [];
    this.activeAction;
    this.activeActionGroup;

    for (var e in input.actions) {
        this.actions[e] = [];
        for (var f in input.actions[e]) {
            this.actions[e][f] = new Player.Action(this, input.actions[e][f]);

        }
    }

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
    this.selectAction = function (action) {
        this.activeAction = action;

        if (this.activeAction) {
            this.scene.setSceneStateOnAction(action);
        } else {
            this.scene.setSceneStateOnFrame(this);
        }
    };
    this.removeCurrentAction = function (skipUpdate) {
        if (this.activeAction) {
            this.removeActionByObject(this.activeAction, skipUpdate);
        }
    };
    this.removeActionByObject = function (action) {
        for (var k in this.actions) {
            for (var j in this.actions[k]) {
                if (this.actions[k][j] === action) {
                    this.removeAction(k, j);
                }
            }
        }
    };
    this.getActiveActionGroup = function (action) {
        for (var i in this.actions) {
            for (var k in this.actions[i]) {
                if (action === this.actions[i][k]) {
                    return this.actions[i];
                }
            }
        }
    };
    this.cloneActionGroup = function (index) {
        var res = [];

        for (var k in this.actions[index]) {
            res.push(this.actions[index][k].cloneAction());
        }

        return res;
    };
    this.onFrameEnded = function (game) {
        if (this.nextFrameOptions === "User Input") {
            if (game.userInput()) {
                game.nextFrame();
            }
        } else if (this.nextFrameOptions === "Automatic") {
            game.nextFrame();
        }
    };
    this.update = function (delta, game) {
        if (this.nextFrameOptions === "User Input Forced") {
            if (game.userInput()) {

                for (var k = 0; k < this.actions.length; k++) {
                    for (var j = 0; j < this.actions[k].length; j++) {
                        this.actions[k][j].endAction(game);
                    }
                }

                game.nextFrame();
            }
        }
        ;
    };
};

Player.Action = function (frame, input) {
    this.context = frame.context;

    this.actionID = input.actionID;
    this.actionName = input.actionName;

    this.stateMatrix = input.stateMatrix;
    this.prevMatrix = {};
    this.time = 0;
    this.dontStep = false;

    this.step = {};
    this.start = {};
    this.end = {};

    if (input.duration) {
        this.duration = parseInt(input.duration);
    } else {
        this.duration = 0;
    }

    if (input.isLinkAction) {
        this.isLinkAction = true;
        this.type = "LINK";

    } else if (input.isEntityAction) {
        this.isEntityAction = true;
        this.type = "ENTITY";

        this.offset = parseInt(input.offset);
        this.easing = Player.Action.getEasingByName(input.easing.name);
        this.targetID = input.targetID;
    } else if (input.isDataAction) {
        this.isDataAction = true;
        this.type = "DATA";
    } else if (input.isAudioAction) {
        this.isAudioAction = true;
        this.type = "AUDIO";
    }

    this.doState = function (state) {
        for (var k in this.stateMatrix) {
            if (state["ss" + this.targetID]) {
                state["ss" + this.targetID][k] = this.stateMatrix[k];
            } else {
            }
        }
    };


    this.cloneAction = function () {
        return new Player.Action(frame, input);
    };

    this.isRunning = false;
    this.stopAction = function () {
        this.isRunning = true;
    };
    this.stepAction = function (t, game) {
        if (!this.isRunning) {
            return false;
        }
        if (this.dontStep) {
            return true;
        }
        this.time -= t * 1000;

        if (this.time <= 0) {
            this.time = 0;
            return false;
        } else if (this.time <= game.resolveValue(this.duration)) {
            if (this.step[ this.type ]) {
                return this.step[this.type](t, game);
            }
        }

        return true;
    };
    this.startAction = function (game) {
        this.isRunning = true;
        this.time = parseInt(game.resolveValue(this.duration)) + parseInt(game.resolveValue(this.offset));

        if (isNaN(this.time)) {
            this.time = 0;
        }

        if (this.start[ this.type ]) {
            this.start[this.type](game);
        }
    };
    this.endAction = function (game) {
        if (this.end[ this.type ]) {
            this.end[this.type](game);
        }
        this.isRunning = false;
    };

    var that = this;

    this.step["ENTITY"] = function (t, game) {
        game.registerEntityAction(this);
        var entity = game.getEntityByID(that.targetID);

        for (var k in that.stateMatrix) {
            var val = Player.Interpolator.interpolate(k, that.prevMatrix[k], game.resolveValue(that.stateMatrix[k]), that.easing.calc((that.duration - that.time) / that.duration));
            entity.set(k, val, that);
        }
        return true;
    };
    this.start["ENTITY"] = function (game) {
        var entity = game.getEntityByID(that.targetID);

        that.prevMatrix = {};
        for (var k in that.stateMatrix) {
            that.prevMatrix[k] = Player.Interpolator.setFromString(k, game.resolveValue(entity[k]));
        }
    };
    this.end["ENTITY"] = function (game) {
        var entity = game.getEntityByID(that.targetID);

        for (var k in that.stateMatrix) {
            entity.set(k, Player.Interpolator.setFromString(k, game.resolveValue(that.stateMatrix[k])), that);
        }
    };

    this.currentSound;
    this.start["LINK"] = function (game) {
        var link = that.stateMatrix.link;

        game.resolveLink(link);
    };
    this.start["DATA"] = function (game) {
        var varName = that.stateMatrix.dvarName;
        var targetValue = that.stateMatrix.dvalue;

        game.setGameVariable(varName, targetValue);
    };
    this.start["AUDIO"] = function (game) {
        var audioSrc = game.resolveValue(that.stateMatrix.audioSrc);
        var volume = game.resolveValue(that.stateMatrix.volume);
        var loop = that.stateMatrix.loop;
        var channel = that.stateMatrix.channel;
        if (!channel)
            channel = 0;

        var removedByEndOfFrame = that.stateMatrix.frameStop;

        if (that.stateMatrix.waitAudio) {
            that.dontStep = true;
            that.currentSound = game.playAudio(channel, audioSrc, volume, loop, function () {
                that.dontStep = false;
                that.time = 0;
            }, removedByEndOfFrame);
        } else {
            that.currentSound = game.playAudio(channel, audioSrc, volume, loop, null, removedByEndOfFrame);
        }
    };
};

Player.Action.Easings = [{
        name: "Linear",
        calc: function (x) {
            return x;
        }
    }];

Player.Interpolator = {
    stringTypes: ["text", "buttonText", "link", "buttonLink"],
    imgTypes: ["src", "normSrc"],
    colorTypes: ["tint", "textColor"],
    setFromString: function (key, value) {
        if (this.stringTypes.indexOf(key) >= 0) {
            return value;
        } else if (this.imgTypes.indexOf(key) >= 0) {
            return value;
        } else if (this.colorTypes.indexOf(key) >= 0) {
            return value;
        } else {
            return parseFloat(value);
        }
    },
    interpolate: function (key, startValue, endValue, step) {
        if (this.stringTypes.indexOf(key) >= 0) {
            step = (step > 1 ? 1 : (step < 0 ? 0 : step));
            var realText = endValue.replace(/(<([^>]+)>)/gi, "");
            ;
            var n = Math.floor(realText.length * step);
            if (n < 1) {
                return "";
            }
            var j = 0;
            var b = 0;
            var i = 0;
            for (var len = endValue.length; i < len; i++) {
                var c = endValue[i];

                if (c === "<") {
                    b++;
                } else if (c === ">") {
                    b--;
                } else if (b === 0) {
                    j++;
                    if (j === n) {
                        break;
                    }
                }
            }
            return endValue.substring(0, i);
        } else if (this.imgTypes.indexOf(key) >= 0) {
            return endValue;
        } else if (this.colorTypes.indexOf(key) >= 0) {
            var s = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(startValue);
            var e = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(endValue);

            var res = "#";
            for (var k = 1; k <= 3; k++) {
                s[k] = parseInt(s[k], 16);
                e[k] = parseInt(e[k], 16);

                var rk = s[k] + (e[k] - s[k]) * step;
                rk = (rk > 255 ? 255 : (rk < 0 ? 0 : rk));
                res += (rk >= 16 ? "" : "0") + (Math.floor(rk)).toString(16).toUpperCase();
            }

            return res;
        } else {
            return startValue + (endValue - startValue) * step;
        }
    }
};

for (var k in TWEEN.Easing) {
    if (k === "Linear")
        continue;

    Player.Action.Easings.push({
        name: k + " In",
        calc: TWEEN.Easing[k].In
    });
    Player.Action.Easings.push({
        name: k + " Out",
        calc: TWEEN.Easing[k].Out
    });
    Player.Action.Easings.push({
        name: k + " InOut",
        calc: TWEEN.Easing[k].InOut
    });
}

Player.Action.getEasingByName = function (name) {
    for (var k in Player.Action.Easings) {
        if (Player.Action.Easings[k].name === name) {
            return Player.Action.Easings[k];
        }
    }
};

Player.Entity = function (context, input) {
    this.context = context;
    this.entityID = input.entityID;
    this.name = input.name;
    this.isAnEntity = input.isAnEntity;
    this.sprite;

    this.onClickActions = [];
    for (var k in input.onClickActions) {
        this.onClickActions[k] = new Player.Action(this, input.onClickActions[k]);
    }
    this.onEnterActions = [];
    for (var k in input.onEnterActions) {
        this.onEnterActions[k] = new Player.Action(this, input.onEnterActions[k]);
    }
    this.onExitActions = [];
    for (var k in input.onExitActions) {
        this.onExitActions[k] = new Player.Action(this, input.onExitActions[k]);
    }

    for (var k in Player.Entity.propSerializable) {
        var kk = Player.Entity.propSerializable[k];
        this[kk] = input[kk];
    }
    for (var k in Player.Entity.shadingSerializable) {
        var kk = Player.Entity.shadingSerializable[k];
        this[kk] = input[kk];
    }

    var game = context.game;
    this.setPropertyListener = function (res) {
        res.addListener(res, "name", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                res.name = newValue;
                s.name = newValue;
            }
            return true;
        });

        res.addListener(res, "posx", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.position.x = parseFloat(game.resolveValue(newValue));
            }
            return true;
        });
        res.addListener(res, "posy", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.position.y = parseFloat(game.resolveValue(newValue));
            }
            return true;
        });
        res.addListener(res, "rotation", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.rotation = parseFloat(game.resolveValue(newValue)) / 57.2958;
            }
            return true;
        });
        res.addListener(res, "scalex", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.scale.x = parseFloat(game.resolveValue(newValue));
            }
            return true;
        });
        res.addListener(res, "scaley", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.scale.y = parseFloat(game.resolveValue(newValue));
            }
            return true;
        });
        res.addListener(res, "anchorx", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.anchor.x = parseFloat(game.resolveValue(newValue));
                if (res.recalculateChildAnchor)
                    res.recalculateChildAnchor();
            }
            return true;
        });
        res.addListener(res, "anchory", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.anchor.y = parseFloat(game.resolveValue(newValue));
                if (res.recalculateChildAnchor)
                    res.recalculateChildAnchor();
            }
            return true;
        });
        res.addListener(res, "pivotx", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.pivot.x = parseFloat(game.resolveValue(newValue));
            }
            return true;
        });
        res.addListener(res, "pivoty", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.pivot.y = parseFloat(game.resolveValue(newValue));
            }
            return true;
        });
        res.addListener(res, "alpha", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.alpha = parseFloat(game.resolveValue(newValue));
            }
            return true;
        });
        res.addListener(res, "tint", function (newValue, res) {

            var s = res.sprite;
            if (s) {
                s.tint = parseInt(game.resolveValue(newValue).replace(/^#/, ''), 16);
            }
            return true;
        });
    };

    setupListener(this);

    if (input.isAButton) {
        Player.Button.decorate(this, input);
    } else if (input.isAQSprite) {
        Player.QSprite.decorate(this, input);
    } else if (input.isAQText) {
        Player.QText.decorate(this, input);
    }

    this.setAllListeners = function (target, cb) {
        this.addListeners(target, Entity.propSerializable, cb);
        this.addListeners(target, Entity.shadingSerializable, cb);
        this.addListeners(target, Entity.serializable, cb);
    };
};

Player.Entity.serializable = ["name", "isAnEntity", "entityID"];
Player.Entity.propSerializable = ["posx", "posy", "rotation", "scalex", "scaley", "anchorx", "anchory", "pivotx", "pivoty"];
Player.Entity.shadingSerializable = ["tint", "alpha"];


Player.QSprite = {};
Player.QSprite.decorate = function (parent, input) {
    parent.src = input.src;
    parent.isAQSprite = input.isAQSprite;

    parent.createImage = function () {
        var ep = parent;
        var c = parent.context;

        var image = new PIXI.Sprite(c.getResource(parent.src));
        image.interactive = true;

        var onEnter = function () {
            c.game.doActions(ep.onEnterActions);
        };
        var onExit = function () {
            c.game.doActions(ep.onExitActions);
        };
        var onDown = function () {

        };
        var onUp = function () {
            c.game.doActions(ep.onClickActions);
        };

        image
                .on('mouseover', onEnter)
                .on('mouseout', onExit)
                .on('mousedown', onDown)
                .on('touchstart', onDown)
                .on('mouseup', onUp)
                .on('touchend', onUp);

        image.anchor.set(ep.anchorx, ep.anchory);
        image.scale.set(ep.scalex, ep.scaley);
        image.position.x = ep.posx;
        image.position.y = ep.posy;
        image.rotation = ep.rotation / 57.2958;
        image.name = parent.name;
        image.type = "Sprite";
        image.model = parent;

        return image;
    };

    var game = parent.context.game;
    parent.getSprite = function () {
        if (!parent.sprite) {
            parent.sprite = parent.createImage();

            parent.setPropertyListener(parent);
            parent.addListener(parent, "src", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    res.src = newValue;
                    s.src = game.resolveValue(newValue);

                    s.texture = PIXI.Texture.fromImage(game.gamePath(newValue));
                }
                return true;
            });
        }
        return parent.sprite;
    };

    parent._setAllListeners = parent.setAllListeners;
    parent.setAllListeners = function (target, cb) {
        parent._setAllListeners(target, cb);
        parent.addListeners(target, Player.QSprite.serializable, cb);
    };

    parent.getSprite();
};
Player.QSprite.serializable = ["src", "isAQSprite"];


Player.Button = {};
Player.Button.decorate = function (parent, input) {
    parent.name = input.name;
    parent.text = input.text;
    parent.link = input.link;
    parent.normSrc = input.normSrc;
    parent.isAButton = input.isAButton;

    parent.createButton = function () {
        var c = parent.context;
        var ep = parent;
        var o = parent;

        var button = new PIXI.Sprite(c.getResource(o.normSrc));
        button.interactive = true;
        button.buttonMode = true;

        var onEnter = function () {
            c.game.doActions(ep.onEnterActions);
        };
        var onExit = function () {
            c.game.doActions(ep.onExitActions);
        };
        var onDown = function () {

        };
        var onUp = function () {
            c.game.doActions(ep.onClickActions);
            if (button.buttonLink && button.buttonLink.length > 0) {
                c.player.game.resolveLink(button.buttonLink);
            }
        };

        button
                .on('mouseover', onEnter)
                .on('mouseout', onExit)
                .on('mousedown', onDown)
                .on('touchstart', onDown)
                .on('mouseup', onUp)
                .on('touchend', onUp);
        button.anchor.set(ep.anchorx, ep.anchory);
        button.scale.set(ep.scalex, ep.scaley);
        button.position.x = ep.posx;
        button.position.y = ep.posy;

        var def = {
            "default": {
                fontFamily: 'Arial', fontSize: 36 + "px", fill: 'black', align: 'center'
            }
        };
        for (var k in Player.QText.textProfiles) {
            def[k] = Player.QText.textProfiles[k];
        }

        var basicText = new MultiStyleText(o.text, def);

        basicText.position.x = button._texture.orig.width * -(button.anchor.x - .5);
        basicText.position.y = button._texture.orig.height * -(button.anchor.y - .5) - 5;
        basicText.anchor.set(0.5, 0.5);

        button.addChild(basicText);

        button.rotation = ep.rotation / 57.2958;
        button.name = o.name;

        button.buttonName = o.text;
        button.buttonLink = o.link;
        button.buttonNrmSrc = o.normSrc;
        button.type = "Button";
        button.model = parent;


        return button;
    };

    parent.recalculateChildAnchor = function () {
        var s = parent.sprite;
        s.children[0].position.x = s._texture.orig.width * -(s.anchor.x - .5);
        s.children[0].position.y = s._texture.orig.height * -(s.anchor.y - .5) - 5;
    };

    var game = parent.context.game;
    parent.getSprite = function () {
        if (!parent.sprite) {
            parent.sprite = parent.createButton();
            parent.recalculateChildAnchor();

            parent.setPropertyListener(parent);

            parent.addListener(parent, "text", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    s.buttonName = newValue;
                    s.children[0].text = game.resolveValue(newValue);
                    res.recalculateChildAnchor();
                }
                return true;
            });
            parent.addListener(parent, "normSrc", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    s.normSrc = game.resolveValue(newValue);
                    res.recalculateChildAnchor();

                    s.texture = PIXI.Texture.fromImage(game.gamePath(newValue));
                }
                return true;
            });
            parent.addListener(parent, "link", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    s.buttonLink = game.resolveValue(newValue);
                }
                return true;
            });
        }
        return parent.sprite;
    };


    parent._setAllListeners = parent.setAllListeners;
    parent.setAllListeners = function (target, cb) {
        parent._setAllListeners(target, cb);

        parent.addListeners(target, Player.Button.serializable, cb);
    };

    parent.getSprite();
};
Player.Button.serializable = ["text", "link", "isAButton", "normSrc"];


Player.QText = {};
Player.QText.decorate = function (parent, input) {
    parent.text = input.text;
    parent.isAQText = input.isAQText;

    for (var k in Player.QText.textAttributes) {
        var kk = Player.QText.textAttributes[k];
        parent[kk] = input[kk];
    }

    for (var k in Player.QText.serializable) {
        var kk = Player.QText.serializable[k];
        parent[kk] = input[kk];
    }

    parent.genStyle = function () {
        var o = parent;
        return {
            fontFamily: o.font,
            fontSize: o.fontSize + "px",
            fill: (o.color === "#000000" ? "black" : o.color),
            align: o.align.toLowerCase(),
            wordWrap: (o.wordWrap > 0),
            wordWrapWidth: o.wordWrap,
            breakWords: o.breakWords,
            strokeThickness: o.stroke,
            stroke: o.strokeColor,
            fontStyle: (o.isItalic ? "italic" : "normal"),
            fontWeight: (o.isExtraBold ? (o.isBold ? "bolder" : "bold") : (o.isBold ? "normal" : "lighter")),
            letterSpacing: o.letterSpacing,
            padding: o.padding,
            valign: o.valign,
            dropShadow: o.dropShadow,
            dropShadowAlpha: o.dsAlpha,
            dropShadowAngle: o.dsAngle,
            dropShadowColor: o.dsColor,
            dropShadowDistance: o.dsDistance,
            dropShadowBlur: o.dsBlur
        };
    };

    parent.createText = function () {
        var ep = parent;
        var o = parent;

        var defStyle = {
            "default": parent.genStyle()
        };
        for (var k in Player.QText.textProfiles) {
            defStyle[k] = Player.QText.textProfiles[k];
        }
        var text = new MultiStyleText(o.text, defStyle);
        text.interactive = true;

        var c = parent.context;
        var onEnter = function () {
            c.game.doActions(ep.onEnterActions);
        };
        var onExit = function () {
            c.game.doActions(ep.onExitActions);
        };
        var onDown = function () {

        };
        var onUp = function () {
            c.game.doActions(ep.onClickActions);
        };

        text
                .on('mouseover', onEnter)
                .on('mouseout', onExit)
                .on('mousedown', onDown)
                .on('touchstart', onDown)
                .on('mouseup', onUp)
                .on('touchend', onUp);

        text.anchor.set(ep.anchorx, ep.anchory);
        text.scale.set(ep.scalex, ep.scaley);
        text.position.x = ep.posx;
        text.position.y = ep.posy;

        text.rotation = ep.rotation / 57.2958;
        text.name = o.name;

        text.text = o.text;
        text.type = "Text";
        text.model = parent;

        return text;
    };

    parent.updateText = function () {
        if (parent.sprite) {
            var newStyle = {
                "default": parent.genStyle()
            };
            for (var k in Player.QText.textProfiles) {
                newStyle[k] = Player.QText.textProfiles[k];
            }
            parent.sprite.styles = newStyle;
            parent.sprite.dirty = true;
        }
    };

    parent.getSprite = function () {
        if (!parent.sprite) {
            parent.sprite = parent.createText();

            parent.setPropertyListener(parent);

            parent.addListener(parent, "text", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    res.text = newValue;
                    s.text = newValue;
                }
                return true;
            });

            for (var k in Player.QText.textAttributes) {
                var tp = Player.QText.textAttributes[k];
                parent.addListener(parent, tp, (function (tp) {
                    return function (newValue, res) {
                        var s = res.sprite;

                        if (s) {
                            res.updateText();
                            res[tp] = newValue;
                        }
                        return true;
                    };
                })(tp));
            }
        }
        return parent.sprite;
    };

    parent._setAllListeners = parent.setAllListeners;
    parent.setAllListeners = function (target, cb) {
        parent._setAllListeners(target, cb);

        parent.addListeners(target, Player.QText.textAttributes, cb);
        parent.addListeners(target, Player.QText.serializable, cb);
    };

    parent.getSprite();
};

Player.QText.textAttributes = ["align", "wordWrap", "breakWords", "color", "font", "fontSize", "stroke", "strokeColor", "isItalic", "isBold", "isExtraBold", "padding", "valign", "letterSpacing", "dropShadow", "dsColor", "dsAlpha", "dsAngle", "dsBlur", "dsDistance"];
Player.QText.serializable = ["text", "isAQText"];

Player.QText.textProfiles = {
    "b": {fontWeight: "bolder"}, "i": {fontStyle: "italic"}, "shadow": {dropShadow: true},
    "top": {fontSize: "14px", valign: "top"}, "middle": {fontSize: "14px", valign: "middle"}, "bottom": {fontSize: "14px", valign: "bottom"}
};

for (var i = 1; i <= 10; i++) {
    Player.QText.textProfiles["s" + i] = {strokeThickness: i};
}

Player.QText.sizes = [8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 36, 40, 44, 48, 50, 52, 54, 56, 60, 64, 72, 84, 96];
for (var k in Player.QText.sizes) {
    var i = Player.QText.sizes[k];
    Player.QText.textProfiles["p" + i] = {fontSize: i + "px"};
}

Player.QText.colours = {"aliceblue": "#f0f8ff", "antiquewhite": "#faebd7", "aqua": "#00ffff", "aquamarine": "#7fffd4", "azure": "#f0ffff",
    "beige": "#f5f5dc", "bisque": "#ffe4c4", "black": "#000000", "blanchedalmond": "#ffebcd", "blue": "#0000ff", "blueviolet": "#8a2be2", "brown": "#a52a2a", "burlywood": "#deb887",
    "cadetblue": "#5f9ea0", "chartreuse": "#7fff00", "chocolate": "#d2691e", "coral": "#ff7f50", "cornflowerblue": "#6495ed", "cornsilk": "#fff8dc", "crimson": "#dc143c", "cyan": "#00ffff",
    "darkblue": "#00008b", "darkcyan": "#008b8b", "darkgoldenrod": "#b8860b", "darkgray": "#a9a9a9", "darkgreen": "#006400", "darkkhaki": "#bdb76b", "darkmagenta": "#8b008b", "darkolivegreen": "#556b2f",
    "darkorange": "#ff8c00", "darkorchid": "#9932cc", "darkred": "#8b0000", "darksalmon": "#e9967a", "darkseagreen": "#8fbc8f", "darkslateblue": "#483d8b", "darkslategray": "#2f4f4f", "darkturquoise": "#00ced1",
    "darkviolet": "#9400d3", "deeppink": "#ff1493", "deepskyblue": "#00bfff", "dimgray": "#696969", "dodgerblue": "#1e90ff",
    "firebrick": "#b22222", "floralwhite": "#fffaf0", "forestgreen": "#228b22", "fuchsia": "#ff00ff",
    "gainsboro": "#dcdcdc", "ghostwhite": "#f8f8ff", "gold": "#ffd700", "goldenrod": "#daa520", "gray": "#808080", "green": "#008000", "greenyellow": "#adff2f",
    "honeydew": "#f0fff0", "hotpink": "#ff69b4",
    "indianred ": "#cd5c5c", "indigo": "#4b0082", "ivory": "#fffff0", "khaki": "#f0e68c",
    "lavender": "#e6e6fa", "lavenderblush": "#fff0f5", "lawngreen": "#7cfc00", "lemonchiffon": "#fffacd", "lightblue": "#add8e6", "lightcoral": "#f08080", "lightcyan": "#e0ffff", "lightgoldenrodyellow": "#fafad2",
    "lightgrey": "#d3d3d3", "lightgreen": "#90ee90", "lightpink": "#ffb6c1", "lightsalmon": "#ffa07a", "lightseagreen": "#20b2aa", "lightskyblue": "#87cefa", "lightslategray": "#778899", "lightsteelblue": "#b0c4de",
    "lightyellow": "#ffffe0", "lime": "#00ff00", "limegreen": "#32cd32", "linen": "#faf0e6",
    "magenta": "#ff00ff", "maroon": "#800000", "mediumaquamarine": "#66cdaa", "mediumblue": "#0000cd", "mediumorchid": "#ba55d3", "mediumpurple": "#9370d8", "mediumseagreen": "#3cb371", "mediumslateblue": "#7b68ee",
    "mediumspringgreen": "#00fa9a", "mediumturquoise": "#48d1cc", "mediumvioletred": "#c71585", "midnightblue": "#191970", "mintcream": "#f5fffa", "mistyrose": "#ffe4e1", "moccasin": "#ffe4b5",
    "navajowhite": "#ffdead", "navy": "#000080",
    "oldlace": "#fdf5e6", "olive": "#808000", "olivedrab": "#6b8e23", "orange": "#ffa500", "orangered": "#ff4500", "orchid": "#da70d6",
    "palegoldenrod": "#eee8aa", "palegreen": "#98fb98", "paleturquoise": "#afeeee", "palevioletred": "#d87093", "papayawhip": "#ffefd5", "peachpuff": "#ffdab9", "peru": "#cd853f", "pink": "#ffc0cb", "plum": "#dda0dd", "powderblue": "#b0e0e6", "purple": "#800080",
    "rebeccapurple": "#663399", "red": "#ff0000", "rosybrown": "#bc8f8f", "royalblue": "#4169e1",
    "saddlebrown": "#8b4513", "salmon": "#fa8072", "sandybrown": "#f4a460", "seagreen": "#2e8b57", "seashell": "#fff5ee", "sienna": "#a0522d", "silver": "#c0c0c0", "skyblue": "#87ceeb", "slateblue": "#6a5acd", "slategray": "#708090", "snow": "#fffafa", "springgreen": "#00ff7f", "steelblue": "#4682b4",
    "tan": "#d2b48c", "teal": "#008080", "thistle": "#d8bfd8", "tomato": "#ff6347", "turquoise": "#40e0d0",
    "violet": "#ee82ee",
    "wheat": "#f5deb3", "white": "#ffffff", "whitesmoke": "#f5f5f5",
    "yellow": "#ffff00", "yellowgreen": "#9acd32"};

for (var k in Player.QText.colours) {
    var i = Player.QText.colours[k];
    Player.QText.textProfiles[k] = {fill: i};
    Player.QText.textProfiles["s" + k] = {stroke: i};
}