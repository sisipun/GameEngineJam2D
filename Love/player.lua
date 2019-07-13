Player = Entity.extend(Entity)

function Player:new(x, y, width, height, horizontalVeloity, verticalVelocity, sprite)
    Player.super.new(self, x, y, width, height, sprite)
    self.horizontalVeloity = horizontalVeloity
    self.verticalVelocity = verticalVelocity
end

function Player:update(dt)
    Player.super.update(self, dt)
    
    if love.keyboard.isDown("right") then self.x = self.x + self.horizontalVeloity * dt end
    if love.keyboard.isDown("left") then self.x = self.x - self.horizontalVeloity * dt end

    self.y = self.y + self.verticalVelocity * dt
end

function Player:getY()
    return self.y
end
