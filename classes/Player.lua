Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"
winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()

local playerCirc = 0.5 --circumference
local playerRadius = 30
local angle = 0

Player = Class{function(self, circleRadius)
    self.position = vector.new(winWidth / 2, winHeight/2)
    self.circleRadius = circleRadius
end}
Player.speed = 5

function Player:update(dt)
    self.direction = vector.new(love.mouse.getX(), love.mouse.getY())
end

function Player:draw()
    -- Only update player direction when mouse is outside of circle
    if(self.direction:dist(self.position) > self.circleRadius) then
       angle = math.atan2(self.position.y-self.direction.y, self.position.x-self.direction.x) + math.pi - playerCirc/2
    end

    love.graphics.print("angle: " .. angle, 30, 10)
    love.graphics.print("Distance center <-> mouse: "..self.position:dist(self.direction), 30, 30)
    love.graphics.arc( "line", self.position.x, self.position.y, self.circleRadius+playerRadius, angle, angle + playerCirc)
end
