cc.Class({
    extends: cc.Component,

    properties: {
        speed: 0,
    },

    // LIFE-CYCLE CALLBACKS:

    onLoad() {
        console.log('x-' + this.node.x);
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
                console.log('press a key');
                this.speed = -100;
                break;
            case cc.macro.KEY.d:
                console.log('press d key');
                this.speed = 100;
                break;
        }
    },

    onKeyUp: function (event) {
        switch (event.keyCode) {
            case cc.macro.KEY.a:
                this.speed = 0;
                console.log('release a key');
                break;
            case cc.macro.KEY.d:
                console.log('release d key');
                this.speed = 0;
                break;
        }
    },

    start() {

    },

    update(dt) {
        console.log('x-' + this.node.x);
        this.node.x += this.speed * dt;
    },
});
