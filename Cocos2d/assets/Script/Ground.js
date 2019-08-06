cc.Class({
    extends: cc.Component,

    properties: {
        verticalVelocity: 100
    },

    start() {

    },

    update(dt) {
        if (Global.gravityZero) {
            this.node.y += 2 * this.verticalVelocity * dt;
        } else {
            this.node.y += this.verticalVelocity * dt;
        }
    },
});
