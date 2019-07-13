Entity = Object.extend(Object)

collisionStatuses = {
    NONE = 0,
    VERTICAL = 1,
    HORIZONTAL = 2
}

function Entity:new(x, y, width, height, sprite)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.sprite = sprite

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
end

function Entity:draw()
    local scaleX, scaleY = getImageScaleForNewDimensions(self.sprite,
                                                         self.width, self.height)
    love.graphics.draw(self.sprite, self.x, self.y, 0, scaleX, scaleY)
end

function Entity:checkCollision(e)
    return self.x + self.width > e.x and self.x < e.x + e.width and self.y +
               self.height > e.y and self.y < e.y + e.height
end

function Entity:wasVerticallyAligned(e)
    return self.last.y < e.last.y + e.height and self.last.y + self.height >
               e.last.y
end

function Entity:wasHorizontallyAligned(e)
    return self.last.x < e.last.x + e.width and self.last.x + self.width >
               e.last.x
end

function Entity:resolveCollision(e)
    if self:checkCollision(e) then
        if self:wasVerticallyAligned(e) then
            if self.x + self.width / 2 < e.x + self.width / 2 then
                local pushback = self.x + self.width - e.x
                self.x = self.x - pushback
                return collisionStatuses.VERTICAL
            else
                local pushback = e.x + e.width - self.x
                self.x = self.x + pushback
                return collisionStatuses.VERTICAL
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.y + self.height / 2 < e.y + self.height / 2 then
                local pushback = self.y + self.height - e.y
                self.y = self.y - pushback
                return collisionStatuses.HORIZONTAL
            else
                local pushback = e.y + e.height - self.y
                self.y = self.y + pushback
                return collisionStatuses.HORIZONTAL
            end
        end
    end

    return collisionStatuses.NONE
end
