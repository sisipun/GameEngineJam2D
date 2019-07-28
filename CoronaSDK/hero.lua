Hero = Entity.extend(Entity)

function Hero:new(body, x, y, physics)
    self.body = body
    self.body.x = x
    self.body.y = y
    physics.addBody(self.body, "dynamic")
    self.body.isFixedRotation = true
    self.velocity = 0
end

function Hero:getBody() return self.body end

function Hero:enterFrame(event) 
    self.body.x = self.body.x + self.velocity
end

function Hero:touch(event)
    if (event.phase == "began") then
        if event.x >= display.contentCenterX then
            self.velocity = 2
        elseif event.x <= display.contentCenterX then
            self.velocity = -2
        end
    elseif (event.phase == "ended") then
        self.velocity = 0
    end
end