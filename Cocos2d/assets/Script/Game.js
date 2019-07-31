cc.Class({
    extends: cc.Component,

    properties: {
    },

    // use this for initialization
    onLoad: function () {
        cc.director.getPhysicsManager().enabled = true;
    },

    // called every frame
    update: function (dt) {

    },
});
