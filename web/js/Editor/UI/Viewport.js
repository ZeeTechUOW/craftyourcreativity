/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Viewport(context, scene) {
    this.context = context;
    this.scene = scene;

    this.ROTATE = 1, this.SCALE = 2, this.DRAG_SCREEN = 3, this.SCALEX = 4, this.SCALEY = 5;
    this.localTake = false;
    this.local = {};

    this.selectedShape = null;
    this.stage = null;
    this.bg = null;
    this.camera = null;
    this.renderer = null;

    this.currentSceneContainer;

    this.canvas = document.getElementById('canvas');
    this.width = this.canvas.parentNode.clientWidth;
    this.height = this.canvas.parentNode.clientHeight;
    this.mode = 0;

    this.widget;
    this.createWidget = function () {

        var onMove = function (event) {
            if (this.selectedShape && this.dragging) {
                switch (this.mode) {
                    case 0: // Grab
                        if (this.selectedShape.data) {

                            var newPosition = this.selectedShape.data.getLocalPosition(this.selectedShape.parent);
                            this.selectedShape.setPosX(Math.floor(this.selectedShape.anchorPosX + newPosition.x));
                            this.selectedShape.setPosY(Math.floor(this.selectedShape.anchorPosY + newPosition.y));
                        }
                        break;

                    case 1: //Rotate
                        break;
                    case 2: //Resize
                        break;
                }
            }
        };
        var onUp = function (event) {
            if (this.selectedShape) {
                var ss = this.selectedShape;
                switch (this.mode) {
                    case 0: // Grab
                        if (ss.position.x !== ss.originalPosX && ss.position.y !== ss.originalPosY) {
                            ss.model.context.registerAction(new EditAction({
                                name: "Move " + ss.name,
                                focus: ss.model,
                                valuex: ss.position.x,
                                valuey: ss.position.y,
                                value2x: ss.originalPosX,
                                value2y: ss.originalPosY
                            }, function (e) {
                                e.focus.sprite.setPos(e.valuex, e.valuey);
                                return true;
                            }, function (e) {
                                e.focus.sprite.setPos(e.value2x, e.value2y);
                                return true;
                            }));
                        }

                        ss.dragging = false;
                        ss.data = null;
                        break;
                    case 1: //Rotate
                        break;
                    case 2: //Resize
                        break;
                }

                this.dragging = true;
            }
        };
        var onDown = function (event) {
            this.dragging = false;
            if (this.selectedShape) {
                var v = event.data.getLocalPosition(this.selectedShape);
                this.regionExec(v, event);
            }
        };

        var image = new PIXI.Sprite();
        image.buttonMode = true;
        image.anchor.set(0.5);
        image.scale.set(1);
        image.interactive = true;

        image
                .on('mousedown', onDown)
                .on('touchstart', onDown)
                .on('mouseup', onUp)
                .on('mouseupoutside', onUp)
                .on('touchend', onUp)
                .on('touchendoutside', onUp)
                .on('mousemove', onMove)
                .on('touchmove', onMove);

        image.position.x = 0;
        image.position.y = 0;
        image.rotation = 0;
        image.name = "[WIDGET]";
        image.type = "Sprite";
        image.isWidget = true;

        this.widget = image;

        this.widget.onGrabStart = function (loc, event) {
            var ss = this.selectedShape;
            ss.data = event.data;

            var lastPos = event.data.getLocalPosition(this.selectedShape.parent);

            ss.originalPosX = ss.position.x;
            ss.originalPosY = ss.position.y;
            ss.anchorPosX = ss.position.x - lastPos.x;
            ss.anchorPosY = ss.position.y - lastPos.y;
//            this.alpha = 0.5;
            ss.dragging = true;

            this.mode = 0;
        };

        var vp = this;
        this.widget.onRotateStart = function (loc, event) {

            vp.mode = vp.ROTATE;
            vp.selectedShape.originalRotation = vp.selectedShape.rotation;
            vp.localTake = true;

            this.mode = 1;
        };

        this.widget.onResizeXStart = function (loc, event) {
            vp.mode = vp.SCALEX;
            vp.selectedShape.originalScaleX = vp.selectedShape.scale.x;
            vp.localTake = true;

            this.mode = 2;
        };
        this.widget.onResizeYStart = function (loc, event) {
            vp.mode = vp.SCALEY;
            vp.selectedShape.originalScaleY = vp.selectedShape.scale.y;
            vp.localTake = true;

            this.mode = 3;
        };
        this.widget.onResizeXYStart = function (loc, event) {
            console.log("Start Resize XY");
            vp.mode = vp.SCALE;
            vp.selectedShape.originalScaleY = vp.selectedShape.scale.y;
            vp.selectedShape.originalScaleX = vp.selectedShape.scale.x;
            vp.localTake = true;

            this.mode = 4;
        };

    };

    this.updateWidget = function (dirty) {
        var x = 0, y = 0, width = 100, height = 100, rot = 0;

        if (this.selectedShape) {
            var w = this.widget;
            var wt = this.selectedShape.worldTransform;

            var bw = 5;
            w.bulletXRadius = bw;
            w.bulletYRadius = bw;

            rot = this.selectedShape.rotation;
            width = Math.sqrt(wt.b * wt.b + wt.a * wt.a) * this.selectedShape._texture.orig.width * 1.1;
            height = Math.sqrt(wt.c * wt.c + wt.d * wt.d) * this.selectedShape._texture.orig.height * 1.1;
            x = wt.tx + 3 - bw / 2;
            y = wt.ty + 3 - bw / 2;

            var ax = this.selectedShape.anchor.x;
            var ay = this.selectedShape.anchor.y;

            if (this.selectedShape !== this.widget.selectedShape) {
                w.selectedShape = this.selectedShape;
                w.lastClicked = +new Date();
                w.distance = function (p1, p2, r) {
                    var dx = p2.x - p1.x;
                    var dy = p2.y - p1.y;
                    return dx * dx + dy * dy - r * r < 0;
                };

            }

            w.visible = true;

            if (w.widgetWidth !== width || w.widgetHeight !== height || dirty) {
                var graphics = new PIXI.Graphics();

                var bx = bw;
                var by = bw;
//                bx += bw * (ax - .5) * 4;
//                by += bw * (ay - .5) * 4;

                graphics.lineStyle(1, 0x000000, 1);
                graphics.beginFill(0xFEFEFE, .1);
                graphics.drawRect(bx, by, width, height);

                graphics.lineStyle(1, 0x000000, 1);
                graphics.beginFill(0x990000, .8);
                graphics.drawCircle(bx + width, by + height, bw);
                graphics.drawCircle(bx, by + height, bw);
                graphics.drawCircle(bx + width, by, bw);
                graphics.drawCircle(bx, by, bw);

                graphics.lineStyle(1, 0x000000, 1);
                graphics.beginFill(0x000099, .8);
                graphics.drawCircle(bx + width / 2, by, bw);
                graphics.drawCircle(bx, by + height / 2, bw);
                graphics.drawCircle(bx + width / 2, by + height, bw);
                graphics.drawCircle(bx + width, by + height / 2, bw);



                graphics.lineStyle(1, 0x000000, 1);
                graphics.beginFill(0xFFFFFF, .8);
                graphics.drawRect(width * ax, height * ay + bw * .75, 2 * bw, bw / 2);
                graphics.drawRect(width * ax + bw * .75, height * ay, bw / 2, 2 * bw);

                w.texture = this.renderer.generateTexture(graphics, PIXI.SCALE_MODES.LINEAR);
                w.widgetWidth = width;
                w.widgetHeight = height;

                var regionWidth = this.selectedShape._texture.orig.width * 1.1 / 2;
                var regionHeight = this.selectedShape._texture.orig.height * 1.1 / 2;

                var ox = regionWidth * (ax * 2 - 1) * -1;
                var oy = regionHeight * (ay * 2 - 1) * -1;

                w.cornerPoints = [];
                if (ax !== 1 || ay !== 1)
                    w.cornerPoints.push({x: ox + regionWidth, y: oy + regionHeight});
                if (ax !== 0 || ay !== 1)
                    w.cornerPoints.push({x: ox - regionWidth, y: oy + regionHeight});
                if (ax !== 1 || ay !== 0)
                    w.cornerPoints.push({x: ox + regionWidth, y: oy - regionHeight});
                if (ax !== 0 || ay !== 0)
                    w.cornerPoints.push({x: ox - regionWidth, y: oy - regionHeight});

                w.sideXPoints = [];
                if (ax !== 1)
                    w.sideXPoints.push({x: ox + regionWidth, y: oy});
                if (ax !== 0)
                    w.sideXPoints.push({x: ox - regionWidth, y: oy});

                w.sideYPoints = [];
                if (ay !== 1)
                    w.sideYPoints.push({x: ox, y: oy + regionHeight});
                if (ax !== 0)
                    w.sideYPoints.push({x: ox, y: oy - regionHeight});

                w.regionExec = function (loc, event) {
                    var wt = this.selectedShape.worldTransform;
                    var wx = Math.sqrt(wt.b * wt.b + wt.a * wt.a) / 2;
                    var wy = Math.sqrt(wt.c * wt.c + wt.d * wt.d) / 2;

                    if (loc.x > ox + regionWidth)
                        loc.x = ox + regionWidth;
                    if (loc.x < ox - regionWidth)
                        loc.x = ox - regionWidth;
                    if (loc.y > oy + regionHeight)
                        loc.y = oy + regionHeight;
                    if (loc.y < oy - regionHeight)
                        loc.y = oy - regionHeight;

                    for (var k in this.cornerPoints) {
                        if (this.distance(loc, this.cornerPoints[k], (this.bulletXRadius / wx + this.bulletYRadius / wy) / 2)) {
                            this.onRotateStart(loc, event);
                            return;
                        }
                    }
                    for (var k in this.sideXPoints) {
                        if (this.distance(loc, this.sideXPoints[k], this.bulletXRadius / wx)) {
                            this.onResizeXStart(loc, event);
                            return;
                        }
                    }
                    for (var k in this.sideYPoints) {
                        if (this.distance(loc, this.sideYPoints[k], this.bulletYRadius / wy)) {
                            this.onResizeYStart(loc, event);
                            return;
                        }
                    }

                    var clicked = +new Date();
                    if (this.lastClicked && clicked - this.lastClicked < 200) {
                        this.lastClicked = 0;
                        this.onResizeXYStart(loc, event);
                        return;
                    }
                    this.lastClicked = clicked;

                    this.onGrabStart(loc, event);
                };
            }

            w.position.x = x;
            w.position.y = y;
            w.scale.x = (this.selectedShape.scale.x < 0 ? -1 : 1);
            w.scale.y = (this.selectedShape.scale.y < 0 ? -1 : 1);
            w.rotation = rot;
            w.anchor.x = ax;
            w.anchor.y = ay;
        } else {
            this.widget.selectedShape = null;
            this.widget.visible = false;
        }
    };

    this.removeWidgetsFrom = function (sprite) {
        for (var k = 0; k < sprite.children.length; k++) {
            if (sprite.children[k] && sprite.children[k].isWidget) {
                sprite.children.splice(k, 1);
                k--;
            }
        }
    };

    this.setSelected = function (s, skipPropUpdate, fromProperties) {
        this.mode = 0;

        this.selectedShape = s;

        if (this.selectedShape) {
            if (this.context.actionData && !fromProperties) {
                this.context.actionData.set("target", this.selectedShape.model);
            }
            if (!skipPropUpdate)
                this.context.changeToEntityModelContext(this.selectedShape.model);
        } else {
            if (!skipPropUpdate)
                this.context.changeToSceneModelContext();
        }
        this.context.editor.sceneContentPanel.updateSceneContent();
    };

    this.initBg = function () {
        var vp = this;

        var rect = new PIXI.Graphics();
        rect.beginFill(0xEEEEEE);
        rect.lineStyle(1, 0xFFFFFF);
        rect.interactive = true;
        rect.hitArea = new PIXI.Rectangle(0, 0, vp.width, vp.height);
        rect.drawRect(0, 0, vp.width, vp.height);
        rect.endFill();

        rect.click = function (ev) {
            if (vp.mode !== 0)
                return;
            vp.setSelected(null);

        };
        vp.bg.addChild(rect);
    };

    this.camRect;

    this.initCam = function () {
        var c = this.context;
        var cam = this.camera;

        var rect = new PIXI.Graphics();
        rect.beginFill(0xFFFFFF);
        rect.lineStyle(2, 0x000000);
        rect.drawRect(-c.editor.innerWidth / 2, -c.editor.innerHeight / 2, c.editor.innerWidth, c.editor.innerHeight);
        rect.endFill();
        rect.name = "Background";

//        if(this.camRect && this.camRect.parent) {
//            this.camRect.parent.removeChild(this.camRect);
//        }
        this.camRect = rect;

//        cam.addChild(rect);
    };

    this.onKeyDown = (function (vp) {
        return function (e) {
            if (
                    e.target.tagName.toUpperCase() === 'INPUT' ||
                    e.target.tagName.toUpperCase() === 'TEXTAREA'
                    ) {
                return; // do nothing
            }

            var keyCode = e.keyCode;

            if (vp.selectedShape && (document.activeElement === document.body || document.activeElement === vp.canvas || document.activeElement === vp.canvas.parentNode)) {
                switch (keyCode) {
                    case 82: //Rotate
                        vp.mode = vp.ROTATE;
                        vp.selectedShape.originalRotation = vp.selectedShape.rotation;
                        vp.localTake = true;

                        break;
                    case 83: //Scale
                        vp.mode = vp.SCALE;
                        vp.selectedShape.originalScaleX = vp.selectedShape.scale.x;
                        vp.selectedShape.originalScaleY = vp.selectedShape.scale.y;
                        vp.localTake = true;
                        break;

                    case 46: //Delete
                        if (vp.selectedShape) {
                            vp.selectedShape.model.originalScene = vp.context.editor.activeScene;

                            vp.context.registerAction(new EditAction({
                                name: "Delete " + vp.selectedShape.name,
                                focus: vp.selectedShape.model,
                                viewport: vp
                            }, function (e) {
                                if (e.viewport.context.editor.activeScene !== e.focus.originalScene) {
                                    e.viewport.context.editor.changeScene(e.focus.originalScene);
                                }
                                e.viewport.context.editor.activeScene.removeEntityFromScene(e.focus.sprite.model);
//                                console.log(e.viewport.context.editor.activeScene.entities);
//                                console.log(e.viewport.currentSceneContainer.children);
                                e.focus.sprite = null;
                                return true;
                            }, function (e) {
                                if (e.viewport.context.editor.activeScene !== e.focus.originalScene) {
                                    e.viewport.context.editor.changeScene(e.focus.originalScene);
                                }
                                console.log("NOT WORKING YET");
//                                e.focus.getSprite();
                                return true;
                            }));
                        }
                        e.stopPropagation();

                        vp.setSelected(null);
                        vp.updateLayerOrder();
                        break;

                    case 81:
                        if (vp.selectedShape && vp.selectedShape.model.isAQSprite) {
                            PIXI.utils.clearTextureCache();
                            vp.selectedShape.texture = PIXI.Texture.fromImage(editor.projectPath(vp.selectedShape.model.src + "?update=" + Math.random()));
                        }
                        break;
                }
            } else {
                var scene = vp.context.editor.activeScene;
                if (!vp.selectedShape && scene.activeFrame && keyCode === 46) {
                    var frame = scene.activeFrame;

                    if (frame.activeAction)
                        frame.removeCurrentAction();
                    else
                        scene.removeCurrentFrame();

                    e.stopPropagation();
                }
            }

        };
    }(this));
    this.onMouseDown = (function (vp) {
        return function (e) {
            if (e.which === 2) {
                vp.mode = vp.DRAG_SCREEN;
                vp.camera.originalPosition = {};
                vp.camera.originalPosition.x = vp.camera.position.x;
                vp.camera.originalPosition.y = vp.camera.position.y;
                vp.localTake = true;
            }
        };
    }(this));
    this.onMouseUp = (function (vp) {
        return function (e) {
            if (e.button === 0) { //LeftClick

                switch (vp.mode) {
                    case vp.ROTATE:
                        vp.context.registerAction(new EditAction({
                            name: "Rotate " + vp.selectedShape.name,
                            focus: vp.selectedShape.model,
                            viewport: vp,
                            value: vp.selectedShape.rotation,
                            value2: vp.selectedShape.originalRotation
                        }, function (e) {
                            e.focus.sprite.setRotation(e.value);
                            return true;
                        }, function (e) {
                            e.focus.sprite.setRotation(e.value2);
                            return true;
                        }));
                        vp.mode = 0;
//                        vp.setSelected(null);
//                        vp.updateLayerOrder();


                        break;
                    case vp.SCALE:
                        vp.context.registerAction(new EditAction({
                            name: "Scale " + vp.selectedShape.name,
                            focus: vp.selectedShape.model,
                            viewport: vp,
                            value: vp.selectedShape.model.entityProperty.scalex,
                            value2: vp.selectedShape.originalScaleX,
                            value3: vp.selectedShape.model.entityProperty.scaley,
                            value4: vp.selectedShape.originalScaleY
                        }, function (e) {
                            e.focus.sprite.setScale(e.value, e.value3);
                            return true;
                        }, function (e) {
                            e.focus.sprite.setScale(e.value2, e.value4);
                            return true;
                        }));
                        vp.mode = 0;
//                        vp.setSelected(null);
//                        vp.updateLayerOrder();
                        break;
                    case vp.SCALEX:
                        vp.context.registerAction(new EditAction({
                            name: "Scale " + vp.selectedShape.name,
                            focus: vp.selectedShape.model,
                            viewport: vp,
                            value: vp.selectedShape.model.entityProperty.scalex,
                            value2: vp.selectedShape.originalScaleX
                        }, function (e) {
                            e.focus.sprite.setScaleX(e.value);
                            return true;
                        }, function (e) {
                            e.focus.sprite.setScaleX(e.value2);
                            return true;
                        }));
                        vp.mode = 0;
//                        vp.setSelected(null);
//                        vp.updateLayerOrder();
                        break;
                    case vp.SCALEY:
                        vp.context.registerAction(new EditAction({
                            name: "Scale " + vp.selectedShape.name,
                            focus: vp.selectedShape.model,
                            viewport: vp,
                            value: vp.selectedShape.model.entityProperty.scaley,
                            value2: vp.selectedShape.originalScaleY
                        }, function (e) {
                            e.focus.sprite.setScaleY(e.value);
                            return true;
                        }, function (e) {
                            e.focus.sprite.setScaleY(e.value2);
                            return true;
                        }));
                        vp.mode = 0;
//                        vp.setSelected(null);
//                        vp.updateLayerOrder();
                        break;
                }

            } else if (e.button === 2) { //RightClick
                switch (vp.mode) {
                    case vp.ROTATE:
                        vp.selectedShape.setRotation(vp.selectedShape.originalRotation);
                        vp.mode = 0;
                        vp.setSelected(null);
                        vp.updateLayerOrder();
                        break;
                    case vp.SCALE:
                        vp.selectedShape.setScale(vp.selectedShape.originalScaleX, vp.selectedShape.originalScaleY);
                        vp.mode = 0;
                        vp.setSelected(null);
                        vp.updateLayerOrder();
                        break;
                }
            } else if (e.which === 2) { //Middle Mouse
                switch (vp.mode) {
                    case vp.DRAG_SCREEN:
                        vp.mode = 0;
                        break;
                }
            }
        };
    }(this));
    this.onMouseMove = (function (vp) {
        return function (e) {
            if (vp.localTake) {
                vp.local.x = vp.renderer.plugins.interaction.mouse.global.x;
                vp.local.y = vp.renderer.plugins.interaction.mouse.global.y;
                vp.localTake = false;
            }
            var e = vp.renderer.plugins.interaction.mouse.global;

            if (vp.selectedShape) {
                var globalX = vp.selectedShape.toGlobal(new PIXI.Point()).x;
                var globalY = vp.selectedShape.toGlobal(new PIXI.Point()).y;

            }

            switch (vp.mode) {
                case vp.ROTATE:
                    var fd = Math.atan2(globalY - vp.local.y, globalX - vp.local.x);
                    var nd = Math.atan2(globalY - e.y, globalX - e.x);
                    var d = fd - nd;
                    while (d > 180)
                        d -= 360;
                    while (d < - 180)
                        d += 360;
                    vp.selectedShape.setRotation(vp.selectedShape.originalRotation - d);
                    break;
                case vp.SCALE:
                    var fd = Math.sqrt((globalY - vp.local.y) * (globalY - vp.local.y) + (globalX - vp.local.x) * (globalX - vp.local.x));
                    var nd = Math.sqrt((globalY - e.y) * (globalY - e.y) + (globalX - e.x) * (globalX - e.x));
                    var scaleX = vp.selectedShape.originalScaleX * nd / fd;
                    var scaleY = vp.selectedShape.originalScaleY * nd / fd;
                    vp.selectedShape.setScale(scaleX, scaleY);
                    break;
                case vp.SCALEX:
                    var fdX = globalX - vp.local.x;
                    var ndX = globalX - e.x;
                    var fdY = globalY - vp.local.y;
                    var ndY = globalY - e.y;
                    var nd = Math.sin(vp.selectedShape.rotation) * ndY + Math.cos(vp.selectedShape.rotation) * ndX;
                    var fd = Math.sin(vp.selectedShape.rotation) * fdY + Math.cos(vp.selectedShape.rotation) * fdX;
                    var scale = vp.selectedShape.originalScaleX * nd / fd;
                    vp.selectedShape.setScaleX(scale);
                    break;
                case vp.SCALEY:
                    var fdX = globalX - vp.local.x;
                    var ndX = globalX - e.x;
                    var fdY = globalY - vp.local.y;
                    var ndY = globalY - e.y;
                    var nd = Math.sin(vp.selectedShape.rotation) * -ndX + Math.cos(vp.selectedShape.rotation) * ndY;
                    var fd = Math.sin(vp.selectedShape.rotation) * -fdX + Math.cos(vp.selectedShape.rotation) * fdY;
                    var scale = vp.selectedShape.originalScaleY * nd / fd;
                    vp.selectedShape.setScaleY(scale);
                    break;

                case vp.DRAG_SCREEN:
                    vp.camera.position.x = vp.camera.originalPosition.x + (e.x - vp.local.x);
                    vp.camera.position.y = vp.camera.originalPosition.y + (e.y - vp.local.y);
                    break;
            }
        };
    }(this));
    this.onMouseWheel = (function (vp) {
        return function (e) {
            var delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail))) / 20;

            if (vp.camera) {
                var tScale = vp.camera.scale.x + delta;

                if (tScale > 5)
                    tScale = 5;
                if (tScale < .1)
                    tScale = .1;

                vp.camera.scale.x = tScale;
                vp.camera.scale.y = tScale;
            }
        };
    }(this));

    this.initEvents = function () {
        var vp = this;
        document.addEventListener("keydown", vp.onKeyDown, false);
        document.addEventListener("mousemove", vp.onMouseMove, false);
        document.addEventListener("mouseup", vp.onMouseUp, false);
        vp.renderer.view.addEventListener("mousedown", vp.onMouseDown);
        vp.renderer.view.addEventListener("mousewheel", vp.onMouseWheel);
    };

    this.init = function () {
        var vp = this;
        vp.width = vp.canvas.parentNode.clientWidth;
        vp.height = vp.canvas.parentNode.clientHeight;

        vp.stage = new PIXI.Container();
        vp.bg = new PIXI.Container();
        vp.camera = new PIXI.Container();


        vp.renderer = new PIXI.CanvasRenderer(vp.width, vp.height, {
            view: vp.canvas,
            resolution: 1
        });
        vp.renderer.backgroundColor = 0xEEEEEE;


        vp.initBg();
        vp.initCam();
        vp.createWidget();

        vp.stage.addChild(vp.bg);
        vp.stage.addChild(vp.camera);

        vp.stage.addChild(vp.widget);
//        vp.widget.zIndex = 1000;

        vp.changeScene(vp.context.editor.project.scenes[0]);

        vp.initEvents();
        //vp.setSelected(null);
    };

    this.update = function () {
        var vp = this;

        var W = vp.canvas.parentNode.clientWidth;
        var H = vp.canvas.parentNode.clientHeight;

        vp.bg.scale.x = vp.bg.scale.x * W / vp.width;
        vp.bg.scale.y = vp.bg.scale.y * H / vp.height;

        vp.camera.position.x = vp.camera.position.x * W / vp.width;
        vp.camera.position.y = vp.camera.position.y * H / vp.height;

        vp.width = W;
        vp.height = H;

        vp.updateWidget();

        vp.renderer.view.style.width = W + 'px';
        vp.renderer.view.style.height = H + 'px';
        vp.renderer.resize(vp.width, vp.height);

        vp.renderer.render(vp.stage);
    };

    this.updateLayerOrder = function () {
        var vp = this;
        vp.currentSceneContainer.children.sort(function (a, b) {
            a.zIndex = a.zIndex || 0;
            b.zIndex = b.zIndex || 0;
            return a.zIndex - b.zIndex;
        });
        for (var i = 0; i < vp.currentSceneContainer.children.length; i++) {
            var item = vp.currentSceneContainer.children[i];
            item.zIndex = i;
            if (item.model)
                item.model.zIndex = i;
        }
        vp.context.editor.activeScene.entities.sort(function (a, b) {
            a.zIndex = a.zIndex || 0;
            b.zIndex = b.zIndex || 0;
            return a.zIndex - b.zIndex;
        });
    };

    this.changeScene = function (scene) {
        var vp = this;

        vp.stage.removeChild(vp.camera);
//        vp.camera.removeChild(vp.currentSceneContainer);

        if (vp.selectedShape)
            vp.setSelected(null);

        if (vp.currentSceneContainer) {
            vp.currentSceneContainer.lastPosX = vp.camera.position.x;
            vp.currentSceneContainer.lastPosY = vp.camera.position.y;
            vp.currentSceneContainer.lastScale = vp.camera.scale.x;

            vp.currentSceneContainer.position.x = vp.context.editor.innerWidth / 2;
            vp.currentSceneContainer.position.y = vp.context.editor.innerHeight / 2;
            vp.currentSceneContainer.scale.x = 1;
            vp.currentSceneContainer.scale.y = 1;
        }

        if (!scene) {
            return;
        }

        vp.currentSceneContainer = scene.viewportContainer;

        vp.camera = vp.currentSceneContainer;
//        vp.camera.addChild(vp.currentSceneContainer);

        if (vp.currentSceneContainer) {

            if (vp.currentSceneContainer.lastPosX && vp.currentSceneContainer.lastPosY && vp.currentSceneContainer.lastScale) {
                vp.camera.position.x = vp.currentSceneContainer.lastPosX;
                vp.camera.position.y = vp.currentSceneContainer.lastPosY;
                vp.camera.scale.x = vp.currentSceneContainer.lastScale;
                vp.camera.scale.y = vp.currentSceneContainer.lastScale;
            } else {
                vp.camera.position.x = vp.context.editor.innerWidth / 2;
                vp.camera.position.y = vp.context.editor.innerHeight / 2;

                var scale = .75 * vp.height / vp.context.editor.innerHeight;
                vp.camera.scale.x = scale;
                vp.camera.scale.y = scale;
            }
        }


        var W = vp.canvas.parentNode.clientWidth;
        var H = vp.canvas.parentNode.clientHeight;
//        vp.currentSceneContainer.position.x = 0;
//        vp.currentSceneContainer.position.y = 0;
        vp.camera.position.x = W / 2;
        vp.camera.position.y = H / 2;

        vp.stage.addChild(vp.camera);
        vp.stage.addChild(vp.widget);
    };

    this.reset = function () {
        var vp = this;
//        for (var i = vp.camera.children.length - 1; i >= 0; i--) {
//            vp.camera.removeChild(vp.camera.children[i]);
//        }


    };

    this.init();
}
