/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function InternalPlayer(context) {
    this.context = context;

    this.onFrameUpdated;
    this.timeElement;
    this.frameElement;
    this.titleElement;
    this.playerDataElement;

    this.lastData;

    this.canvas;
    this.renderer;

    this.game;

    this.time;
    this.isRunning = false;
    this.counter = 0;

    this.start = function () {
        this.loadData();

        this.canvas = document.getElementById("playerCanvas");
        this.timeElement = document.getElementById("playerTimeLabel");
        this.titleElement = document.getElementById("playTextModalLabel");
        this.frameElement = document.getElementById("playerFrameLabel");
        this.playerDataElement = document.getElementById("playerDataTableBody");

        this.renderer = new PIXI.CanvasRenderer(this.game.windowSize.x, this.game.windowSize.y, {
            view: this.canvas,
            resolution: 1
        });
        this.renderer.backgroundColor = 0xFFFFFF;


        this.time = new Time();
        this.isRunning = true;
        this.titleElement.innerHTML = this.game.gameName;
    };

    this.stop = function () {
        this.game.stop();
        this.isRunning = false;
        this.time.stop();
    };

    this.loadData = function () {
        var data = this.context.editor.project.serialize();
        
        this.game = new Player.Game(new Player.Context(this, function (value) {
            return editor.projectPath(value);
        }), JSON.parse(JSON.stringify(data)));
    };

    this.update = function () {
        if (!this.isRunning || !this.game) {
            return;
        }
        this.time.updateTime();

        this.game.update(this.time.deltaTime);

        if (this.timeElement && this.time && this.counter < 0) {
            this.timeElement.innerHTML = (1 / this.time.deltaTime).toFixed(0) + "fps / " + this.time.elapsedTime.toFixed(0);
            this.counter = 10;
        } else {
            this.counter--;
        }
        if (this.frameElement && this.game.activeScene && this.game.currentActionGroupIndex >= 0 && this.game.currentFrameIndex >= 0) {
            this.frameElement.innerHTML = this.game.activeScene.sceneName + " - Frame " + (this.game.currentFrameIndex + 1) + " | Col " + (this.game.currentActionGroupIndex + 1);
        }

        if (this.playerDataElement) {
            var curData = this.getCurrentData();
            if (this.lastData !== JSON.stringify(curData)) {

                this.lastData = JSON.stringify(curData);

                this.renderPlayerData(curData);
            }
        }

        this.renderer.render(this.game.stage);
    };

    this.getCurrentData = function () {
        var pData = this.game.dataVariables;
        var sData = [];
        if( this.game.activeScene ) {
            sData = this.game.activeScene.dataVariables;
        }

        var data = {
            project: JSON.parse(JSON.stringify(pData)),
            scene: JSON.parse(JSON.stringify(sData))
        };

        return data;
    };

    this.renderPlayerData = function (data) {
        var pRes = [];
        for (var k in data.project) {
            pRes.push({name: k, val: data.project[k]});
        }
        var sRes = [];
        for (var k in data.scene) {
            sRes.push({name: k, val: data.scene[k]});
        }

        if (pRes.length + sRes.length <= 0) {
            this.playerDataElement.innerHTML = "";
            return;
        }

        var res = "<tr>\n" +
                "   <th colspan=\"2\">\n" +
                "       Current Scene Data\n" +
                "   </th>\n" +
                "   <th colspan=\"2\">\n" +
                "       Project Data\n" +
                "   </th>\n" +
                "</tr>";

        var counter = 0;

        while (true) {
            res += "<tr>";

            if (counter < sRes.length) {
                res += "<td>" + sRes[counter].name + "</td>";

                var v = sRes[counter].val.value;
                if (!v || v === "") {
                    v = "<b>Empty</b>";
                }
                res += "<td>" + v + "</td>";

                
            } else {
                res += "<td></td>";
                res += "<td></td>";
            }

            if (counter < pRes.length) {
                res += "<td>" + pRes[counter].name + "</td>";
                
                var v = pRes[counter].val.value;
                if (!v || v === "") {
                    v = "<b>Empty</b>";
                }
                res += "<td>" + v + "</td>";
            } else {
                res += "<td></td>";
                res += "<td></td>";
            }
            counter++;

            res += "</tr>";

            if (counter >= pRes.length && counter >= sRes.length) {
                break;
            }
        }

        this.playerDataElement.innerHTML = res;
    };
}
