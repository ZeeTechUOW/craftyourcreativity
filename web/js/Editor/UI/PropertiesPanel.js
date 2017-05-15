/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function PropertiesPanel(context) {
    this.context = context;
    var editor = context.editor;

    this.currentPropertiesContext = null;
    this.dom = document.getElementById("propertiesPanel");

    this.EntityModelContext = function (entity, modelExtension) {
        return new ModelContext(entity, function (modelContext, paneler) {

            modelContext.insert(paneler.createEntityPropField(entity, "name", "Name"));
            modelContext.insert(paneler.createDualField(
                    paneler.createEntityPropField(entity, "posx", "x"),
                    paneler.createEntityPropField(entity, "scalex", "w"))
                    );
            modelContext.insert(paneler.createDualField(
                    paneler.createEntityPropField(entity, "posy", "y"),
                    paneler.createEntityPropField(entity, "scaley", "h"))
                    );
            modelContext.insert(paneler.createEntityPropField(entity, "rotation", "Rotation"));
            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createEntityPropField(entity, "anchorx", "Horizontal Anchor"));
            modelContext.insert(paneler.createEntityPropField(entity, "anchory", "Vertical Anchor"));
            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createEntityPropField(entity, "tint", "Tint Color"));
            modelContext.insert(paneler.createEntityPropField(entity, "alpha", "Alpha"));
            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createLabel("Events"));
            modelContext.insert(paneler.createActionArray("Mouse Clicked", entity, "onClickActions"));
            modelContext.insert(paneler.createActionArray("Mouse Entered", entity, "onEnterActions"));
            modelContext.insert(paneler.createActionArray("Mouse Exit", entity, "onExitActions"));
            modelContext.insert(paneler.createSeperator());

            if (modelExtension) {
                modelExtension(modelContext, paneler);
            }
        });
    };

    this.QSpriteModelContext = function (sprite) {
        return this.EntityModelContext(sprite, function (modelContext, paneler) {
            modelContext.insert(0, paneler.createLabel("Image"));
            modelContext.insert(2, paneler.createEntityPropField(sprite, "src", "Image Source"));
            modelContext.insert(3, paneler.createSeperator());

        });
    };

    this.ButtonModelContext = function (button) {
        return this.EntityModelContext(button, function (modelContext, paneler) {
            modelContext.insert(0, paneler.createLabel("Button"));
            modelContext.insert(2, paneler.createSeperator());
            modelContext.insert(3, paneler.createEntityPropField(button, "link", "Button Link"));
            modelContext.insert(4, paneler.createEntityPropField(button, "text", "Button Text"));
            modelContext.insert(5, paneler.createEntityPropField(button, "normSrc", "Button Image"));
            modelContext.insert(6, paneler.createSeperator());
        });
    };

    this.QTextModelContext = function (qtext) {
        return this.EntityModelContext(qtext, function (modelContext, paneler) {
            modelContext.insert(0, paneler.createLabel("Text"));
            modelContext.insert(2, paneler.createSeperator());
            modelContext.insert(3, paneler.createEntityPropField(qtext, "text", "Text"));
            modelContext.insert(4, paneler.createEntityPropField(qtext, "font", "Font"));
            modelContext.insert(5, paneler.createEntityPropField(qtext, "align", "Align"));
            modelContext.insert(6, paneler.createEntityPropField(qtext, "wordWrap", "Word Wrap"));
            modelContext.insert(7, paneler.createEntityPropField(qtext, "color", "Font Color"));
            modelContext.insert(8, paneler.createEntityPropField(qtext, "fontSize", "Font Size"));
            modelContext.insert(9, paneler.createSeperator());
        });
    };

    this.SceneModelContext = function (scene) {
        return new ModelContext(scene, function (modelContext, paneler) {
            var p = editor.project;

            modelContext.insert(paneler.createLabel("Scene"));
            modelContext.insert(paneler.createTextField("Scene Name", scene, "sceneName", {
                validateNewValue: function (newValue, oldValue) {
                    if (scene.sceneName === newValue)
                        return newValue;
                    var name = incrementIfDuplicate(
                            newValue,
                            editor.project.scenes,
                            function (s) {
                                return s.sceneName;
                            }
                    );
            
                    editor.context.addEdit(Edit.editSceneEdit(scene, "sceneName", name, oldValue));
            
                    return name;
                }
            }));


            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createObjectField("Scene Data", scene.dataVariables, {
                type: "ANY",
                modifyable: true,
                onCompleted: function () {
                    editor.diagramPanel.updateDiagramPanel();
                }
            }));

            modelContext.insert(paneler.createObjectField("Project Data", p.dataVariables, {
                type: "ANY",
                modifyable: true,
                onCompleted: function () {
                    editor.diagramPanel.updateDiagramPanel();
                }
            }));
            
            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createDropdownField("Window Size", p, "windowSize", {
                data: [{x: 845, y: 480}, {x: 800, y: 600}, {x: 1024, y: 768}, {x: 1280, y: 720}],
                formatValueToElem: function (d) {
                    return d.x + " x " + d.y;
                },
                validateNewValue: function (newValue) {
                    editor.innerWidth = newValue.x;
                    editor.innerHeight = newValue.y;

                    var activeScene = editor.activeScene;

                    for (var k in editor.project.scenes) {
                        var kk = editor.project.scenes[k];
                        kk.initScene();
                    }
                    editor.viewport.changeScene(activeScene);
                    editor.projectPanel.updateSceneList();

                    return newValue;
                }
            }));
        });
    };

    this.FrameModelContext = function (frame) {
        return new ModelContext(frame, function (modelContext, paneler) {
            var frameNo = (editor.activeScene.frames.indexOf(frame) + 1);

            modelContext.insert(paneler.createLabel("Frame " + frameNo));
            modelContext.insert(paneler.createButton("Delete Frame", function () {
                editor.context.addEdit(Edit.deleteFrameEdit(frame, editor.activeScene));
            }));

            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createDropdownField("Next Frame", frame, "nextFrameOptions", {
                data: Frame.nextFrameOptions,
                formatValueToElem: function (d) {
                    return d;
                },
                validateNewValue: function (newValue, oldValue) {            
                    editor.context.addEdit(Edit.editFrameEdit(editor.activeScene, frame, "nextFrameOptions", newValue, oldValue));
            
                    return newValue;
                }
            }));

            modelContext.insert(paneler.createAnchor("ActionField"));
            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createButton("Add Entity Action", function () {
                editor.context.propCallbacks["ActionFieldOps"] = function () {
                    editor.context.propCallbacks["ActionFieldValue"] = function () {
                        var ad = editor.context.actionData;
                        ad.duration = 1000;
                        ad.offset = 0;
                        ad.graph = Action.LinearGraph;

                        var field = paneler.createEntityPropField(ad.target, ad.op.values, ad.op.name);
                        var res = field.print();
                        res += paneler.createSeperator().print();
                        res += paneler.createIntField("Offset (ms)", ad, "offset").print();
                        res += paneler.createIntField("Duration (ms)", ad, "duration").print();
                        res += paneler.createDropdownField("Easing", ad, "graph", {
                            data: Action.Easings,
                            formatValueToElem: function (d) {
                                return d.name;
                            }
                        }).print();

                        $("#ActionFieldValue").html(res);
//                                replaceDom("ActionFieldValue", res);

                        field.updateUI();
                    };
                    var ad = editor.context.actionData;
                    if (!ad.target)
                        return;
                    editor.viewport.setSelected(ad.target.sprite, true, true);

                    var data = [];
                    if (ad.target.getKeyableProperties) {
                        data = ad.target.getKeyableProperties();
                    }

                    ad.op = (data.length > 0 ? data[0] : null);
                    ad.addListener(editor, "op", function (newValue, res) {
                        res.context.propCallbacks["ActionFieldValue"]();
                        return true;
                    });

                    var res = paneler.createDropdownField("Operations", ad, "op", {
                        data: data,
                        formatValueToElem: function (data) {
                            return data.name;
                        }
                    }).print();

                    res += paneler.createAnchor("ActionFieldValue").print();

                    $("#ActionFieldOps").html(res);
                    editor.context.propCallbacks["ActionFieldValue"]();
                };

                editor.context.actionData = {
                    activeScene: editor.activeScene,
                    activeFrame: (editor.activeScene ? editor.activeScene.activeFrame : null)
                };
                setupListener(editor.context.actionData);
                editor.context.actionData.addListener(editor, "target", function (newValue, res) {
                    res.context.propCallbacks["ActionFieldOps"]();
                    return true;
                });
                editor.context.actionData.target = editor.viewport.selectedShape ? editor.viewport.selectedShape.model : (editor.activeScene.entities.length > 0 ? editor.activeScene.entities[0] : null);

                var res = paneler.createSeperator().print();
                res += paneler.createDropdownField("Target Object", editor.context.actionData, "target", {
                    data: editor.activeScene.entities,
                    formatValueToElem: function (d) {
                        return d.name;
                    }
                }).print();
                res += paneler.createAnchor("ActionFieldOps").print();
                res += paneler.createDualButton(
                        paneler.createButton("Add", function () {
                            var ad = editor.context.actionData;

                            var parent = ad.op.parent ? ad.op.parent : ad.target;
                            for (var k in ad.op.values) {
                                var v = ad.op.values[k];
                                ad.op.values[k] = {
                                    value: v,
                                    valueParent: parent,
                                    targetValue: parent[v]
                                };
                            }

                            var action = Action.entityAction(ad);
                            editor.activeScene.activeFrame.addAction(action);

                            delete editor.context.actionData;
                            editor.activeScene.activeFrame.selectAction(action);
                        }),
                        paneler.createButton("Cancel", function () {
                            delete editor.context.actionData;
                            editor.context.changeToFrameModelContext(editor.activeScene.activeFrame);
                        })
                        ).print();

                $("#ActionField").html(res);
                editor.context.propCallbacks["ActionFieldOps"]();
            }));

            modelContext.insert(paneler.createButton("Add Link Action", function () {
                var res = "";

                var ad = {link: ""};
                setupListener(ad);

                res += paneler.createSeperator().print();
                res += paneler.createLinkField("Link", ad, "link").print();

                res += paneler.createDualButton(
                        paneler.createButton("Add", function () {
                            var action = Action.linkAction(ad.link);
                            editor.activeScene.activeFrame.addAction(action);
                            editor.activeScene.activeFrame.selectAction(action);
                        }),
                        paneler.createButton("Cancel", function () {
                            editor.context.changeToFrameModelContext(editor.activeScene.activeFrame);
                        })).print();

                $("#ActionField").html(res);
            }));
            modelContext.insert(paneler.createButton("Add Data Action", function () {
                var res = "";

                var ad = {varName: "", value: ""};
                setupListener(ad);

                res += paneler.createSeperator().print();
                res += paneler.createTextField("Variable Name", ad, "varName").print();
                res += paneler.createAnyField("Value", ad, "value").print();

                res += paneler.createDualButton(
                        paneler.createButton("Add", function () {
                            var action = Action.dataAction(ad.varName, ad.value.value);

                            if (action) {
                                editor.activeScene.activeFrame.addAction(action);
                                editor.activeScene.activeFrame.selectAction(action);
                            }
                        }),
                        paneler.createButton("Cancel", function () {
                            editor.context.changeToFrameModelContext(editor.activeScene.activeFrame);
                        })).print();

                $("#ActionField").html(res);
            }));
            modelContext.insert(paneler.createButton("Add Audio Action", function () {
                var res = "";

                var ad = {audioSrc: "", loop: 0, volume: 1};
                setupListener(ad);

                res += paneler.createSeperator().print();
                res += paneler.createAudioField("Audio Source", ad, "audioSrc").print();
                res += paneler.createSliderField("Volume", ad, "volume", {
                    lowerLimit: 0, upperLimit: 1, step: .01
                }).print();
                res += paneler.createDropdownField("Channel", ad, "channel", {
                    data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                    formatValueToElem: function (d) {
                        if (d === 0)
                            return "Auto";
                        return d;
                    }
                }).print();
                res += paneler.createBoolField("Frame Stop", ad, "frameStop").print();
                res += paneler.createBoolField("Loop", ad, "loop").print();
                res += paneler.createBoolField("Wait Audio", ad, "waitAudio").print();

                res += paneler.createDualButton(
                        paneler.createButton("Add", function () {
                            var action = Action.audioAction(ad);

                            if (action) {
                                editor.activeScene.activeFrame.addAction(action);
                                editor.activeScene.activeFrame.selectAction(action);
                            }
                        }),
                        paneler.createButton("Cancel", function () {
                            editor.context.changeToFrameModelContext(editor.activeScene.activeFrame);
                        })).print();

                $("#ActionField").html(res);
            }));

            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createButton("Insert New Frame Before", function () {
                delete editor.context.actionData;
                insertNewFrameBefore();
            }));
            modelContext.insert(paneler.createButton("Insert New Frame After", function () {
                delete editor.context.actionData;
                insertNewFrameAfter();
            }));
        });
    };

    this.ActionModelContext = function (action) {

        return new ModelContext(action, function (modelContext, paneler) {
            modelContext.insert(paneler.createLabel("Action"));
            modelContext.insert(paneler.createButton("Delete Action", function () {
                editor.activeScene.activeFrame.removeCurrentAction();
            }));
            modelContext.insert(paneler.createSeperator());
            modelContext.insert(paneler.createTextField("Action Name", action, "actionName"));

            if (action.isEntityAction) {
                modelContext.insert(paneler.createIntField("Offset (ms)", action, "offset"));
                modelContext.insert(paneler.createIntField("Duration (ms)", action, "duration"));
                modelContext.insert(paneler.createDropdownField("Easing", action, "easing", {
                    data: Action.Easings,
                    formatValueToElem: function (d) {
                        return d.name;
                    }
                }));

                modelContext.insert(paneler.createSeperator());
                modelContext.insert(paneler.createObjectField("Value List", action.stateMatrix, {
                    modifyable: false,
                    type: "ENTITY",
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
            } else if (action.isLinkAction) {
                modelContext.insert(paneler.createSeperator());
                modelContext.insert(paneler.createObjectField("Value List", action.stateMatrix, {
                    modifyable: false,
                    type: "LINK",
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
            } else if (action.isDataAction) {
                modelContext.insert(paneler.createSeperator());
                modelContext.insert(paneler.createLabel("Value List"));
                modelContext.insert(paneler.createTextField("dvarName", action.stateMatrix, "dvarName", {
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
                modelContext.insert(paneler.createTextField("dvalue", action.stateMatrix, "dvalue", {
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
            } else if (action.isAudioAction) {
                modelContext.insert(paneler.createSeperator());
                modelContext.insert(paneler.createLabel("Value List"));
                modelContext.insert(paneler.createAudioField("audioSrc", action.stateMatrix, "audioSrc", {
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
                modelContext.insert(paneler.createSliderField("volume", action.stateMatrix, "volume", {
                    lowerLimit: 0, upperLimit: 1, step: .01,
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
                modelContext.insert(paneler.createDropdownField("channel", action.stateMatrix, "channel", {
                    data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                    formatValueToElem: function (d) {
                        if (d === 0)
                            return "Auto";
                        return d;
                    }
                }));
                modelContext.insert(paneler.createBoolField("frameStop", action.stateMatrix, "frameStop"));
                modelContext.insert(paneler.createBoolField("loop", action.stateMatrix, "loop", {
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
                modelContext.insert(paneler.createBoolField("waitAudio", action.stateMatrix, "waitAudio", {
                    onCompleted: function () {
                        editor.sequencePanel.updateSequencePanel();
                        editor.activeScene.setSceneStateOnCurrent();
                    }
                }));
            }

        });
    };

    this.NodeModelContext = function (node) {
        return new ModelContext(node, function (modelContext, paneler) {
            modelContext.insert(paneler.createLabel("Node - " + node.nodeName));
            modelContext.insert(paneler.createButton("Delete Node", function () {
                editor.diagramPanel.deleteSelectedNode();
            }));
            modelContext.insert(paneler.createSeperator());

            node.populateModelContext(modelContext, paneler);
        });
    };

    this.init = function () {
        var c = this.context;
        c.propertiesContext = this.SceneModelContext(c.editor.activeScene);
    };

    this.update = function () {
        $("#propertiesPanel").height($("#propertiesCol").height() - $("#propertiesHeading").height());
        $("#propertiesPanel").css("max-height", $("#propertiesCol").height() - $("#propertiesHeading").height() - 30);
        if (this.currentPropertiesContext !== this.context.propertiesContext) {
            this.currentPropertiesContext = this.context.propertiesContext;
            this.clearPanel();
            this.currentPropertiesContext.init();
            this.appendCurrentToPanel();
        }

        if (this.currentPropertiesContext) {
            this.currentPropertiesContext.updateUI();
        }
    };

    this.appendCurrentToPanel = function () {
        if (this.currentPropertiesContext) {
            var list = this.currentPropertiesContext.fieldList;

            for (var i in list) {
                this.dom.innerHTML += list[i].print();

            }
        }
    };

    this.clearPanel = function () {
        this.dom.innerHTML = "";
    };

    this.init();
}