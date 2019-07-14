Entity = Object.extend(Object)

collisionStatuses = {NONE = 0, RIGHT = 1, LEFT = 2, BOTTOM = 3, TOP = 4}

function Entity:new(x, y, width, height, weight, sprite)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.sprite = sprite

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y

    self.gravity = 0
    self.weight = weight
    self.canJump = false
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y

    self.gravity = self.gravity + self.weight * dt

    self.y = self.y + self.gravity * dt
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
            if self.x + self.width < e.x + self.width then
                local pushback = self.x + self.width - e.x
                self.x = self.x - pushback
                return collisionStatuses.RIGHT
            else
                local pushback = e.x + e.width - self.x
                self.x = self.x + pushback
                return collisionStatuses.LEFT
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.y + self.height < e.y + self.height then
                local pushback = self.y + self.height - e.y
                self.y = self.y - pushback
                if (self.gravity > 0) then self.gravity = 0 end
                self.canJump = true
                return collisionStatuses.BOTTOM
            else
                local pushback = e.y + e.height - self.y
                self.y = self.y + pushback
                return collisionStatuses.TOP
            end
        end
    end

    return collisionStatuses.NONE
end
