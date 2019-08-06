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
        }
    },

    onLoad() {
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this.onKeyDown, this);
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_UP, this.onKeyUp, this);
    },

    destroy() {
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
                this.speed = 0;
                break;
            case cc.macro.KEY.d:
                this.speed = 0;
                break;
        }
    },

    start() {

    },

    update(dt) {
        this.node.x += this.speed * dt;
    },

    onPreSolve: function (contact, selfCollider, otherCollider) {
        cc.director.getPhysicsManager().gravity = cc.v2(0, -320);
        Global.gravityZero = false
    },
});
