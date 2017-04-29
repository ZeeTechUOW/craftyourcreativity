/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Project(context) {
    this.context = context;
    context.project = this;
    
    this.projectName = "Project1";
    this.projectID = uid();
    this.version = "1.0.0";
    this.description = "";
    this.author = "Matthew";

    this.windowSize = {x: 800, y:600};

    this.dataVariables = {
        
    };
    
    this.lastUpdated;

    setupListener(this);

    this.scenes = [];

    this.scenes[0] = new Scene(context, "Scene");
    this.scenes[0].sceneNo = 0;

    this.initialScene = this.scenes[0];

    generateListCF(this, "Scene", this.scenes, {
        Name: function (s) {
            return s.sceneName;
        }
    });

    this._addScene = this.addScene;
    this.addScene = function (name) {
        if (name.isAScene) {
            name.no = this.scenes.length;
            this._addScene(name);
        } else {
            var newName = incrementIfDuplicate(name, this.scenes, function (scene) {
                return scene.sceneName;
            });

            var s = new Scene(this.context, newName);
            s.no = this.scenes.length;
            this.scenes.push(s);
        }
        this.context.editor.changeScene(this.scenes.length - 1);
    };

    this.serialize = function () {
        var p = this;
        var scenes = {};

        for (var s in p.scenes) {
            scenes[s] = p.scenes[s].serialize();
        }

        var res = {};
        res.scenes = scenes;
        for (var s in Project.serializable) {
            var ss = Project.serializable[s];
            res[ss] = p[ss];
        }
        
        var ns = p.context.editor.diagramPanel.nodes;
        var nodes = [];
        for( var k in ns ) {
            nodes[k] = ns[k].serialize();
        }
        res.nodes = nodes;
        
        res.windowSizeX = p.windowSize.x;
        res.windowSizeY = p.windowSize.y;
        res.initialScene = p.initialScene.sceneID;
        
        res.dataVariables = p.dataVariables;
        res.lastUniqueID = uuid();
        
        return res;
    };
}

Project.serializable = ["projectName", "version", "description", "author"];

Project.deserialize = function (context, input) {
    var p = new Project(context);
    p.removeSceneByNo(0);
    reset_uid(parseInt(input.lastUniqueID));

    for (var k in Project.serializable) {
        var kk = Project.serializable[k];
        p[kk] = input[kk];
    }
    p.windowSize = {
        x: input.windowSizeX,
        y: input.windowSizeY
    };
    
    context.editor.innerWidth = p.windowSize.x;
    context.editor.innerHeight = p.windowSize.y;

    for (var s in input.scenes) {
        var scene = Scene.deserialize(context, input.scenes[s]);
        p.scenes[s] = scene;
        
        if( scene.sceneID === input.initialScene ) {
            p.initialScene = scene;
        }
    }
    
    for( var k in input.nodes ) {
        var n = DiagramNode.deserialize(context, input.nodes[k]);
        context.editor.diagramPanel.nodes[k] = n;
    }
    
    p.dataVariables = input.dataVariables;

    return p;
};