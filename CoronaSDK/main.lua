local background = display.newImageRect("assets/background.png",
                                        display.contentWidth,
                                        display.contentHeight)
background.x = display.contentCenterX
background.y = display.contentCenterY

local hero = display.newImageRect("assets/hero_single.png", 30, 50)
hero.x = display.contentCenterX
hero.y = display.contentCenterY

local physics = require("physics")
physics.start()

physics.addBody(hero, "dynamic")
hero.isFixedRotation = true

local motionX = 0
local groups = {}
local groupGenerationBorder = display.contentHeight / 2

local function playerVelocity(event)
    if (event.phase == "began") then
        if event.x >= display.contentCenterX then
            motionX = 2
        elseif event.x <= display.contentCenterX then
            motionX = -2
        end
    elseif (event.phase == "ended") then
        motionX = 0
    end
end

Runtime:addEventListener("touch", playerVelocity)

local function moveHero(event) hero.x = hero.x + motionX end

Runtime:addEventListener("enterFrame", moveHero)

local function generateGroundRow()
    holeIndex = math.random(2, 5)
    group = {}
    for i = 0, 7 do
        if (i ~= holeIndex) then
            local ground = display.newImageRect("assets/ground_single.png", 50,
                                                50)
            ground.x = i * 50
            ground.y = display.contentHeight + 100
            physics.addBody(ground, "static")
            table.insert(group, ground)
        end
    end
    table.insert(groups, group)
end

local function moveGrous(event)
    local groupY = 0
    for i, group in ipairs(groups) do
        for i, ground in ipairs(group) do
            ground.y = ground.y - 1
            groupY = ground.y
        end
    end
    if groupY < groupGenerationBorder then generateGroundRow() end
end

Runtime:addEventListener("enterFrame", moveGrous)

generateGroundRow()
