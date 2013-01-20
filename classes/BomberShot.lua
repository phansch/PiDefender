Class = require ".libraries.hump.class"
require ".libraries.Helper"

BomberShot = Class{function(self, position)
    self.angle = 0
    self.targetVector = winCenter
    self.position = position
    self.direction = vector.new(0,0)
end}
BomberShot.speed = 5

function BomberShot:load()
    self.img = love.graphics.newImage("graphics/projectile.png")
    self.imgSize = vector.new(self.img:getWidth(), self.img:getHeight())
    self.hasloaded = true
end

function BomberShot:update(dt)
    self.direction = self.position - self.targetVector
    self.angle = math.atan2(self.position.y-self.targetVector.y, self.position.x-self.targetVector.x) + math.pi/2
    self.position = self.position + self.direction:normalized() * -1 * EnemyTriangle.speed
end

function BomberShot:draw()
    love.graphics.draw(self.img, self.position.x, self.position.y, self.angle + math.pi/2, 1, 1)
end

function BomberShot:circleCollision(radius)
    centerVector = vector.new(winWidth/2, winHeight/2)
    if self.position:dist(centerVector) < radius then
        return true
    end
    return false
end

function BomberShot:playerCollision(player)
    local shot_pos2 = self.position + self.imgSize
    local object2_pos = player.position + player.imgSize

    return self.position.x < object2_pos.x and shot_pos2.x > player.position.x and
        self.position.y < player.position.y and shot_pos2.y > player.position.y
end