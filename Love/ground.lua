Ground = Object.extend(Object)

function Ground:new(x, y, width, height, sprite)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.sprite = sprite
end

function Ground:draw()
    local scaleX, scaleY = getImageScaleForNewDimensions(self.sprite, self.width, self.height)
    love.graphics.draw(self.sprite, self.x, self.y, 0, scaleX, scaleY)
end