/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Time() {
    this.startTime = 0;
    this.oldTime = 0;
    this.elapsedTime = 0;
    this.deltaTime = 0;

    this.running = false;

    this.start = function () {
        this.startTime = Date.now();

        this.oldTime = this.startTime;
        this.elapsedTime = 0;
        this.running = true;

    };

    this.stop = function () {
        this.running = false;
    };

    this.updateTime = function () {
        if (this.running) {
            var newTime = Date.now();
            this.deltaTime = (newTime - this.oldTime) / 1000;
            this.oldTime = newTime;

            this.elapsedTime += this.deltaTime;

        }
    };
    
    this.start();
}