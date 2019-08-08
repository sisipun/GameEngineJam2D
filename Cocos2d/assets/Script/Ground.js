cc.Class({
    extends: cc.Component,

    properties: {
        verticalVelocity: {
            default: 100,
            type: cc.Integer
        },
    },

    update: function (dt) {
        const speedFactor = Global.isZeroGravity ? 2 : 1;
        this.node.y += speedFactor * this.verticalVelocity * dt;
    },
});
