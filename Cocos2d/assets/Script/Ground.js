cc.Class({
    extends: cc.Component,

    properties: {
        verticalVelocity: 100
    },

    start () {

    },

    update (dt) {
        this.node.y += this.verticalVelocity * dt;
    },
});
