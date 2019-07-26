local background = display.newImageRect("assets/background.png", display.contentWidth, display.contentHeight)
background.x = display.contentCenterX
background.y = display.contentCenterY

local hero = display.newImageRect("assets/hero_single.png", 30, 50)
hero.x = display.contentCenterX
hero.y = display.contentCenterY

local ground = display.newImageRect("assets/ground_single.png", 50, 50)
ground.x = display.contentCenterX
ground.y = display.contentCenterY + 100