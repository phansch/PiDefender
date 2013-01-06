Class = require ".libraries.hump.class"
require ".libraries.helper"

Shot = Class{function(self, targetVector, angle, radius)
    self.position = getCirclePoint(vector.new(winWidth/2, winHeight/2), angle, radius)
    self.acceleration = vector.new(1, 1)
    self.velocity = vector.new(0, 0)
    self.direction = vector.new(0,0)
    distance = self.position - targetVector
end}
Shot.speed = 10

function Shot:load()
    Shot.img = love.graphics.newImage("graphics/projectile.png")
    Shot.imgSize = vector.new(Shot.img:getWidth(), Shot.img:getHeight())
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

function Shot:checkCollision(triangleEnemy)
    local shot_pos2 = self.position + self.imgSize
    local object2_pos = triangleEnemy.position + triangleEnemy.imgSize

    return self.position.x < object2_pos.x and shot_pos2.x > triangleEnemy.position.x and
        self.position.y < triangleEnemy.position.y and shot_pos2.y > triangleEnemy.position.y
end