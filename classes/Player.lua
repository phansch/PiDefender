Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"
winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()

local playerSize = 0.5

Player = Class{function(self)
    self.pos = vector.new(winWidth / 2, winHeight/2)
end}
Player.speed = 5

function Player:update(dt, player)
    self.direction = vector.new(love.mouse.getX(), love.mouse.getY())
end

function Player:draw()
    if(self.direction:dist(self.pos) > 200) then
       angle = math.atan2(self.pos.y-self.direction.y, self.pos.x-self.direction.x) + math.pi - playerSize/2
    end

    love.graphics.print("angle: " .. angle, 30, 10)
    love.graphics.print("Distance center <-> mouse: "..self.pos:dist(self.direction), 30, 30)
    love.graphics.arc( "line", self.pos.x, self.pos.y, 230, angle, angle + playerSize)
end
