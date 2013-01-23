Class = require ".libraries.hump.class"
require ".libraries.Helper"

aoe = Class{function(self, targetVector, angle)
    self.radius = 0
    self.maxRadius = 100
    self.angle = angle
    self.targetVector = targetVector
    self.position = getCirclePoint(vector.new(winWidth/2, winHeight/2), self.angle, self.maxRadius)
    self.acceleration = vector.new(0.1, 0.1)
    self.velocity = vector.new(0, 0)
    self.direction = vector.new(0,0)
    self.stop = false
end}
aoe.speed = 5

function aoe:update(dt)
    if self.position:dist(self.targetVector) > 5 and not self.stop then
        self.direction = self.position - self.targetVector

    else
        self.stop = true
        self.direction = vector.new(0,0)
        if not self.emitted then
            Signals.emit('aoe_init', self)
            self.emitted = true
        end
    end
    self.acceleration = self.direction:normalized() * -1
    self.velocity = self.velocity + self.acceleration * dt * aoe.speed
    if not self.stop then
        self.position = self.position + self.velocity
    end
    self.angle = math.atan2(winCenter.y-self.targetVector.y, winCenter.x-self.targetVector.x) + math.pi
end

function aoe:draw()
    if not self.stop then
        love.graphics.draw(aoeimg, self.position.x, self.position.y, self.angle + math.pi/2, 2, 2)
    else
        if self.radius < self.maxRadius then
            love.graphics.circle("line", self.position.x, self.position.y, self.radius, 50)
        end
    end

end

function aoe:isInBounds()
    return (self.position.x > 0) and (self.position.y > 0) and (self.position.x < winWidth) and (self.position.y < winHeight)
end

function aoe:checkCollision(triangleEnemy)
    local shot_pos2 = self.position + ShotimgSize
    local object2_pos = triangleEnemy.position + triangleEnemy.imgSize

    return self.position.x < object2_pos.x and shot_pos2.x > triangleEnemy.position.x and
        self.position.y < triangleEnemy.position.y and shot_pos2.y > triangleEnemy.position.y
end

function aoe:checkCollision(player)
    local shot_pos2 = self.position + ShotimgSize
    local object2_pos = player.position + player.imgSize

    return self.position.x < object2_pos.x and shot_pos2.x > player.position.x and
        self.position.y < player.position.y and shot_pos2.y > player.position.y
end

Signals.register('aoe_init', function(aoe)
    --increase maxRadius
    Timer.addPeriodic(0.01, function()
        aoe.radius = aoe.radius + 3
    end, 100)
end)