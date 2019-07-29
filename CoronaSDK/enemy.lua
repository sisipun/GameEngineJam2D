Enemy = Object.extend(Object)

function Enemy:new(body, x, y, velocity, physics, leftBorder, rightBorder, orientation)
    self.body = body
    self.body.x = x
    self.body.y = y
    self.velocity = velocity
    self.leftBorder = leftBorder
    self.rightBorder = rightBorder
    physics.addBody(self.body, "dynamic", {density = 1, bounce = 0.0})
    self.body.isFixedRotation = true
    self.body:setLinearVelocity(self.velocity, 0)
    self.orientation = orientation
end

function Enemy:getBody() return self.body end

function Enemy:remove()
    self.body = nil 
end

function Enemy:enterFrame(event)
    if (self.body == nil) then
        return
    end
    if (self.body.x < self.leftBorder or self.body.x + self.body.width > self.rightBorder) then
        self.orientation = -1 * self.orientation
    end
    self.body:setLinearVelocity(self.orientation * self.velocity, 0)
end
