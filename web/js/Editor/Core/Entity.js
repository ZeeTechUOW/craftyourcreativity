/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Deni Barasena
 */

function Entity(context, name) {
    this.context = context;
    this.entityID = uid();
    this.name = incrementIfDuplicate(name, context.editor.activeScene ? context.editor.activeScene.entities : [], function (e) {
        return e.name;
    });
    this.isAnEntity = true;
    this.sprite = null;

    this.onClickActions = [];
    this.onEnterActions = [];
    this.onExitActions = [];

    this.entityProperty = {
        posx: 0,
        posy: 0,
        rotation: 0,
        scalex: 1,
        scaley: 1,
        anchorx: .5,
        anchory: .5,
        pivotx: 0,
        pivoty: 0,
        serialize: function () {
            var ep = {};

            for (var k in Entity.propSerializable) {
                var n = Entity.propSerializable[k];
                ep[n] = this[n];
            }

            return ep;
        }
    };

    setupListener(this);

    this.setPosX = function (x) {
        var s = this.sprite;
        if (s) {
            s.position.x = x;
        }

        this.entityProperty.set("posx", x, this);
    };
    this.setPosY = function (y) {
        var s = this.sprite;
        if (s) {
            s.position.y = y;
        }
        this.entityProperty.set("posy", y, this);
    };
    this.setPos = function (x, y) {
        var e = this;

        if (isDefined(y)) {
            e.setPosX(x);
            e.setPosY(y);
        } else {
            e.setPosX(x.x);
            e.setPosY(x.y);
        }
    };
    this.setRotation = function (r) {
        var s = this.sprite;
        if (s) {
            s.rotation = r;
        }
        this.entityProperty.set("rotation", r * 57.2958, this);
    };
    this.setScaleX = function (sx) {
        var s = this.sprite;
        if (s) {
            s.scale.x = sx;
        }
        this.entityProperty.set("scalex", sx, this);
    };
    this.setScaleY = function (sy) {
        var s = this.sprite;
        if (s) {
            s.scale.y = sy;
        }
        this.entityProperty.set("scaley", sy, this);
    };
    this.setScale = function (x, y) {
        var e = this;

        if (isDefined(y)) {
            e.setScaleX(x);
            e.setScaleY(y);
        } else {
            e.setScaleX(x.x);
            e.setScaleY(x.y);
        }
    };
    this.setAnchorX = function (sx) {
        var s = this.sprite;
        if (s) {
            s.anchor.x = sx;
        }
        this.entityProperty.set("anchorx", sx, this);
    };
    this.setAnchorY = function (sy) {
        var s = this.sprite;
        if (s) {
            s.anchor.y = sy;
        }
        this.entityProperty.set("anchory", sy, this);
    };
    this.setAnchor = function (x, y) {
        var e = this;

        if (isDefined(y)) {
            e.setAnchorX(x);
            e.setAnchorY(y);
        } else {
            e.setAnchorX(x.x);
            e.setAnchorY(x.y);
        }
    };
    this.setPivotX = function (sx) {
        var s = this.sprite;
        if (s) {
            s.pivot.x = sx;
        }
        this.entityProperty.set("pivotx", sx, this);
    };
    this.setPivotY = function (sy) {
        var s = this.sprite;
        if (s) {
            s.pivot.y = sy;
        }
        this.entityProperty.set("pivoty", sy, this);
    };
    this.setPivot = function (x, y) {
        var e = this;

        if (isDefined(y)) {
            e.setPivotX(x);
            e.setPivotY(y);
        } else {
            e.setPivotX(x.x);
            e.setPivotY(x.y);
        }
    };

    this.shadingProperty = {
        alpha: 1,
        tint: "#FFFFFF",
        serialize: function () {
            var ep = {};

            for (var k in Entity.shadingSerializable) {
                var n = Entity.shadingSerializable[k];
                ep[n] = this[n];
            }
            return ep;
        }
    };

    this.setAlpha = function (a) {
        var s = this.sprite;
        if (s) {
            s.alpha = a;
        }
        this.shadingProperty.set(this, "alpha", a);
    };
    this.setTint = function (t) {
        var s = this.sprite;
        if (s) {
            s.tint = t;
        }
        this.shadingProperty.set(this, "tint", t);
    };
    
    this.getFlat = function (key) {
        for(var k in Entity.propSerializable) {
            if( key === Entity.propSerializable[k] ) {
                return this.entityProperty[key];
            }
        }
        for(var k in Entity.shadingSerializable) {
            if( key === Entity.shadingSerializable[k] ) {
                return this.shadingProperty[key];
            }
        }
        return this[key];
    };
    this.setFlat = function (key, value) {
        for(var k in Entity.propSerializable) {
            if( key === Entity.propSerializable[k] ) {
                this.entityProperty.set(key, value);
                return;
            }
        }
        for(var k in Entity.shadingSerializable) {
            if( key === Entity.shadingSerializable[k] ) {
                this.shadingProperty.set(key, value);
                return;
            }
        }
        
        this.set(key, value);
    };

    this.setPropertyUpdater = function (e, sprite) {
        sprite.setPosX = function (x) {
            e.setPosX(x);
        };
        sprite.setPosY = function (x) {
            e.setPosY(x);
        };
        sprite.setPos = function (x, y) {
            e.setPos(x, y);
        };
        sprite.setRotation = function (x) {
            e.setRotation(x);
        };
        sprite.setScaleX = function (x) {
            e.setScaleX(x);
        };
        sprite.setScaleY = function (x) {
            e.setScaleY(x);
        };
        sprite.setScale = function (x, y) {
            e.setScale(x, y);
        };
        sprite.setAnchorX = function (x) {
            e.setAnchorX(x);
        };
        sprite.setAnchorY = function (x) {
            e.setAnchorY(x);
        };
        sprite.setAnchor = function (x, y) {
            e.setAnchor(x, y);
        };
        sprite.setPivotX = function (x) {
            e.setPivotX(x);
        };
        sprite.setPivotY = function (x) {
            e.setPivotY(x);
        };
        sprite.setPivot = function (x, y) {
            e.setPivot(x, y);
        };
        sprite.setAlpha = function (x) {
            e.setAlpha(x);
        };
        sprite.setTint = function (x) {
            e.setTint(x);
        };
    };

    this.setPropertyListener = function (res) {

        res.addListener(res, "name", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                res.name = newValue;
                s.name = newValue;
                res.opt.name = newValue;
                res.context.editor.sceneContentPanel.updateSceneContent();
            }
            return true;
        });

        res.entityProperty.addListener(res, "posx", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.position.x = newValue;
            }
            return true;
        });
        res.entityProperty.addListener(res, "posy", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.position.y = newValue;
            }
            return true;
        });
        res.entityProperty.addListener(res, "rotation", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.rotation = newValue / 57.2958;
            }
            return true;
        });
        res.entityProperty.addListener(res, "scalex", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.scale.x = newValue;
            }
            return true;
        });
        res.entityProperty.addListener(res, "scaley", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.scale.y = newValue;
            }
            return true;
        });
        res.entityProperty.addListener(res, "anchorx", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.anchor.x = newValue;
                res.context.editor.viewport.updateWidget(true);
                if (res.recalculateChildAnchor)
                    res.recalculateChildAnchor();
            }
            return true;
        });
        res.entityProperty.addListener(res, "anchory", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.anchor.y = newValue;
                res.context.editor.viewport.updateWidget(true);
                if (res.recalculateChildAnchor)
                    res.recalculateChildAnchor();
            }
            return true;
        });
        res.entityProperty.addListener(res, "pivotx", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.pivot.x = newValue;
                res.context.editor.viewport.updateWidget(true);
            }
            return true;
        });
        res.entityProperty.addListener(res, "pivoty", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.pivot.y = newValue;
                res.context.editor.viewport.updateWidget(true);
            }
            return true;
        });
        res.shadingProperty.addListener(res, "alpha", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.alpha = newValue;
            }
            return true;
        });
        res.shadingProperty.addListener(res, "tint", function (newValue, res) {
            var s = res.sprite;
            if (s) {
                s.tint = parseInt(newValue.replace(/^#/, ''), 16);
            }
            return true;
        });
    };

    this.serialize = function () {
        var res = {};

        for (var k in Entity.serializable) {
            var kk = Entity.serializable[k];
            res[kk] = this[kk];
        }

        res.entityProperty = this.entityProperty.serialize();
        res.shadingProperty = this.shadingProperty.serialize();

        var clickActions = [];
        for (var k in this.onClickActions) {
            clickActions[k] = this.onClickActions[k].serialize();
        }
        var enterActions = [];
        for (var k in this.onEnterActions) {
            enterActions[k] = this.onEnterActions[k].serialize();
        }
        var exitActions = [];
        for (var k in this.onExitActions) {
            exitActions[k] = this.onExitActions[k].serialize();
        }

        res.onClickActions = clickActions;
        res.onEnterActions = enterActions;
        res.onExitActions = exitActions;

        return res;
    };

    this.serializeFlat = function () {
        var res = {};

        for (var k in Entity.serializable) {
            var kk = Entity.serializable[k];
            res[kk] = this[kk];
        }

        for (var k in Entity.propSerializable) {
            var kk = Entity.propSerializable[k];
            res[kk] = this.entityProperty[kk];
        }
        for (var k in Entity.shadingSerializable) {
            var kk = Entity.shadingSerializable[k];
            res[kk] = this.shadingProperty[kk];
        }


        var clickActions = [];
        for (var k in this.onClickActions) {
            clickActions[k] = this.onClickActions[k].serialize();
        }
        var enterActions = [];
        for (var k in this.onEnterActions) {
            enterActions[k] = this.onEnterActions[k].serialize();
        }
        var exitActions = [];
        for (var k in this.onExitActions) {
            exitActions[k] = this.onExitActions[k].serialize();
        }
        res.onClickActions = clickActions;
        res.onEnterActions = enterActions;
        res.onExitActions = exitActions;
        return res;
    };

    this.setAllListeners = function (target, cb) {
        this.entityProperty.addListeners(target, Entity.propSerializable, cb);
        this.shadingProperty.addListeners(target, Entity.shadingSerializable, cb);
        this.addListeners(target, Entity.serializable, cb);
    };

    this.getKeyableProperties = function () {
        var that = this;
        var data = [{
                name: "Position",
                values: ["posx", "posy"],
                parent: that.entityProperty
            }, {
                name: "Rotation",
                values: ["rotation"],
                parent: that.entityProperty
            }, {
                name: "Scale",
                values: ["scalex", "scaley"],
                parent: that.entityProperty
            }, {
                name: "Alpha",
                values: ["alpha"],
                parent: that.shadingProperty
            }, {
                name: "Tint",
                values: ["tint"],
                parent: that.shadingProperty
            }];
        return data;
    };

    setupListener(this.entityProperty);
    setupListener(this.shadingProperty);
}

Entity.serializable = ["name", "isAnEntity", "entityID"];
Entity.propSerializable = ["posx", "posy", "rotation", "scalex", "scaley", "anchorx", "anchory", "pivotx", "pivoty"];
Entity.shadingSerializable = ["tint", "alpha"];

Entity.extend = function (child, opt, context) {
    var b = new Entity(context, opt.name);
    if (opt.entityID)
        b.entityID = opt.entityID;
    for (var k in b) {
        child[k] = b[k];
    }
};

Entity.deserialize = function (context, input) {
    if (input.isAButton) {
        return Button.deserialize(context, input);
    } else if (input.isAQSprite) {
        return QSprite.deserialize(context, input);
    } else if (input.isAQText) {
        return QText.deserialize(context, input);
    }
};