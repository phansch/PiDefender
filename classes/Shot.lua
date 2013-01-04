Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"

Shot = Class{function(self, targetVector, angle, radius)
    self.angle = angle
    self.circleRadius = radius
    self.position = vector.new(winWidth/2, winHeight/2)
    self.acceleration = vector.new(0.1, 0.1)
    self.velocity = vector.new(0, 0)
    self.direction = vector.new(0,0)
    distance = self.position - targetVector
end}
Shot.speed = 10

-- phi =
-- vector = cannon.position


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
    local test = vector(0,1):rotated(90)
    love.graphics.print(test.x, 5, 5)
    --love.graphics.line(self.position.x, self.position.y, vector.new(winWidth/2-1000/6, winHeight/2):unpack())
end

function Shot:isInBounds()
    return (self.position.x > 0) and (self.position.y > 0) and (self.position.x < winWidth) and (self.position.y < winHeight)
end


function Shot:checkCollision(triangleEnemy)
    local shot_pos2 = self.position + self.imgSize
    local object2_pos = triangleEnemy.position + EnemyTriangle.imgSize

    return self.position.x < object2_pos.x and shot_pos2.x > triangleEnemy.position.x and
        self.position.y < triangleEnemy.position.y and shot_pos2.y > triangleEnemy.position.y
end