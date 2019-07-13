GroundRow = Object.extend(Object)

function GroundRow:new(y, rowSize, elemWidth, elemHeight)
    if (rowSize < 3) then
        rowSize = 3
    end
    
    self.values = {}
    self.y = y

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