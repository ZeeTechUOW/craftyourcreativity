/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Deni Barasena
 */

function DiagramNode(context, opt) {
    if (!opt)
        opt = {};
    this.context = context;

    this.isANode = true;
    this.nodeID = opt.nodeID ? opt.nodeID : uid();
    this.x = opt.x ? opt.x : 0;
    this.y = opt.y ? opt.y : 0;
    this.nodeTypeID = opt.nodeType ? opt.nodeType : "playScene";
    this.nodeType = DiagramNode.NodeTypes[this.nodeTypeID]();

    for (var k in this.nodeType) {
        this[k] = this.nodeType[k];
    }

    this.print = function () {
        var res = "";
        var id = "Node" + this.nodeID;

        res += "<div id='" + id + "' class=\"diagramNode " + this.nodeSize + "" + (editor && this === editor.diagramPanel.selectedNode ? " active": "") + "\" onmousedown='selectDiagramNode(this, event);' style=\"top: " + this.y + "px; left: " + this.x + "px\">" +
                "<div id='head" + id + "' class=\"nodeHeader\" onmousedown='startDiagramNodeDrag(this, event);'>";

        if (this.flowInput)
            res += "<div  id='fi" + id + "' qid='" + this.nodeID + "' qvarname='_def' class=\"flowInput\" onmouseup='endFlowDrag(this, event, \"FLOW\")' onmousedown='startFlowInputDrag(this, event, \"FLOW\"); event.stopPropagation();'></div>";

        res += "<div class=\"nodeName\">" + this.nodeName + "</div>";

        if (this.flowOutput && this.flowOutput._def) {
            res += "<div id='fo" + id + "0_def' qid='" + this.nodeID + "' qvarname='_def' class=\"flowOutput\" onmousedown='startFlowOutputDrag(this, event, \"FLOW\"); event.stopPropagation();'></div>";
        }


        res += "</div>";

        if (this.content || (this.flowOutput && this.flowOutput.length > 1)) {
            res += "<div class=\"nodeContent\">";

            if (this.flowOutput) {
                var isExtra = false;
                for (var k in this.flowOutput) {
                    if (k !== "_def") {
                        isExtra = true;
                        res += "<div id='fo" + id + "0" + k + "' class=\"flowOutputLabel\">" + k;
                        res += "<div id='fo" + id + "0" + k + "' qid='" + this.nodeID + "' qvarname='" + k + "' class=\"flowOutput\" onmousedown='startFlowOutputDrag(this, event, \"FLOW\"); event.stopPropagation();'></div>";
                        res += "</div>";
                    }
                }
                if (isExtra) {
                    res += "<div class='seperator'></div>";
                }

            }

            for (var k in this.content) {
                var c = this.content[k];
                res += "<div id='nci" + id + "0" + k + "' class='nodeContentItem'>";

                if (c.label) {
                    res += "<div class=\"nodeLabel\">" + c.label + "</div>";
                }

                if (c.contextField) {
                    res += c.contextField().printField();
                }
                if (c.dataInput) {
                    res += "<div id='fdi" + id + "0" + k + "' qid='" + this.nodeID + "' qvarname='" + k + "' class=\"flowDataInput\" onmouseup='endFlowDrag(this, event, \"DATA\")' onmousedown='startFlowInputDrag(this, event, \"DATA\"); event.stopPropagation();'></div>";

                }
                if (c.dataOutput) {
                    res += "<div id='fdo" + id + "0" + k + "' qid='" + this.nodeID + "' qvarname='" + k + "' class=\"flowDataOutput\" onmousedown='startFlowOutputDrag(this, event, \"DATA\"); event.stopPropagation();'></div>";
                }

                res += "</div>";
            }

            res += "</div>";
        }

        res += "</div>";

        return res;
    };
    this.useZoomLevel = false;
    if (isIEorEDGE() || /Firefox/i.test(navigator.userAgent)) {
        this.useZoomLevel = true;
    }

    var that = this;
    this.getFlowInputPos = function (zoomLevel) {
        return {
            x: that.x,
            y: that.y + 15
        };
    };
    this.getFlowOutputPos = function (outputName, zoomLevel) {
        var y = that.y + 15;

        if (outputName !== "_def") {
            var pos = $("#foNode" + this.nodeID + "0" + outputName).position();
            
            if( pos ) {
                y += pos.top / (that.useZoomLevel ? zoomLevel : 1);
            }
        }

        return {
            x: that.x + $("#Node" + this.nodeID).outerWidth(),
            y: y
        };
    };
    this.getFlowDataOutputPos = function (dataTarget, zoomLevel) {
        var pos = $("#nciNode" + this.nodeID + "0" + dataTarget).position();
        
        var y = that.y + 15 + (pos?pos.top:0) / (that.useZoomLevel ? zoomLevel : 1);

        return {
            x: that.x + $("#Node" + this.nodeID).outerWidth(),
            y: y
        };
    };
    this.getFlowDataInputPos = function (dataTarget, zoomLevel) {
        var pos = $("#nciNode" + this.nodeID + "0" + dataTarget).position();
        var y = that.y + 15 + (pos?pos.top:0) / (that.useZoomLevel ? zoomLevel : 1);

        return {
            x: that.x,
            y: y
        };
    };

    this.serialize = function () {
        var res = {};

        res.nodeID = this.nodeID;
        res.nodeName = this.nodeName;
        res.nodeTypeID = this.nodeTypeID;
        res.x = this.x;
        res.y = this.y;
        res.flowInput = this.flowInput;

        if (this.flowOutput) {
            res.flowOutput = {};
            for (var k in this.flowOutput) {
                res.flowOutput[k] = this.flowOutput[k];
            }
        }

        res.nodeTypeData = {};
        for (var k in this.content) {
            res.nodeTypeData[k] = {};
            res.nodeTypeData[k].dataInput = this.content[k].dataInput;

            if (this.content[k].serializeValue) {
                res.nodeTypeData[k].value = this.content[k].serializeValue();
            } else {
                res.nodeTypeData[k].value = this.content[k].value;
            }

        }

        return res;
    };

    this.populateModelContext = function (modelContext, paneler) {

        if (this.content) {
            modelContext.insert(paneler.createLabel("Value List"));
            for (var k in this.content) {
                var c = this.content[k];
                if (c.contextField) {
                    modelContext.insert(c.contextField());
                }
            }

        }
    };

    if (this.content) {
        for (var k in this.content) {
            var c = this.content[k];
            c.node = this;
            setupListener(c);
        }
    }
}

DiagramNode.deserialize = function (context, input) {
    var ext = {};

    ext.nodeID = input.nodeID;
    ext.nodeName = input.nodeName;
    ext.nodeType = input.nodeTypeID;
    ext.x = input.x;
    ext.y = input.y;

    var res = new DiagramNode(context, ext);

    res.flowInput = input.flowInput;
    res.flowOutput = {};
    for (var k in input.flowOutput) {
        res.flowOutput[k] = input.flowOutput[k];
    }

    for (var k in input.nodeTypeData) {
        if (!res.content[k]) {
            res.content[k] = {};
        }
        res.content[k].dataInput = input.nodeTypeData[k].dataInput;
        if (res.content[k].deserializeValue) {
            res.content[k].value = res.content[k].deserializeValue(input.nodeTypeData[k].value, context);
        } else {
            res.content[k].value = input.nodeTypeData[k].value;
        }
    }

    if (res.updateUI) {
        res.updateUI();
    }

    return res;
};

DiagramNode.serializable = ["x", "y", "nodeID", "nodeType"];
DiagramNode.NodeTypes = {
    start: function () {
        return {
            nodeName: "Start",
            nodeSize: "small",
            flowOutput: {
                _def: true
            }
        };
    },
    end: function () {
        return {
            nodeName: "End",
            nodeSize: "small",
            flowInput: true,
            content: {
                score: {
                    label: "Score",
                    dataInput: true,
                    value: 0,
                    contextField: function () {
                        var that = this;

                        return InputRenderer.createFloatField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {score: {value: newValue}}}, "Edit", {content: {score: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                }
            },
            updateUI: function () {
                if (editor) {
                    var exContents = editor.getEndData();
                }

                for (var k in exContents) {
                    var d = "";
                    var din = true;
                    if (this.content["dataEnd_" + k]) {
                        d = this.content["dataEnd_" + k].value;
                        din = this.content["dataEnd_" + k].dataInput;
                    }
                    var that = this;
                    this.content["dataEnd_" + k] = {
                        label: k,
                        value: d,
                        dataInput: din,
                        contextField: (function (k) {
                            return function () {
                                return InputRenderer.createAnyField(this.label, this, "value", {
                                    onCompleted: function () {
                                        editor.diagramPanel.updateDiagramPanel();
                                        editor.context.changeToNodeModelContext(that);
                                    },
                                    validateNewValue: function (newValue, oldValue) {
                                        var stateData = {content: {}};
                                        stateData.content["dataEnd_" + k] = {value: newValue};
                                        var prevStateData = {content: {}};
                                        prevStateData.content["dataEnd_" + k] = {value: oldValue};
                                        editor.context.addEdit(Edit.editNodeEdit(that, stateData, "Edit", prevStateData).dontInitDo().setOnCompleted(function () {
                                            editor.context.changeToNodeModelContext(that);
                                        }));
                                        return newValue;
                                    }
                                });
                            };
                        }(k))
                    };
                    exContents[k] = false;
                }
                for (var k in exContents) {
                    if (exContents[k]) {
                        delete this.content[k];
                    }
                }

            }
        };
    },
    playScene: function () {
        return {
            nodeName: "Play Scene",
            nodeSize: "",
            flowInput: true,
            flowOutput: {
                _def: true
            },
            content: {
                sceneName: {
                    label: "Scene Name",
                    value: null,
                    serializeValue: function () {
                        return (this.value ? this.value.sceneID : null);
                    },
                    deserializeValue: function (value, context) {
                        var d = context.project.scenes;
                        for (var k in d) {

                            if (d[k].sceneID === value) {
                                return d[k];
                            }
                        }
                        return null;
                    },
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createDropdownField(this.label, this, "value", {
                            data: this.data(),
                            formatValueToElem: this.getData,
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(that.node);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                var stateData = {content: {sceneName: {value: newValue}}};
                                var prevStateData = {flowOutput: {}, content: {sceneName: {value: oldValue}}};
                                
                                for ( var k in that.node.flowOutput ) {
                                    prevStateData.flowOutput[k] = that.node.flowOutput[k];
                                }
                                for ( var k in that.node.content ) {
                                    if( k !== "sceneName" ) {
                                        prevStateData.content[k] = {};
                                        prevStateData.content[k].dataInput = that.node.content[k].dataInput;
                                        prevStateData.content[k].value = that.node.content[k].value;
                                    }
                                }
                                
                                var edit = Edit.editNodeEdit(that.node, stateData, "Edit", prevStateData).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                });
                                for( var k in editor.diagramPanel.nodes ) {
                                    for( var j in editor.diagramPanel.nodes[k].content ) {
                                        var c = editor.diagramPanel.nodes[k].content[j];
                                        if( c.dataInput && c.dataInput !== true ) {
                                            var cdata = c.dataInput.split("|");
                                            if( cdata[0] === that.node.nodeID + "" ) {
                                                var nStateData = {content: {}};
                                                nStateData.content[j] = {dataInput: true};
                                                var nPrevStateData = {content: {}};
                                                nPrevStateData.content[j] = {dataInput: c.dataInput};
                                                
                                                var nEdit = Edit.editNodeEdit(editor.diagramPanel.nodes[k], nStateData, "", nPrevStateData);
                                                edit.combine(nEdit);
                                                c.dataInput = true;
                                            }
                                        }
                                    }
                                }
                                
                                
                                editor.context.addEdit(edit);
                                return newValue;
                            }
                        });
                    },
                    data: function () {
                        return editor ? editor.project.scenes : [];
                    },
                    getData: function (d) {
                        if (!d)
                            return "null";
                        return d.sceneName;
                    }
                }
            },
            updateUI: function () {
                var exContents = {};
                for (var k in this.content) {
                    if (k.startsWith("sceneVar_")) {
                        exContents[k] = true;
                    }
                }
                var exFlows = {};
                for (var k in this.flowOutput) {
                    if (k !== "_def") {
                        exFlows[k] = true;
                    }
                }

                if (!this.content.sceneName.value) {
                    this.content.sceneName.value = this.content.sceneName.data()[0];
                }

                if (this.content.sceneName.value) {
                    for (var k in this.content.sceneName.value.dataVariables) {
                        var d = this.content.sceneName.value.dataVariables[k];
                        var din = true;
                        if (this.content["sceneVar_" + k]) {
                            d = this.content["sceneVar_" + k].value;
                            din = this.content["sceneVar_" + k].dataInput;
                        }
                        var that = this;
                        this.content["sceneVar_" + k] = {
                            label: "@" + k,
                            value: d,
                            dataInput: din,
                            dataOutput: true,
                            contextField: (function (k) {
                                return function () {
                                    return InputRenderer.createAnyField(this.label, this, "value", {
                                        onCompleted: function () {
                                            editor.diagramPanel.updateDiagramPanel();
                                            editor.context.changeToNodeModelContext(that);
                                        },
                                        validateNewValue: function (newValue, oldValue) {
                                            var stateData = {content: {}};
                                            stateData.content["sceneVar_" + k] = {value: newValue};
                                            var prevStateData = {content: {}};
                                            prevStateData.content["sceneVar_" + k] = {value: oldValue};
                                            editor.context.addEdit(Edit.editNodeEdit(that, stateData, "Edit", prevStateData).dontInitDo().setOnCompleted(function () {
                                                editor.context.changeToNodeModelContext(that);
                                            }));
                                            return newValue;
                                        }
                                    });
                                };
                            }(k))
                        };
                        exContents["sceneVar_" + k] = false;
                    }
                    for (var k in exContents) {
                        if (exContents[k]) {
                            delete this.content[k];
                        }
                    }

                    var sceneLinks = this.content.sceneName.value.getAllSceneLinks();
                    for (var k in sceneLinks) {

                        if (!exFlows[k]) {
                            this.flowOutput[k] = true;
                        }

                        exFlows[k] = false;
                    }

                    for (var k in exFlows) {
                        if (exFlows[k]) {
                            delete this.flowOutput[k];
                        }
                    }
                }
            }
        };
    },
    condition: function () {
        return {
            nodeName: "Condition",
            nodeSize: "",
            flowInput: true,
            flowOutput: {
                True: true,
                False: true
            },
            content: {
                lhsCondition: {
                    label: "Left Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createAnyField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {lhsCondition: {value: newValue}}}, "Edit", {content: {lhsCondition: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                operator: {
                    label: "Operator",
                    value: "==",
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createDropdownField(this.label, this, "value", {
                            data: ["<=", "==", "!=", ">=", "<", ">"],
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {operator: {value: newValue}}}, "Edit", {content: {operator: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                rhsCondition: {
                    label: "Right Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createAnyField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {rhsCondition: {value: newValue}}}, "Edit", {content: {rhsCondition: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                }
            }
        };
    },
    printCertificate: function () {
        return {
            nodeName: "Print Certificate",
            nodeSize: "",
            flowInput: true,
            flowOutput: {
                _def: true
            },
            content: {
                sceneName: {
                    label: "Scene Name",
                    value: null,
                    serializeValue: function () {
                        return (this.value ? this.value.sceneID : null);
                    },
                    deserializeValue: function (value, context) {
                        var d = context.project.scenes;
                        for (var k in d) {

                            if (d[k].sceneID === value) {
                                return d[k];
                            }
                        }
                        return null;
                    },
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createDropdownField(this.label, this, "value", {
                            data: this.data(),
                            formatValueToElem: this.getData,
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(that.node);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                var stateData = {content: {sceneName: {value: newValue}}};
                                var prevStateData = {flowOutput: {}, content: {sceneName: {value: oldValue}}};
                                
                                for ( var k in that.node.flowOutput ) {
                                    prevStateData.flowOutput[k] = that.node.flowOutput[k];
                                }
                                for ( var k in that.node.content ) {
                                    if( k !== "sceneName" ) {
                                        prevStateData.content[k] = {};
                                        prevStateData.content[k].dataInput = that.node.content[k].dataInput;
                                        prevStateData.content[k].value = that.node.content[k].value;
                                    }
                                }
                                
                                var edit = Edit.editNodeEdit(that.node, stateData, "Edit", prevStateData).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                });
                                for( var k in editor.diagramPanel.nodes ) {
                                    for( var j in editor.diagramPanel.nodes[k].content ) {
                                        var c = editor.diagramPanel.nodes[k].content[j];
                                        if( c.dataInput && c.dataInput !== true ) {
                                            var cdata = c.dataInput.split("|");
                                            if( cdata[0] === that.node.nodeID + "" ) {
                                                var nStateData = {content: {}};
                                                nStateData.content[j] = {dataInput: true};
                                                var nPrevStateData = {content: {}};
                                                nPrevStateData.content[j] = {dataInput: c.dataInput};
                                                
                                                var nEdit = Edit.editNodeEdit(editor.diagramPanel.nodes[k], nStateData, "", nPrevStateData);
                                                edit.combine(nEdit);
                                                c.dataInput = true;
                                            }
                                        }
                                    }
                                }
                                
                                
                                editor.context.addEdit(edit);
                                return newValue;
                            }
                        });
                    },
                    data: function () {
                        return editor ? editor.project.scenes : [];
                    },
                    getData: function (d) {
                        if (!d)
                            return "null";
                        return d.sceneName;
                    }
                }
            },
            updateUI: function () {
                var exContents = {};
                for (var k in this.content) {
                    if (k.startsWith("sceneVar_")) {
                        exContents[k] = true;
                    }
                }

                if (!this.content.sceneName.value) {
                    this.content.sceneName.value = this.content.sceneName.data()[0];
                }

                if (this.content.sceneName.value) {
                    for (var k in this.content.sceneName.value.dataVariables) {
                        var d = this.content.sceneName.value.dataVariables[k];
                        var din = true;
                        if (this.content["sceneVar_" + k]) {
                            d = this.content["sceneVar_" + k].value;
                            din = this.content["sceneVar_" + k].dataInput;
                        }
                        var that = this;
                        this.content["sceneVar_" + k] = {
                            label: "@" + k,
                            value: d,
                            dataInput: din,
                            contextField: (function (k) {
                                return function () {
                                    return InputRenderer.createAnyField(this.label, this, "value", {
                                        onCompleted: function () {
                                            editor.diagramPanel.updateDiagramPanel();
                                            editor.context.changeToNodeModelContext(that);
                                        },
                                        validateNewValue: function (newValue, oldValue) {
                                            var stateData = {content: {}};
                                            stateData.content["sceneVar_" + k] = {value: newValue};
                                            var prevStateData = {content: {}};
                                            prevStateData.content["sceneVar_" + k] = {value: oldValue};
                                            editor.context.addEdit(Edit.editNodeEdit(that, stateData, "Edit", prevStateData).dontInitDo().setOnCompleted(function () {
                                                editor.context.changeToNodeModelContext(that);
                                            }));
                                            return newValue;
                                        }
                                    });
                                };
                            }(k))
                        };
                        exContents["sceneVar_" + k] = false;
                    }
                    for (var k in exContents) {
                        if (exContents[k]) {
                            delete this.content[k];
                        }
                    }
                }
            }
        };
    },
    achievement: function () {
        return {
            nodeName: "Unlock Achievement",
            nodeSize: "",
            flowInput: true,
            flowOutput: {_def: true},
            content: {
                achievementName: {
                    label: "Achievement Name",
                    value: 0,
                    contextField: function () {
                        var that = this;
                        var d = editor.getAchievementData();
                        if (!editor.getAchievementDataLabel(this.value)) {
                            this.value = d[0];
                        }
                        return InputRenderer.createDropdownField(this.label, this, "value", {
                            data: d,
                            formatValueToElem: function (newValue) {
                                return editor.getAchievementDataLabel(newValue);
                            },
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {achievementName: {value: newValue}}}, "Edit", {content: {achievementName: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                }
            }
        };
    },
    setProjectData: function () {
        return {
            nodeName: "Project Data",
            nodeSize: "small",
            flowInput: true,
            flowOutput: {"_def": true},
            content: {},
            updateUI: function () {
                var exContents = {};
                for (var k in this.content) {
                    if (k.startsWith("projVar_")) {
                        exContents[k] = true;
                    }
                }

                for (var k in editor.project.dataVariables) {
                    var din = true;
                    var val = null;

                    if (this.content["projVar_" + k]) {
                        din = this.content["projVar_" + k].dataInput;
                        val = this.content["projVar_" + k].value;
                    }

                    var that = this;
                    this.content["projVar_" + k] = {
                        label: "Set #" + k,
                        dataInput: din,
                        dataOutput: false,
                        value: val,
                        contextField: (function (k) {
                            return function () {
                                return InputRenderer.createAnyField(this.label, this, "value", {
                                    onCompleted: function () {
                                        editor.diagramPanel.updateDiagramPanel();
                                        editor.context.changeToNodeModelContext(that);
                                    },
                                    validateNewValue: function (newValue, oldValue) {
                                        var stateData = {content: {}};
                                        stateData.content["projVar_" + k] = {value: newValue};
                                        var prevStateData = {content: {}};
                                        prevStateData.content["projVar_" + k] = {value: oldValue};
                                        editor.context.addEdit(Edit.editNodeEdit(that, stateData, "Edit", prevStateData).dontInitDo().setOnCompleted(function () {
                                            editor.context.changeToNodeModelContext(that);
                                        }));
                                        return newValue;
                                    }
                                });
                            };
                        }(k))
                    };
                    exContents["projVar_" + k] = false;
                }
                for (var k in exContents) {
                    if (exContents[k]) {
                        delete this.content[k];
                    }
                }
            }
        };
    },
    getProjectData: function () {
        return {
            nodeName: "Project Data",
            nodeSize: "small",
            content: {},
            updateUI: function () {
                var exContents = {};
                for (var k in this.content) {
                    if (k.startsWith("projVar_")) {
                        exContents[k] = true;
                    }
                }

                for (var k in editor.project.dataVariables) {
                    this.content["projVar_" + k] = {
                        label: "#" + k,
                        dataInput: false,
                        dataOutput: true,
                        contextField: function () {
                            return {
                                print: function () {
                                    return "";
                                },
                                printField: function () {
                                    return "";
                                }
                            };
                        }
                    };
                    exContents["projVar_" + k] = false;
                }
                for (var k in exContents) {
                    if (exContents[k]) {
                        delete this.content[k];
                    }
                }
            }
        };
    },
    arithmetics: function () {
        return {
            nodeName: "Math",
            nodeSize: "small",
            content: {
                lhs: {
                    label: "Left Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createFloatField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {lhs: {value: newValue}}}, "Edit", {content: {lhs: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                operator: {
                    label: "Operator",
                    value: "+",
                    dataOutput: true,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createDropdownField(this.label, this, "value", {
                            data: ["+", "-", "*", "/", "^", "%"],
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {operator: {value: newValue}}}, "Edit", {content: {operator: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                rhs: {
                    label: "Right Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createFloatField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {rhs: {value: newValue}}}, "Edit", {content: {rhs: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                }
            }
        };
    },
    comparison: function () {
        return {
            nodeName: "Compare",
            nodeSize: "small",
            content: {
                lhs: {
                    label: "Left Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createAnyField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {lhs: {value: newValue}}}, "Edit", {content: {lhs: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                operator: {
                    label: "Operator",
                    value: "==",
                    dataOutput: true,
                    dataInput: true,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createDropdownField(this.label, this, "value", {
                            data: ["<=", "==", "!=", ">=", "<", ">"],
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {operator: {value: newValue}}}, "Edit", {content: {operator: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                rhs: {
                    label: "Right Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createAnyField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {rhs: {value: newValue}}}, "Edit", {content: {rhs: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                }
            }
        };
    },
    logical: function () {
        return {
            nodeName: "Logic",
            nodeSize: "small",
            content: {
                lhs: {
                    label: "Left Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createAnyField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {lhs: {value: newValue}}}, "Edit", {content: {lhs: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                operator: {
                    label: "Operator",
                    value: "AND",
                    dataOutput: true,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createDropdownField(this.label, this, "value", {
                            data: ["AND", "OR", "NOT"],
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {operator: {value: newValue}}}, "Edit", {content: {operator: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                },
                rhs: {
                    label: "Right Value",
                    dataInput: true,
                    value: null,
                    contextField: function () {
                        var that = this;
                        return InputRenderer.createAnyField(this.label, this, "value", {
                            onCompleted: function () {
                                editor.diagramPanel.updateDiagramPanel();
                                editor.context.changeToNodeModelContext(editor.diagramPanel.selectedNode);
                            },
                            validateNewValue: function (newValue, oldValue) {
                                editor.context.addEdit(Edit.editNodeEdit(that.node, {content: {rhs: {value: newValue}}}, "Edit", {content: {rhs: {value: oldValue}}}).dontInitDo().setOnCompleted(function () {
                                    editor.context.changeToNodeModelContext(that.node);
                                }));
                                return newValue;
                            }
                        });
                    }
                }
            }
        };
    }
};