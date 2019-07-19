function createGroup(game, y, hero) {
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

    game.physics.add.collider(hero, groundGroup, collideGround, null, game);
    game.physics.add.overlap(hero, holeGroup, overlapHole, null, game);

    return {
        value: groundGroup,
        positionY: y
    };
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