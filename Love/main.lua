function love.load()
    Object = require "object"
    require "player"
    require "ground"
    require "utils"

    playerSprite = love.graphics.newImage("assets/hero_single.png")
    groundSprite = love.graphics.newImage("assets/ground_single.png")
    background = love.graphics.newImage("assets/background.png")
    gameWidth = love.graphics.getWidth()
    gameHeight = love.graphics.getHeight()

    player = Player(100, 100, 60, 100, 100, playerSprite)
    ground = Ground(200, 200, 100, 100, groundSprite)
end

function love.update(dt) player:update(dt) end

function love.draw()
    local scaleX, scaleY = getImageScaleForNewDimensions(background, gameWidth, gameHeight)
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)
    ground:draw()
    player:draw()
end
