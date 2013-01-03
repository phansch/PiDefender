Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"
require ".classes.Shot"

local cannonCirc = 0.5 --circumference
local cannonRadius = 30
local angle = 0
local cannonShots = {}

Cannon = Class{function(self, circleRadius)
    self.position = vector.new(winWidth / 2, winHeight/2)
    self.circleRadius = circleRadius
    self.direction = vector.new(love.mouse.getX(), love.mouse.getY())
end}
Cannon.speed = 5

function Cannon:update(dt, circleradius)
    self.direction = vector(love.mouse.getX(), love.mouse.getY())
    self.circleRadius = circleradius

    for i,shot in ipairs(cannonShots) do
        shot:update(dt)
        if not shot:isInBounds() then
            table.remove(cannonShots, i)
        end
    end
end

function Cannon:draw()
    -- Only update cannon direction when mouse is outside of circle
    if(self.direction:dist(self.position) > self.circleRadius) then
       angle = math.atan2(self.position.y-self.direction.y, self.position.x-self.direction.x) + math.pi - cannonCirc/2
    end

    for i,shot in ipairs(cannonShots) do
        shot:draw()
    end

    love.graphics.arc("line", self.position.x, self.position.y, self.circleRadius+cannonRadius, angle, angle + cannonCirc)
end

function Cannon:shoot()
    local mouseVector = vector(love.mouse.getX(), love.mouse.getY())

    shot = Shot(mouseVector)
    shot:load()
    table.insert(cannonShots, shot)
end

Signals.register('cannon_shoot', function()
    Cannon:shoot()
end)