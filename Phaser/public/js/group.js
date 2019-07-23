function createGroup(game, y, groundSize, holeSize, groundGroupParticipantsNumber, enemyWidth, enemyHeight, enemyVelocity, hero) {
    groundGroup = game.physics.add.staticGroup();
    holeGroup = game.physics.add.staticGroup();

    const holeIndex = Phaser.Math.Between(2, groundGroupParticipantsNumber - 2);
    for (var i = 0; i < groundGroupParticipantsNumber; i++) {
        if (holeIndex != i) {
            groupElement = groundGroup.create(i * groundSize, y, 'ground');
            size = groundSize
        } else {
            groupElement = holeGroup.create(i * groundSize, y + 10, 'empty');
            size = holeSize
        }
        groupElement.setOrigin(0, 0);
        groupElement.displayWidth = size;
        groupElement.displayHeight = size;
        groupElement.refreshBody();
    }

    orientation = Phaser.Math.Between(0, 1)
    if (!orientation) {
        orientation = -1
    }

    enemy = createEnemy(game, (holeIndex + 2 * orientation) * groundSize + enemyWidth, y - enemyHeight / 2, enemyWidth, enemyHeight, orientation * Math.abs(enemyVelocity));

    game.physics.add.collider(hero, groundGroup, collideGround, null, game);
    game.physics.add.collider(enemy, groundGroup);
    game.physics.add.overlap(hero, holeGroup, overlapHole, null, game);
    game.physics.add.overlap(hero, enemy, overlapEnemy, null, game);

    return {
        value: groundGroup,
        positionY: y,
        enemy: {
            value: enemy,
            velocity: enemyVelocity,
            rightOrientation: orientation === 1
        },
        holeIndex: holeIndex,
        groundSize: groundSize
    };
}

function createEnemy(game, x, y, enemyWidth, enemyHeight, enemyVelocity) {
    enemy = game.physics.add.sprite(x, y, 'enemy');
    enemy.displayWidth = enemyWidth;
    enemy.displayHeight = enemyHeight;
    enemy.setVelocityX(enemyVelocity)
    return enemy;
}

function groupUpdate(group, leftBorder, rightBorder) {
    if (group.enemy.rightOrientation) {
        if (group.enemy.value.x + group.enemy.value.displayWidth / 2 > rightBorder) {
            group.enemy.value.setVelocityX(-group.enemy.velocity)
        } else if (group.enemy.value.x - group.enemy.value.displayWidth / 2 < (group.holeIndex * group.groundSize) + group.groundSize) {
            group.enemy.value.setVelocityX(group.enemy.velocity)
        }
    } else if (!group.enemy.rightOrientation) {
        if (group.enemy.value.x - group.enemy.value.displayWidth / 2 < leftBorder) {
            group.enemy.value.setVelocityX(group.enemy.velocity)
        } else if (group.enemy.value.x + group.enemy.value.displayWidth / 2 > group.holeIndex * group.groundSize) {
            group.enemy.value.setVelocityX(-group.enemy.velocity)
        }
    }
}

function collideGround() {
    scoreFactor = 1
}

function overlapHole(hero, hole) {
    score += 1 * scoreFactor
    scoreFactor += 1
    hole.disableBody(true, true);
    scoreText.setText('score: ' + score)
}

function overlapEnemy(hero, enemy) {
    if (hero.y < enemy.y - enemy.displayWidth / 2) {
        enemy.disableBody(true, true);
        score += 1
    } else {
        this.scene.start()
    }
}