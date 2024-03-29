function love.load()
    Object = require "object"
    require "entity"
    require "player"
    require "enemy"
    require "ground"
    require "utils"
    require "groundRow"

    -- Assets
    playerSprite = love.graphics.newImage("assets/hero_single.png")
    enemySprite = love.graphics.newImage("assets/monster_single.png")
    groundSprite = love.graphics.newImage("assets/ground_single.png")
    background = love.graphics.newImage("assets/background.png")
    scoreSong = love.audio.newSource("assets/score.mp3", "stream")
    killSong = love.audio.newSource("assets/enemy_kill.wav", "stream")
    deathSong = love.audio.newSource("assets/death.wav", "stream")
    gameWidth = love.graphics.getWidth()
    gameHeight = love.graphics.getHeight()

    -- Constants
    initGroundY = 300
    groundRowSize = 15
    distanceBetweenRows = 300
    enemyChance = 1
    cameraVelocity = 50

    restart()
end

function love.update(dt)
    camera.y = camera.y + (cameraVelocity * dt)
    player:update(dt, borders)

    for i, row in ipairs(groundRows) do
        row:update(dt, borders)
        row:resolveCollision()
        if (not row:wasPast() and row:getY() < player:getY()) then
            if (not row:wasLanded()) then
                scoreFactor = scoreFactor + 1
            end
            scoreSong:play()
            score = score + 1 * scoreFactor
            row:setAsPast()
        end
        for i, ground in ipairs(row:getValues()) do
            collisionStatus = player:resolveCollision(ground)
            if (collisionStatus == collisionStatuses.BOTTOM) then
                row:setAsLanded()
                scoreFactor = 1
            end
        end
        if (row:getEnemy() ~= nil) then
            collisionStatus = player:resolveCollision(row:getEnemy())
            if (collisionStatus == collisionStatuses.BOTTOM) then
                killSong:play()
                row:killEnemy()
                score = score + 1
            elseif (collisionStatus == collisionStatuses.LEFT or collisionStatus ==
                collisionStatuses.RIGHT) then
                deathSong:play()
                restart()
            end
        end
    end
    if (camera.y + gameHeight + 50 > lastGroundRow:getY() + distanceBetweenRows) then
        lastGroundRow = GroundRow(lastGroundRow:getY() + distanceBetweenRows,
                                  groundRowSize, 50, 50)
        if (love.math.random(enemyChance) == 1) then
            lastGroundRow:addEnemy(enemySprite)
        end

        table.insert(groundRows, lastGroundRow)
    end
    if (player:getY() > camera.y + gameHeight / 2) then
        camera.y = player:getY() - gameHeight / 2
    end
    if (camera.y > player:getY()) then
        deathSong:play()
        restart()
    end
end

function love.draw()
    -- Camera move
    love.graphics.translate(-camera.x, -camera.y)

    -- Background
    local scaleX, scaleY = getImageScaleForNewDimensions(background, gameWidth,
                                                         gameHeight)
    love.graphics.draw(background, camera.x, camera.y, 0, scaleX, scaleY)

    -- Entities
    for i, row in ipairs(groundRows) do row:draw() end
    player:draw()

    -- Score
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(string.format("Score: %s", score), camera.x + 20,
                        camera.y + 20)
    love.graphics.setColor(255, 255, 255)
end

function restart()
    player = Player(100, 100, 30, 50, 300, 250, playerSprite)

    groundRows = {}
    lastGroundRow = GroundRow(initGroundY, groundRowSize, 50, 50)
    table.insert(groundRows, lastGroundRow)

    camera = {}
    camera.x = 0
    camera.y = 0

    score = 0
    scoreFactor = 1

    borders = {}
    borders.x = camera.x
    borders.y = camera.y
    borders.width = gameWidth
    borders.height = gameHeight
end
