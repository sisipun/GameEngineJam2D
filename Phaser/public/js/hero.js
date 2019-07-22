function createHero(game, x, y, heroWidth, heroHeight) {
    hero = game.physics.add.sprite(x, y, 'hero');
    hero.displayWidth = heroWidth;
    hero.displayHeight = heroHeight;    
    return hero; 
}