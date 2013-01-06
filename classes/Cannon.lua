Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"
require ".classes.Shot"

Cannon = Class{function(self, circleRadius)
    self.position = vector.new(winWidth / 2, winHeight/2)
    self.circleRadius = circleRadius

    self.direction = vector.new(love.mouse.getX(), love.mouse.getY())
end}
Cannon.speed = 5
Cannon.circ = 0.5
Cannon.radius = 4
Cannon.cannonShots = {}

function Cannon:update(dt, circleradius)
    self.direction = vector(love.mouse.getX(), love.mouse.getY())
    self.circleRadius = circleradius

    -- Only update cannon direction when mouse is outside of circle
    if(self.direction:dist(self.position) > self.circleRadius) then
       self.angle = math.atan2(self.position.y-self.direction.y, self.position.x-self.direction.x) + math.pi - Cannon.circ/2
    end

    for i,shot in ipairs(Cannon.cannonShots) do
        shot:update(dt)

        -- remove shot when out of bounds
        if not shot:isInBounds() then
            table.remove(Cannon.cannonShots, i)
        end
    end
end

function Cannon:draw()
    for i,shot in ipairs(Cannon.cannonShots) do
        shot:draw()
    end
    love.graphics.setColor(255, 100, 0)
    love.graphics.arc("fill", self.position.x, self.position.y, self.circleRadius+Cannon.radius, self.angle, self.angle + Cannon.circ)
    love.graphics.setColor(255, 255, 255)
end

function Cannon:shoot(cannon, circleRadius)
    shot = Shot(mousePos, cannon.angle + Cannon.circ/2, circleRadius + Cannon.radius)
    shot:load()
    table.insert(Cannon.cannonShots, shot)
end

Signals.register('cannon_shoot', function(radius, angle)
    Cannon:shoot(radius, angle)
end)