Player = Object.extend(Object)

function Player:new(x, y, width, height, speed, sprite)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = speed
    self.sprite = sprite
end

function Player:update(dt)
    if love.keyboard.isDown("right") then self.x = self.x + self.speed * dt end
    if love.keyboard.isDown("left") then self.x = self.x - self.speed * dt end
end

function Player:draw()
    local scaleX, scaleY = getImageScaleForNewDimensions(self.sprite, self.width, self.height)
    love.graphics.draw(self.sprite, self.x, self.y, 0, scaleX, scaleY)
end