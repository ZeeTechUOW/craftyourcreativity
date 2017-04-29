/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Context(editor) {
    this.resources = {};
    this.actions = [];
    this.redoActions = [];

    this.propertiesContext = null;
    this.propCallbacks = [];
    this.editor = editor;

    this.getResource = function (resourceName) {
        var c = this;

        if (!isDefined(c.resources, resourceName)) {
            c.resources[resourceName] = PIXI.Texture.fromImage(editor.projectPath(resourceName));
        }
        return c.resources[resourceName];
    };

    this.onDragStart = (function (c) {
        return function (event) {
            var mode = c.editor.viewport.mode;
            var selectedShape = c.editor.viewport.selectedShape;

            if (mode !== 0)
                return;
            if (selectedShape)
                selectedShape.alpha = 1;
            this.data = event.data;

            var lastPos = event.data.getLocalPosition(this.parent);
            this.originalPosX = this.position.x;
            this.originalPosY = this.position.y;
            this.anchorPosX = this.position.x - lastPos.x;
            this.anchorPosY = this.position.y - lastPos.y;
//            this.alpha = 0.5;
            this.dragging = true;

            c.editor.viewport.setSelected(this);
            c.editor.viewport.updateLayerOrder();

        };
    }(this));

    this.onDragEnd = function () {
        if (this.position.x !== this.originalPosX && this.position.y !== this.originalPosY) {
            this.model.context.registerAction(new EditAction({
                name: "Move " + this.name,
                focus: this.model,
                valuex: this.position.x,
                valuey: this.position.y,
                value2x: this.originalPosX,
                value2y: this.originalPosY
            }, function (e) {
//                console.log("Ca");
                e.focus.sprite.setPos(e.valuex, e.valuey);
                return true;
            }, function (e) {
//                console.log("Cb");
                e.focus.sprite.setPos(e.value2x, e.value2y);
                return true;
            }));
        }

        this.dragging = false;
        this.data = null;
    };

    this.onDragMove = function () {
        if (this.dragging) {
            var newPosition = this.data.getLocalPosition(this.parent);
//            console.log("D");
            this.setPosX(Math.floor(this.anchorPosX + newPosition.x));
            this.setPosY(Math.floor(this.anchorPosY + newPosition.y));
        }
    };

    this.imageChosen = function (url, i) {
        if (!i)
            i = 0;

        var name = url.split("/").pop();

        var http = new XMLHttpRequest();

        http.open('HEAD', editor.projectPath(url), true);
        http.onload = function () {
            if (http.status !== 404) {
                console.log("SUCCESS i=" + i);
                editor.addToCurrentViewport(Editor.QSprite, {
                    name: name,
                    src: url
                });
                editor.hideSmallLoader();
            } else if (i > 0) {
                console.log("404 i=" + i);
                setTimeout(function () {
                    editor.context.imageChosen(url, i - 1);
                }, 500);
            } else {
                editor.addToCurrentViewport(Editor.QSprite, {
                    name: name,
                    src: "resource/missing_file.png"
                });
                editor.hideSmallLoader();
            }
        };
        http.send();
    };

    this.registerAction = function (editAction) {
        if (editAction.do()) {
            this.actions.push(editAction);
            this.redoActions = [];
            return true;
        }
        return false;
    };

    this.undo = function () {
        if (this.actions.length < 1) {
            return false;
        } else {
            var editAction = this.actions.pop();
            console.log("Undo");
            console.log(editAction);
            editAction.undo();
            this.redoActions.push(editAction);
//            editAction.setFocus();
            return true;
        }
    };

    this.redo = function () {
        if (this.redoActions.length < 1) {
            return false;
        } else {
            var editAction = this.redoActions.pop();
            console.log("Redo");
            console.log(editAction);

            if (editAction.do()) {
                this.actions.push(editAction);
//                editAction.setFocus();
                return true;
            } else {
                alert("Something Happened");
                redoActions = [];
                return false;
            }
        }
    };

    this.resetActions = function () {
        this.actions = [];
        this.redoActions = [];
    };

    this.changeToSceneModelContext = function (scene) {
        if (this.actionData) {
            if (
                    !scene &&
                    this.editor.activeScene === this.actionData.activeScene &&
                    this.editor.activeScene.activeFrame === this.actionData.activeFrame
                    ) {
                return;
            } else {
                delete this.actionData;
            }
        }
        this.editor.viewport.setSelected(null, true);
        this.propertiesContext = this.editor.propertiesPanel.SceneModelContext((scene ? scene : this.editor.activeScene));
    };

    this.changeToEntityModelContext = function (entity) {
        if (this.actionData)
            return;

        if (entity.isAButton) {
            this.changeToButtonModelContext(entity);
        } else if (entity.isAQSprite) {
            this.changeToQSpriteModelContext(entity);
        } else if (entity.isAQText) {
            this.changeToQTextModelContext(entity);
        } else if (entity.isAnEntity) {
            this.propertiesContext = this.editor.propertiesPanel.EntityModelContext(entity);
        }
    };

    this.changeToQSpriteModelContext = function (sprite) {
        if (sprite)
            this.propertiesContext = this.editor.propertiesPanel.QSpriteModelContext(sprite);
    };

    this.changeToQTextModelContext = function (sprite) {
        if (sprite)
            this.propertiesContext = this.editor.propertiesPanel.QTextModelContext(sprite);
    };

    this.changeToButtonModelContext = function (button) {
        if (button)
            this.propertiesContext = this.editor.propertiesPanel.ButtonModelContext(button);
    };
    this.changeToNodeModelContext = function (node) {
        if (node) {
            this.editor.activeScene.changeFrame(null);
            this.propertiesContext = this.editor.propertiesPanel.NodeModelContext(node);
        }
    };

    this.changeToActionModelContext = function (action) {
        if (action) {
            this.editor.diagramPanel.setSelected(null);
            this.editor.viewport.setSelected(null, true);
            this.propertiesContext = this.editor.propertiesPanel.ActionModelContext(action);
        }
    };
    this.changeToFrameModelContext = function (action) {
        if (action) {
            this.editor.diagramPanel.setSelected(null);
            this.editor.viewport.setSelected(null, true);
            this.propertiesContext = this.editor.propertiesPanel.FrameModelContext(action);
        }
    };
}