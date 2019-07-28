Object = require "object"
require "entity"
require "hero"
require "groundRow"

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

-- Hero
local hero = Hero(display.newImageRect("assets/hero_single.png", 30, 50),
                  display.contentCenterX, display.contentCenterY, physics)
Runtime:addEventListener("enterFrame", hero)
Runtime:addEventListener("touch", hero)

-- Ground Rows
local rows = {}
local groupGenerationBorder = display.contentHeight / 1.5

local function generateGroundRow()
    if (lastRow == nil or lastRow:getY() < groupGenerationBorder) then
        local row = GroundRow(display.contentHeight + 100, 7, 50, physics,
                              display)
        Runtime:addEventListener("enterFrame", row)
        Runtime:addEventListener("collision", row)
        table.insert(rows, row)
        lastRow = row
    end
end

Runtime:addEventListener("enterFrame", generateGroundRow)

local function checkDeath()
    if (display.screenOriginY > hero:getBody().y) then
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        hero:getBody().x = display.contentCenterX
        hero:getBody().y = display.contentCenterY
        for i, row in ipairs(rows) do
            for i, ground in ipairs(row:getValues()) do
                display.remove(ground)
            end
            row:remove()
        end
        rows = {}
        lastRow = nil
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