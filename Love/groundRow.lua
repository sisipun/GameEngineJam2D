GroundRow = Object.extend(Object)

function GroundRow:new(y, rowSize, elemWidth, elemHeight)
    if (rowSize < 3) then rowSize = 3 end

    self.values = {}
    self.y = y
    self.past = false
    self.landed = false

    self.rowSize = rowSize
    self.holeIndex = love.math.random(2, rowSize - 2)
    self.elemWidth = elemWidth

    for i = 0, rowSize do
        if (i ~= self.holeIndex) then
            table.insert(self.values, Ground(i * elemWidth, y, elemWidth,
                                             elemHeight, groundSprite))
        end
    end
end

function GroundRow:addEnemy(enemySprite)
    position = love.math.random(0, self.rowSize)
    if (position == self.holeIndex) then position = position + 1 end
    self.enemy = Enemy(position, position * self.elemWidth, self.y - 50, 50, 50, 150, 200,
                       enemySprite)
end

function GroundRow:update(dt, borders)
    for i, value in ipairs(self.values) do value:update(dt) end
    if (self.enemy ~= nil) then
        if (self.enemy:getX() < borders.x or (self.enemy:getIndex() > self.holeIndex and self.enemy:getX() <
            (self.holeIndex + 1) * self.elemWidth)) then
            self.enemy:moveRight()
        end
        if (self.enemy:getX() + self.enemy:getWidth() > borders.x +
            borders.width or (self.enemy:getIndex() < self.holeIndex and self.enemy:getX() + self.enemy:getWidth() >
            self.holeIndex * self.elemWidth)) then 
                self.enemy:moveLeft() 
            end
        self.enemy:update(dt)
    end
end

function GroundRow:resolveCollision()
    if (self.enemy ~= nil) then
        for i, ground in ipairs(self.values) do
            self.enemy:resolveCollision(ground)
        end
    end
end

function GroundRow:getEnemy() return self.enemy end

function GroundRow:killEnemy() self.enemy = nil end

function GroundRow:getY() return self.y end

function GroundRow:getValues() return self.values end

function GroundRow:draw()
    for i, value in ipairs(self.values) do
        value:draw()
        if (self.enemy ~= nil) then self.enemy:draw() end
    end
end

function GroundRow:setAsPast() self.past = true end

function GroundRow:wasPast() return self.past end

function GroundRow:setAsLanded() self.landed = true end

function GroundRow:wasLanded() return self.landed end
