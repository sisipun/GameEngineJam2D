GroundRow = Object.extend(Object)

function GroundRow:new(y, rowSize, elemWidth, velocity, physics, display)
    self.values = {}
    self.y = y
    self.past = false
    self.touched = false
    self.velocity = velocity
    holeIndex = math.random(2, rowSize - 2)
    for i = 0, rowSize do
        if (i ~= holeIndex) then
            local ground = display.newImageRect("assets/ground_single.png",
                                                elemWidth, elemWidth)
            ground.x = i * elemWidth
            ground.y = y
            physics.addBody(ground, "kinematic", {density=400, friction = 0.0, bounce = 0.0})
            ground:setLinearVelocity(0, -self.velocity)
            table.insert(self.values, ground)
        end
    end
end

function GroundRow:getValues() return self.values end

function GroundRow:getY() return self.y end

function GroundRow:enterFrame(event)
    for i, ground in ipairs(self.values) do self.y = ground.y end
end

function GroundRow:collision(event) self.touched = true end

function GroundRow:wasPast() return self.past end

function GroundRow:wasTouched() return self.touched end

function GroundRow:setAsPast() self.past = true end

function GroundRow:remove() self.values = {} end

function GroundRow:moveFast()
    for i, ground in ipairs(self.values) do
        ground:setLinearVelocity(0, -2.5 * self.velocity)
    end
end

function GroundRow:moveNormal()
    for i, ground in ipairs(self.values) do
        ground:setLinearVelocity(0, -self.velocity)
    end
end
