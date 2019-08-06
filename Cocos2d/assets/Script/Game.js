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
        window.Global = {
            gravityZero: false,
        };

        cc.director.getPhysicsManager().enabled = true;
    },

    start: function () {
        this.lastRow = this.generateRow(this.initialGenerateRowY);
        this.rows.push(this.lastRow);

        this.hero.setPosition(this.heroStartX, this.heroStartY);
    },

    update: function (dt) {
        if (this.lastRow.values[0].y > this.generateRowTriggerLine) {
            this.lastRow = this.generateRow(this.generateRowY);
            this.rows.push(this.lastRow);
        }

        if (this.hero.y > this.heroDeathTriggerLine) {
            this.rows.forEach(row => {
                row.values.forEach(ground => {
                    ground.stopAllActions();
                    ground.destroy();
                });
            });
            this.hero.setPosition(this.heroStartX, this.heroStartY);
            this.lastRow = this.generateRow(this.initialGenerateRowY);
            this.rows = [];
        }

        if (this.hero.y < this.heroGravitationTriggerLine) {
            cc.director.getPhysicsManager().gravity = cc.v2();
            this.hero.getComponent(cc.RigidBody).linearVelocity = cc.v2();
            Global.gravityZero = true
        }
    },

    generateRow: function (y) {
        const holeIndex = Math.round(this.getRandom(2, this.rowSize - 2));
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
            values: grounds
        };
    },

    getRandom: function (min, max) {
        return Math.random() * (max - min) + min;
    },
});
