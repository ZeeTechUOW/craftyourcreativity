/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Deni Barasena
 */

function SequencePanel(context) {
    this.context = context;
    this.dom = document.getElementById("sequenceRow");

    this.updateSequencePanel = function () {
        var activeScene = this.context.editor.activeScene;
        
        if(!activeScene) {
            this.dom.innerHTML = "No Active Scene";
            return;
        }
        var activeFrame = activeScene.activeFrame;
        var activeAction = (activeFrame ? activeFrame.activeAction : null);


        var res = "<ul class='list-inline sequenceList'>";

        res += "<li class='frameListItem" + (!activeFrame ? "Active" : "") + "' style='padding-right: 15px'>" +
                "   <div class='frameGroup' style='text-align: left'>" +
                "       <button class='btn btn-md frameButton " + (!activeFrame ? "active" : "") + "' onclick='editor.activeScene.goToFrame(-1);'>" +
                "           Start" +
                "       </button>" +
                "   </div>" +
                "</li>";

        var n = 1;
        for (var k in activeScene.frames) {
            var frame = activeScene.frames[k];
            var b = (frame === activeFrame ? "active" : "") && !activeAction;
            var isCollapsed = frame.isCollapsed;

            res += "<li class='frameListItem" + (b ? "Active" : "") + "' style='padding-right: 15px'>" +
                    "   <div class='frameGroup' style='text-align: left'>" +
                    "       <button class='btn btn-md frameButton " + (b ? "active" : "") + "' onclick='editor.activeScene.goToFrame(" + k + ");' ondragover='event.preventDefault();' ondrop='moveAction(event.dataTransfer.getData(\"Text\"), \"" + k + "-0\", true ); event.preventDefault(); event.stopPropagation();'>" +
                    n +
                    "       </button>";



            for (var j = 0; j < frame.actions.length; j++) {
                for (var l = 0; frame.actions[j] && l < frame.actions[j].length; l++) {
                    var action = frame.actions[j][l];

                    if (action.isEntityAction && !action.getTargetID()) {
                        frame.removeActionByObject(action, true);
                        j--;
                        l--;
                    }
                }
            }

            if (frame.actions.length >= 1) {
                res += "       <button class='btn btn-sm frameButton actionGroupCollapseButton' onclick='toggleCollapseFrame(" + k + ");'><span class='" + (isCollapsed ? "icon-plus3" : "icon-minus3") + "'>" +
                        "       </span></button>";
            }

            if (!isCollapsed) {
                for (var j = 0; j < frame.actions.length; j++) {
                    var actionGroupCode = k + "-" + j;
                    res += "<div id='Action" + actionGroupCode + "' class='actionGroup" + (b ? "Active" : "") + "' style='" + (j === 0 ? "margin-left: -15px" : "") + "' ondragover='event.preventDefault();' ondrop='moveAction(event.dataTransfer.getData(\"Text\"), \"" + actionGroupCode + "\" ); event.preventDefault(); '>";
                    res += "<div class='leftOfActionGroup' ondragover='event.preventDefault();' ondrop='moveAction(event.dataTransfer.getData(\"Text\"), \"" + actionGroupCode + "\", true ); event.stopPropagation(); event.preventDefault(); '></div>";
                    res += "<div class='rightOfActionGroup' ondragover='event.preventDefault();' ondrop='moveAction(event.dataTransfer.getData(\"Text\"), \"" + k + "-" + (j + 1) + "\", true ); event.stopPropagation(); event.preventDefault(); '></div><ul class='list-unstyled'>";
                    for (var l = 0; l < frame.actions[j].length; l++) {
                        var actionCode = k + "-" + j + "-" + l;
                        var action = frame.actions[j][l];


                        var c = b || activeAction === action;
                        var ap;

                        if (isIEorEDGE()) {
                            ap = "<li id='Action" + actionCode + "' onclick='actionClicked(this);' class = 'actionBox" + (c ? "Active" : "") + "' style='" + (l === frame.actions[j].length - 1 ? "margin-bottom: 0px" : "") + "' draggable='true' ondragstart='event.dataTransfer.setData(\"Text\", \"" + actionCode + "\");'>" +
                                    action.printAction() +
                                    "</li>";
                        } else {
                            ap = "<li id='Action" + actionCode + "' onmouseup='actionClicked(this, true);' class = 'actionBox" + (c ? "Active" : "") + "' style='" + (l === frame.actions[j].length - 1 ? "margin-bottom: 0px" : "") + "' draggable='true' ondragstart='event.dataTransfer.setData(\"Text\", \"" + actionCode + "\");'>" +
                                    action.printAction() +
                                    "</li>";
                        }

                        res += ap;
                    }
                    res += "</ul></div>";
                }
            }
            res += "</div></li>";

            n++;
        }

        res += "<li class='frameListItemHead'><div class='frameGroup'><button class='btn btn-md frameButton' onclick='editor.addNewFrame();'><span class='icon-plus3'></span></button></div></li>";

        res += "</ul>";
        this.dom.innerHTML = res;
    }
    ;
}