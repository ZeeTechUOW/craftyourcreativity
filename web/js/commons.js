/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

if (typeof String.prototype.endsWith !== 'function') {
    String.prototype.endsWith = function (suffix) {
        return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
}

function isDefined(target, path) {
    if (typeof path === "undefined" || path === null) {
        return !(typeof target === 'undefined' || target === null);
    } else {
        if (typeof target !== 'object' || target === null) {
            return false;
        }

        var parts = path.split('.');

        while (parts.length) {
            var branch = parts.shift();
            if (!(branch in target)) {
                return false;
            }

            target = target[branch];
        }

        return true;
    }
}

function setDefault(obj, propName, propVal) {
    if (!isDefined(obj))
        obj = {};
    if (isDefined(propVal)) {
        if (!isDefined(obj, propName))
            obj[propName] = propVal;
    } else {
        for (var k in propName) {
            if (!isDefined(obj, k))
                obj[k] = propName[k];
        }
    }
    return obj;
}

function incrementIfDuplicate(source, targetArray, getFromArray) {
    var i = 1;
    var newSource = source;
    while (true) {
        var b = true;
        for (var s in targetArray) {
            if (getFromArray(targetArray[s]) === newSource) {
                b = false;
                break;
            }
        }
        if (b)
            break;
        newSource = source + (i++);
    }

    return newSource;
}

function generateListCF(classPrototype, elementName, targetList, paths, callbacks) {
    function cb(prop) {
        if (isDefined(callbacks, prop))
            callbacks[prop]();
    }

    classPrototype["add" + elementName] = (function (targetList, cb) {
        return function (element) {
            cb("Add");
            targetList.push(element);
        };
    })(targetList, cb);

    classPrototype["get" + elementName + "ByNo"] = (function (targetList, cb) {
        return function (no) {
            var n = targetList[no];
            if (n)
                cb("Get");
            cb("GetByNo");
            return n;
        };
    })(targetList, cb);

    for (var p in paths) {
        classPrototype["get" + elementName + "By" + p] = (function (targetList, cb) {
            return function (pt) {
                for (var i = 0; i < targetList.length; i++) {
                    if (paths[p](targetList[i]) === pt) {
                        cb("Get");
                        cb("GetBy" + p);
                        return targetList[i];
                    }
                }
                return null;
            };
        })(targetList, cb);
    }

    classPrototype["get" + elementName] = (function (classPrototype, elementName) {
        return function (obj) {
            var n = classPrototype["get" + elementName + "ByNo"](obj);
            if (n) {
                return n;
            }

            for (var p in paths) {
                n = classPrototype["get" + elementName + "By" + p](obj);
                if (n) {
                    return n;
                }
            }
            return n;
        };
    })(classPrototype, elementName);

    classPrototype["remove" + elementName + "ByNo"] = (function (targetList, cb) {
        return function (no) {
            if (no >= targetList.length)
                return false;
            targetList.splice(no, 1);
            cb("Remove");
            cb("RemoveByNo");
            return true;
        };
    })(targetList, cb);

    classPrototype["remove" + elementName + "ByObject"] = (function (targetList, cb) {
        return function (obj) {
            var n = targetList.indexOf(obj);
            if (n >= 0) {
                cb("Remove");
                cb("RemoveByObject");
                targetList.splice(n, 1);
                return n;
            }
            return -1;
        };
    })(targetList, cb);

    for (var p in paths) {
        classPrototype["remove" + elementName + "By" + p] = (function (targetList, cb) {
            return function (pt) {
                for (var i = 0; i < targetList.length; i++) {
                    if (paths[p](targetList[i]) === pt) {
                        cb("Remove");
                        cb("RemoveBy" + p);
                        targetList.splice(i, 1);
                        return i;
                    }
                }
                return -1;
            };
        })(targetList, cb);
    }

    classPrototype["remove" + elementName] = (function (classPrototype, elementName) {
        return function (obj) {
            var n = classPrototype["remove" + elementName + "ByObject"](obj);
            if (n >= 0) {
                return n;
            }

            for (var p in paths) {
                n = classPrototype["remove" + elementName + "By" + p](obj);
                if (n >= 0) {
                    return n;
                }
            }

            return classPrototype["remove" + elementName + "ByNo"](obj);
        };
    })(classPrototype, elementName);
}

function setupListener(model) {
    model.listeners = {};
    model.mListeners = [];
    model.addListener = function (source, key, callback) {
        if (!model.listeners[key])
            model.listeners[key] = [];
        model.listeners[key].push({src: source, cb: callback});
    };
    model.addListeners = function (source, keys, callback) {
        model.mListeners.push({src: source, cb: callback, keys: keys});
    };
    model.set = function (key, value, src) {
        model[key] = value;
        for (var k in model.listeners[key]) {
            if (!src || src !== model.listeners[key][k].src) {
                if (!model.listeners[key][k].cb(value, model.listeners[key][k].src)) {
                    model.listeners[key].splice(k, 1);
                }
            }
        }
        for (var k in model.mListeners) {
            var curLis = model.mListeners[k];

            if (curLis.keys) {
                for (var j in curLis.keys) {
                    if (curLis.keys[j] === key && (!src || src !== curLis.src)) {
                        if (!curLis.cb(value, key, curLis.src)) {
                            model.mListeners.splice(k, 1);
                        }
                    }
                }
            } else {
                if (!src || src !== curLis.src) {
                    if (!curLis.cb(value, key, curLis.src)) {
                        model.mListeners.splice(k, 1);
                    }
                }
            }

        }
    };
}

function cpy(from, target, keys, filter) {
    if(!filter) filter = function (r) {return r;};
    
    for (var j in keys) {
        var key = keys[j];

        if (target[key] !== from[key])
            if (target.set)
                target.set(key, filter(from[key]), from);
            else
                target[key] = filter(from[key]);
    }
}

function hashCode(str) {
    var hash = 0;
    if (str.length === 0)
        return hash;
    for (i = 0; i < str.length; i++) {
        char = str.charCodeAt(i);
        hash = ((hash << 5) - hash) + char;
        hash = hash & hash; // Convert to 32bit integer
    }
    return hash < 0 ? -hash : hash;
}

function hexToRgb(hex) {
    var x = hex.toString(16);
    while (x.length < 6)
        x = "0" + x;
    return "#" + x;
}

function replaceDom(id, newHTML) {
    $("#" + id).replaceWith(newHTML);
}

function isIEorEDGE() {
    return navigator.appName === 'Microsoft Internet Explorer' || (navigator.appName === "Netscape" && navigator.appVersion.indexOf('Edge') > -1) || (navigator.appName === "Netscape" && navigator.appVersion.indexOf('Trident') > -1);
}

var _lastUniqueIdentifier = 1;

function uid() {
    _lastUniqueIdentifier += 1;
    return _lastUniqueIdentifier;
}
function uuid() {
    return _lastUniqueIdentifier;
}
function reset_uid(val) {
    if (!val) val = 0;
    _lastUniqueIdentifier = val + 1;
}