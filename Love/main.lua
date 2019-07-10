function love.load()
    Object = require "object"
    require "player"
    require "ground"

    playerSprite = love.graphics.newImage("assets/hero_single.png")
    groundSprite = love.graphics.newImage("assets/ground_single.png")

    player = Player(100, 100, 60, 100, 100, playerSprite)
    ground = Ground(200, 200, 100, 100, groundSprite)
end

function love.update(dt) player:update(dt) end

function love.draw()
    player:draw()
    ground:draw()
end
