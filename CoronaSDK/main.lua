local background = display.newImageRect("assets/background.png",
                                        display.contentWidth,
                                        display.contentHeight)
background.x = display.contentCenterX
background.y = display.contentCenterY

local hero = display.newImageRect("assets/hero_single.png", 30, 50)
hero.x = display.contentCenterX
hero.y = display.contentCenterY

local ground = display.newImageRect("assets/ground_single.png", 50, 50)
ground.x = display.contentCenterX
ground.y = display.contentCenterY + 100

local physics = require("physics")
physics.setGravity(2, 6)
physics.start()

physics.addBody(ground, "static")
physics.addBody(hero, "dynamic")
hero.isFixedRotation = true

motionX = 0

function playerVelocity(event)
    if (event.phase == "began") then
        if event.x >= display.contentCenterX then
            motionX = 1
        elseif event.x <= display.contentCenterX then
            motionX = -1
        end
    elseif (event.phase == "ended") then
        motionX = 0
    end
end

Runtime:addEventListener("touch", playerVelocity)

local function moveHero(event) hero.x = hero.x + motionX end

Runtime:addEventListener("enterFrame", moveHero)

local function moveGround(event) ground.y = ground.y - 1 end

Runtime:addEventListener("enterFrame", moveGround)
