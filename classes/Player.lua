Class = require ".libraries.hump.class"

Player = Class{function(self)
end}
Player.enabled = true
Player.lives = 5
Player.score = 0

function Player:load()
    self.img = love.graphics.newImage("graphics/hexagon.png")
    self.imgSize = vector.new(self.img:getWidth(), self.img:getHeight())
end

function Player:update()
    self.position = mousePos
end

function Player:draw()
    if self.enabled then
        love.graphics.draw(self.img, mousePos.x - self.imgSize.x/2, mousePos.y - self.imgSize.y/2, 0)
    end

    -- draw player live count
    for i=1,self.lives do
        love.graphics.draw(self.img, 10 * i * 3.5, winHeight-40)
    end

    --draw player score
    love.graphics.print("Score: "..self.score, 250, winHeight-20)
end

function Player:isInsideSafezone(cannonRadius)
    return self.position:dist(winCenter) > cannonRadius
end

function Player:hasCollided(triangleEnemy)
    if self.enabled then
        local player_pos2 = self.position + self.imgSize
        local object2_pos = triangleEnemy.position + triangleEnemy.imgSize

        return self.position.x < object2_pos.x and player_pos2.x > triangleEnemy.position.x and
            self.position.y < triangleEnemy.position.y and player_pos2.y > triangleEnemy.position.y
    end
end

function Player:hasCollidedCircle(radius)
    if self.position:dist(winCenter) < radius then
        return true
    end
    return false
end