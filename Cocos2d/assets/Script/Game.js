cc.Class({
    extends: cc.Component,

    properties: {
        groundTarget: {
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
        }
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
            oldRows.forEach(row => row.values.forEach(ground => ground.destroy()));
            this.rows = currentRows;
        }

        var row = this.rows.filter(row => !row.scored)[0]
        if (row && row.values[0].y > this.hero.y) {
            row.scored = true
            Global.score += 1 * Global.scoreFactor
            this.scoreLabel.string = "Score: " + Global.score
            Global.scoreFactor += 1
        }
    },

    generateRow: function (y) {
        const holeIndex = this.getRandom(2, this.rowSize - 2);
        const grounds = [];

        for (var i = 0; i < this.rowSize; i++) {
            if (i != holeIndex) {
                var scene = cc.director.getScene();
                var groundNode = cc.instantiate(this.groundTarget);

                groundNode.parent = scene;
                groundNode.setPosition(groundNode.width / 2 + i * (groundNode.width - 1), y);
                groundNode.active = true;
                grounds.push(groundNode);
            }
        }

        return {
            y: y,
            values: grounds,
            scored: false
        };
    },

    restart: function () {
        window.Global = {
            isZeroGravity: false,
            score: 0,
            scoreFactor: 1,
        };

        this.scoreLabel.string = "Score: " + Global.score;

        this.rows.forEach(row => {
            row.values.forEach(ground => {
                ground.stopAllActions();
                ground.destroy();
            });
        });
        this.rows = [];

        this.hero.setPosition(this.heroStartX, this.heroStartY);
        this.lastRow = this.generateRow(this.initialGenerateRowY);
        this.rows.push(this.lastRow);
    },

    getRandom: function (min, max) {
        return Math.round(Math.random() * (max - min) + min);
    },
});
