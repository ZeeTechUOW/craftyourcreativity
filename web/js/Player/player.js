/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the player.
 */
/**
 *
 * @author Deni Barasena
 */

function GamePlayer(moduleID, userID) {
    this.context = new Player.Context(this, function (value) {
        if( value.startsWith("Assets") ) {
            value = "Published/" + value;
        }
        return "module/" + moduleID + "/" + value;
    });

    this.moduleID = moduleID;
    this.userID = userID;
    
    this.canvas;
    this.isRunning = false;
    this.renderer;
    this.time;

    this.game;
    this.onReady;
    
    this.startGame = function (onReady) {
        this.onReady = onReady;
        this.loadModule();
    };
    
    this.start = function () {
        this.canvas = document.getElementById("gameCanvas");
        $(this.canvas).width(this.game.windowSize.x);
        $(this.canvas).height(this.game.windowSize.y);
        
        this.time = new Time();
        this.isRunning = true;
        
        this.renderer = new PIXI.CanvasRenderer(this.game.windowSize.x, this.game.windowSize.y, {
            view: this.canvas,
            resolution: 1
        });
        this.renderer.backgroundColor= 0xffffff;
        
        if( this.onReady ) {
            this.onReady();
        }
        this.update();
    };
    
    this.stop = function () {
        this.game.stop();
        this.isRunning = false;
        this.time.stop();
    };

    this.loadModule = function () {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'RunGameServlet?mid=' + this.moduleID + "&uid=" + this.userID, true);
        xhr.onload = (function (c) {
            return function () {
                var json = JSON.parse(xhr.responseText);
                c.player.game = new Player.Game(c, json);
                
                console.log(json);
                console.log(c.player.game);
                
                c.player.start();
            };
        }(this.context));

        xhr.send();
    };

    this.update = function () {
        requestAnimationFrame(this.update.bind(this));

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

        this.renderer.render(this.game.stage);
    };
}