Class = require ".libraries.hump.class"
require ".libraries.Helper"

Shot = Class{function(self, targetVector, angle, radius)
    self.angle = angle
    self.targetVector = targetVector
    self.position = getCirclePoint(vector.new(winWidth/2, winHeight/2), self.angle, radius)
    self.acceleration = vector.new(0.1, 0.1)
    self.velocity = vector.new(0, 0)
    self.direction = vector.new(0,0)
    self.distance = self.position - self.targetVector
end}
Shot.speed = 5

function Shot:update(dt)
    self.direction = self.direction + self.distance
    self.acceleration = self.direction:normalized()
    self.velocity = self.velocity + self.acceleration * dt * -1 * Shot.speed
    self.position = self.position + self.velocity
    self.angle = math.atan2(winCenter.y-self.targetVector.y, winCenter.x-self.targetVector.x) + math.pi
end

function Shot:draw()
    love.graphics.draw(Shotimg, self.position.x, self.position.y, self.angle + math.pi/2, 2, 2)
end

function Shot:isInBounds()
    return (self.position.x > 0) and (self.position.y > 0) and (self.position.x < winWidth) and (self.position.y < winHeight)
end

function Shot:checkCollision(triangleEnemy)
    local shot_pos2 = self.position + ShotimgSize
    local object2_pos = triangleEnemy.position + triangleEnemy.imgSize

    return self.position.x < object2_pos.x and shot_pos2.x > triangleEnemy.position.x and
        self.position.y < triangleEnemy.position.y and shot_pos2.y > triangleEnemy.position.y
end

function Shot:checkCollision(player)
    local shot_pos2 = self.position + ShotimgSize
    local object2_pos = player.position + player.imgSize

    return self.position.x < object2_pos.x and shot_pos2.x > player.position.x and
        self.position.y < player.position.y and shot_pos2.y > player.position.y
end