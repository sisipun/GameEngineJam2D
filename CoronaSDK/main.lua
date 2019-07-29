Object = require "object"
require "hero"
require "groundRow"
require "enemy"

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
physics.setGravity(0, 7)
physics.start()

-- Walls
leftWall = display.newRect(display.screenOriginX - 5, 0, 0, display.contentHeight)
rightWall = display.newRect(display.contentWidth + 5, 0, 0, display.contentHeight)
physics.addBody(leftWall, "static", {density=400, friction = 0.0, bounce = 0.0})
physics.addBody(rightWall, "static", {density=400, friction = 0.0, bounce = 0.0})

-- Hero
local hero = Hero(display.newImageRect("assets/hero_single.png", 30, 50),
                  display.contentCenterX + 50, display.contentCenterY - 50, 150,
                  physics)
Runtime:addEventListener("touch", hero)

-- Ground Rows
local rows = {}
local groupGenerationBorder = display.contentHeight / 1.5

local function generateGroundRow()
    if (lastRow == nil) then
        local row = GroundRow(display.contentCenterY + 50, 7, 50, 70, 50, 70, physics,
                              display)
        Runtime:addEventListener("enterFrame", row)
        Runtime:addEventListener("collision", row)
        Runtime:addEventListener("enterFrame", row:getEnemy())
        table.insert(rows, row)
        lastRow = row
    elseif (lastRow:getY() < groupGenerationBorder) then
        local row = GroundRow(display.contentHeight + 100, 7, 50, 70, 50, 70, physics,
                              display)
        Runtime:addEventListener("enterFrame", row)
        Runtime:addEventListener("collision", row)
        Runtime:addEventListener("enterFrame", row:getEnemy())
        table.insert(rows, row)
        lastRow = row
    end
end

Runtime:addEventListener("enterFrame", generateGroundRow)

local function checkDeath()
    if (display.screenOriginY > hero:getBody().y) then
        physics.setGravity(0, 7)
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        hero:getBody().x = display.contentCenterX
        hero:getBody().y = display.contentCenterY
        for i, row in ipairs(rows) do
            row:remove(display)
        end
        rows = {}
        lastRow = nil
        score = 0
    end
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

local function checkLanding(event)
    if (event.object1.contentBounds.yMax < event.object2.contentBounds.yMin) then
        physics.setGravity(0, 7)
        for i, row in ipairs(rows) do row:moveNormal() end
    end
end

Runtime:addEventListener("preCollision", checkLanding)
