/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function SceneContentPanel(context) {
    this.dom = $("#sceneContentList");
    this.context = context;

    this.update = function () {
        $("#sceneContentData").height($("#sceneContentRow").height() - $("#sceneContentHeading").outerHeight());
    };

    this.updateSceneContent = function () {
        var c = this.context;
        var d = "";
        
        var sceneName = "No Active Scene";
        if( c.editor.activeScene ) sceneName = c.editor.activeScene.sceneName;
        document.getElementById("sceneContentName").innerHTML = sceneName;
        
        
        var cam = c.editor.viewport.currentSceneContainer;
        var selectedShape = c.editor.viewport.selectedShape;
        for (var i = 1; i < cam.children.length; i++) {
            var item = cam.children[cam.children.length - i];
            item.zIndex = cam.children.length - i;

            var clickTarget = cam.children.length - i;
            if (selectedShape === item) {
                d += "<li class='list-group-item activee' clickTarget='" + clickTarget + "' onclick='sceneContentClicked(this)'><span class='bold'>" + item.name + "</span></li>";
            } else {
                d += "<li class='list-group-item' clickTarget='" + clickTarget + "' onclick='sceneContentClicked(this)'>" + item.name + "</li>";
            }
        }
        
        var s = this.dom.scrollTop();
        this.dom.html(d);
        this.dom.scrollTop(s);
    };

    this.sortable = Sortable.create(document.getElementById('sceneContentList'), {
        animation: 200,
        ghostClass: "sceneContentGhost",
        onUpdate: (function (context) {
            return function (evt) {
                var cam = context.editor.viewport.currentSceneContainer;
                
                var from = evt.oldIndex + 1;
                var to = evt.newIndex + (evt.oldIndex > evt.newIndex ? .5 : 1.5);

                var length = cam.children.length;
                from = length - from;
                to = length - to;
                
                context.addEdit(Edit.reorderEntityEdit(cam.children[from].model, context.editor.activeScene, to, from + (evt.oldIndex < evt.newIndex ? .5 : -.5)));
            };
        }(this.context))
    });
}