GroundRow = Entity.extend(Entity)

function GroundRow:new(y, rowSize, elemWidth, physics, display)
    self.values = {}
    self.y = y
    self.past = false
    self.touched = false
    holeIndex = math.random(2, rowSize - 2)
    for i = 0, rowSize do
        if (i ~= holeIndex) then
            local ground = display.newImageRect("assets/ground_single.png",
                                                elemWidth, elemWidth)
            ground.x = i * elemWidth
            ground.y = y
            physics.addBody(ground, "static")
            table.insert(self.values, ground)
        end
    end
end

function GroundRow:getValues() return self.values end

function GroundRow:getY() return self.y end

function GroundRow:enterFrame(event)
    for i, ground in ipairs(self.values) do
        ground.y = ground.y - 1
        self.y = ground.y
    end
end

function GroundRow:collision(event)
    self.touched = true
end

function GroundRow:wasPast()
    return self.past
end

function GroundRow:wasTouched()
    return self.touched
end

function GroundRow:setAsPast()
    self.past = true
end

function GroundRow:remove()
    self.values = {}
end
