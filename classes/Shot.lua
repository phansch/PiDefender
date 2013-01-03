Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"

Shot = Class{function(self, targetVector)
    self.position = vector.new(winWidth/2, winHeight/2)
    self.acceleration = vector.new(0.1, 0.1)
    self.velocity = vector.new(0, 0)
    self.direction = vector.new(0,0)
    distance = self.position - targetVector
end}
Shot.speed = 10

function Shot:load()
    Shot.img = love.graphics.newImage("graphics/projectile.png")
end

function Shot:update(dt)
    self.direction = self.direction + distance
    self.acceleration = self.direction:normalized()
    self.velocity = self.velocity + self.acceleration * dt * -1 * Shot.speed
    self.position = self.position + self.velocity
end

function Shot:draw()
    love.graphics.draw(Shot.img, self.position:unpack())
end

function Shot:isInBounds()
    return (self.position.x > 0) and (self.position.y > 0) and (self.position.x < winWidth) and (self.position.y < winHeight)
end
