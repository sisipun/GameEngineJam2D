GroundRow = Object.extend(Object)

function GroundRow:new(y, rowSize, elemWidth, elemHeight)
    if (rowSize < 3) then
        rowSize = 3
    end
    
    self.values = {}
    self.y = y
    self.past = false
    self.landed = false

    holeIndex = love.math.random(rowSize - 1)

    for i = 0, rowSize do
        if (i ~= holeIndex) then
            table.insert(self.values, Ground(i * elemWidth, y, elemWidth, elemHeight, groundSprite))
        end
    end
end

function GroundRow:getY() 
    return self.y
end

function GroundRow:getValues() 
    return self.values
end

function GroundRow:draw()
    for i, value in ipairs(self.values) do value:draw() end
end

function GroundRow:setAsPast()
    self.past = true
end

function GroundRow:wasPast()
    return self.past
end

function GroundRow:setAsLanded()
    self.landed = true
end

function GroundRow:wasLanded()
    return self.landed
end