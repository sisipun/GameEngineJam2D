Ground = Entity.extend(Entity)

function Ground:new(x, y, width, height, sprite)
    Ground.super.new(self, x, y, width, height, sprite)
end
