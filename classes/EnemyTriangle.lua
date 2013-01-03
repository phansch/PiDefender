Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"

EnemyTriangle = Class{function(self, position)
    self.position = position
    self.targetVector = vector.new(winWidth/2, winHeight/2)
end}
EnemyTriangle.speed = 2

function EnemyTriangle:load()
    img = love.graphics.newImage("graphics/enemy1.png")
    self.imgWidth = img:getWidth()
    self.imgHeight = img:getHeight()
end

function EnemyTriangle:update(dt)
    self.direction = self.position - self.targetVector
    self.angle = math.atan2(self.position.y-self.targetVector.y, self.position.x-self.targetVector.x) + math.pi/2
    self.position = self.position + self.direction:normalized() * -1 * EnemyTriangle.speed
end

function EnemyTriangle:draw()
    centerVector = vector.new(winWidth/2, winHeight/2)
    love.graphics.draw(img, self.position.x, self.position.y, self.angle, 1, 1, self.imgWidth/2, self.imgHeight/2)
end

function EnemyTriangle:hasCollided(radius)
    centerVector = vector.new(winWidth/2, winHeight/2)
    if self.position:dist(centerVector) < radius then
        return true
    end
    return false
end
