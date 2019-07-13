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
        if (not row:wasPast() and row:getY() < player:getY()) then
            if (not row:wasLanded()) then
                scoreFactor = scoreFactor + 1
            end
            score = score + 1 * scoreFactor
            row:setAsPast()
        end
        for i, ground in ipairs(row:getValues()) do
            collisionStatus = player:resolveCollision(ground)
            if (collisionStatus == collisionStatuses.HORIZONTAL) then
                row:setAsLanded()
                scoreFactor = 1
            end
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
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(string.format("Score: %s", score), camera.x + 20, camera.y + 20)
    love.graphics.setColor(255, 255, 255)
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

    score = 0
    scoreFactor = 1
end