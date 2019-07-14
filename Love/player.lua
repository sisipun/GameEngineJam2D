Player = Entity.extend(Entity)

function Player:new(x, y, width, height, horizontalVeloity, weight, sprite)
    Player.super.new(self, x, y, width, height, weight, sprite)
    self.horizontalVeloity = horizontalVeloity
    self.verticalVelocity = verticalVelocity
end

function Player:update(dt, borders)
    Player.super.update(self, dt)
    
    if (love.keyboard.isDown("right") and self.x + self.width < borders.x + borders.width) then self.x = self.x + self.horizontalVeloity * dt end
    if (love.keyboard.isDown("left") and self.x > borders.x) then self.x = self.x - self.horizontalVeloity * dt end
    if (love.keyboard.isDown("space") and self.canJump) then 
        self.gravity = -200
        self.canJump = false 
    end
end

function Player:getY()
    return self.y
end
