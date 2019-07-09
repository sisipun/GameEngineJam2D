function love.load()
    Object = require "object"
    require "player"

    playerSprite = love.graphics.newImage("assets/hero_single.png")

    player = Player(100, 100, 60, 100, 100, playerSprite)
end

function love.update(dt) player:update(dt) end

function love.draw() player:draw() end
