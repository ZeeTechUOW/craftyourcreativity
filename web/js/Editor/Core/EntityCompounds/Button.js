/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Button(context, opt) {
    opt = setDefault(opt, {
        name: "Button",
        text: "Default Text",
        link: "www.google.com",
        normSrc: "button.png"
    });
    Entity.extend(this, opt, context);
    opt.name = this.name;
    this.opt = opt;

    this.text = opt.text;
    this.link = opt.link;
    this.normSrc = opt.normSrc;

    this.isAButton = true;

    for (var v in this.entityProperty) {
        if (isDefined(this.opt, v))
            this.entityProperty[v] = this.opt[v];
    }


    this._serializeFlat = this.serializeFlat;
    this.serializeFlat = function () {
        var target = this._serializeFlat();
        for (var k in Button.serializable) {
            var kk = Button.serializable[k];
            target[kk] = this[kk];
        }

        return target;
    };

    this._serialize = this.serialize;
    this.serialize = function () {
        var res = this._serialize();

        for (var k in Button.serializable) {
            var kk = Button.serializable[k];
            res[kk] = this[kk];
        }


        res.entityProperty = this.entityProperty.serialize();
        res.shadingProperty = this.shadingProperty.serialize();

        return res;
    };

    this.createButton = function () {
        var c = this.context;
        var ep = this.entityProperty;
        var o = this.opt;
        var button = new PIXI.Sprite(c.getResource(o.normSrc));
        button.interactive = true;
        button.buttonMode = true;
        button.anchor.set(o.anchorx, o.anchory);
        button.scale.set(ep.scalex);
        button
                .on('mousedown', c.onDragStart)
                .on('touchstart', c.onDragStart)
                .on('mouseup', c.onDragEnd)
                .on('mouseupoutside', c.onDragEnd)
                .on('touchend', c.onDragEnd)
                .on('touchendoutside', c.onDragEnd)
                .on('mousemove', c.onDragMove)
                .on('touchmove', c.onDragMove);
        button.position.x = ep.posx;
        button.position.y = ep.posy;

        var def = {
            "default": {
                fontFamily: 'Arial', fontSize: 36 + "px", fill: 'black', align: 'center'
            }
        };
        for (var k in QText.textProfiles) {
            def[k] = QText.textProfiles[k];
        }

        var basicText = new MultiStyleText(o.text, def);
//                            basicText.x = 20;
//                            basicText.y = 10;
        basicText.position.x = button._texture.orig.width * -(button.anchor.x - .5);
        basicText.position.y = button._texture.orig.height * -(button.anchor.y - .5) - 5;
        basicText.anchor.set(0.5, 0.5);


        button.addChild(basicText);

        button.rotation = ep.rotation / 57.2958;
        button.name = o.name;

        button.buttonName = o.text;
        button.buttonLink = o.link;
        button.buttonNrmSrc = o.normSrc;
        button.type = "Button";
        button.model = this;

        this.setPropertyUpdater(this, button);
//
//        if (c && c.onButtonCreated) {
//            c.onButtonCreated(button);
//        }

        return button;
    };
    
    
    this.getLinkName = function () {
        var link = editor.resolveValue(this.link);
        if ( link && link.startsWith("#") && link.length > 1) {
            return link.substring(1);
        }
        return null;
    };

    this.recalculateChildAnchor = function () {
        var s = this.sprite;
        s.children[0].position.x = s._texture.orig.width * -(s.anchor.x - .5);
        s.children[0].position.y = s._texture.orig.height * -(s.anchor.y - .5) - 5;
    };

    this.getSprite = function () {
        if (!this.sprite) {
            this.sprite = this.createButton();

            this.setPropertyListener(this);

            this.addListener(this, "text", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    s.buttonName = newValue;
                    res.opt.text = newValue;
                    s.children[0].text = newValue;
                    res.recalculateChildAnchor();

                }
                return true;
            });
            this.addListener(this, "normSrc", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    s.normSrc = newValue;
                    res.opt.normSrc = newValue;
                    res.recalculateChildAnchor();
                    
                    s.texture = PIXI.Texture.fromImage(editor.projectPath(newValue));
                }
                return true;
            });
            this.addListener(this, "link", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    s.buttonLink = newValue;
                    res.opt.link = newValue;
                }
                return true;
            });
        }
        return this.sprite;
    };


    this._setAllListeners = this.setAllListeners;
    this.setAllListeners = function (target, cb) {
        this._setAllListeners(target, cb);

        this.addListeners(target, Button.serializable, cb);
    };

    this._getKeyableProperties = this.getKeyableProperties;
    this.getKeyableProperties = function () {
        var that  = this;
        var data = this._getKeyableProperties();

        data.push({
            name: "Button Text",
            values: ["text"]
        });
        data.push({
            name: "Button Link",
            values: ["link"]
        });
        data.push({
            name: "Button Image",
            values: ["normSrc"]
        });
        return data;
    };
    
    this.clone = function () {
        var entity = Button.deserialize(this.context, JSON.parse(JSON.stringify(this.serialize())));
        entity.entityID = uid();
        return entity;
    };

    setupListener(this);

    this.getSprite();
}

Button.serializable = ["text", "link", "isAButton", "normSrc"];

Button.deserialize = function (context, input) {
    var opt = {};

    for (var k in Entity.serializable) {
        var kk = Entity.serializable[k];
        opt[kk] = input[kk];
    }

    for (var k in Entity.propSerializable) {
        var kk = Entity.propSerializable[k];
        opt[kk] = input.entityProperty[kk];
    }

    for (var k in Entity.shadingSerializable) {
        var kk = Entity.shadingSerializable[k];
        opt[kk] = input.shadingProperty[kk];
    }
    
    for (var k in Button.serializable) {
        var kk = Button.serializable[k];
        opt[kk] = input[kk];
    }

    var b = new Button(context, opt); 
    for( var k in input.onClickActions ) {
        b.onClickActions[k] = Action.deserialize(b, input.onClickActions[k]);
    }
    for( var k in input.onEnterActions ) {
        b.onEnterActions[k] = Action.deserialize(b, input.onEnterActions[k]);
    }
    for( var k in input.onExitActions ) {
        b.onExitActions[k] = Action.deserialize(b, input.onExitActions[k]);
    }
    
    return b;
};
