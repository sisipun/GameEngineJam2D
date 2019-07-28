Hero = Object.extend(Object)

function Hero:new(body, x, y, velocity, physics)
    self.body = body
    self.body.x = x
    self.body.y = y
    physics.addBody(self.body, "dynamic", {density=1, bounce = 0.0})
    self.body.isFixedRotation = true
    self.velocity = velocity
end

function Hero:getBody() return self.body end

function Hero:touch(event)
    local dx, dy = self.body:getLinearVelocity()
    if (event.phase == "began") then
        if event.x >= display.contentCenterX then
            self.body:setLinearVelocity(self.velocity, dy)
        elseif event.x <= display.contentCenterX then
            self.body:setLinearVelocity(-self.velocity, dy)
        end
    elseif (event.phase == "ended") then
        self.body:setLinearVelocity(0, dy)
    end
end
