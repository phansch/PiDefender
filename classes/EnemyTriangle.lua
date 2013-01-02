Class = require ".libraries.hump.class"
vector = require ".libraries.hump.vector"



EnemyTriangle = Class{function(self, position)
    self.position = position
    self.targetVector = vector.new(winWidth/2, winHeight/2)
end}
EnemyTriangle.speed = 50

function EnemyTriangle:load()
    enemyImg = love.graphics.newImage("graphics/enemy1.png")
    imgWidth = enemyImg:getWidth()
    imgHeight = enemyImg:getHeight()
end

function EnemyTriangle:update(dt)
    self.direction = self.position - self.targetVector
    self.angle = math.atan2(self.position.y-self.targetVector.y, self.position.x-self.targetVector.x) + math.pi/2
    self.position = self.position + self.direction:normalized() * -1
end

function EnemyTriangle:draw()
    love.graphics.draw(enemyImg, self.position.x, self.position.y, self.angle, 1, 1, imgWidth/2, imgHeight/2)
end