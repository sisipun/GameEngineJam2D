cc.Class({
    extends: cc.Component,

    properties: {
        groundTarget: {
            default: null,
            type: cc.Node,
        },
        
        enemyTarget: {
            default: null,
            type: cc.Node,
        },

        hero: {
            default: null,
            type: cc.Node,
        },

        scoreLabel: {
            default: null,
            type: cc.Label,
        },

        rowSize: {
            default: 18,
            type: cc.Integer
        },

        lastRow: {
            default: null,
            type: Object
        },

        generateRowTriggerLine: {
            default: 300,
            type: cc.Integer
        },

        initialGenerateRowY: {
            default: 200,
            type: cc.Integer
        },

        generateRowY: {
            default: 0,
            type: cc.Integer
        },

        heroDeathTriggerLine: {
            default: -100,
            type: cc.Integer
        },

        heroGravitationTriggerLine: {
            default: 200,
            type: cc.Integer
        },

        heroStartX: {
            default: 0,
            type: cc.Integer
        },

        heroStartY: {
            default: 0,
            type: cc.Integer
        },

        rows: {
            default: [],
            type: Array
        },

        enemyHorizontalVelocity: {
            default: 100,
            type: cc.Integer
        },
    },

    onLoad: function () {
        cc.director.getPhysicsManager().enabled = true;
    },

    start: function () {
        window.Global = {
            isZeroGravity: false,
            score: 0,
            scoreFactor: 1,
            gravity: -320,
            jumpActionTag: 1
        };

        var scene = cc.director.getScene();
        this.hero.parent = scene;
        this.hero.setPosition(this.heroStartX, this.heroStartY);

        this.lastRow = this.generateRow(this.initialGenerateRowY);
        this.rows.push(this.lastRow);

        this.scoreLabel.string = "Score: " + Global.score;
    },

    update: function (dt) {
        if (this.lastRow.values[0].y > this.generateRowTriggerLine) {
            this.lastRow = this.generateRow(this.generateRowY);
            this.rows.push(this.lastRow);
        }

        if (this.hero.y > this.heroDeathTriggerLine) {
            this.restart();
        }

        if (!Global.isZeroGravity && this.hero.y < this.heroGravitationTriggerLine) {
            cc.director.getPhysicsManager().gravity = cc.v2();
            this.hero.getComponent(cc.RigidBody).linearVelocity = cc.v2();
            Global.isZeroGravity = true
        }

        if (this.rows.length > 5) {
            var currentRows = this.rows.filter(row => row.values[0].y <= this.heroDeathTriggerLine);
            var oldRows = this.rows.filter(row => row.values[0].y > this.heroDeathTriggerLine);
            oldRows.forEach(row => {
                row.values.forEach(ground => ground.destroy());
                row.enemy.destroy();
            });
            this.rows = currentRows;
        }

        var row = this.rows.filter(row => !row.scored)[0]
        if (row && row.values[0].y > this.hero.y) {
            row.scored = true
            Global.score += 1 * Global.scoreFactor
            this.scoreLabel.string = "Score: " + Global.score
            Global.scoreFactor += 1
        }

        this.rows.forEach(row => {
            if (row.enemyOrientation == 1) {
                if (row.enemy.x + row.groundWidth / 2 > row.values[this.rowSize - 2].x + row.groundWidth / 2) {
                    row.enemySpeed = -this.enemyHorizontalVelocity;
                } 
                else if (row.enemy.x - row.groundWidth / 2 < (row.holeIndex * row.groundWidth) + row.groundWidth) {
                    row.enemySpeed = this.enemyHorizontalVelocity;
                } 
            } else if (row.enemyOrientation == -1) {
                if (row.enemy.x - row.groundWidth / 2 < row.values[0].x - row.groundWidth / 2) {
                    row.enemySpeed = this.enemyHorizontalVelocity;
                } else if (row.enemy.x + row.groundWidth / 2 > row.holeIndex * row.groundWidth) {
                    row.enemySpeed = -this.enemyHorizontalVelocity;
                }
            }
            row.enemy.x += row.enemySpeed * dt;
        });
    },

    generateRow: function (y) {
        const holeIndex = this.getRandom(2, this.rowSize - 2);
        const grounds = [];

        var scene = cc.director.getScene();

        for (var i = 0; i < this.rowSize; i++) {
            if (i != holeIndex) {
                var groundNode = cc.instantiate(this.groundTarget);

                groundNode.parent = scene;
                groundNode.setPosition(groundNode.width / 2 + i * (groundNode.width - 1), y);
                groundNode.active = true;
                grounds.push(groundNode);
            }
        }

        var enemyNode = cc.instantiate(this.enemyTarget);

        var enemyOrientation = this.getRandom(-2, 2);
        if (enemyOrientation >= 0) {
            enemyOrientation = 1;
        } else {
            enemyOrientation = -1;
        }

        enemyNode.parent = scene;
        enemyNode.setPosition(grounds[0].width / 2 + (holeIndex + enemyOrientation) * (grounds[0].width - 1), y + enemyNode.width);
        enemyNode.active = true;

        return {
            y: y,
            groundWidth: grounds[0].width - 1,
            values: grounds,
            holeIndex: holeIndex,
            scored: false,
            enemy: enemyNode,
            enemyOrientation: enemyOrientation,
            enemySpeed: enemyOrientation * this.enemyHorizontalVelocity,
        };
    },

    restart: function () {
        var isZeroGravity = Global.isZeroGravity;
        window.Global = {
            isZeroGravity: isZeroGravity,
            score: 0,
            scoreFactor: 1,
        };

        this.scoreLabel.string = "Score: " + Global.score;

        this.rows.forEach(row => {
            row.values.forEach(ground => {
                ground.stopAllActions();
                ground.destroy();
            });
            row.enemy.destroy();
        });
        this.rows = [];

        this.hero.setPosition(this.heroStartX, this.heroStartY);
        this.hero.stopAction(Global.jumpActionTag);
        this.lastRow = this.generateRow(this.initialGenerateRowY);
        this.rows.push(this.lastRow);
    },

    getRandom: function (min, max) {
        return Math.round(Math.random() * (max - min) + min);
    },
});
