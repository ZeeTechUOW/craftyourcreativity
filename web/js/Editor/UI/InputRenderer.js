/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var InputRenderer = {};
InputRenderer.funcs = {};
InputRenderer.doFunc = function (id, args1, args2, args3) {
    if (InputRenderer.funcs[id]) {
        InputRenderer.funcs[id](args1, args2, args3);
    }
};
InputRenderer.setFunc = function (id, func) {
    InputRenderer.funcs[id] = func;
};
InputRenderer.propertiesRow = function (content) {
    return "<div class='row propertiesRow'>" + content + "</div>\n";
};
InputRenderer.cb = function (id) {
    return "InputRenderer.doFunc('" + id + "', this);";
};
InputRenderer.label = function (labelName) {
    return "<div class='col-md-6 col-lg-4 propFieldContainer'><label class='propLabel'>" + labelName + "</label></div>\n";
};
InputRenderer.field = function (content) {
    return "<div class='col-md-6 col-lg-8 propFieldContainer'>" + content + "</div>\n";
};
InputRenderer.labelFieldOptions = function (labelName, field, options, fieldID) {
    return "<div class='col-xs-12 col-sm-12 col-md-6 col-lg-4 propFieldContainer'><label class='propLabel'>" + labelName + "</label></div>\n" +
            "<div " + (fieldID ? " id='" + fieldID + "' " : "") + " class='col-xs-12 col-sm-12 col-md-5 col-lg-7 propFieldContainer'>" + field + "</div>\n" +
            "<div class='col-xs-12 col-sm-12 col-md-1 col-lg-1 propFieldContainer'>" + options + "</div>\n";
};
InputRenderer.blurOnEnter = function () {
    return " onkeydown=\"if(event.keyCode === 13) {this.blur();}\" ";
};
InputRenderer.processValue = function (source) {
    var valueParent = source.valueParent;
    var value = source.value;
    var ext = source.ext;
    return function (elem) {
        var val = ext.getValueFromElement(elem);
        val = ext.validateNewValue(val, valueParent[value]);
        ext.renderValueToElem(val);
        if (valueParent.set) {
            valueParent.set(value, val, source);
        } else {
            valueParent[value] = val;
        }

        if (ext.onCompleted) {
            ext.onCompleted();
        }
    };
};
InputRenderer.addListener = function (source) {
    if (source.valueParent.addListener) {

        source.valueParent.addListener(source, source.value, function (newValue, res) {

            source.ext.renderValueToElem(newValue);
            return true;
        });
    }
};
InputRenderer.initExt = function (ext, id) {
    if (!ext.getValueFromElement) {
        ext.getValueFromElement = function (elem) {
            return elem.value;
        };
    }
    if (!ext.validateNewValue) {
        ext.validateNewValue = function (val) {
            return val;
        };
    }
    if (!ext.renderValueToElem) {
        ext.renderValueToElem = function (val) {
            var value = ext.formatValueToElem(val);
            $("#" + id).val(value);
        };
    }
    if (!ext.formatValueToElem) {
        ext.formatValueToElem = function (val) {
            return val;
        };
    }

    return ext;
};
InputRenderer.initRes = function (name, valueParent, value, ext, idPrefix) {
    if (!idPrefix)
        idPrefix = "A";
    if (!ext)
        ext = {};
    var res = {
        name: name,
        valueParent: valueParent,
        value: value
    };
    res.id = idPrefix + hashCode(name + value + uid());
    res.ext = InputRenderer.initExt(ext, res.id);
    res.onUpdated = InputRenderer.processValue(res);
    InputRenderer.addListener(res);
    InputRenderer.setFunc(res.id, res.onUpdated);
    res.type = "text";
    res.enterListener = "onchange";
    res.className = "propField";
    res.attrs = "";
    res.printField = function () {
        var v = ext.formatValueToElem(valueParent[value]);
        var e = InputRenderer.cb(res.id);
        var b = InputRenderer.blurOnEnter();
        if (ext.onInputKeydown) {
            InputRenderer.setFunc("ikd" + res.id, ext.onInputKeydown);
            b = "onkeydown=\"InputRenderer.doFunc('ikd" + res.id + "', this, event); if(event.keyCode === 13) {this.blur();}\"";
        }

        return "<input id=\"" + res.id + "\" type='" + this.type + "' class='" + this.className + "' value=\"" + v + "\" " + b + " " + this.enterListener + "=\"" + e + "\" " + this.attrs + " >";
    };
    res.print = function () {
        return InputRenderer.propertiesRow(InputRenderer.label(name) + InputRenderer.field(res.printField()));
    };
    res.printProperties = function () {
        return InputRenderer.propertiesRow(InputRenderer.label(name) + InputRenderer.field(res.printField()));
    };
    res.printDiagram = function () {
        return InputRenderer.propertiesRow(InputRenderer.label(name) + InputRenderer.field(res.printField()));
    };
    res.updateUI = function () {

    };
    return res;
};
InputRenderer.createTextField = function (name, valueParent, value, ext) {
    var res = InputRenderer.initRes(name, valueParent, value, ext, "Text");
    res.type = "text";
    res.className = "fieldText";
    res.enterListener = "onblur";
    return res;
};
InputRenderer.createFloatField = function (name, valueParent, value, ext) {
    if (!ext)
        ext = {};
    if (!ext.formatValueToElem) {
        ext.formatValueToElem = function (newValue) {
            if (isNaN(newValue))
                return newValue;
            return Math.round(newValue * 100) / 100;
        };
    }

    if (!ext.onInputKeydown) {
        ext.onInputKeydown = function (elem, event) {
            var empty = (!elem.value || elem.value.length <= 0);
            if (elem.type === "text" && empty) {
                elem.type = "number";
                elem.value = 0;
            }
            if (empty && event.keyCode === 219 && elem.type === "number") {
                elem.type = "text";
                elem.value = "";
            }
        };
    }

    var res = InputRenderer.initRes(name, valueParent, value, ext, "Float");
    res._printField = res.printField;
    res.printField = function () {
        if ((res.ext.formatValueToElem(valueParent[value]) + "").startsWith("{")) {
            res.type = "text";
        }
        return res._printField();
    };
    res.type = "number";
    res.className = "fieldFloat";
    res.attrs = "step='0.02'";
    return res;
};
InputRenderer.createIntField = function (name, valueParent, value, ext) {
    if (!ext)
        ext = {};
    if (!ext.onInputKeydown) {
        ext.onInputKeydown = function (elem, event) {
            var empty = (!elem.value || elem.value.length <= 0);
            if (elem.type === "text" && empty) {
                elem.type = "number";
                elem.value = 0;
            }
            if (empty && event.keyCode === 219 && elem.type === "number") {
                elem.type = "text";
                elem.value = "";
            }
        };
    }

    var res = InputRenderer.initRes(name, valueParent, value, ext, "Float");
    res._print = res.print;
    res.print = function () {
        if ((res.ext.formatValueToElem(valueParent[value]) + "").startsWith("{")) {
            res.type = "text";
        }
        return res._print();
    };
    res.type = "number";
    res.className = "fieldInt";
    res.attrs = "step='1'";
    return res;
};
InputRenderer.createBoolField = function (name, valueParent, value, ext) {
    if (!ext) {
        ext = {};
    }
    if (!ext.getValueFromElement) {
        ext.getValueFromElement = function (elem) {
            return elem.checked;
        };
    }

    var res = InputRenderer.initRes(name, valueParent, value, ext, "Bool");
    res.printField = function () {
        var v = res.ext.formatValueToElem(valueParent[value]);
        var e = InputRenderer.cb(res.id);
        var b = InputRenderer.blurOnEnter();
        if (res.ext.onInputKeydown) {
            InputRenderer.setFunc("ikd" + res.id, res.ext.onInputKeydown);
            b = "onkeydown=\"InputRenderer.doFunc('ikd" + res.id + "', this, event); if(event.keyCode === 13) {this.blur();}\"";
        }

        return "<input id=\"" + res.id + "\" type='checkbox' class='fieldBool' value=\"" + v + "\" " + (v ? "checked" : "") + " " + b + " onchange=\"" + e + "\" >";
    };
    return res;
};
InputRenderer.createSliderField = function (name, valueParent, value, ext) {
    var res = InputRenderer.initRes(name, valueParent, value, ext, "Slider");
    res.type = "range";
    res.className = "fieldSlider";
    var ll = res.ext.lowerLimit ? res.ext.lowerLimit : 0;
    var ul = res.ext.upperLimit ? res.ext.upperLimit : 1;
    var step = res.ext.step ? res.ext.step : .1;
    res.attrs = " min='" + ll + "' max='" + ul + "' step='" + step + "' ";
    return res;
};
InputRenderer.createDropdownField = function (name, valueParent, value, ext) {
    if (!ext)
        ext = {};
    if (!ext.getValueFromElement) {
        ext.getValueFromElement = function (elem) {
            return ext.data[ elem.selectedIndex ];
        };
    } else {
        ext._gve = ext.getValueFromElement;
        ext.getValueFromElement = function (elem) {
            return ext._gve(ext.data[ elem.selectedIndex ]);
        };
    }
    var res = InputRenderer.initRes(name, valueParent, value, ext, "Dropdown");
    res.printField = function () {
        var v = res.ext.formatValueToElem(valueParent[value]);
        var e = InputRenderer.cb(res.id);
        var str = "<select id=\"" + res.id + "\" class='fieldDropdown' onchange=\"" + e + "\" >";
        for (var k in res.ext.data) {
            var d = res.ext.formatValueToElem(res.ext.data[k]);
            str += "<option value='" + d + "' " + (d === v ? "selected" : "") + " class='fieldDropdownItem'>" + d + "</option>";
        }

        str += "</select>";
        return str;
    };
    return res;
};
InputRenderer.createActionDropdownField = function (name, ext) {
    if (!ext)
        ext = {};
    if (!ext.getValueFromElement) {
        ext.getValueFromElement = function (elem) {
            return ext.data[ elem.selectedIndex ];
        };
    } else {
        ext._gve = ext.getValueFromElement;
        ext.getValueFromElement = function (elem) {
            return ext._gve(ext.data[ elem.selectedIndex ]);
        };
    }
    var res = InputRenderer.initRes(name, {}, "", ext, "ActionDropdown");
    res.printField = function () {
        var className = "fieldActionDropdown";
        var dropdownClassName = "";
        if (res.ext.buttonClass) {
            className = res.ext.buttonClass;
        }
        if (res.ext.dropdownClass) {
            dropdownClassName = res.ext.dropdownClass;
        }
        var str = "<div class=\"btn-group fieldActionDropdownGroup\"><button type=\"button\" class=\"btn btn-default btn-sm dropdown-toggle " + className + "\" data-toggle=\"dropdown\" id=\"" + res.id + "\">" + name + " <span class=\"caret\"></span></button>";
        str += "<ul class=\"dropdown-menu " + dropdownClassName + "\">";
        for (var k in res.ext.data) {
            var d = res.ext.formatValueToElem(res.ext.data[k]);
            if (d) {

                if (res.ext.data[k].children) {
                    str +=
                            "<li class=\"dropdown-submenu\">\n" +
                            "<a tabindex=\"-1\" href=\"#\">" + d + "</a>\n" +
                            "<ul class=\"dropdown-menu dropdown-menu-right\">\n";
                    for (var j in res.ext.data[k].children) {
                        var e = res.ext.formatValueToElem(res.ext.data[k].children[j]);
                        InputRenderer.setFunc(res.id + "1" + k + "2" + j, res.ext.data[k].children[j].onclick);
                        str += "<li><a href='#' onclick=\"InputRenderer.doFunc('" + res.id + "1" + k + "2" + j + "')\">" + e + "</a></li>";
                    }

                    str +=
                            "</ul>\n" +
                            "</li>";
                } else {
                    InputRenderer.setFunc(res.id + "0" + k, res.ext.data[k].onclick);
                    str += "<li><a href='#' onclick=\"InputRenderer.doFunc('" + res.id + "0" + k + "')\">" + d + "</a></li>";
                }
            } else {
                str += "<li role=\"separator\" class=\"divider\"></li>";
            }

        }

        str += "</ul></div>";
        return str;
    };
    return res;
};
InputRenderer.createLinkField = function (name, valueParent, value, ext) {
    if (!ext) {
        ext = {};
    }
    if (ext.onCompleted) {
        ext._oc = ext.onCompleted;
        ext.onCompleted = function () {
            ext._oc();

            editor.diagramPanel.updateDiagramPanel();
        };
    } else {
        ext.onCompleted = function () {
            editor.diagramPanel.updateDiagramPanel();
        };
    }

    var res = InputRenderer.initRes(name, valueParent, value, ext, "Link");
    res.type = "text";
    res.className = "fieldLink";
    res.enterListener = "onblur";
//    res._pf = res.printField();
//    res.printField = function () {
//        return res._pf + "<button class='btn btn-default btn-xs fieldLinkButton' onclick='$(\"#" + res.id + "\").val(\">[frameNo]\");'' >H</button>";
//    };
    return InputRenderer.createOptionedField(name, res, {
        options: [
            {
                name: "Link To Frame",
                onclick: function () {
                    editor.prompt("Link To Frame", 0, function (newValue) {
                        if (!newValue || newValue.length < 1) {
                            return;
                        }
                        if (newValue === "Start" || newValue === "Next") {
                            $("#" + res.id).val(">" + newValue);
                            return;
                        }
                        var frameNo = parseInt(newValue);

                        if (isNaN(frameNo)) {
                            $.notify("Frame must be a number or either Start or Next", {position: "top right", className: "error"});
                            return;
                        }
                        $("#" + res.id).val(">" + frameNo);
                    });
                }
            }, {
                name: "Link To Diagram",
                onclick: function () {
                    editor.prompt("Link To Diagram", "A", function (newValue) {
                        if (!newValue || newValue.length < 1) {
                            return;
                        }

                        $("#" + res.id).val("#" + newValue);
                    });
                }

            }]
    });
};
InputRenderer.createColorField = function (name, valueParent, value, ext) {
    var res = InputRenderer.initRes(name, valueParent, value, ext, "Color");
    res.type = "jscolor";
    res.className = "jscolor fieldColor";
    res.updateUI = function () {
        var dom = document.getElementById(res.id);
        if (dom && !dom.jscolor) {
            dom.jscolor = new jscolor(dom, {});
        }
    };
    return res;
};
InputRenderer.createSeperator = function () {
    return {
        print: function () {
            return "<div class='fieldSeperator'><hr></div>\n";
        }
    };
};
InputRenderer.createLabel = function (name) {
    return {
        print: function () {
            return InputRenderer.propertiesRow("<h2 class='fieldLabel'>" + name + "</h2>");
        }
    };
};
InputRenderer.createButton = function (name, onclick, ext) {
    var res = InputRenderer.initRes(name, {}, "value", ext, "Button");
    InputRenderer.setFunc(res.id, onclick);
    res.printField = function () {
        return "<button id='" + res.id + "' onclick=\"this.blur(); " + InputRenderer.cb(res.id) + "\"  class='btn btn-default btn-md fieldButton'>" + name + "</button>";
    };
    res.print = function () {
        var str = "";
        if (res.ext.label) {
            str += InputRenderer.propertiesRow("<h3 class='fieldButtonLabel' > " + ext.label + " </h3>");
        }

        return str + InputRenderer.propertiesRow(res.printField());
    };
    return res;
};
InputRenderer.createImageField = function (name, valueParent, value, ext) {
    if (!ext)
        ext = {};
    if (!ext.renderValueToElem) {
        ext.renderValueToElem = function (newValue) {
            $("#" + res.id).val(newValue);
            $("#IMG" + res.id).attr("src", newValue);
        };
    }

    var res = InputRenderer.initRes(name, valueParent, value, ext, "Image");
    editor.context.propCallbacks["Func" + res.id] = function (newValue) {
        var val = res.ext.validateNewValue(newValue, valueParent[value]);

        if (valueParent.set) {
            valueParent.set(value, val, res);
        } else {
            valueParent[value] = val;
        }

        if (res.ext.onCompleted) {
            res.ext.onCompleted();
        }

        res.ext.renderValueToElem(val);
    };
    res.type = "url";
    res.className = "fieldImageText";
    res.attrs = "disabled";
    res._pf = res.printField;
    res.printField = function () {
        return res._pf() + "<button type='button' class='btn btn-default btn-xs fieldImageButton' onclick='this.blur(); openFileChooser(\"Choose Image\", \"IMAGE\", \"Func" + res.id + "\");'>Choose</button>\n";
    };
    res.print = function () {
        return InputRenderer.propertiesRow(InputRenderer.label(name) + InputRenderer.field(this.printField())) +
                "<div class='row propertiesRow fieldImageRowContainer'><img id='IMG" + res.id + "' src='" + editor.projectPath(valueParent[value]) + "' class='img-responsive propertiesImagePreview'></div>";
    };
    return res;
};
InputRenderer.createAudioField = function (name, valueParent, value, ext) {
    if (!ext)
        ext = {};
    if (!ext.renderValueToElem) {
        ext.renderValueToElem = function (newValue) {
            $("#" + res.id).val(newValue);
        };
    }

    var res = InputRenderer.initRes(name, valueParent, value, ext, "Audio");
    editor.context.propCallbacks["Func" + res.id] = function (newValue) {
        var val = res.ext.validateNewValue(newValue, valueParent[value]);
        if (valueParent.set) {
            valueParent.set(value, val, res);
        } else {
            valueParent[value] = val;
        }

        if (res.ext.onCompleted) {
            res.ext.onCompleted();
        }

        res.ext.renderValueToElem(val);
    };
    res.type = "url";
    res.className = "fieldAudioText";
    res.attrs = "disabled";
    res._pf = res.printField;
    res.printField = function () {
        return res._pf() + "<button type='button' class='btn btn-default btn-xs fieldAudioButton' onclick='this.blur(); openFileChooser(\"Choose Audio\", \"AUDIO\", \"Func" + res.id + "\");'>Choose</button>\n";
    };
    res.print = function () {
        return InputRenderer.propertiesRow(InputRenderer.label(name) + InputRenderer.field(this.printField()));
    };
    return res;
};
InputRenderer.createRichTextField = function (name, valueParent, value, ext) {
    if (!ext)
        ext = {};
    if (!ext.validateNewValue) {
        ext.validateNewValue = function (newValue) {
            return newValue.trim();
        };
    } else {
        ext._vnv = ext.validateNewValue;
        ext.validateNewValue = function (newValue, oldValue) {
            return ext._vnv(newValue.trim(), oldValue);
        };
    }
    if (!ext.renderValueToElem) {
        ext.renderValueToElem = function (newValue) {
            $("#" + res.id).html(newValue);
            return true;
        };
    }

    var res = InputRenderer.initRes(name, valueParent, value, ext, "TextArea");
    if (!res.ext.eventType) {
        res.ext.eventType = "onblur";
    }
    res.printField = function () {
        var v = ext.formatValueToElem(valueParent[value]);
        return "<textarea id='" + res.id + "' name='" + name + "' class='form-control fieldRichText' " + res.ext.eventType + "=\"" + InputRenderer.cb(res.id) + "\">" + v + "</textarea>";
    };
    res.print = function () {
        return InputRenderer.propertiesRow(InputRenderer.label(name) + InputRenderer.field("<button class='btn btn-default btn-sm fieldRichTextButton' onclick='this.blur(); openTagEditor();'>Tags</button>")) +
                InputRenderer.propertiesRow(res.printField());
    };
    return res;
};
InputRenderer.createOptionedField = function (name, field, ext) {
    if (!ext) {
        ext = {};
    }
    var res = field;
    res.print = function () {
        return InputRenderer.propertiesRow(InputRenderer.labelFieldOptions(name, res.printField(), InputRenderer.createActionDropdownField("", {
            dropdownClass: "dropdown-menu-right",
            data: ext.options,
            formatValueToElem: function (d) {
                if (d)
                    return d.name;
                else
                    return null;
            },
            validateNewValue: function (d) {
                d.onclick();
                return d;
            }
        }).printField(), ext.fieldAnchorID));
    };
    return res;
};
InputRenderer.createAnyField = function (name, valueParent, value, ext) {
    if (!ext) {
        ext = {};
    }

    if (!valueParent[value] || !valueParent[value].type) {
        valueParent[value] = {
            type: "TEXT",
            value: ""
        };
    }
    if (!ext.formatValueToElem) {
        ext.formatValueToElem = function (val) {
            return val.value;
        };
    } else {
        ext._fve = ext.formatValueToElem;
        ext.formatValueToElem = function (val) {
            return ext._fve(val.value);
        };
    }
    if (!ext.validateNewValue) {
        ext.validateNewValue = function (d) {
            return d;
        };
    }


    var textRes = InputRenderer.createTextField(name, valueParent, value, $.extend({}, ext, {
        validateNewValue: function (v) {
            return ext.validateNewValue({type: "TEXT", value: v}, valueParent[value]);
        }
    }));
    var floatRes = InputRenderer.createFloatField(name, valueParent, value, $.extend({}, ext, {
        validateNewValue: function (v) {
            return ext.validateNewValue({type: "NUMBER", value: v}, valueParent[value]);
        }
    }));
    var colorRes = InputRenderer.createColorField(name, valueParent, value, $.extend({}, ext, {
        validateNewValue: function (v) {
            return ext.validateNewValue({type: "COLOR", value: v}, valueParent[value]);
        }
    }));
    var richTextRes = InputRenderer.createRichTextField(name, valueParent, value, $.extend({}, ext, {
        validateNewValue: function (v) {
            return ext.validateNewValue({type: "RICHTEXT", value: v}, valueParent[value]);
        }
    }));
    var res = InputRenderer.initRes(name, valueParent, value, ext, "ANY");
    var opts = [{
            name: "Text",
            onclick: function () {
                valueParent[value].type = "TEXT";
                $("#" + res.id).html(textRes.printField());
            }
        }, {
            name: "Number",
            onclick: function () {
                valueParent[value].type = "NUMBER";
                $("#" + res.id).html(floatRes.printField());
            }
        }, {
            name: "Color",
            onclick: function () {
                valueParent[value].type = "COLOR";
                $("#" + res.id).html(colorRes.printField());
                colorRes.updateUI();
            }
        }, {
            name: "Rich Text",
            onclick: function () {
                valueParent[value].type = "RICHTEXT";
                $("#" + res.id).html(richTextRes.printField());
            }
        }
    ];
    if (res.ext.extraOptions) {
        opts.push(null);
        for (var k in res.ext.extraOptions) {
            opts.push(res.ext.extraOptions[k]);
        }
    }

    switch (valueParent[value].type) {
        case "TEXT":
            res.printField = textRes.printField;
            break;
        case "NUMBER":
            res.printField = floatRes.printField;
            res.updateUI = floatRes.updateUI;
            break;
        case "COLOR":
            res.printField = colorRes.printField;
            res.updateUI = colorRes.updateUI;
            break;
        case "RICHTEXT":
            res.printField = richTextRes.printField;
            break;
    }

    return InputRenderer.createOptionedField(name, res, {
        options: opts,
        fieldAnchorID: res.id
    });
};
InputRenderer.createActionArray = function (name, valueParent, value, ext) {
    if (!ext) {
        ext = {};
    }
    var id = "ActionArray" + uid();
    ext = InputRenderer.initExt(ext, id);
    return {
        ext: ext,
        id: id,
        children: [],
        addActionToData: function (action) {
            if (action)
                this.getDataArray().push(action);
        },
        getDataArray: function () {
            return this.ext.formatValueToElem(valueParent[value]);
        },
        moveUp: function (index) {
            var arr = this.getDataArray();
            if (index > 0) {
                var temp = arr[index];
                arr[index] = arr[index - 1];
                arr[index - 1] = temp;
                return true;
            }
            return false;
        },
        moveDown: function (index) {
            var arr = this.getDataArray();
            if (arr.length <= index + 1) {
                var temp = arr[index];
                arr[index] = arr[index + 1];
                arr[index + 1] = temp;
                return true;
            }
            return false;
        },
        delete: function (index) {
            var arr = this.getDataArray();
            arr.splice(index, 1);
        },
        getRefreshedContent: function () {
            this.children = [];
            var that = this;
            var str = "";
            var arr = this.getDataArray();
            for (var k in arr) {
                var action = arr[k];
                var name = action.actionName;
                str += "<div class='propActionGroup'>" +
                        InputRenderer.propertiesRow(
                                "<div class='propActionGroupName'>" + name + "</div>" +
                                "<div class='propActionGroupContextMenu'>" +
                                InputRenderer.createActionDropdownField("", {
                                    dropdownClass: "dropdown-menu-right",
                                    data: [{name: "Move Up", onclick: (function (c) {
                                                return function () {
                                                    if (that.moveUp(c)) {
                                                        that.refreshContent();
                                                    }
                                                };
                                            }(k))}, {name: "Move Down", onclick: (function (c) {
                                                return function () {
                                                    if (that.moveDown(c)) {
                                                        that.refreshContent();
                                                    }
                                                };
                                            }(k))}, null, {name: "Delete", onclick: (function (c) {
                                                return function () {
                                                    that.delete(c);
                                                    that.refreshContent();
                                                };
                                            }(k))}
                                    ],
                                    formatValueToElem: function (d) {
                                        if (d)
                                            return d.name;
                                        else
                                            return null;
                                    },
                                    validateNewValue: function (d) {
                                        d.onclick();
                                        return d;
                                    }
                                }).printField() +
                                "</div>");

                if (action.isEntityAction) {
                    str += InputRenderer.createIntField("Offset (ms)", action, "offset").print();
                    str += InputRenderer.createIntField("Duration (ms)", action, "duration").print();
                    str += InputRenderer.createDropdownField("Easing", action, "easing", {
                        data: Action.Easings,
                        formatValueToElem: function (d) {
                            return d.name;
                        }
                    }).print();

                    var valueList = InputRenderer.createObjectField("", action.stateMatrix, {
                        modifyable: false,
                        type: "ENTITY"
                    });
                    this.children.push(valueList);
                    str += valueList.print();

                } else if (action.isLinkAction) {
                    var valueList = InputRenderer.createObjectField("", action.stateMatrix, {
                        modifyable: false,
                        type: "LINK"
                    });
                    this.children.push(valueList);
                    str += valueList.print();

                } else if (action.isDataAction) {

                    str += InputRenderer.createTextField("dvarName", action.stateMatrix, "dvarName").print();
                    str += InputRenderer.createTextField("dvalue", action.stateMatrix, "dvalue").print();
                } else if (action.isAudioAction) {

                    str += InputRenderer.createAudioField("audioSrc", action.stateMatrix, "audioSrc").print();
                    str += InputRenderer.createSliderField("volume", action.stateMatrix, "volume", {
                        lowerLimit: 0, upperLimit: 1, step: .01
                    }).print();
                    str += InputRenderer.createDropdownField("channel", action.stateMatrix, "channel", {
                        data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                        formatValueToElem: function (d) {
                            if (d === 0)
                                return "Auto";
                            return d;
                        }
                    }).print();
                    str += InputRenderer.createBoolField("frameStop", action.stateMatrix, "frameStop").print();
                    str += InputRenderer.createBoolField("loop", action.stateMatrix, "loop").print();
                    str += InputRenderer.createBoolField("waitAudio", action.stateMatrix, "waitAudio").print();
                }

                str += "</div>\n";

            }

            return str;
        },
        refreshContent: function () {
            console.log(this.id);
            $("#Content" + this.id).html(this.getRefreshedContent());
        },
        print: function () {
            var res = "<div><div>";
            res += InputRenderer.createLabel(name).print();

            var that = this;
            var entityActions = [{name: "Position", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            posx: valueParent.entityProperty.posx,
                            posy: valueParent.entityProperty.posy
                        }));
                        that.refreshContent();
                    }}, {name: "Rotation", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            rotation: valueParent.entityProperty.rotation
                        }));
                        that.refreshContent();
                    }}, {name: "Scale", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            scalex: valueParent.entityProperty.scalex,
                            scaley: valueParent.entityProperty.scaley
                        }));
                        that.refreshContent();
                    }}, {name: "Tint", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            tint: valueParent.shadingProperty.tint
                        }));
                        that.refreshContent();
                    }}, {name: "Alpha", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            alpha: valueParent.shadingProperty.alpha
                        }));
                        that.refreshContent();
                    }}
            ];
            if (valueParent.isAQSprite) {
                entityActions.push({name: "Image Source", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            src: valueParent.src
                        }));
                        that.refreshContent();
                    }});
            } else if (valueParent.isAButton) {
                entityActions.push({name: "Button Text", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            text: valueParent.text
                        }));
                        that.refreshContent();
                    }});
                entityActions.push({name: "Button Link", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            link: valueParent.link
                        }));
                        that.refreshContent();
                    }});
                entityActions.push({name: "Image Source", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            normSrc: valueParent.normSrc
                        }));
                        that.refreshContent();
                    }});

            } else if (valueParent.isAQText) {
                entityActions.push({name: "Text", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            text: valueParent.text
                        }));
                        that.refreshContent();
                    }});
                entityActions.push({name: "Word Wrap", onclick: function () {
                        that.addActionToData(Action.basicAction(valueParent, {
                            wordWrap: valueParent.wordWrap
                        }));
                        that.refreshContent();
                    }});

            }

            res += "</div><div id='Content" + this.id + "' class='propActArrContent'>";
            res += this.getRefreshedContent();
            res += "</div>";
            res += "<div>";
            res += InputRenderer.createActionDropdownField("Add Action", {
                buttonClass: "fieldAddActionButton",
                dropdownClass: "fieldAddActionDropdown",
                data: [
                    {name: "Link Action", onclick: function () {
                            console.log("CCC");
                            that.addActionToData(Action.linkAction(">1"));
                            that.refreshContent();
                        }},
                    {name: "Data Action", onclick: function () {
                            that.addActionToData(Action.dataAction("aVariable", ""));
                            that.refreshContent();
                        }},
                    {name: "Audio Action", onclick: function () {
                            that.addActionToData(Action.audioAction({
                                audioSrc: "",
                                volume: 1,
                                channel: 0,
                                frameStop: false,
                                waitAudio: false,
                                loop: false
                            }));
                            that.refreshContent();
                        }},
                    {name: "Entity Action", children: entityActions}

                ],
                formatValueToElem: function (d) {
                    if (d)
                        return d.name;
                    else
                        return null;
                },
                validateNewValue: function (d) {
                    d.onclick();
                    return d;
                }}).printField();
            res += "</div>";
            res += "</div>";
            return res;
        },
        updateUI: function () {
            for (var k in this.children) {
                if (this.children[k].updateUI) {
                    this.children[k].updateUI();
                }
            }
        }
    };
};
InputRenderer.createDualField = function (field1, field2) {
    return {
        field1: field1,
        field2: field2,
        print: function () {
            return InputRenderer.propertiesRow(
                    "   <div class='col-sm-6 col-md-3 col-lg-2 propDualFieldContainer'><label class='propLabel'>" + field1.name + "</label></div>\n" +
                    "   <div class='col-sm-6 col-md-3 col-lg-4 propDualFieldContainer'>" + field1.printField() + "</div>\n" +
                    "   <div class='clearfix visible-sm-block'></div>" +
                    "   <div class='col-sm-6 col-md-3 col-lg-2 propDualFieldContainer'><label class='propLabel'>" + field2.name + "</label></div>\n" +
                    "   <div class='col-sm-6 col-md-3 col-lg-4 propDualFieldContainer'>" + field2.printField() + "</div>\n");
        },
        updateUI: function () {

        }
    };
};
InputRenderer.createDualButton = function (field1, field2) {
    return {
        field1: field1,
        field2: field2,
        print: function () {
            return InputRenderer.propertiesRow(
                    "   <div class='col-xs-12 col-md-6 col-lg-6 propDualButtonContainer'>" + field1.printField() + "</div>\n" +
                    "   <div class='col-xs-12 col-md-6 col-lg-6 propDualButtonContainer'>" + field2.printField() + "</div>\n");
        },
        updateUI: function () {

        }
    };
};
InputRenderer.createGroup = function (name) {
    return {
        groupName: name,
        htmlOpener: "<div>" +
                "    <button class='propertiesRowGroupHeader' data-toggle='collapse' data-target='#c" + hashCode(name) + "' >" + name + "</button>" +
                "    <div id='c" + hashCode(name) + "' class='collapse'>",
        htmlCloser: "</div></div>\n",
        children: [],
        print: function () {
            var res = this.htmlOpener;
            for (var k in this.children) {
                res += this.children[k].print();
            }

            return res + this.htmlCloser;
        },
        updateUI: function () {
            for (var k in this.children) {
                if (this.children[k].updateUI) {
                    this.children[k].updateUI();
                }
            }
        },
        insert: function (index, panel) {
            if (!panel) {
                panel = index;
                this.children.push(panel);
            } else {
                this.children.splice(index, 0, panel);
            }
        }
    };
};
InputRenderer.createObjectField = function (name, arrayObject, ext) {

    return {
        arrayObject: arrayObject,
        ext: ext,
        type: ext.type,
        modifyable: ext.modifyable,
        id: uid(),
        children: [],
        getRefreshedContent: function () {
            var res = "";
            this.children = [];
            var that = this;
            for (var k in this.arrayObject) {
                if (this.type === "TEXT") {
                    var r = InputRenderer.createTextField(k, arrayObject, k, ext);
                    this.children.push(r);
                } else if (this.type === "LINK") {
                    this.children.push(InputRenderer.createLinkField(k, arrayObject, k, ext));
                } else if (this.type === "COLOR") {
                    this.children.push(InputRenderer.createColorField(k, arrayObject, k, ext));
                } else if (this.type === "FLOAT") {
                    this.children.push(InputRenderer.createFloatField(k, arrayObject, k, ext));
                } else if (this.type === "RICHTEXT") {
                    this.children.push(InputRenderer.createRichTextField(k, arrayObject, k, ext));
                } else if (this.type === "IMAGE") {
                    this.children.push(InputRenderer.createImageField(k, arrayObject, k, ext));
                } else if (this.type === "ENTITY") {
                    this.children.push(InputRenderer.createEntityPropSingleField(arrayObject, k, k, {
                        isFlat: true,
                        onCompleted: this.ext.onCompleted
                    }));
                } else if (this.type === "ANY") {

                    this.children.push(InputRenderer.createAnyField(k, this.arrayObject, k, function (c) {
                        return {
                            extraOptions: [
                                {
                                    name: "Rename",
                                    onclick: function () {
                                        editor.prompt("New Name", c, function (newName) {
                                            if (!newName) {
                                                return;
                                            }
                                            newName = newName.replace(/[^a-zA-Z0-9_]/gi, '').replace(/[^a-zA-Z]/, "_");
                                            if (!newName || newName.length <= 0) {
                                                return;
                                            }

                                            that.arrayObject[newName] = that.arrayObject[c];
                                            delete that.arrayObject[c];
                                            $("#ArrContent" + that.id).html(that.getRefreshedContent());


                                            if (ext.onCompleted) {
                                                ext.onCompleted();
                                            }
                                        });
                                    }
                                }, {
                                    name: "Delete",
                                    onclick: function () {
                                        delete that.arrayObject[c];
                                        $("#ArrContent" + that.id).html(that.getRefreshedContent());

                                        if (ext.onCompleted) {
                                            ext.onCompleted();
                                        }
                                    }
                                }
                            ]
                        };
                    }(k)));
                } else {
                    this.children.push(InputRenderer.createTextField(k, this.arrayObject, k));
                }
            }
            for (var k in this.children) {
                res += this.children[k].print();
            }
            return res;
        },
        print: function () {
            var res = "<div><div>";
            if (name && name.length > 0)
                res += InputRenderer.createLabel(name).print();
            res += "</div><div id='ArrContent" + this.id + "' class='propArrContent'>";
            res += this.getRefreshedContent();
            res += "</div>";
            if (this.modifyable) {
                var that = this;
                res += "<div>";
                res += InputRenderer.createButton("+", function (elem) {
                    editor.prompt("New Variable Name", "newVariable", function (newName) {
                        if (!newName) {
                            return;
                        }
                        newName = newName.replace(/[^a-zA-Z0-9_]/gi, '').replace(/[^a-zA-Z]/, "_");
                        if (!newName || newName.length <= 0) {
                            return;
                        }

                        that.arrayObject[newName] = "";
                        $("#ArrContent" + that.id).html(that.getRefreshedContent());

                        if (ext.onCompleted) {
                            ext.onCompleted();
                        }
                    });
                }).print();
                res += "</div>";
            }

            res += "</div>";
            return res;
        },
        updateUI: function () {
            for (var k in this.children) {
                if (this.children[k].updateUI) {
                    this.children[k].updateUI();
                }
            }
        }
    };
};
InputRenderer.createAnchor = function (id) {
    return {
        id: id,
        print: function () {
            return "<div id='" + this.id + "'></div>";
        },
        updateUI: function () {

        }
    };
};
InputRenderer.createEntityPropField = function (entity, propertyName, labelName, ext) {
    if (propertyName.constructor !== Array) {
        propertyName = [propertyName];
    }

    if (!ext) {
        ext = {};
    }
    if (ext.validateNewValue) {
        ext.__vnv = ext.validateNewValue;
        ext.validateNewValue = function (newValue, oldValue) {
            var value = ext.__vnv(newValue, oldValue);

            if (propertyName[0] === "name") {
                editor.context.addEdit(Edit.editEntityEdit(entity, entity.originalScene, entity.originalScene.activeFrame, {name: value}, "Edit", {name: oldValue}));

            } else if (editor.activeScene && !editor.activeScene.activeFrame) {
                if (propertyName[0] === "text") {
                    var stateData = {};
                    stateData[propertyName[0]] = value;
                    var prevStateData = {};
                    prevStateData[propertyName[0]] = oldValue;
                    
                    editor.context.addEdit(Edit.editEntityEdit(entity, entity.originalScene, null, stateData, "Edit", prevStateData).setCombineSignal("TEXT" + entity.entityID));

                } else {
                    var stateData = {};
                    stateData[propertyName[0]] = value;
                    var prevStateData = {};
                    prevStateData[propertyName[0]] = oldValue;
                    editor.context.addEdit(Edit.editEntityEdit(entity, entity.originalScene, null, stateData, "Edit", prevStateData));
                }
            }


            return value;
        };
    } else {
        ext.validateNewValue = function (newValue, oldValue) {
            var value = newValue;

            if (propertyName[0] === "name") {
                editor.context.addEdit(Edit.editEntityEdit(entity, entity.originalScene, entity.originalScene.activeFrame, {name: value}, "Edit", {name: oldValue}));

            } else if (editor.activeScene && !editor.activeScene.activeFrame) {
                if (propertyName[0] === "text") {
                    var stateData = {};
                    stateData[propertyName[0]] = value;
                    var prevStateData = {};
                    prevStateData[propertyName[0]] = oldValue;

                    editor.context.addEdit(Edit.editEntityEdit(entity, entity.originalScene, null, stateData, "Edit", prevStateData).setCombineSignal("TEXT" + entity.entityID));

                } else {
                    var stateData = {};
                    stateData[propertyName[0]] = value;
                    var prevStateData = {};
                    prevStateData[propertyName[0]] = oldValue;
                    editor.context.addEdit(Edit.editEntityEdit(entity, entity.originalScene, null, stateData, "Edit", prevStateData));
                }
            }

            return value;
        };
    }

    var name = (labelName ? labelName : propertyName[0]);
    var fields = [];
    for (var k in propertyName) {
        var pname = propertyName[k];
        fields[k] = InputRenderer.createEntityPropSingleField(entity, pname, name, ext);
    }

    if (fields.length === 1) {
        return fields[0];
    } else if (fields.length === 2) {
        fields[0].name = propertyName[0];
        fields[1].name = propertyName[1];
        return InputRenderer.createDualField(fields[0], fields[1]);
    } else if (fields.length > 2) {
        var group = InputRenderer.createGroup(name);
        for (var k in fields) {
            group.insert(fields[k]);
        }
        return group;
    }
};
InputRenderer.createEntityPropSingleField = function (entity, propertyName, name, ext) {
    if (!ext)
        ext = {};
    var isFlat = ext.isFlat;
    switch (propertyName) {
        case "name":
            ext.entity = entity;
            if (ext.validateNewValue) {
                ext._vnv = ext.validateNewValue;
                ext.validateNewValue = function (newValue, oldValue) {
                    if (this.entity.name === newValue)
                        return newValue;

                    var value = incrementIfDuplicate(
                            newValue,
                            this.entity.originalScene.children,
                            function (e) {
                                return e.name;
                            }
                    );
                    return ext._vnv(value, oldValue);
                };
            } else {
                ext.validateNewValue = function (newValue) {
                    if (this.entity.name === newValue)
                        return newValue;

                    var value = incrementIfDuplicate(
                            newValue,
                            this.entity.originalScene.children,
                            function (e) {
                                return e.name;
                            }
                    );
                    return value;
                };
            }

            return InputRenderer.createTextField(name, entity, propertyName, ext);
        case "posx":
        case "posy":
            return InputRenderer.createIntField(name, (isFlat ? entity : entity.entityProperty), propertyName, ext);
        case "wordWrap":
        case "fontSize":
            ext.step = 50;
            return InputRenderer.createIntField(name, entity, propertyName, ext);
        case "scalex":
        case "scaley":
        case "rotation":
            return InputRenderer.createFloatField(name, (isFlat ? entity : entity.entityProperty), propertyName, ext);
        case "alpha":
            ext.lowerLimit = 0;
            ext.upperLimit = 1;
            ext.step = 0.01;
            return InputRenderer.createSliderField(name, (isFlat ? entity : entity.shadingProperty), propertyName, ext);
        case "tint":
            return InputRenderer.createColorField(name, (isFlat ? entity : entity.shadingProperty), propertyName, ext);
        case "color":
            if (ext.validateNewValue) {
                ext._vnv = ext.validateNewValue;

                ext.validateNewValue = function (v, oldValue) {
                    return "#" + ext._vnv(v, oldValue);
                };
            } else {
                ext.validateNewValue = function (v) {
                    return "#" + v;
                };
            }
            return InputRenderer.createColorField(name, entity, propertyName, ext);
        case "src":
        case "normSrc":
            ext._onCompleted = ext.onCompleted;
            ext.onCompleted = function () {
                entity.sprite.texture = PIXI.Texture.fromImage(editor.projectPath(entity[propertyName]));
                if (ext._onCompleted)
                    ext._onCompleted();
            };
            return InputRenderer.createImageField(name, entity, propertyName, ext);
        case "text":
            ext.eventType = "oninput";
            return InputRenderer.createRichTextField(name, entity, propertyName, ext);
        case "font":
            return InputRenderer.createTextField(name, entity, propertyName, ext);
        case "link":
            return InputRenderer.createLinkField(name, entity, propertyName, ext);
        case "anchorx":
            ext.data2 = ["Left", "Center", "Right"];
            ext.data = [0, 0.5, 1];
            ext.formatValueToElem = function (d) {
                return this.data2[d * 2];
            };
            return InputRenderer.createDropdownField(name, entity.entityProperty, propertyName, ext);
        case "anchory":
            ext.data2 = ["Top", "Middle", "Bottom"];
            ext.data = [0, 0.5, 1];
            ext.formatValueToElem = function (d) {
                return this.data2[d * 2];
            };
            return InputRenderer.createDropdownField(name, entity.entityProperty, propertyName, ext);
        case "align":
            ext.data = ["Left", "Center", "Right"];
            ext.formatValueToElem = function (d) {
                return d;
            };
            return InputRenderer.createDropdownField(name, entity, propertyName, ext);
        default:
            return InputRenderer.createTextField(name, entity, propertyName, ext);
    }
};