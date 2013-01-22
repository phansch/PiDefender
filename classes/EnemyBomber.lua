Class = require ".libraries.hump.class"
require ".classes.BomberShot"

EnemyBomber = Class{function(self)
    self.hp = 250
    self.shots = {}
    self.shotCount = 0
    self.color = {255, 0, 0, 255}

    self.direction = vector.new(0, -1)
    self.rotation = math.pi

    local y = winHeight + 10
    local x = 0
    local choose = math.random(1, 2)
    if choose == 1 then
        x = math.random(50, winWidth/2 - 150)
        print(choose.." x:"..x)
    else
        x = math.random(winWidth/2 + 150, winWidth-50)
        print(choose.." x:"..x)
    end

    self.startPos = vector.new(x, y)
    print(self.startPos)
    self.position = self.startPos
end}
EnemyBomber.speed = 2
EnemyBomber.damage = 30

function EnemyBomber:load()
    EnemyBomber.img = love.graphics.newImage("graphics/triangle-bomber.png")
    EnemyBomber.imgSize = vector.new(EnemyBomber.img:getWidth()*0.2, EnemyBomber.img:getHeight()*0.2)
end

function EnemyBomber:update(dt, player)
    self.position = self.position + self.direction * EnemyBomber.speed
    self:warp()

    for i,bomberShot in ipairs(self.shots) do
        bomberShot:update(dt)
    end

    --create a new shot 3 seconds after destruction
    if self.shotCount == 0 then
        Timer.add(3, function()
            self:shoot()
        end)
        self.shotCount = 1
    end
end

function EnemyBomber:warp()
    self.position.y = self.position.y % (winHeight+20)
end

function EnemyBomber:draw()
    love.graphics.setColorMode("modulate")
    love.graphics.setColor(self.color)
    love.graphics.draw(self.img, self.position.x+EnemyBomber.imgSize.x, self.position.y+EnemyBomber.imgSize.y, self.rotation, 0.2, 0.2, self.imgSize.x/2, self.imgSize.y/2)
    love.graphics.setColor(255, 255, 255, 255)

    --draw shot
    for i,shot in ipairs(self.shots) do
        shot:draw()
    end
end

function EnemyBomber:shoot()
    --fires into window center until it collides with circle or earth
    local shot = BomberShot(self.position)
    shot:load()
    table.insert(self.shots, shot)
end

function EnemyBomber:hasCollided(player)
    local shot_pos2 = self.position + EnemyBomber.imgSize
    local object2_pos = player.position

    return self.position.x < object2_pos.x and shot_pos2.x > player.position.x and
        self.position.y < player.position.y and shot_pos2.y > player.position.y
end