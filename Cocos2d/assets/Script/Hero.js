cc.Class({
    extends: cc.Component,

    properties: {
        horizontalVelocity: 0,
    },

    // LIFE-CYCLE CALLBACKS:

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
                this.horizontalVelocity = -100;
                break;
            case cc.macro.KEY.d:
                this.horizontalVelocity = 100;
                break;
        }
    },

    onKeyUp: function (event) {
        switch (event.keyCode) {
            case cc.macro.KEY.a:
                this.horizontalVelocity = 0;
                break;
            case cc.macro.KEY.d:
                this.horizontalVelocity = 0;
                break;
        }
    },

    start() {

    },

    update(dt) {
        this.node.x += this.horizontalVelocity * dt;
    },
});
