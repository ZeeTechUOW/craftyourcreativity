/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function ProjectPanel(context) {
    this.context = context;

    this.update = function () {
        $("#scenePanel").height($("#scenesRow").height() - $("#scenePanelHeading").outerHeight());
        for (var k in this.context.editor.project.scenes) {
            var width = $("#sceneDiv" + k).width() - $("#sceneDivNo" + k).outerWidth() - 20;
            $("#sceneDivThumb" + k).width(width);
            $("#sceneDivThumb" + k).height(width / this.context.editor.innerWidth * this.context.editor.innerHeight);
            
            $("#sceneThumbnailCanvas" + k).width(width);
            $("#sceneThumbnailCanvas" + k).height(width / this.context.editor.innerWidth * this.context.editor.innerHeight);
            
            this.context.editor.project.scenes[k].renderThumbnail();
        }
        
    };

    this.updateSceneList = function () {
        var p = this;
        
        var elem = $("#scenePanel");

        var content = "";

        for (var k in p.context.editor.project.scenes) {
            var b =  p.context.editor.project.scenes[k] === p.context.editor.activeScene;
            console.log(k + " | " + b);
            content +=
                    "                                <div class='row sceneNameDiv'><div id='sceneDivName" + k + "' class=\"sceneDiv\">\n" +
                    "                                    " + ( parseInt(k) + 1 ) + "." + p.context.editor.project.scenes[k].sceneName + "\n" +
                    "                                </div></div>\n" +
                    "                                <div class='row noMargin'><div id='sceneDiv" + k + "' class=\"sceneDiv\">\n" +
                    "                                    <div id='sceneDivNo" + k + "' style=\"display: none\">\n" +
                    "                                        " + (1 + parseInt(k)) + "\n" +
                    "                                    </div>\n" +
                    "                                    <div id='sceneDivThumb" + k + "' class =\"sceneThumbGroup" + (b?" active": "") + " \" onclick=\"changeScene(" + k + ");\">\n" +
                    "                                        <canvas id=\"sceneThumbnailCanvas" + k + "\" onload=\"\">\n" +
                    "                                        </canvas>\n" +
                    "                                        <button class=\"btn btn-default btn-xs deleteSceneButton\" onclick=\"deleteScene(this, " + k + "); event.stopPropagation()\">\n" +
                    "                                            <span class='glyphicon deleteIcon'></span>\n" +
                    "                                        </button>\n" +
                    "                                    </div>\n" +
                    "                                </div></div>";
            
        }
        
        

        content +=
                "<div class='row noMargin'><button id=\"addSceneButton\" class=\"btn-lg btn-default\" onclick=\"addScene(this)\">" +
                "Add Scene" +
                "</button></div>";
        
        var s = elem.scrollTop();
        elem.html(content);
        elem.scrollTop(s);

        for (var k in p.context.editor.project.scenes) {
            var canvas = document.getElementById("sceneThumbnailCanvas" + k);
            canvas.style["pointer-events"] = "none";
            
            p.context.editor.project.scenes[k].updateThumbnailRenderer( canvas );
        };
    };
    
}