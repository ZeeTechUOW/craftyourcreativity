/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function Editor(opts) {
    if (!isDefined(opts))
        opts = {};
    opts.getElement = function (identifier, def) {
        if (typeof (this[identifier]) !== 'undefined' && this[identifier] !== null) {
            return this[identifier];
        }
        return def;
    };
    this.opts = opts;

    this.width = window.innerWidth;
    this.height = window.innerHeight;

    this.innerWidth = 800;
    this.innerHeight = 600;

    this.context = new Context(this);
    this.project = new Project(this.context);
    this.activeScene = this.project.getSceneByNo(0);

    this.toolbarPanel = new Toolbar(this.context);
    this.projectPanel = new ProjectPanel(this.context);
    this.sceneContentPanel = new SceneContentPanel(this.context, this.activeScene);
    this.propertiesPanel = new PropertiesPanel(this.context);
    this.sequencePanel = new SequencePanel(this.context, this.activeScene);
    this.viewport = new Viewport(this.context, this.activeScene);
    this.diagramPanel = new DiagramPanel(this.context);
    this.internalPlayer = new InternalPlayer(this.context);

    this.tabs = [];
    this.tabs.push(this.activeScene);

    this.sceneContentPanel.updateSceneContent();
    this.sequencePanel.updateSequencePanel();

    this.saveCurrentProject = function (onSave) {
        var project = this.project;

        if (project) {
            var postData = project.serialize();
            console.log(postData);

            var xhr = new XMLHttpRequest();
            var data = JSON.stringify(postData, null, "\t");
            data = projectID + "\n" + userID + "\n" + data;
            console.log(data);

            xhr.open('POST', "SaveServlet", true);
            xhr.setRequestHeader('Content-Type', 'application/json;');
            xhr.onload = function () {
                console.log(this.responseText);
            };
            xhr.send(data);
        }
    };

    this.loadProject = function () {

        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'LoadServlet?mid=' + projectID + "&uid=" + userID, true);
        xhr.onload = (function (c) {
            return function () {
                console.log(xhr.responseText);
                var json = JSON.parse(xhr.responseText);
                console.log(json);

                if (this.viewport) {
                    this.viewport.reset();
                }

                this.activeScene = null;
                c.resetActions();
                c.editor.diagramPanel.reset();

                c.editor.project = Project.deserialize(c, json);
                console.log(c.editor.project);
                c.editor.changeScene(0);
                c.editor.activeScene.changeFrame(null);

                c.editor.viewport.updateLayerOrder();
                c.editor.projectPanel.updateSceneList();
                c.editor.sequencePanel.updateSequencePanel();
                c.editor.diagramPanel.updateDiagramPanel();

                console.log("loaded");
            };
        }(this.context));
        xhr.send();
    };

    this.saveToLocal = function () {
        var project = this.project;

        if (project) {
            var data = JSON.stringify(project.serialize(), null, 4);

            var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(data);
            var dlAnchorElem = document.getElementById('downloadJSON');
            dlAnchorElem.setAttribute("href", dataStr);
            dlAnchorElem.setAttribute("download", project.projectName + ".json");
            dlAnchorElem.click();
        }
    };

    this.loadFromLocal = function () {
        $("#saveFileUpload").click();
    };

    this.loadProjectFromFile = function (file) {
        var reader = new FileReader();
        reader.onload = function (event) {

            var json = JSON.parse(event.target.result);
            var c = editor.context;

            if (this.viewport) {
                this.viewport.reset();
            }

            this.activeScene = null;
            c.resetActions();
            c.editor.diagramPanel.reset();

            c.editor.project = Project.deserialize(c, json);
            console.log(c.editor.project);
            c.editor.changeScene(0);
            c.editor.activeScene.changeFrame(null);

            c.editor.viewport.updateLayerOrder();
            c.editor.projectPanel.updateSceneList();
            c.editor.sequencePanel.updateSequencePanel();
            c.editor.diagramPanel.updateDiagramPanel();

            console.log("loaded");
        };
        reader.readAsText(file);
    };

    this.achievementData = [];
    this.achievementDataLabel = {};
    this.getAchievementData = function () {
        var xhr = new XMLHttpRequest();
        var that = this;
        
        xhr.open('GET', "GetAchievementServlet?mid=" + projectID, true);
        xhr.onload = function () {
            that.achievementDataLabel = JSON.parse(xhr.responseText);
            that.achievementData = [];
            for( var k in that.achievementDataLabel ) {
                that.achievementData.push(k);
            }
        };
        xhr.send();
        
        return this.achievementData;
    };
    
    this.getAchievementDataLabel = function (value) {
        return this.achievementDataLabel[value];
    };

    this.runCurrentProject = function () {
//        if (this.project) {
//            this.saveCurrentProject(function () {
//                var win = window.open("player.jsp", '_blank');
//                win.focus();
//            });
//        }
        this.diagramPanel.updateDiagramPanel();
        this.internalPlayer.start();
        $("#playModal").modal("show");
    };

    this.closeInternalPlayer = function () {
        this.internalPlayer.stop();
    };

    this.update = function () {
        requestAnimationFrame(this.update.bind(this));

        this.updateUI();
        this.viewport.update();
        this.sceneContentPanel.update();
        this.projectPanel.update();

        this.internalPlayer.update();
    };

    this.togglePanel = function (type) {
        if (pDrag[type] < .01) {
            pDrag[type] = pDrag["l" + type];
        } else {
            pDrag[type] = 0;
        }
        this.updateLayout();
    };

    this.togglePropertiesPanel = function () {
        this.togglePanel("prop");
    };

    this.toggleProjectPanel = function () {
        this.togglePanel("proj");
    };

    this.toggleSequencePanel = function () {
        this.togglePanel("seq");
    };

    this.addNewScene = function () {
        this.context.registerAction(new EditAction({
            name: "Add New Scene",
            focus: this
        }, function (e) {
            e.sceneNo = e.focus.project.scenes.length;
            e.focus.project.addScene("Scene");
            e.focus.diagramPanel.updateDiagramPanel();
            e.focus.projectPanel.updateSceneList();

            return true;
        }, function (e) {
            var scene = e.focus.project.getSceneByNo(e.sceneNo);
            if (scene === e.focus.activeScene) {
                if (e.focus.project.scenes.length <= 1) {
                    e.focus.activeScene = null;
                } else if (e.sceneNo > 0) {
                    e.focus.activeScene = e.focus.project.getSceneByNo(e.sceneNo - 1);
                } else {
                    e.focus.activeScene = e.focus.project.getSceneByNo(e.sceneNo + 1);
                }
            }

            e.focus.project.removeSceneByObject(scene);
            e.focus.diagramPanel.updateDiagramPanel();
            e.focus.projectPanel.updateSceneList();
            return true;
        }));
    };

    this.removeScene = function (i) {
        this.context.registerAction(new EditAction({
            name: "Add New Scene",
            focus: this,
            sceneNo: i
        }, function (e) {
            var scene = e.focus.project.getSceneByNo(e.sceneNo);
            if (scene === e.focus.activeScene) {
                if (e.focus.project.scenes.length < 1) {
                    e.focus.activeScene = null;
                } else if (e.sceneNo > 0) {
                    e.focus.changeScene(e.sceneNo - 1);
                } else {
                    e.focus.changeScene(e.sceneNo + 1);
                }
            }
            e.scene = scene;
            e.focus.project.removeSceneByNo(i);
            e.focus.diagramPanel.updateDiagramPanel();
            e.focus.projectPanel.updateSceneList();
            return true;
        }, function (e) {
            e.focus.project.addScene(e.scene);
            e.focus.diagramPanel.updateDiagramPanel();
            e.focus.projectPanel.updateSceneList();
            return true;
        }));
    };

    this.addToCurrentViewport = function (type, opts) {
        var e = this;

        if (!this.activeScene) {
            alert("No Active Scene!");
            return;
        }

        this.context.registerAction(new EditAction({
            name: "Add " + opts.name,
            focus: e,
            opts: opts,
            type: type
        }, function (e) {
            if (isDefined(e, "sprite")) {
                if (e.focus.activeScene !== e.sprite.originalScene) {
                    e.focus.changeScene(e.sprite.originalScene);
                }

                e.sprite.getSprite();

            } else {
                setDefault(e.opts, {
                    posx: 0,
                    posy: 0,
                    rotation: 0,
                    scalex: 1,
                    scaley: 1,
                    anchorx: .5,
                    anchory: .5
                });
                var sprite = null;
                switch (e.type) {
                    case Editor.QSprite:
                        sprite = new QSprite(e.focus.context, e.opts);
                        e.focus.activeScene.addEntityToScene(sprite);
                        break;

                    case Editor.Button:
                        sprite = new Button(e.focus.context, e.opts);
                        e.focus.activeScene.addEntityToScene(sprite);
                        break;

                    case Editor.QText:
                        sprite = new QText(e.focus.context, e.opts);
                        e.focus.activeScene.addEntityToScene(sprite);
                        break;
                }
                e.sprite = sprite;
                e.sprite.originalScene = e.focus.activeScene;
            }

            return true;
        }, function (e) {
            if (e.focus.activeScene !== e.sprite.originalScene) {
                e.focus.changeScene(e.sprite.originalScene);
            }

            e.focus.activeScene.removeEntityByObject(e.sprite.sprite);
            e.focus.viewport.currentSceneContainer.removeChild(e.sprite.sprite);
            e.sprite.sprite = null;

            return true;
        }));

    };

    this.fileChooserLastPath = "Assets/";
    this.fileChooserFilter = "";

    this.openFileChooser = function (title, type, funcID) {
        this.context.currentFileChooserTarget = funcID;

        this.fileChooserFilter = type;
        $("#fileChooserModalLabel").html(title);

        if (!type) {
            $("#fileChooserSelectButtonGroup").hide();
        } else {
            $("#fileChooserSelectButtonGroup").show();
        }


        this.refreshFileChooser("/Assets", function () {
            $('#fileChooserModal').modal('show');
        });
    };

    this.openRichTextEditor = function (ext) {
        $('#richTextModal').modal('show');
    };

    this.fileItemSelected = function (selectedItem) {
        if (this.context.currentFileChooserTarget && this.fileChooserFilter) {
            console.log(this.context.currentFileChooserTarget);
            this.context.propCallbacks[this.context.currentFileChooserTarget](selectedItem);
            $('#fileChooserModal').modal('hide');
        } else {
            downloadSelectedFile();
        }
    };

    this.refreshFileChooser = function (path, onComplete) {
        if (path) {
            if (path.charAt(0) === "/")
                path = path.substr(1);
            if (!path.endsWith("/"))
                path += "/";
            this.fileChooserLastPath = path;
        } else {
            path = this.fileChooserLastPath;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'DirectoryServlet?op=list&path=' + this.projectPath(path) + '&filter=' + this.fileChooserFilter, true);
        xhr.onload = (function (c, onComplete) {
            return function () {
                var json = JSON.parse(xhr.responseText);
                var html = "";
                for (var k in json.files) {
                    var resFileName = json.files[k].fileName;
                    var resPath = editor.removeProjectPath(json.files[k].resPath);
                    if (!json.files[k].isDirectory) {
                        var ext = resFileName.substr(resFileName.lastIndexOf('.') + 1);
                        console.log(resPath);
                        if (Editor.fileFilter.IMAGE.indexOf(ext.toUpperCase()) >= 0) {
                            html +=
                                    "<li name='" + resPath + "' ext='" + ext + "' class=\"list-group-item fileItem\" " +
                                    "value=\"" + resPath + "\" tabindex=\"-1\" onfocus=\"fileItemSelect(this, false);\" " +
                                    "draggable='true' ondragstart='event.dataTransfer.setData(\"Text\", \"" + resPath + "\");' " +
                                    "ondblclick=\"fileItemSelect(this, false); fileItemChosen();\">" +
                                    "<div class=\"fileItemFileContainer\">" +
                                    "<img src=\"" + editor.projectPath(resPath) + "\" class=\"img-responsive img-thumbnail fileItemImage\" draggable='false'>" +
                                    "</div>" +
                                    "<label class=\"fileItemLabel\">" + resFileName + "</label>" +
                                    "</li>";
                        } else if (Editor.fileFilter.AUDIO.indexOf(ext.toUpperCase()) >= 0) {
                            html +=
                                    "<li name='" + resPath + "' ext='" + ext + "' class=\"list-group-item fileItem\" " +
                                    "value=\"" + resPath + "\" tabindex=\"-1\" onfocus=\"fileItemSelect(this, false);\" " +
                                    "draggable='true' ondragstart='event.dataTransfer.setData(\"Text\", \"" + resPath + "\");' " +
                                    "ondblclick=\"fileItemSelect(this, false); fileItemChosen();\">" +
                                    "<div class=\"fileItemFileContainer\">" +
                                    "<img src=\"resource/audio.png\" class=\"img-responsive img-thumbnail fileItemAudio\" draggable='false'>" +
                                    "</div>" +
                                    "<label class=\"fileItemLabel\">" + resFileName + "</label>" +
                                    "</li>";
                        }

                    } else {
                        html +=
                                "<li name='" + resPath + "' ext='[FOLDER]' class=\"list-group-item fileItem\" " +
                                "tabindex=\"-1\" onfocus=\"fileItemSelect(this, true);\" " +
                                "draggable='true' ondragstart='event.dataTransfer.setData(\"Text\", \"" + resPath + "\");' " +
                                "ondragover='event.preventDefault();' ondrop='event.preventDefault(); moveFile(event.dataTransfer.getData(\"Text\"), \"" + resPath + "\");' " +
                                "ondblclick=\"refreshFileChooser('" + resPath + "/');\">" +
                                "<div class=\"fileItemFileContainer\">" +
                                "<img src=\"resource/folder.png\" class=\"img-responsive img-thumbnail fileItemFolder\" draggable='false'>" +
                                "</div>" +
                                "<label class=\"fileItemLabel\">" + resFileName + "</label>" +
                                "</li>";
                    }

                }

                $("#fileList").html(html);
                if (onComplete) {
                    onComplete();
                }
            };
        }(editor.context, onComplete));
        xhr.send();

        var paths = path.split('/');
        path = "";
        var p = "";
        for (var k in paths) {
            if (p !== "") {
                path += "/";
                p += "/";
            }
            if (paths[k]) {
                p += paths[k];
                path += "<button class='btn btn-default btn-sm breadcrumbButton' onclick='refreshFileChooser(\"" + p + "\")' ondragover='event.preventDefault();' ondrop='event.preventDefault(); moveFile(event.dataTransfer.getData(\"Text\"), \"" + p + "\");'>" + paths[k] + "</button>";
            }

        }


        $("#fileItemPath").html(path);
    };

    this.moveFile = function (from, to, onComplete) {

        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'DirectoryServlet?op=move&path=' + this.projectPath(from) + '&to=' + this.projectPath(to), true);
        if (onComplete) {
            xhr.onload = function () {
                onComplete();
            };
        }

        xhr.send();
    };

    this.renameFile = function (path, newName, onComplete) {
        if (!path) {
            path = this.fileChooserLastPath;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'DirectoryServlet?op=rename&path=' + this.projectPath(path) + '&newName=' + newName, true);
        if (onComplete) {
            xhr.onload = function () {
                onComplete();
            };
        }
        xhr.send();
    };

    this.deleteFile = function (path, onComplete) {
        if (!path) {
            path = this.fileChooserLastPath;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'DirectoryServlet?op=delete&path=' + this.projectPath(path), true);
        if (onComplete) {
            xhr.onload = function () {
                onComplete();
            };
        }
        xhr.send();
    };

    this.createNewFolder = function (path, name, onComplete) {
        if (!path) {
            path = this.fileChooserLastPath;
        }

        console.log("ANJING", path, name);

        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'DirectoryServlet?op=newFolder&path=' + this.projectPath(path) + '&newName=' + name, true);
        if (onComplete) {
            xhr.onload = function () {
                console.log("COMPLETE ", path, name);

                onComplete();
            };
        }
        xhr.send();
    };

    this.changeScene = function (sceneNo) {
        var scene = sceneNo;
        if (!isDefined(sceneNo, "sceneName")) {
            scene = this.project.scenes[sceneNo];
        }

        this.activeScene = scene;
        this.viewport.changeScene(scene);
        this.sceneContentPanel.updateSceneContent();
        this.sequencePanel.updateSequencePanel();
        this.context.changeToSceneModelContext();

        for (var k in this.project.scenes) {
            var scene = this.project.scenes[k];

            if (scene === this.activeScene) {
                $("#sceneDivThumb" + k).addClass("active");
            } else {
                $("#sceneDivThumb" + k).removeClass("active");
            }
        }
    };

    this.moveAction = function (fromCode, toCode, inBetween) {
        var froms = fromCode.split("-");
        var tos = toCode.split("-");

        if (!inBetween && froms[0] === tos[0] && froms[1] === tos[1]) {
            return;
        }
        var fromAction = this.activeScene.frames[ froms[0] ].actions[ froms[1] ][ froms[2] ];
        var willEmpty = this.activeScene.frames[ froms[0] ].actions[ froms[1] ].length <= 1 && froms[0] === tos[0];
        this.activeScene.frames[ froms[0] ].removeAction(froms[1], froms[2]);
        this.activeScene.frames[ tos[0] ].addAction(fromAction, (+tos[1] + (froms[1] < tos[1] ? (willEmpty ? -1 : 0) : 0)), inBetween);

    };

    this.resolveValue = function (value) {
        var projValues = editor.project.dataVariables;
        var sceneValues;
        if (editor.activeScene) {
            sceneValues = editor.activeScene.dataVariables;
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

    this.addNewFrame = function () {
        if (this.activeScene) {
            this.activeScene.addFrame();
        }
    };

    this.insertNewFrameAfter = function () {
        if (this.activeScene) {
            var scene = this.activeScene;

            if (this.activeScene.activeFrame) {
                var k = scene.frames.indexOf(scene.activeFrame);

                if (k >= 0) {
                    scene.addFrameAt(k + 1);
                }
            } else {
                scene.addFrameAt(0);
            }
        }
    };

    this.insertNewFrameBefore = function () {

        if (this.activeScene && this.activeScene.activeFrame) {
            var scene = this.activeScene;

            var k = scene.frames.indexOf(scene.activeFrame);

            if (k >= 0) {
                scene.addFrameAt(k);
            }
        }
    };

    this.projectPath = function (path) {
        return "module/" + projectID + "/" + path;
    };

    this.removeProjectPath = function (path) {
        if (path) {
            if (path.startsWith("/")) {
                path.substring(1);
            }

            return path.replace("module/" + projectID + "/", "");
        }
        return null;
    };

    this.selectAction = function (actionCode, skipRerender) {
        var codes = actionCode.split("-");

        var action = this.activeScene.frames[ codes[0] ].actions[ codes[1] ][ codes[2] ];
        this.activeScene.goToFrame(codes[0], skipRerender);
        this.activeScene.activeFrame.selectAction(action, skipRerender);

    };

    this.selectEntityByTarget = function (target) {
        var targets = target.split(",");
        var curEntity = this.viewport.currentSceneContainer;

        for (var k in targets) {
            curEntity = curEntity.children[targets[k]];
        }

        this.viewport.setSelected(curEntity);
    };

    this.getEntityNameByID = function (id, scene) {
        if (scene) {

            for (var j in scene.entities) {
                if (scene.entities[j].entityID === id) {
                    return scene.entities[j].name;
                }
            }
        } else {
            for (var k in this.project.scenes) {
                var scene = this.project.scenes[k];

                for (var j in scene.entities) {
                    if (scene.entities[j].entityID === id) {
                        return scene.entities[j].name;
                    }
                }
            }
        }
    };

    this.prompt = function (message, defaultValue, onComplete) {
        $("#inputPromptModalLabel").html(message);
        $("#inputPromptField").val(defaultValue);
        $("#inputPromptSubmitButton").on("click.inputPrompt", function () {
            console.log("AJAJAJA");
            if (onComplete) {
                onComplete($("#inputPromptField").val());
            }
            $("#inputPromptModal").modal("hide");
            $("#inputPromptSubmitButton").off("click.inputPrompt");
        });
        $("#inputPromptModal").modal("show");

    };

    this.updateUI = function () {
//        $("#propertiesData").height($("#propertiesRow").height() - $("#propertiesHeading").height());
        this.updateLayout();
        this.propertiesPanel.update();
    };

    this.updateLayout = function () {

        var delay = .3;
        pDrag.cproj = pDrag.cproj + (pDrag.proj - pDrag.cproj) * delay;
        pDrag.cprop = pDrag.cprop + (pDrag.prop - pDrag.cprop) * delay;
        pDrag.cseq = pDrag.cseq + (pDrag.seq - pDrag.cseq) * delay;

        var totalWidth = $("#rootContent").width();
        var projW = pDrag.cproj * totalWidth;
        var propW = pDrag.cprop * totalWidth;
        var mainW = .9999 * totalWidth - propW - projW;


        if (propW < 4 && !$("#propertiesCol").hasClass("hidden")) {
//            prompt("CCC");
            $("#propertiesCol").addClass("hidden");
        } else if (propW > 4 && $("#propertiesCol").hasClass("hidden")) {
            $("#propertiesCol").removeClass("hidden");
        }

        if (projW < 1 && !$("#projectCol").hasClass("hidden")) {
            $("#projectCol").addClass("hidden");
        } else if (projW > 1 && $("#projectCol").hasClass("hidden")) {
            $("#projectCol").removeClass("hidden");
        }

        $("#mainCol").css("width", mainW);
        $("#mainCol").css("max-width", mainW);
        $("#projectCol").css("width", projW);
        $("#projectCol").css("max-width", projW);
        $("#propertiesCol").css("width", propW);
        $("#propertiesCol").css("max-width", propW);

        var totalHeight = $("#mainCol").height() - $("#tabRow").height() - 20;
        var seqH = pDrag.cseq * totalHeight;
        var mainH = totalHeight - seqH;


        if (seqH < 1 && !$("#sequenceRow").hasClass("hidden")) {
//            $("#sequenceRow").addClass("hidden");
        } else if (seqH > 1 && $("#sequenceRow").hasClass("hidden")) {
//            $("#sequenceRow").removeClass("hidden");
        }
//        $("#mainCol").height(totalHeight);
//        $("#projectCol").height(totalHeight);
//        $("#propertiesCol").height(totalHeight);

//        $("#toolbarRow").height(toolH);
        $("#sequenceRow").height(seqH);
        $("#mainRow").height(mainH);
        $("#canvasRow").height(mainH - $("#toolRow").height() - 2);

        var h = $(window).height();
        $("#subtitle").css("font-size", (h / 40) + "px");
        $("#toolbar").css("font-size", (h / 50) + "px");
//        $("#logButton").css("font-size", (h / 30) + "px");

    };

    var pDrag = {
        proj: .2,
        prop: .3,
        tool: .2,
        seq: .3,
        lproj: .2,
        lprop: .3,
        ltool: .2,
        lseq: .3,
        cproj: .2,
        cprop: .3,
        ctool: .2,
        cseq: .3,
        dragTime: 0

    };

    var pDragDown = function (type) {
        return  function (event) {
            pDrag.ppDrag = true;
            pDrag.startX = event.screenX;
            pDrag.startY = event.screenY;
            pDrag.target = type;


            pDrag.totalHeight = $("#mainCol").height();
            pDrag.mainHeight = $("#canvasRow").height();
            pDrag.seqHeight = $("#sequenceRow").height();

            pDrag.projWidth = $("#projectCol").width();
            pDrag.propWidth = $("#propertiesCol").width();
            pDrag.mainWidth = $("#mainCol").width();
            pDrag.totalWidth = $("#rootContent").width();
            pDrag.dragTime = +new Date();
        };
    };

    var pDragUp = function (type) {
        return function (event) {
            if (+new Date() - pDrag.dragTime < 150) {

                if (pDrag[type] < .01) {
                    pDrag[type] = pDrag["l" + type];
                } else {
                    pDrag[type] = 0;
                }
            }
        };
    };

    $("#projectPanelPuller").on("mousedown", pDragDown("PROJECT")).on("mouseup", pDragUp("proj"));
    $("#propertiesPanelPuller").on("mousedown", pDragDown("PROPERTIES")).on("mouseup", pDragUp("prop"));
    $("#sequencePanelPuller").on("mousedown", pDragDown("SEQUENCE")).on("mouseup", pDragUp("seq"));

    $(window).on("mousemove", function (event) {
        if (pDrag.ppDrag) {
            pDrag.dragFlag = true;
            var deltaX = event.screenX - pDrag.startX;
            var deltaY = event.screenY - pDrag.startY;


            switch (pDrag.target) {
                case "PROJECT":
                    var tProjWidth = pDrag.projWidth + deltaX;
                    if (tProjWidth < 0 * pDrag.totalWidth) {
                        tProjWidth = 0;
                    }
                    if (tProjWidth > .3 * pDrag.totalWidth) {
                        tProjWidth = .3 * pDrag.totalWidth;
                    }

                    pDrag.proj = tProjWidth / pDrag.totalWidth;
                    break;

                case "PROPERTIES":
                    var tPropWidth = pDrag.propWidth - deltaX;
                    if (tPropWidth < 0 * pDrag.totalWidth) {
                        tPropWidth = 0;
                    }
                    if (tPropWidth > .4 * pDrag.totalWidth) {
                        tPropWidth = .4 * pDrag.totalWidth;
                    }

                    pDrag.prop = tPropWidth / pDrag.totalWidth;
                    break;

                case "SEQUENCE":
                    var tSeqHeight = pDrag.seqHeight - deltaY;
                    if (tSeqHeight > .6 * pDrag.totalHeight) {
                        tSeqHeight = .6 * pDrag.totalHeight;
                    }
                    if (tSeqHeight < 0)
                        tSeqHeight = 0;

                    pDrag.seq = tSeqHeight / pDrag.totalHeight;
                    break;

                case "TOOLBAR":
                    break;
            }
        }
    }).on("mouseup", function (event) {
        pDrag.ppDrag = false;

        if (pDrag.prop < .1)
            pDrag.prop = 0;
        if (pDrag.proj < .1)
            pDrag.proj = 0;
        if (pDrag.seq < .1)
            pDrag.seq = 0;
    });


    $('#buttonUpload').on("fileuploaded", (function (c) {
        return function (event, data, previewId, index) {
            editor.hideSmallLoader();
            if (editor.currentFileChooserTarget) {
                editor.fileItemSelected(editor.removeProjectPath(data.response.filename));
            } else {
                refreshFileChooser();
            }
        };
    }(this.context)));
    $('#buttonUpload').on("fileuploadederror", function () {
        editor.hideSmallLoader();
    });

    $('#buttonUpload').on("filebatchselected", function (event, files) {
        if (files && files.length > 0) {
            var fileName = files[0].name;
            var ext = fileName.substr(fileName.lastIndexOf('.') + 1);

            if (fileName && fileName.match(/[^A-Za-z0-9 .(),:-]/g)) {
                return;
            }

            if (!editor.fileChooserFilter || Editor.fileFilter[editor.fileChooserFilter].indexOf(ext.toUpperCase()) >= 0) {
                $("#buttonUpload").fileinput("upload");
                editor.showSmallLoader();
            } else {
                return;
            }
        }
    });

    $("#buttonUpload").fileinput({
        showCaption: false,
        browseClass: "hidden",
        progressClass: "hidden",
        cancelClass: "hidden",
        showPreview: false,
        showUpload: false,
        showRemove: false,
        uploadAsync: true,
        uploadUrl: "UploadServlet",
        uploadExtraData: function () {
            return {
                userID: "aaaa",
                path: editor.projectPath(editor.fileChooserLastPath)
            };
        }
    });

    $('#saveFileUpload').on("filebatchselected", function (event, files) {
        if (files && files.length > 0) {
            var fileName = files[0].name;
            var ext = fileName.substr(fileName.lastIndexOf('.') + 1);

            if (fileName && fileName.match(/[^A-Za-z0-9 .(),:-]/g)) {
                return;
            }

            if (ext.toUpperCase() === "JSON") {
                editor.loadProjectFromFile(files[0]);
            } else {
                return;
            }
        }
    }).fileinput({
        showCaption: false,
        browseClass: "hidden",
        progressClass: "hidden",
        cancelClass: "hidden",
        showPreview: false,
        showUpload: false,
        showRemove: false,
        uploadAsync: true
    });

    this.hideLoader = function () {
        $("#loader").fadeOut("slow");
        $("#loaderWrapper").fadeOut("slow");
    };
    this.showLoader = function () {
        $("#loader").fadeIn("fast");
        $("#loaderWrapper").fadeIn("fast");
    };
    this.hideSmallLoader = function () {
        $("#smallLoader").hide();
        $("#smallLoaderWrapper").hide();
    };
    this.showSmallLoader = function () {
        $("#smallLoader").show();
        $("#smallLoaderWrapper").show();
    };

    $(document).on('show.bs.modal', '.modal', function () {
        var zIndex = 40 + (10 * $('.modal:visible').length);
        $(this).css('z-index', zIndex);
        setTimeout(function () {
            $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
        }, 0);
    });

    $('#playModal').on('hidden.bs.modal', function () {
        editor.closeInternalPlayer();
    });
    
    this.getAchievementData();

    this.projectPanel.updateSceneList();
    this.update();
}

Editor.QSprite = 1;
Editor.Button = 2;
Editor.QText = 3;

Editor.fileFilter = {
    IMAGE: ["JPG", "PNG"],
    AUDIO: ["WAV", "MP3"]
};