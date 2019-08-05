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
            type: Number
        },

        lastRow: {
            default: null,
            type: Object
        },

        generateRowTriggerLine: {
            default: 300,
            type: Number
        },

        initialGenerateRowY: {
            default: 200,
            type: Number
        },

        generateRowY: {
            default: 0,
            type: Number
        },

        heroDeathTriggerLine: {
            default: -100,
            type: Number
        },

        heroGravitationTriggerLine: {
            default: 200,
            type: Number
        },

        heroStartX: {
            default: 0,
            type: Number
        },

        heroStartY: {
            default: 0,
            type: Number
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
        this.lastRow = this.generateRow(this.initialGenerateRowY);
        this.rows.push(this.lastRow);

        this.hero.setPosition(this.heroStartX, this.heroStartY);
        const heroCollider = this.hero.getComponent(cc.PhysicsBoxCollider);
        // heroCollider.node.on(cc.Node.EventType.TOUCH_START, function (touch, event) {
            // console.log("hello")
                // cc.director.getPhysicsManager().gravity = cc.v2 ();
        // }, this);
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

        // if (this.hero.y < this.heroGravitationTriggerLine) {
        //     cc.director.getPhysicsManager().gravity = cc.v2 (0, 0);
        // }
    },

    generateRow: function (y) {
        const holeIndex = Math.round(this.getRandom(2, this.rowSize - 2));
        const grounds = [];
        for (var i = 0; i < this.rowSize; i++) {
            if (i != holeIndex) {
                var scene = cc.director.getScene();
                var groundNode = cc.instantiate(this.groundTarget);

                groundNode.parent = scene;
                groundNode.setPosition(groundNode.width / 2 + i * groundNode.width, y);
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
    }
});
