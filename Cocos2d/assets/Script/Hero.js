cc.Class({
    extends: cc.Component,

    properties: {
        jumpVelocity: {
            default: 300,
            type: cc.Integer
        },
        jumpDuration: {
            default: 2,
            type: cc.Integer
        },
        velocity: {
            default: 300,
            type: cc.Integer
        },
        enemyKillSound: {
            default: null,
            type: cc.AudioSource
        },
    },

    onLoad: function () {
        this.speed = 0;
        this.canJump = false;
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
                this.speed = -this.velocity;
                break;
            case cc.macro.KEY.d:
                this.speed = this.velocity;
                break;
            case cc.macro.KEY.space:
                if (this.canJump && !Global.isZeroGravity) {
                    this.node.runAction(this.jumpAction);
                    this.canJump = false;
                }
                break
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
        this.canJump = true;

        if (Global.isZeroGravity) {
            cc.director.getPhysicsManager().gravity = cc.v2(0, Global.gravity);
            Global.isZeroGravity = false;
        }

        if (otherCollider.node.name == "enemy") {
            if (otherCollider.node.y + (otherCollider.node.height / 2) > selfCollider.node.y) {
                Global.restart = true;
            } else {
                Global.score += 1;
                otherCollider.node.active = false;
                this.enemyKillSound.play();
            }
        }
    },
});
