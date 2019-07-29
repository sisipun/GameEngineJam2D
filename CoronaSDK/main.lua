Object = require "object"
require "hero"
require "groundRow"
require "enemy"

local heroId = "hero"
local groundId = "ground"
local enemyId = "enemy"

local scoreSound = audio.loadSound("assets/score.mp3")
local killSound = audio.loadSound("assets/enemy_kill.wav")
local deathSound = audio.loadSound("assets/death.wav")

-- Background
local background = display.newImageRect("assets/background.png",
                                        display.contentWidth,
                                        display.contentHeight)
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Score
local score = 0
local scoreFactor = 1
local scoreText = display.newText("Score: " .. score, 60, 50, 100, 50,
                                  native.systemFont, 15)
scoreText:setFillColor(0, 0, 0)
local function updateText() scoreText.text = "Score: " .. score end
Runtime:addEventListener("enterFrame", updateText)

-- Physics
local physics = require("physics")
physics.start()
physics.setGravity(0, 7)

-- Walls
leftWall = display.newRect(display.screenOriginX - 5, 0, 0,
                           display.contentHeight)
rightWall = display.newRect(display.contentWidth + 5, 0, 0,
                            display.contentHeight)
physics.addBody(leftWall, "static",
                {density = 400, friction = 0.0, bounce = 0.0})
physics.addBody(rightWall, "static",
                {density = 400, friction = 0.0, bounce = 0.0})

-- Hero
local hero = Hero(display.newImageRect("assets/hero_single.png", 30, 50),
                  heroId, display.contentCenterX + 50,
                  display.contentCenterY - 50, 150, 200, physics)
Runtime:addEventListener("touch", hero)
Runtime:addEventListener("enterFrame", hero)
Runtime:addEventListener("collision", hero)

-- Ground Rows
local rows = {}
local groupGenerationBorder = display.contentHeight / 1.5

local function createGroundRow(y)
    local row = GroundRow(groundId, y, 7, 50, 70,
    enemyId, 50, 70, physics, display)
    Runtime:addEventListener("enterFrame", row)
    Runtime:addEventListener("collision", row)
    Runtime:addEventListener("enterFrame", row:getEnemy())
    table.insert(rows, row)
    return row
end

local function generateGroundRow()
    if (lastRow == nil) then
        lastRow = createGroundRow(display.contentCenterY + 200)
    elseif (lastRow:getY() < groupGenerationBorder) then
        lastRow = createGroundRow(display.contentHeight + 100)
    end
end

Runtime:addEventListener("enterFrame", generateGroundRow)

local function restart()
    audio.play(deathSound)
    physics.setGravity(0, 7)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    hero:getBody().x = display.contentCenterX
    hero:getBody().y = display.contentCenterY
    for i, row in ipairs(rows) do row:remove(display) end
    rows = {}
    lastRow = nil
    score = 0
end

local function checkDeath()
    if (display.screenOriginY > hero:getBody().y) then restart() end
end

Runtime:addEventListener("enterFrame", checkDeath)

local function checkScore()
    for i, row in ipairs(rows) do
        if (not row:wasPast() and row:getY() < hero:getBody().y) then
            if (row:wasTouched()) then
                scoreFactor = 1
            else
                scoreFactor = scoreFactor + 1
            end
            score = score + (1 * scoreFactor)
            row:setAsPast()
            audio.play(scoreSound)
        end
    end
end

Runtime:addEventListener("enterFrame", checkScore)

local function checkFall()
    if (hero:getBody().y > display.contentCenterY) then
        physics.setGravity(0, 0)
        local dx, dy = hero:getBody():getLinearVelocity()
        hero:getBody():setLinearVelocity(dx, 0)
        for i, row in ipairs(rows) do row:moveFast() end
    end
end

Runtime:addEventListener("enterFrame", checkFall)

local function enemyKill(enemy) 
    physics.setGravity(0, 7)
    for i, row in ipairs(rows) do row:moveNormal() end
    display.remove(enemy)
    score = score + 1
    audio.play(killSound)
end

local function checkLanding(event)
    if (event.object1.id == heroId or event.object2.id == heroId) then
        if (event.object1.id == groundId or event.object2.id == groundId) then
            if (event.object1.contentBounds.yMax <
                event.object2.contentBounds.yMin) then
                physics.setGravity(0, 7)
                for i, row in ipairs(rows) do row:moveNormal() end
            end
        end
        if (event.object1.id == enemyId) then
            if (event.object2.y < event.object1.y) then
                enemyKill(event.object1)
            else
                restart()
            end
        end
        if (event.object2.id == enemyId) then
            if (event.object1.y < event.object2.y) then
                enemyKill(event.object2)
            else
                restart()
            end
        end
    end
end

Runtime:addEventListener("preCollision", checkLanding)
