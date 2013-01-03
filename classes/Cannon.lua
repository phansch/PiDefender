Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"
winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()

local cannonCirc = 0.5 --circumference
local cannonRadius = 30
local angle = 0

Cannon = Class{function(self, circleRadius)
    self.position = vector.new(winWidth / 2, winHeight/2)
    self.circleRadius = circleRadius
end}
Cannon.speed = 5

function Cannon:update(dt)
    self.direction = vector.new(love.mouse.getX(), love.mouse.getY())
end

function Cannon:draw()
    -- Only update cannon direction when mouse is outside of circle
    if(self.direction:dist(self.position) > self.circleRadius) then
       angle = math.atan2(self.position.y-self.direction.y, self.position.x-self.direction.x) + math.pi - cannonCirc/2
    end

    love.graphics.print("angle: " .. angle, 30, 10)
    love.graphics.print("Distance center <-> mouse: "..self.position:dist(self.direction), 30, 30)
    love.graphics.arc( "line", self.position.x, self.position.y, self.circleRadius+cannonRadius, angle, angle + cannonCirc)
end
