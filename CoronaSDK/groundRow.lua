GroundRow = Object.extend(Object)

function GroundRow:new(id, y, rowSize, elemSize, velocity, enemyId, enemySize,
                       enemyVelocity, physics, display)
    self.values = {}
    self.y = y
    self.past = false
    self.touched = false
    self.velocity = velocity
    self.isMoveFast = false
    holeIndex = math.random(2, rowSize - 2)
    for i = 0, rowSize do
        if (i ~= holeIndex) then
            local ground = display.newImageRect("assets/ground_single.png",
                                                elemSize, elemSize)
            ground.x = i * elemSize
            ground.y = y
            ground.id = id
            physics.addBody(ground, "kinematic",
                            {density = 400, friction = 0.0, bounce = 0.0})
            ground:setLinearVelocity(0, -self.velocity)
            table.insert(self.values, ground)
        end
    end
    enemyOrientation = math.random(0, 1)
    if (enemyOrientation == 1) then
        leftBorder = holeIndex * elemSize + elemSize
        rightBorder = display.screenOriginX + display.contentWidth + enemySize /
                          2
    else
        leftBorder = display.screenOriginX + enemySize / 2
        rightBorder = holeIndex * elemSize
        enemyOrientation = -1
    end
    self.enemy = Enemy(display.newImageRect("assets/enemy_single.png",
                                            enemySize, enemySize), enemyId,
                       (holeIndex + enemyOrientation) * elemSize, y - enemySize,
                       enemyVelocity, physics, leftBorder, rightBorder,
                       enemyOrientation)
end

function GroundRow:getValues() return self.values end

function GroundRow:getEnemy() return self.enemy end

function GroundRow:getY() return self.y end

function GroundRow:enterFrame(event)
    for i, ground in ipairs(self.values) do
        self.y = ground.y
        if (self.isMoveFast) then
            ground:setLinearVelocity(0, -2.5 * self.velocity)
        else
            ground:setLinearVelocity(0, -self.velocity)
        end
    end
end

function GroundRow:collision(event)
    if (event.object1.id == "ground" or event.object2.id == "ground") then
        if (event.object1.id == "hero" or event.object2.id == "hero") then
            self.touched = true
        end
    end
end

function GroundRow:wasPast() return self.past end

function GroundRow:wasTouched() return self.touched end

function GroundRow:setAsPast() self.past = true end

function GroundRow:remove(display)
    for i, ground in ipairs(self.values) do display.remove(ground) end
    display.remove(self.enemy:getBody())
    self.enemy:remove()
    self.values = {}
end

function GroundRow:moveFast() self.isMoveFast = true end

function GroundRow:moveNormal() self.isMoveFast = false end
