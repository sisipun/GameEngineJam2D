cc.Class({
    extends: cc.Component,

    properties: {
        horizontalVelocity: {
            default: 300,
            type: cc.Integer
        },
        speed: {
            default: 0,
            type: cc.Integer
        },
    },

    onLoad: function () {
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this.onKeyDown, this);
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_UP, this.onKeyUp, this);
    },

    onDestroy: function () {
        cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN, this.onKeyDown, this);
        cc.systemEvent.off(cc.SystemEvent.EventType.KEY_UP, this.onKeyUp, this);
    },

    onKeyDown: function (event) {
        switch (event.keyCode) {
            case cc.macro.KEY.a:
                this.speed = -this.horizontalVelocity;
                break;
            case cc.macro.KEY.d:
                this.speed = this.horizontalVelocity;
                break;
        }
    },

    onKeyUp: function (event) {
        switch (event.keyCode) {
            case cc.macro.KEY.a:
            case cc.macro.KEY.d:
                this.speed = 0;
                break;
        }
    },

    update(dt) {
        this.node.x += this.speed * dt;
    },

    onPreSolve: function (contact, selfCollider, otherCollider) {
        Global.scoreFactor = 1;
        if (Global.isZeroGravity) {
            cc.director.getPhysicsManager().gravity = cc.v2(0, Global.gravity);
            Global.isZeroGravity = false;
        }
    },
});
