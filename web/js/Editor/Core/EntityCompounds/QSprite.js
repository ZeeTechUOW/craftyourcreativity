/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Deni Barasena
 */


function QSprite(context, opt) {
    opt = setDefault(opt, {
        name: "Shape",
        src: "bunny.png"
    });
    Entity.extend(this, opt, context);

    opt.name = this.name;
    this.opt = opt;
    this.src = opt.src;
    this.isAQSprite = true;

    for (var v in this.entityProperty) {
        if (isDefined(this.opt, v))
            this.entityProperty[v] = this.opt[v];
    }

    this._serializeFlat = this.serializeFlat;
    this.serializeFlat = function () {
        var target = this._serializeFlat();

        for (var k in QSprite.serializable) {
            var kk = QSprite.serializable[k];
            target[kk] = this[kk];
        }
        return target;
    };

    this._serialize = this.serialize;
    this.serialize = function () {
        var res = this._serialize();
        for (var k in QSprite.serializable) {
            var kk = QSprite.serializable[k];
            res[kk] = this[kk];
        }

        return res;
    };

    this.createImage = function () {
        var ep = this.entityProperty;
        var c = this.context;

        var image = new PIXI.Sprite(c.getResource(this.opt.src));
        image.interactive = true;
        image.buttonMode = true;
        image.anchor.set(this.opt.anchorx, this.opt.anchory);
        image.scale.set(ep.scalex);
        image
                .on('mousedown', c.onDragStart)
                .on('touchstart', c.onDragStart)
                .on('mouseup', c.onDragEnd)
                .on('mouseupoutside', c.onDragEnd)
                .on('touchend', c.onDragEnd)
                .on('touchendoutside', c.onDragEnd)
                .on('mousemove', c.onDragMove)
                .on('touchmove', c.onDragMove);
        image.position.x = ep.posx;
        image.position.y = ep.posy;
        image.rotation = ep.rotation / 57.2958;
        image.name = this.opt.name;
        image.type = "Sprite";
        image.model = this;

        this.setPropertyUpdater(this, image);
//
//        if (c && c.onSpriteCreated) {
//            c.onSpriteCreated(image);
//        }

        return image;
    };

    this.getSprite = function () {
        if (!this.sprite) {
            this.sprite = this.createImage();

            this.setPropertyListener(this);
            this.addListener(this, "src", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    res.src = newValue;
                    s.src = newValue;
                    res.opt.src = newValue;
                    
                    s.texture = PIXI.Texture.fromImage(editor.projectPath(newValue));
                }
                return true;
            });
        }
        return this.sprite;
    };
    
    
    this.clone = function () {
        var entity = QSprite.deserialize(this.context, JSON.parse(JSON.stringify(this.serialize())));
        entity.entityID = uid();
        return entity;
    };


    this._setAllListeners = this.setAllListeners;
    this.setAllListeners = function (target, cb) {
        this._setAllListeners(target, cb);

        this.addListeners(target, QSprite.serializable, cb);
    };

    this._getKeyableProperties = this.getKeyableProperties;
    this.getKeyableProperties = function () {
        var that = this;
        var data = this._getKeyableProperties();

        data.push({
            name: "Image Source",
            values: ["src"]
        });
        
        return data;
    };

    setupListener(this);

    this.getSprite();
}

QSprite.serializable = ["src", "isAQSprite"];

QSprite.deserialize = function (context, input) {
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

    for (var k in QSprite.serializable) {
        var kk = QSprite.serializable[k];
        opt[kk] = input[kk];
    }

    var sprite = new QSprite(context, opt); 
    for( var k in input.onClickActions ) {
        sprite.onClickActions[k] = Action.deserialize(sprite, input.onClickActions[k]);
    }
    for( var k in input.onEnterActions ) {
        sprite.onEnterActions[k] = Action.deserialize(sprite, input.onEnterActions[k]);
    }
    for( var k in input.onExitActions ) {
        sprite.onExitActions[k] = Action.deserialize(sprite, input.onExitActions[k]);
    }

    return sprite;
};
