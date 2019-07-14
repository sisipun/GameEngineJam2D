Enemy = Entity.extend(Entity)

function Enemy:new(index, x, y, width, height, horizontalVeloity,
                   verticalVelocity, sprite)
    Player.super.new(self, x, y, width, height, sprite)
    self.horizontalVeloity = horizontalVeloity
    self.verticalVelocity = verticalVelocity
    self.direction = 1
    self.index = index
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)

    self.x = self.x + self.horizontalVeloity * self.direction * dt
    self.y = self.y + self.verticalVelocity * dt
end

function Enemy:getX() return self.x end

function Enemy:getWidth() return self.width end

function Enemy:moveLeft() self.direction = -1 end

function Enemy:moveRight() self.direction = 1 end

function Enemy:getIndex() return self.index end
