/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the player.
 */

function Player() {
    this.context = new Player.Context(this);

    this.canvas;
    this.renderer;
    this.stage;

    this.game;

    this.startGame = function () {
        this.canvas = document.getElementById("canvas");
        this.renderer = new PIXI.CanvasRenderer(this.game.windowSize.x, this.game.windowSize.y, {
            view: this.canvas,
            resolution: 1
        });
        this.stage = new PIXI.Container();
        
        
    };

    this.loadProject = function (projectID) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'LoadServlet?projectID=' + projectID, true);
        xhr.onload = (function (c) {
            return function () {
                var json = JSON.parse(xhr.responseText);
                console.log(json);

                c.player.game = new Game(c, json);
                console.log(c.player.game);
            };
        }(this.context));

        xhr.send();
    };

    this.update = function () {
        requestAnimationFrame(this.update.bind(this));

        this.renderer.render(this.stage);
    };
    
    this.changeScene = function () {
        
    };
}