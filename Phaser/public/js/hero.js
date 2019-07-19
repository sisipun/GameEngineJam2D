function createHero(game, x, y) {
    hero = game.physics.add.sprite(x, y, 'hero');
    hero.displayWidth = heroWidth;
    hero.displayHeight = heroHeight;    
    return hero; 
}