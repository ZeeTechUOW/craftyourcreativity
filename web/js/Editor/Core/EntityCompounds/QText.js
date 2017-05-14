/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function QText(context, opt) {
    opt = setDefault(opt, {
        name: "Text",
        text: "Default Text",
        align: "Center",
        wordWrap: 0,
        breakWords: false,
        color: "#000000",
        font: "Arial",
        fontSize: 48,
        isItalic: false,
        isBold: false,
        isExtraBold: false,
        stroke: 0,
        strokeColor: 0x000000,
        valign: "middle",
        letterSpacing: 0,
        padding: 0,
        dropShadow: false,
        dsAlpha: 1,
        dsAngle: Math.PI / 6,
        dsBlur: 0,
        dsColor: 0x000000,
        dsDistance: 5
    });
    Entity.extend(this, opt, context);
    opt.name = this.name;
    this.opt = opt;
    this.text = opt.text;

    for (var k in opt) {
        this[k] = opt[k];
    }
    this.isAQText = true;

    for (var v in this.entityProperty) {
        if (isDefined(this.opt, v))
            this.entityProperty[v] = this.opt[v];
    }

    this._serializeFlat = this.serializeFlat;
    this.serializeFlat = function () {
        var target = this._serializeFlat();

        for (var k in QText.serializable) {
            var kk = QText.serializable[k];
            target[kk] = this[kk];
        }
        for (var k in QText.textAttributes) {
            var kk = QText.textAttributes[k];
            target[kk] = this[kk];
        }

        return target;
    };

    this._serialize = this.serialize;
    this.serialize = function () {
        var res = this._serialize();

        for (var k in QText.serializable) {
            var kk = QText.serializable[k];
            res[kk] = this[kk];
        }
        for (var k in QText.textAttributes) {
            var kk = QText.textAttributes[k];
            res[kk] = this[kk];
        }

        return res;
    };

    this.genStyle = function () {
        var o = this;
        return {
            fontFamily: o.font,
            fontSize: o.fontSize + "px",
            fill: (o.color === "#000000" ? "black" : o.color),
            align: o.align.toLowerCase(),
            wordWrap: (o.wordWrap > 0),
            wordWrapWidth: o.wordWrap,
            breakWords: o.breakWords,
            strokeThickness: o.stroke,
            stroke: o.strokeColor,
            fontStyle: (o.isItalic ? "italic" : "normal"),
            fontWeight: (o.isExtraBold ? (o.isBold ? "bolder" : "bold") : (o.isBold ? "normal" : "lighter")),
            letterSpacing: o.letterSpacing,
            padding: o.padding,
            valign: o.valign,
            dropShadow: o.dropShadow,
            dropShadowAlpha: o.dsAlpha,
            dropShadowAngle: o.dsAngle,
            dropShadowColor: o.dsColor,
            dropShadowDistance: o.dsDistance,
            dropShadowBlur: o.dsBlur
        };
    };

    this.createText = function () {
        var c = this.context;
        var ep = this.entityProperty;
        var o = this.opt;

        var defStyle = {
            "default": this.genStyle()
        };
        for (var k in QText.textProfiles) {
            defStyle[k] = QText.textProfiles[k];
        }
        for (var k in c.editor.project.textProfiles) {
            console.log(k);
            defStyle[k] = c.editor.project.textProfiles[k];
        }
        var text = new MultiStyleText(o.text, defStyle);
        text.interactive = true;
        text.buttonMode = true;
        text.anchor.set(o.anchorx, o.anchory);
        text.scale.set(ep.scalex);
        text
                .on('mousedown', c.onDragStart)
                .on('touchstart', c.onDragStart)
                .on('mouseup', c.onDragEnd)
                .on('mouseupoutside', c.onDragEnd)
                .on('touchend', c.onDragEnd)
                .on('touchendoutside', c.onDragEnd)
                .on('mousemove', c.onDragMove)
                .on('touchmove', c.onDragMove);
        text.position.x = ep.posx;
        text.position.y = ep.posy;

        text.rotation = ep.rotation / 57.2958;
        text.name = o.name;

        text.text = o.text;
        text.type = "Text";
        text.model = this;

        this.setPropertyUpdater(this, text);
//
//        if (c && c.onTextCreated) {
//            c.onTextCreated(text);
//        }

        return text;
    };

    this.updateText = function () {
        if (this.sprite) {
            var newStyle = {
                "default": this.genStyle()
            };
            for (var k in QText.textProfiles) {
                newStyle[k] = QText.textProfiles[k];
            }
            for (var k in this.context.editor.project.textProfiles) {
                newStyle[k] = this.context.editor.project.textProfiles[k];
            }
            this.sprite.styles = newStyle;

            this.sprite.dirty = true;
        }
    };

    this.getSprite = function () {
        if (!this.sprite) {
            this.sprite = this.createText();

            this.setPropertyListener(this);

            this.addListener(this, "text", function (newValue, res) {
                var s = res.sprite;
                if (s) {
                    s.text = newValue;
                    res.opt.text = newValue;
                }
                return true;
            });

            for (var k in QText.textAttributes) {
                var tp = QText.textAttributes[k];
                this.addListener(this, tp, (function (tp) {
                    return function (newValue, res) {
                        var s = res.sprite;

                        if (s) {
                            res.updateText();
                            res.opt[tp] = newValue;
                        }
                        return true;
                    };
                })(tp));
            }
            this.addListener(this, "", function (newValue, res) {

            });
        }
        return this.sprite;
    };


    this.clone = function () {
        var entity = QText.deserialize(this.context, JSON.parse(JSON.stringify(this.serialize())));
        entity.entityID = uid();
        return entity;
    };

    this._setAllListeners = this.setAllListeners;
    this.setAllListeners = function (target, cb) {
        this._setAllListeners(target, cb);

        this.addListeners(target, QText.textAttributes, cb);
        this.addListeners(target, QText.serializable, cb);
    };


    this._getKeyableProperties = this.getKeyableProperties;
    this.getKeyableProperties = function () {
        var that = this;
        var data = this._getKeyableProperties();

        data.push({
            name: "Text",
            values: ["text"]
        });
        data.push({
            name: "Word Wrap",
            values: ["wordWrap"]
        });

        return data;
    };

    setupListener(this);

    this.getSprite();
}

QText.textAttributes = ["align", "wordWrap", "breakWords", "color", "font", "fontSize", "stroke", "strokeColor", "isItalic", "isBold", "isExtraBold", "padding", "valign", "letterSpacing", "dropShadow", "dsColor", "dsAlpha", "dsAngle", "dsBlur", "dsDistance"];
QText.serializable = ["text", "isAQText"];

QText.deserialize = function (context, input) {
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

    for (var k in QText.textAttributes) {
        var kk = QText.textAttributes[k];
        opt[kk] = input[kk];
    }

    for (var k in QText.serializable) {
        var kk = QText.serializable[k];
        opt[kk] = input[kk];
    }
    
    
    var text = new QText(context, opt); 
    for( var k in input.onClickActions ) {
        text.onClickActions[k] = Action.deserialize(text, input.onClickActions[k]);
    }
    for( var k in input.onEnterActions ) {
        text.onEnterActions[k] = Action.deserialize(text, input.onEnterActions[k]);
    }
    for( var k in input.onExitActions ) {
        text.onExitActions[k] = Action.deserialize(text, input.onExitActions[k]);
    }

    return text;
};


QText.textProfiles = {
    "b": {fontWeight: "bolder"}, "i": {fontStyle: "italic"}, "shadow": {dropShadow: true},
    "top": {fontSize: "14px", valign: "top"}, "middle": {fontSize: "14px", valign: "middle"}, "bottom": {fontSize: "14px", valign: "bottom"}
};

for (var i = 1; i <= 10; i++) {
    QText.textProfiles["s" + i] = {strokeThickness: i};
}

QText.sizes = [8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 36, 40, 44, 48, 50, 52, 54, 56, 60, 64, 72, 84, 96];
for (var k in QText.sizes) {
    var i = QText.sizes[k];
    QText.textProfiles["p" + i] = {fontSize: i + "px"};
}

QText.colours = {"aliceblue": "#f0f8ff", "antiquewhite": "#faebd7", "aqua": "#00ffff", "aquamarine": "#7fffd4", "azure": "#f0ffff",
    "beige": "#f5f5dc", "bisque": "#ffe4c4", "black": "#000000", "blanchedalmond": "#ffebcd", "blue": "#0000ff", "blueviolet": "#8a2be2", "brown": "#a52a2a", "burlywood": "#deb887",
    "cadetblue": "#5f9ea0", "chartreuse": "#7fff00", "chocolate": "#d2691e", "coral": "#ff7f50", "cornflowerblue": "#6495ed", "cornsilk": "#fff8dc", "crimson": "#dc143c", "cyan": "#00ffff",
    "darkblue": "#00008b", "darkcyan": "#008b8b", "darkgoldenrod": "#b8860b", "darkgray": "#a9a9a9", "darkgreen": "#006400", "darkkhaki": "#bdb76b", "darkmagenta": "#8b008b", "darkolivegreen": "#556b2f",
    "darkorange": "#ff8c00", "darkorchid": "#9932cc", "darkred": "#8b0000", "darksalmon": "#e9967a", "darkseagreen": "#8fbc8f", "darkslateblue": "#483d8b", "darkslategray": "#2f4f4f", "darkturquoise": "#00ced1",
    "darkviolet": "#9400d3", "deeppink": "#ff1493", "deepskyblue": "#00bfff", "dimgray": "#696969", "dodgerblue": "#1e90ff",
    "firebrick": "#b22222", "floralwhite": "#fffaf0", "forestgreen": "#228b22", "fuchsia": "#ff00ff",
    "gainsboro": "#dcdcdc", "ghostwhite": "#f8f8ff", "gold": "#ffd700", "goldenrod": "#daa520", "gray": "#808080", "green": "#008000", "greenyellow": "#adff2f",
    "honeydew": "#f0fff0", "hotpink": "#ff69b4",
    "indianred ": "#cd5c5c", "indigo": "#4b0082", "ivory": "#fffff0", "khaki": "#f0e68c",
    "lavender": "#e6e6fa", "lavenderblush": "#fff0f5", "lawngreen": "#7cfc00", "lemonchiffon": "#fffacd", "lightblue": "#add8e6", "lightcoral": "#f08080", "lightcyan": "#e0ffff", "lightgoldenrodyellow": "#fafad2",
    "lightgrey": "#d3d3d3", "lightgreen": "#90ee90", "lightpink": "#ffb6c1", "lightsalmon": "#ffa07a", "lightseagreen": "#20b2aa", "lightskyblue": "#87cefa", "lightslategray": "#778899", "lightsteelblue": "#b0c4de",
    "lightyellow": "#ffffe0", "lime": "#00ff00", "limegreen": "#32cd32", "linen": "#faf0e6",
    "magenta": "#ff00ff", "maroon": "#800000", "mediumaquamarine": "#66cdaa", "mediumblue": "#0000cd", "mediumorchid": "#ba55d3", "mediumpurple": "#9370d8", "mediumseagreen": "#3cb371", "mediumslateblue": "#7b68ee",
    "mediumspringgreen": "#00fa9a", "mediumturquoise": "#48d1cc", "mediumvioletred": "#c71585", "midnightblue": "#191970", "mintcream": "#f5fffa", "mistyrose": "#ffe4e1", "moccasin": "#ffe4b5",
    "navajowhite": "#ffdead", "navy": "#000080",
    "oldlace": "#fdf5e6", "olive": "#808000", "olivedrab": "#6b8e23", "orange": "#ffa500", "orangered": "#ff4500", "orchid": "#da70d6",
    "palegoldenrod": "#eee8aa", "palegreen": "#98fb98", "paleturquoise": "#afeeee", "palevioletred": "#d87093", "papayawhip": "#ffefd5", "peachpuff": "#ffdab9", "peru": "#cd853f", "pink": "#ffc0cb", "plum": "#dda0dd", "powderblue": "#b0e0e6", "purple": "#800080",
    "rebeccapurple": "#663399", "red": "#ff0000", "rosybrown": "#bc8f8f", "royalblue": "#4169e1",
    "saddlebrown": "#8b4513", "salmon": "#fa8072", "sandybrown": "#f4a460", "seagreen": "#2e8b57", "seashell": "#fff5ee", "sienna": "#a0522d", "silver": "#c0c0c0", "skyblue": "#87ceeb", "slateblue": "#6a5acd", "slategray": "#708090", "snow": "#fffafa", "springgreen": "#00ff7f", "steelblue": "#4682b4",
    "tan": "#d2b48c", "teal": "#008080", "thistle": "#d8bfd8", "tomato": "#ff6347", "turquoise": "#40e0d0",
    "violet": "#ee82ee",
    "wheat": "#f5deb3", "white": "#ffffff", "whitesmoke": "#f5f5f5",
    "yellow": "#ffff00", "yellowgreen": "#9acd32"};

for (var k in QText.colours) {
    var i = QText.colours[k];
    QText.textProfiles[k] = {fill: i};
    QText.textProfiles["s" + k] = {stroke: i};
}