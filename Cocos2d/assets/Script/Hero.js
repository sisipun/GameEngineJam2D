cc.Class({
    extends: cc.Component,

    properties: {
        jumpVelocity: {
            default: 350,
            type: cc.Integer
        },
        jumpDuration: {
            default: 50,
            type: cc.Integer
        },
        horizontalVelocity: {
            default: 300,
            type: cc.Integer
        },
        speed: {
            default: 0,
            type: cc.Integer
        },
        canJump: {
            default: false,
            type: cc.Boolean
        },
        killAudio: {
            default: null,
            type: cc.AudioSource
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

    start: function () {
        this.jumpAction = cc.moveBy(this.jumpDuration, cc.v2(0, this.jumpVelocity)).easing(cc.easeCubicActionOut());
        this.jumpAction.setTag(Global.jumpActionTag);
    },

    onKeyDown: function (event) {
        switch (event.keyCode) {
            case cc.macro.KEY.a:
                this.speed = -this.horizontalVelocity;
                break;
            case cc.macro.KEY.d:
                this.speed = this.horizontalVelocity;
                break;
            case cc.macro.KEY.space:
                if (this.canJump && !Global.isZeroGravity) {
                    this.node.runAction(this.jumpAction);
                    this.canJump = false;
                }
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
        this.canJump = true;
        if (otherCollider.node.name == "enemy") {
            if (otherCollider.node.y + (otherCollider.node.height / 2) > selfCollider.node.y) {
                Global.restart = true;
            } else {
                Global.score += 1;
                otherCollider.node.active = false;
                this.killAudio.play();
            }
        }
    },
});
