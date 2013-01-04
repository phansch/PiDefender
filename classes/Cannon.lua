Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"
require ".classes.Shot"

local cannonCirc = 0.5 --circumference
local cannonRadius = 30
local angle = 0

Cannon = Class{function(self, circleRadius)
    self.position = vector.new(winWidth / 2, winHeight/2)
    self.circleRadius = circleRadius
    self.direction = vector.new(love.mouse.getX(), love.mouse.getY())
end}
Cannon.speed = 5
Cannon.cannonShots = {}

-- need to determine vector to cannon end:
--

function Cannon:update(dt, circleradius)
    self.direction = vector(love.mouse.getX(), love.mouse.getY())
    self.circleRadius = circleradius

    for i,shot in ipairs(Cannon.cannonShots) do
        shot:update(dt)
        if not shot:isInBounds() then
            table.remove(Cannon.cannonShots, i)
        end
    end
end

function Cannon:draw()
    -- Only update cannon direction when mouse is outside of circle
    if(self.direction:dist(self.position) > self.circleRadius) then
       angle = math.atan2(self.position.y-self.direction.y, self.position.x-self.direction.x) + math.pi - cannonCirc/2
    end
    love.graphics.print(angle, 20, 20)
    love.graphics.setPointSize(5)
    local test = vector.new(self.position.x+self.circleRadius, self.position.y):rotated(angle)
    love.graphics.print("dist: "..self.position:dist(test), 10, 10)
    love.graphics.line(self.position.x, self.position.y, test:unpack())
    for i,shot in ipairs(Cannon.cannonShots) do
        shot:draw()
    end

    love.graphics.arc("line", self.position.x, self.position.y, self.circleRadius+cannonRadius, angle, angle + cannonCirc)
end

function Cannon:shoot()
    local mouseVector = vector(love.mouse.getX(), love.mouse.getY())

    shot = Shot(mouseVector, angle, self.circleRadius)
    shot:load()
    table.insert(Cannon.cannonShots, shot)
end

Signals.register('cannon_shoot', function()
    Cannon:shoot()
end)