/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Scene(context, sceneName) {
    this.context = context;
    this.sceneID = uid();
    this.sceneName = sceneName;
    this.backgroundColor = 0xFFFFFF;

    this.thumbnailRenderer;
    this.viewportContainer;
    this.thumbnailContainer;

    this.startState = {};
    this.dataVariables = {
    };

    this.activeFrame;
    this.isAScene = true;

    this.entities = [];
    this.frames = [];

    this.rootAttributes = {};

    this.addFrame = function (f) {
        if(!f) {
            f = new Frame(this);
        }
        
        this.frames.push(f);

        this.changeFrame(f);
    };
    this.addFrameAt = function (f, index) {
        if (index === this.frames.length) {
            this.addFrame();
        } else if (index >= 0 && index < this.frames.length) {
            if(!f) {
                f = new Frame(this);
            }
            

            this.frames.splice(index, 0, f);
            this.changeFrame(f);
        }
    };

    this.removeFrame = function (frameNo) {
        this.frames.splice(frameNo, 1);
    };

    this.removeCurrentFrame = function () {
        if (this.activeFrame) {
            var index = this.frames.indexOf(this.activeFrame);
            this.removeFrame(index);
            if (this.frames.length <= 0) {
                this.changeFrame(null);
            } else if (index > 0) {
                this.goToFrame(index - 1);
            } else {
                this.goToFrame(index);
            }
        }
    };

    this.changeFrame = function (frame, skipRerender, skipContextRerender) {
        if (this.context.actionData) {
            delete this.context.actionData;
        }

        this.activeFrame = frame;
        if (this.activeFrame)
            this.activeFrame.activeAction = null;

        if (skipRerender)
            return;

        this.context.editor.sequencePanel.updateSequencePanel();
        if (this.activeFrame) {
            if (!skipContextRerender)
                this.context.changeToFrameModelContext(this.activeFrame);
            this.setSceneStateOnFrame(this.activeFrame);
            $("#recordTool").prop("disabled", false);
        } else {
            if (!skipContextRerender)
                this.context.changeToSceneModelContext();
            this.setSceneState();
            $("#recordTool").prop("disabled", true);
        }

        this.context.editor.toScene(true);

        $("#recordTool").removeClass("recording");
        $("#recordToolBadge").html("");
        context.recordedActions = {};
    };

    this.goToFrame = function (frameNo, skipRerender) {
        if (frameNo < 0)
            this.changeFrame(null, skipRerender);
        else
            this.changeFrame(this.frames[frameNo], skipRerender);
    };

    setupListener(this);
    this.addListener(this, "sceneName", function (newValue, res) {
        res.context.editor.sceneContentPanel.updateSceneContent();
        res.context.editor.projectPanel.updateSceneList();
        return true;
    });
    this.addListener(this, "backgroundColor", function (newValue, res) {
        return true;
    });
    this.addListener(this, "dataVariables", function (newValue, res) {
        res.context.editor.diagramPanel.updateDiagramPanel();
        return true;
    });

    this.addEntityToScene = function (entity) {

        this.entities.push(entity);
        entity.originalScene = this;
        this.startState["ss" + entity.entityID] = entity.serializeFlat();


        entity.setAllListeners(this, function (newValue, key, res) {
            var activeScene = res.context.editor.activeScene;
            if (!activeScene.activeFrame && res === activeScene) {
                if (!res.startState["ss" + entity.entityID]) {
                    res.startState["ss" + entity.entityID] = {};
                }
                res.startState["ss" + entity.entityID][key] = newValue;

                if (key === "name") {
                    res.context.editor.sequencePanel.updateSequencePanel();
                }
            } else if (activeScene.activeFrame && key !== "name") {
                if (!res.context.recordedActions["ss" + entity.entityID]) {
                    res.context.recordedActions["ss" + entity.entityID] = {};
                }
                res.context.recordedActions["ss" + entity.entityID][key] = newValue;

                var count = 0;
                for (var k in res.context.recordedActions) {
                    var posNo = 0;
                    var scaleNo = 0;
                    for (var j in res.context.recordedActions[k]) {
                        if (/pos/i.test(j))
                            posNo++;
                        if (/scale/i.test(j))
                            scaleNo++;
                        count++;
                    }
                    if (posNo > 1)
                        count--;
                    if (scaleNo > 1)
                        count--;
                }
                if (count > 0) {
                    $("#recordTool").addClass("recording");
                }
                $("#recordToolBadge").html(count);

            }
            if (key === "name" && res === activeScene) {
                if (!res.startState["ss" + entity.entityID]) {
                    res.startState["ss" + entity.entityID] = {};
                }
                res.startState["ss" + entity.entityID][key] = newValue;
                res.context.editor.sequencePanel.updateSequencePanel();
            }


            return true;
        });
        this.changeFrame(null, false, true);

        var sprite = entity.getSprite();
        sprite.zIndex = this.viewportContainer.children.length;
        this.viewportContainer.addChild(sprite);


        this.sceneContentEditedCallback();

        this.context.editor.viewport.setSelected(sprite);
    };

    this.getEntityByID = function (id) {
        for (var k in this.entities) {
            if (this.entities[k].entityID === id) {
                return this.entities[k];
            }
        }
        return null;
    };

    this.removeEntityFromScene = function (entity) {
        this.entities.splice(this.entities.indexOf(entity), 1);

        delete this.startState["ss" + entity.entityID];

        this.viewportContainer.removeChild(entity.sprite);
        this.sceneContentEditedCallback();
    };

    this.sceneContentEditedCallback = (function (c, scene) {
        return function () {
            c.editor.sceneContentPanel.updateSceneContent();
            c.editor.sequencePanel.updateSequencePanel();
            scene.renderThumbnail();

            if (this.context.propCallbacks['ActionField']) {
                this.context.propCallbacks['ActionField']();
            }
        };
    }(context, this));
    this.sceneEditedCallback = (function (c, scene) {
        return function () {
            scene.renderThumbnail();
        };
    }(context, this));

    this.updateThumbnailRenderer = function (view) {
        this.thumbnailRenderer = new PIXI.CanvasRenderer(this.context.editor.innerWidth, this.context.editor.innerHeight, {
            view: view,
            resolution: 1
        });
        this.thumbnailRenderer.backgroundColor = 0xEEEEEE;
    };

    this.initialRenders = 10;
    this.thumbnailRendererCounter = 0;
    this.renderThumbnail = function () {
        if (this.thumbnailRendererCounter > 0) {
            if(this.initialRenders < 0) {
                this.thumbnailRendererCounter--;
                return;
            } else {
                this.initialRenders--;
            }
        } else {
            if (this.context.editor.activeScene === this) {
                this.thumbnailRendererCounter = 10;
            } else {
                this.thumbnailRendererCounter = 100;
            }
        }

        var renderer = this.thumbnailRenderer;

        renderer.view = this.thumbnailRenderer.view;
        renderer.backgroundColor = 0xEEEEEE;
        if (this.context.editor.activeScene === this) {
            renderer.resize(this.context.editor.viewport.canvas.parentNode.clientWidth, this.context.editor.viewport.canvas.parentNode.clientWidth / this.context.editor.innerWidth * this.context.editor.innerHeight);
        } else {
            renderer.resize(this.context.editor.innerWidth, this.context.editor.innerHeight);
        }
        renderer.render(this.viewportContainer);
//        renderer.view = this.context.editor.viewport.canvas;
    };

    this.serialize = function () {
        var s = this;

//        var entities = {};
//        for (var e in s.entities) {
//            entities[e] = s.entities[e].serialize();
//        }
        var frames = {};
        for (var f in s.frames) {
            frames[f] = s.frames[f].serialize();
        }
        var startState = {};
        for (var f in s.startState) {
            startState[f] = s.startState[f];
        }

        var res = {};
        res.entities = [];

        for (var k in s.entities) {
            res.entities.push(s.entities[k].serialize());
        }

        res.frames = frames;
        res.startState = startState;
        for (var k in Scene.serializable) {
            var kk = Scene.serializable[k];
            res[kk] = s[kk];
        }

        res.dataVariables = s.dataVariables;


        return res;
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

                if (this.activeFrame) {
                    cpy(stateData, entity, Entity.serializable, this.context.editor.resolveValue);
                    cpy(stateData, entity.entityProperty, Entity.propSerializable, this.context.editor.resolveValue);
                    cpy(stateData, entity.shadingProperty, Entity.shadingSerializable, this.context.editor.resolveValue);

                    if (stateData.isAButton) {
                        cpy(stateData, entity, Button.serializable, this.context.editor.resolveValue);
                    } else if (stateData.isAQSprite) {
                        cpy(stateData, entity, QSprite.serializable, this.context.editor.resolveValue);
                    } else if (stateData.isAQText) {
                        cpy(stateData, entity, QText.serializable, this.context.editor.resolveValue);
                        cpy(stateData, entity, QText.textAttributes, this.context.editor.resolveValue);
                    }
                } else {
                    cpy(stateData, entity, Entity.serializable);
                    cpy(stateData, entity.entityProperty, Entity.propSerializable);
                    cpy(stateData, entity.shadingProperty, Entity.shadingSerializable);

                    if (stateData.isAButton) {
                        cpy(stateData, entity, Button.serializable);
                    } else if (stateData.isAQSprite) {
                        cpy(stateData, entity, QSprite.serializable);
                    } else if (stateData.isAQText) {
                        cpy(stateData, entity, QText.serializable);
                        cpy(stateData, entity, QText.textAttributes);
                    }
                }



            }
        }
    };

    this.getAllSceneLinks = function () {
        var res = {};
        for (var k in this.frames) {
            for (var j in this.frames[k].actions) {
                for (var l in this.frames[k].actions[j]) {
                    var action = this.frames[k].actions[j][l];
                    if (action.isLinkAction) {
                        var ln = action.getLinkName();
                        if (ln) {
                            res[ln] = true;
                        }
                    }
                }
            }
        }
        for (var k in this.entities) {
            var en = this.entities[k];
            if (en.isAButton) {
                var ln = en.getLinkName();
                if (ln) {
                    res[ln] = true;
                }
            }
            for (var j in en.onClickActions) {
                var action = en.onClickActions[j];
                if (action.isLinkAction) {
                    var ln = action.getLinkName();
                    if (ln) {
                        res[ln] = true;
                    }
                }
            }
            for (var j in en.onEnterActions) {
                var action = en.onEnterActions[j];
                if (action.isLinkAction) {
                    var ln = action.getLinkName();
                    if (ln) {
                        res[ln] = true;
                    }
                }
            }
            for (var j in en.onExitActions) {
                var action = en.onExitActions[j];
                if (action.isLinkAction) {
                    var ln = action.getLinkName();
                    if (ln) {
                        res[ln] = true;
                    }
                }
            }
        }

        return res;
    };

    generateListCF(this, "Entity", this.entities, {
        Name: function (e) {
            return e.name;
        }
    }, {
        Add: this.sceneContentEditedCallback,
        Remove: this.sceneContentEditedCallback
    });

    this.initScene = function () {
        var s = this;

        this.thumbnailRenderer = PIXI.autoDetectRenderer(this.context.editor.innerWidth, this.context.editor.innerHeight, {
            resolution: 1
        });
        var nvc = s.viewportContainer;
        s.viewportContainer = new PIXI.Container();



        var c = this.context;

        var rect = new PIXI.Graphics();
        rect.beginFill(0xFFFFFF);
        rect.lineStyle(2, 0x000000);
        rect.drawRect(-c.editor.innerWidth / 2, -c.editor.innerHeight / 2, c.editor.innerWidth, c.editor.innerHeight);
        rect.endFill();
        rect.name = "Background";

        s.viewportContainer.addChild(rect);
        s.viewportContainer.position.x = c.editor.innerWidth / 2;
        s.viewportContainer.position.y = c.editor.innerHeight / 2;
        s.initialRenders = 10;
        if (nvc) {
            var length = nvc.children.length;
            for (var i = 1; i < length; i++) {
                s.viewportContainer.addChild(nvc.children[1]);
            }
        }
    };

    this.initScene();
}

Scene.serializable = ["sceneName", "sceneID", "backgroundColor", "rootAttributes"];

Scene.deserialize = function (context, input) {
    var scene = new Scene(context, input.sceneName);

//    context.editor.activeScene = scene;
    for (var k in Scene.serializable) {
        var kk = Scene.serializable[k];
        scene[kk] = input[kk];
    }

    for (var e in input.entities) {
        scene.addEntityToScene(Entity.deserialize(context, input.entities[e]));
    }
    for (var e in input.frames) {
        scene.frames[e] = Frame.deserialize(scene, input.frames[e]);
    }
    for (var e in input.startState) {
        scene.startState[e] = input.startState[e];
    }

    scene.dataVariables = input.dataVariables;

    return scene;
};