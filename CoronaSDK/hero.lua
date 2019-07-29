Hero = Object.extend(Object)

function Hero:new(body, id, x, y, horizontalVelocity, verticalVelocity, physics)
    self.body = body
    self.body.id = id
    self.body.x = x
    self.body.y = y
    self.horizontalVelocity = horizontalVelocity
    self.verticalVelocity = verticalVelocity
    physics.addBody(self.body, "dynamic", {density = 1, bounce = 0.0})
    self.body.isFixedRotation = true
    self.onGround = false
end

function Hero:getBody() return self.body end

function Hero:touch(event)
    local dx, dy = self.body:getLinearVelocity()
    if (event.phase == "began") then
        if event.y <= display.contentCenterY and self.onGround then
            self.body:setLinearVelocity(dx, -self.verticalVelocity)
            self.onGround = false
        elseif event.x >= display.contentCenterX then
            self.body:setLinearVelocity(self.horizontalVelocity, dy)
        elseif event.x <= display.contentCenterX then
            self.body:setLinearVelocity(-self.horizontalVelocity, dy)
        end
    elseif (event.phase == "ended") then
        self.body:setLinearVelocity(0, dy)
    end
end

function Hero:collision(event)
    if (event.object1.id == "hero" or event.object2.id == "hero") then
        self.onGround = true
    end
end
