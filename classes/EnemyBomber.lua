Class = require ".libraries.hump.class"
require ".classes.BomberShot"

EnemyBomber = Class{function(self, playerPos)
    self.playerPos = playerPos
    self.startY = math.random(1,2)
    if(self.startY == 1) then
        y = -10
        self.direction = vector.new(0, 1)
        self.rotation = math.pi * 2
    else
        y = winHeight + 10
        self.direction = vector.new(0, -1)
        self.rotation = math.pi
    end
    self.startPos = vector.new(math.random(10, winWidth-10), y)
    self.position = self.startPos
end}
EnemyBomber.speed = 2
EnemyBomber.damage = 30
EnemyBomber.shots = {}
EnemyBomber.shotCount = 0


function EnemyBomber:load()
    self.img = love.graphics.newImage("graphics/enemy1.png")
    self.imgSize = vector.new(self.img:getWidth()*2, self.img:getHeight()*2)

end

function EnemyBomber:update(dt, player)
    self.position = self.position + self.direction * EnemyBomber.speed
    self:warp()

    for i,bomberShot in ipairs(EnemyBomber.shots) do
        bomberShot:update(dt)
    end

    --create a new shot 3 seconds after destruction
    if EnemyBomber.shotCount == 0 then
        Timer.add(3, function()
            self:shoot()
        end)
        EnemyBomber.shotCount = 1
    end
end

function EnemyBomber:warp()
    self.position.y = self.position.y % (winHeight+20)
end

function EnemyBomber:draw()
    centerVector = vector.new(winWidth/2, winHeight/2)
    love.graphics.setColorMode("modulate")
    love.graphics.setColor(0, 255, 255)
    love.graphics.draw(self.img, self.position.x, self.position.y, self.rotation, 2, 2, self.imgSize.x/2, self.imgSize.y/2)
    love.graphics.setColor(255, 255, 255)

    --draw shot
    for i,shot in ipairs(EnemyBomber.shots) do
        shot:draw()
    end
end

function EnemyBomber:shoot()
    --fires into window center until it collides with circle or earth
    shot = BomberShot(self.position)
    shot:load()
    table.insert(EnemyBomber.shots, shot)
end

function EnemyBomber:hasCollided(player)
    centerVector = vector.new(winWidth/2, winHeight/2)
    if self.position:dist(centerVector) < radius then
        return true
    end
    return false
end