/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Deni Barasena
 */

function DiagramPanel(context) {
    this.context = context;
    this.dom;
    this.cameraDom;
    this.nodeDom;
    this.svgDom;

    this.nodes = [];

    this.selectedNode = null;

    this.init = function () {
        this.dom = document.getElementById("diagram");
        this.cameraDom = document.getElementById("diagramCamera");
        this.nodeDom = document.getElementById("diagramNodes");
        this.svgDom = document.getElementById("svgAnchor");

        this.nodes.push(new DiagramNode(this.context, {
            x: 50, y: 50, nodeType: "start"
        }));
        this.nodes.push(new DiagramNode(this.context, {
            x: 200, y: 100, nodeType: "playScene"
        }));
        this.nodes.push(new DiagramNode(this.context, {
            x: 450, y: 60, nodeType: "end"
        }));
        this.nodes[0].flowOutput._def = this.nodes[1].nodeID;
        this.nodes[1].flowOutput._def = this.nodes[2].nodeID;

        this.updateDiagramPanel();
    };

    this.reset = function () {
        this.setSelected(null);
        this.nodes = [];
        this.updateDiagramPanel();
    };

    this.addNode = function (type) {
        var canoffset = $(this.cameraDom).offset();
        var canzoom = parseFloat($(this.cameraDom).css("zoom"));

        var x = 500 + document.body.scrollLeft + document.documentElement.scrollLeft - Math.floor(canoffset.left * canzoom);
        var y = 500 + document.body.scrollTop + document.documentElement.scrollTop - Math.floor(canoffset.top * canzoom) + 1;



        var node = new DiagramNode(this.context, {
            x: x, y: y, nodeType: type
        });

        this.context.addEdit(Edit.addNodeEdit(node));
    };

    this.getNodeById = function (id) {
        for (var k in this.nodes) {
            if (this.nodes[k].nodeID === id)
                return this.nodes[k];
        }
    };

    this.updateDiagramPanel = function () {

        var res = "";
        for (var k in this.nodes) {
            var n = this.nodes[k];
            if (n.updateUI)
                n.updateUI();
            res += n.print();
        }

        this.nodeDom.innerHTML = res;

        this.updateDiagramConnections();

    };

    this.updateDiagramConnections = function (x, y) {
        var res = "";
        for (var k in this.nodes) {
            var node = this.nodes[k];
            var fromNode = node;

            for (var j in node.flowOutput) {

                var toNode = this.getNodeById(node.flowOutput[j]);

                if (this.dragAnchor && fromNode === this.dragAnchor.draggedNodeFrom && this.dragAnchor.dataTarget === j && this.dragAnchor.connectionType === "FLOW" && x && y) {
                    var from = fromNode.getFlowOutputPos(j, this.zoomLevel);

                    var midFromX = from.x + (x - from.x) * .5 * (x > from.x ? 1 : -1);
                    var midToX = x + (from.x - x) * .5 * (x > from.x ? 1 : -1);

                    res += "<path stroke=\"#8e9e8e\" stroke-width=\"4\" fill=\"none\" d=\"M" + from.x + "," + from.y + " C" + midFromX + "," + from.y + " " + midToX + "," + y + " " + x + "," + y + "\"></path>";

                } else if (toNode) {
                    var from = fromNode.getFlowOutputPos(j, this.zoomLevel);
                    var to = toNode.getFlowInputPos(this.zoomLevel);

                    var midFromX = from.x + (to.x - from.x) * .5 * (to.x > from.x ? 1 : -1);
                    var midToX = to.x + (from.x - to.x) * .5 * (to.x > from.x ? 1 : -1);

                    res += "<path id='fp" + node.nodeID + "0" + j + "' qid='" + node.nodeID + "' qvarname='" + j + "' onmousedown='startFlowDrag(this, event, \"FLOW\");' stroke=\"#8e9e8e\" stroke-width=\"4\" fill=\"none\" d=\"M" + from.x + "," + from.y + " C" + midFromX + "," + from.y + " " + midToX + "," + to.y + " " + to.x + "," + to.y + "\"></path>";
                }
            }

            for (var j in node.content) {
                var c = node.content[j];

                var toStr = c.dataInput;

                if (this.dragAnchor && fromNode === this.dragAnchor.draggedNodeFrom && this.dragAnchor.dataTarget === j && this.dragAnchor.connectionType === "DATA" && x && y) {
                    var from = fromNode.getFlowDataOutputPos(j, this.zoomLevel);

                    var midFromX = from.x + (x - from.x) * .5 * (x > from.x ? 1 : -1);
                    var midToX = x + (from.x - x) * .5 * (x > from.x ? 1 : -1);

                    res += "<path stroke=\"#8e9e8e\" stroke-width=\"4\" fill=\"none\" d=\"M" + from.x + "," + from.y + " C" + midFromX + "," + from.y + " " + midToX + "," + y + " " + x + "," + y + "\"></path>";

                }
                if (toStr && toStr.split) {
                    var data = toStr.split("|");

                    if (data.length > 1) {
                        var from = this.getNodeById(parseInt(data[0]));
                        if (from) {
                            from = from.getFlowDataOutputPos(data[1], this.zoomLevel);
                            var to = fromNode.getFlowDataInputPos(j, this.zoomLevel);

                            var midFromX = from.x + (to.x - from.x) * .5 * (to.x > from.x ? 1 : -1);
                            var midToX = to.x + (from.x - to.x) * .5 * (to.x > from.x ? 1 : -1);

                            res += "<path id='fdp" + node.nodeID + "0" + j + "' qid='" + data[0] + "' qrid='" + node.nodeID + "' qvarname='" + j + "' onmousedown='startFlowDrag(this, event, \"DATA\");' stroke=\"#8e9e8e\" stroke-width=\"4\" fill=\"none\" d=\"M" + from.x + "," + from.y + " C" + midFromX + "," + from.y + " " + midToX + "," + to.y + " " + to.x + "," + to.y + "\"></path>";
                        } else {
                            c.dataInput = true;
                        }
                    }
                }
            }
        }

        this.svgDom.innerHTML = "<svg id='diagramSVG'>" + res + "</svg>";
    };

    this.setSelected = function (node, skipRerender) {
        if (this.selectedNode) {
            if (node === this.selectedNode) {
                $("#Node" + this.selectedNode.nodeID).addClass("active");
                this.context.changeToNodeModelContext(this.selectedNode);
                return;
            }

            $("#Node" + this.selectedNode.nodeID).removeClass("active");
        }

        this.selectedNode = node;

        if (this.selectedNode) {
            $("#deleteDiagramTool").prop("disabled", false);
            $("#Node" + this.selectedNode.nodeID).addClass("active");
            this.context.changeToNodeModelContext(this.selectedNode);
        } else {
            $("#deleteDiagramTool").prop("disabled", true);
            if (!skipRerender)
                this.context.changeToSceneModelContext();
        }
    };

    this.update = function () {

    };
    this.init();

    this.mode = "";
    this.dragAnchor = {};
    this.zoomLevel = 1;

    this.selectDiagramNode = function (elem, event) {
        if (event.button !== 0)
            return;

        var id = parseInt(elem.id.replace("Node", ""));
        var node = this.getNodeById(id);

        this.setSelected(node);
        event.stopPropagation();
    };
    this.startDiagramNodeDrag = function (elem, event) {
        if (event.button !== 0)
            return;

        var id = parseInt(elem.id.replace("headNode", ""));
        var node = this.getNodeById(id);

        if (node) {
            this.dragAnchor.draggedNode = node;
            this.mode = "DRAG_NODE";
            this.setSelected(node);

            that.dragAnchor.x = event.clientX;
            that.dragAnchor.y = event.clientY;

            that.dragAnchor.nodeX = this.dragAnchor.draggedNode.x;
            that.dragAnchor.nodeY = this.dragAnchor.draggedNode.y;

            event.stopPropagation();
        }
    };

    this.startConnectionDrag = function (node, dataTarget, connectionType, startX, startY, event) {
        if (event.button !== 0)
            return;

        if (node) {
            this.mode = "DRAG_CONNECTION";
            this.setSelected(null);

            that.dragAnchor.draggedNodeFrom = node;
            that.dragAnchor.dataTarget = dataTarget;
            that.dragAnchor.connectionType = connectionType;

            that.dragAnchor.x = event.clientX;
            that.dragAnchor.y = event.clientY;

            that.dragAnchor.nodeX = startX;
            that.dragAnchor.nodeY = startY;

            event.stopPropagation();
        }
    };
    this.startFlowDrag = function (elem, event, type) {
        if (event.button !== 0)
            return;

        var id = parseInt(elem.getAttribute("qid"));
        var dataTarget = elem.getAttribute("qvarname");

        var node = this.getNodeById(id);

        if (node) {
            var canoffset = $(this.cameraDom).offset();
            var canzoom = this.zoomLevel;

            var x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - Math.floor(canoffset.left * canzoom);
            var y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - Math.floor(canoffset.top * canzoom) + 1;

            if (type === "DATA") {
                var knode = this.getNodeById(parseInt(elem.getAttribute("qrid")));
                if (knode) {
                    var dt = dataTarget;

                    if (knode.content[dt].dataInput) {
                        dataTarget = knode.content[dt].dataInput.split("|")[1];
                    }

                    var stateData = {content: {}};
                    stateData.content[dt] = {};
                    stateData.content[dt].dataInput = knode.content[dt].dataInput;
                    this.dragAnchor.otherStateData = stateData;
                    this.dragAnchor.otherStateDataTarget = knode;

                    knode.content[dt].dataInput = true;
                }
            }

            this.startConnectionDrag(node, dataTarget, type, x / canzoom, y / canzoom, event);
        }
    };
    this.startFlowInputDrag = function (elem, event, type) {
        if (event.button !== 0)
            return;

        var id = parseInt(elem.getAttribute("qid"));
        var dataTarget = elem.getAttribute("qvarname");
        var node = this.getNodeById(id);


        if (node) {
            var fromNode;
            var p;

            if (type === "FLOW") {
                p = node.getFlowInputPos(dataTarget, this.zoomLevel);
                for (var k in this.nodes) {
                    for (var j in this.nodes[k].flowOutput) {
                        if (this.nodes[k].flowOutput[j] === id) {
                            fromNode = this.nodes[k];
                            dataTarget = j;
                        }
                    }
                }

            } else if (type === "DATA") {

                if (node.content[dataTarget].dataInput && node.content[dataTarget].dataInput.split) {
                    var data = node.content[dataTarget].dataInput.split("|");

                    if (data && data.length > 1) {
                        fromNode = this.getNodeById(parseInt(data[0]));


                        var stateData = {content: {}};
                        stateData.content[dataTarget] = {};
                        stateData.content[dataTarget].dataInput = node.content[dataTarget].dataInput;
                        this.dragAnchor.otherStateData = stateData;
                        this.dragAnchor.otherStateDataTarget = node;

                        node.content[dataTarget].dataInput = true;

                        if (fromNode) {
                            p = node.getFlowDataInputPos(dataTarget, this.zoomLevel);
                        }
                        dataTarget = data[1];
                    }
                }
            }

            if (p) {
                this.startConnectionDrag(fromNode, dataTarget, type, p.x, p.y, event);
            }
        }
    };
    this.startFlowOutputDrag = function (elem, event, type) {
        if (event.button !== 0)
            return;

        var id = parseInt(elem.getAttribute("qid"));
        var dataTarget = elem.getAttribute("qvarname");
        var node = this.getNodeById(id);

        if (node) {
            var p;
            if (type === "FLOW") {
                p = node.getFlowOutputPos(dataTarget, this.zoomLevel);
            } else if (type === "DATA") {
                p = node.getFlowDataOutputPos(dataTarget, this.zoomLevel);
            }

            this.startConnectionDrag(node, dataTarget, type, p.x, p.y, event);
        }
    };
    this.endFlowDrag = function (elem, event, type) {
        if (event.button !== 0)
            return;

        var id = parseInt(elem.getAttribute("qid"));
        var dataTarget = elem.getAttribute("qvarname");
        var node = this.getNodeById(id);

        if (node && this.mode === "DRAG_CONNECTION") {
            if (this.dragAnchor.connectionType === "FLOW" && type === "FLOW") {
//                this.dragAnchor.draggedNodeFrom.flowOutput[ this.dragAnchor.dataTarget ] = node.nodeID;

                var stateData = {flowOutput: {}};
                stateData.flowOutput[this.dragAnchor.dataTarget] = node.nodeID;
                this.context.addEdit(Edit.editNodeEdit(this.dragAnchor.draggedNodeFrom, stateData, "Flow"));

            } else if (this.dragAnchor.connectionType === "DATA" && type === "DATA") {
                if (node !== this.dragAnchor.draggedNodeFrom) {
                    var value = this.dragAnchor.draggedNodeFrom.nodeID + "|" + this.dragAnchor.dataTarget;
//                    node.content[dataTarget].dataInput = value;

                    if (this.dragAnchor.otherStateDataTarget) {
                        var stateData = JSON.parse(JSON.stringify(that.dragAnchor.otherStateData));
                        for (var k in stateData.content) {
                            stateData.content[k].dataInput = true;
                        }
                        
                        var edit2 = Edit.editNodeEdit(this.dragAnchor.otherStateDataTarget, stateData, "Flow Data", this.dragAnchor.otherStateData);
                        
                        stateData = {content: {}};
                        stateData.content[dataTarget] = {};
                        stateData.content[dataTarget].dataInput = value;
                        this.context.addEdit(Edit.editNodeEdit(node, stateData, "Flow Data").combine(edit2));
                        
                        this.dragAnchor.otherStateData = null;
                        this.dragAnchor.otherStateDataTarget = null;
                    } else {
                        var stateData = {content: {}};
                        stateData.content[dataTarget] = {};
                        stateData.content[dataTarget].dataInput = value;
                        this.context.addEdit(Edit.editNodeEdit(node, stateData, "Flow Data"));

                    }

                }
            } else {
                $.notify("Mismatched Node Connection", {position: "top right", className: "error"});
            }

            that.mode = "";
            that.dragAnchor.draggedNodeFrom = null;
            that.dragAnchor.connectionType = null;
            that.dragAnchor.dataTarget = null;
            that.updateDiagramConnections();

            event.stopPropagation();
        }
    };

    this.addNodeToDiagram = function (node) {
        this.nodes.push(node);
        this.updateDiagramPanel();
    };

    this.deleteNodeFromDiagram = function (node) {
        if (node.nodeName !== "Start ") {
            this.nodes.splice(this.nodes.indexOf(node), 1);
            this.updateDiagramPanel();
        }
    };

    this.addClonedToDiagram = function (node, label) {
        var newNode = DiagramNode.deserialize(this.context, JSON.parse(JSON.stringify(node.serialize())));
        newNode.nodeID = uid();

        var canoffset = $(this.cameraDom).offset();
        var canzoom = this.zoomLevel;

        newNode.x = 500 + document.body.scrollLeft + document.documentElement.scrollLeft - Math.floor(canoffset.left * canzoom);
        newNode.y = 500 + document.body.scrollTop + document.documentElement.scrollTop - Math.floor(canoffset.top * canzoom) + 1;

        this.context.addEdit(Edit.addNodeEdit(newNode).changeName(function () {
            return label + " " + this.node.nodeName;
        }));
        this.addNodeToDiagram(newNode);
    };

    this.deleteSelectedNode = function () {
        if (this.selectedNode) {
            this.context.addEdit(Edit.deleteNodeEdit(this.selectedNode));
            this.setSelected(null);
        }
    };

    var that = this;
    this.dom.addEventListener("mousedown", function (event) {
        that.setSelected(null);

        if (event.button === 0) {

        } else if (event.button === 1) {
            that.mode = "DRAG_CAMERA";

            that.dragAnchor.x = event.clientX;
            that.dragAnchor.y = event.clientY;

            that.dragAnchor.camX = parseFloat($(that.cameraDom).css("left"));
            that.dragAnchor.camY = parseFloat($(that.cameraDom).css("top"));

            if (isNaN(that.dragAnchor.camX)) {
                that.dragAnchor.camX = 0;
            }
            if (isNaN(that.dragAnchor.camY)) {
                that.dragAnchor.camY = 0;
            }

        }
    });
    this.dom.addEventListener(/Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel", function (event) {
        var delta = -(event.wheelDelta || -event.detail * 20) * 1.0 / 1000;

        var z = parseFloat($(that.cameraDom).css("zoom"));
        if (z > 10) {
            z /= 100;
        } else if (isNaN(z)) {
            z = 1;
        }

        var zoom = z - delta;


        if (zoom > 1.25) {
            zoom = 1.25;
            delta = z - zoom;
        }

        if (zoom < .4) {
            zoom = .4;
            delta = z - zoom;
        }

        that.zoomLevel = zoom;
        $(that.cameraDom).css("zoom", zoom);
        if (/Firefox/i.test(navigator.userAgent)) {
            $(that.cameraDom).css("left", parseFloat($(that.cameraDom).css("left")) + (parseFloat($(that.cameraDom).width()) * delta / 2) + "px");
            $(that.cameraDom).css("top", parseFloat($(that.cameraDom).css("top")) + (parseFloat($(that.cameraDom).height()) * delta / 2) + "px");
        } else {
            $(that.cameraDom).css("left", parseFloat($(that.cameraDom).css("left")) + (parseFloat($(that.cameraDom).width()) * delta / 2 / z) + "px");
            $(that.cameraDom).css("top", parseFloat($(that.cameraDom).css("top")) + (parseFloat($(that.cameraDom).height()) * delta / 2 / z) + "px");
        }

        that.updateDiagramPanel();
    });
    document.addEventListener("mousemove", function (event) {
        if (that.mode === "DRAG_CAMERA") {
            if (/Firefox/i.test(navigator.userAgent) || isIE()) {
                $(that.cameraDom).css("left", that.dragAnchor.camX + (event.clientX - that.dragAnchor.x) + "px");
                $(that.cameraDom).css("top", that.dragAnchor.camY + (event.clientY - that.dragAnchor.y) + "px");
            } else {
                $(that.cameraDom).css("left", that.dragAnchor.camX + (event.clientX - that.dragAnchor.x) / that.zoomLevel + "px");
                $(that.cameraDom).css("top", that.dragAnchor.camY + (event.clientY - that.dragAnchor.y) / that.zoomLevel + "px");
            }

            event.stopPropagation();
        } else if (that.mode === "DRAG_NODE") {
            var xRes = that.dragAnchor.nodeX + (event.clientX - that.dragAnchor.x) / that.zoomLevel;
            var yRes = that.dragAnchor.nodeY + (event.clientY - that.dragAnchor.y) / that.zoomLevel;

            that.dragAnchor.draggedNode.x = xRes;
            that.dragAnchor.draggedNode.y = yRes;

            $("#Node" + that.dragAnchor.draggedNode.nodeID).css("left", xRes + "px");
            $("#Node" + that.dragAnchor.draggedNode.nodeID).css("top", yRes + "px");

            that.updateDiagramConnections();
            event.stopPropagation();
        } else if (that.mode === "DRAG_CONNECTION") {
            var xRes = that.dragAnchor.nodeX + (event.clientX - that.dragAnchor.x) / that.zoomLevel;
            var yRes = that.dragAnchor.nodeY + (event.clientY - that.dragAnchor.y) / that.zoomLevel;

            that.updateDiagramConnections(xRes, yRes);
            event.stopPropagation();
        }
    });
    document.addEventListener("mouseup", function (event) {
        if (that.mode === "DRAG_CONNECTION") {
            if (that.dragAnchor.connectionType === "FLOW") {
                if (that.dragAnchor.draggedNodeFrom.flowOutput[that.dragAnchor.dataTarget] !== true) {
                    var stateData = {flowOutput: {}};
                    stateData.flowOutput[that.dragAnchor.dataTarget] = true;
                    that.context.addEdit(Edit.editNodeEdit(that.dragAnchor.draggedNodeFrom, stateData, "Flow"));
                }
            } else if (that.dragAnchor.connectionType === "DATA") {

                if (that.dragAnchor.otherStateDataTarget) {
                    var stateData = JSON.parse(JSON.stringify(that.dragAnchor.otherStateData));
                    for (var k in stateData.content) {
                        stateData.content[k].dataInput = true;
                    }
                    that.context.addEdit(Edit.editNodeEdit(that.dragAnchor.otherStateDataTarget, stateData, "Flow Data", that.dragAnchor.otherStateData));
                }
            }

            that.dragAnchor.otherStateData = null;
            that.dragAnchor.otherStateDataTarget = null;
            that.dragAnchor.draggedNodeFrom = null;
            that.dragAnchor.connectionType = null;
            that.dragAnchor.dataTarget = null;
            that.updateDiagramConnections();
        } else if (that.mode === "DRAG_NODE") {
            that.context.addEdit(Edit.editNodeEdit(that.dragAnchor.draggedNode, {
                x: that.dragAnchor.draggedNode.x,
                y: that.dragAnchor.draggedNode.y
            }, "Move", {
                x: that.dragAnchor.nodeX,
                y: that.dragAnchor.nodeY
            }));
        }

        that.mode = "";
        that.dragAnchor.draggedNode = null;
    });
    document.addEventListener("keydown", function (event) {
        if (event.keyCode === 46 && that.selectedNode) {
            that.deleteSelectedNode();
            event.stopPropagation();
        }
    });
}