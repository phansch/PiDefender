Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"
winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()

Player = Class{function(self)
    self.pos = vector.new(winWidth / 2, winHeight/2)
    self.direction = vector.new(0, 0)
end}
Player.speed = 5

function Player:update(dt, player)
    self.direction = vector.new(love.mouse.getX(), love.mouse.getY())
end

function Player:draw()
    angle = math.atan2(self.pos.y-self.direction.y, self.pos.x-self.direction.x) + math.pi

    love.graphics.print("angle: " .. angle, 30, 10)
    love.graphics.print("Distance center <-> mouse: "..self.pos:dist(self.direction), 30, 30)
    love.graphics.arc( "line", self.pos.x, self.pos.y, 230, angle, angle + 0.5)
end
