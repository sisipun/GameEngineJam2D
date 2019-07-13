function love.load()
    Object = require "object"
    require "entity"
    require "player"
    require "ground"
    require "utils"
    require "groundRow"

    playerSprite = love.graphics.newImage("assets/hero_single.png")
    groundSprite = love.graphics.newImage("assets/ground_single.png")
    background = love.graphics.newImage("assets/background.png")
    gameWidth = love.graphics.getWidth()
    gameHeight = love.graphics.getHeight()

    restart()
end

function love.update(dt)
    player:update(dt)
    camera.y = camera.y + (20 * dt)

    for i, row in ipairs(groundRows) do
        for i, ground in ipairs(row:getValues()) do
            player:resolveCollision(ground)
        end
    end
    if (camera.y + gameHeight > lastGroundRow:getY() + distanceBetweenRows) then
        lastGroundRow = GroundRow(lastGroundRow:getY() + distanceBetweenRows,
                                  groundRowSize, 50, 50)
        table.insert(groundRows, lastGroundRow)
    end
    if (player:getY() > camera.y + gameHeight / 2) then
        camera.y = player:getY() - gameHeight / 2
    end
    if (camera.y > player:getY()) then
        restart()
    end
end

function love.draw()
    love.graphics.translate(-camera.x, -camera.y)
    local scaleX, scaleY = getImageScaleForNewDimensions(background, gameWidth,
                                                         gameHeight)
    love.graphics.draw(background, camera.x, camera.y, 0, scaleX, scaleY)
    for i, row in ipairs(groundRows) do row:draw() end
    player:draw()
end

function restart() 
    player = Player(100, 100, 30, 50, 150, 200, playerSprite)

    initGroundY = 300
    groundRowSize = 15
    distanceBetweenRows = 300
    groundRows = {}
    lastGroundRow = GroundRow(initGroundY, groundRowSize, 50, 50)
    table.insert(groundRows, lastGroundRow)

    camera = {}
    camera.x = 0
    camera.y = 0
end