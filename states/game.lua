Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Cannon"
require ".classes.EnemyTriangle"

cannon = Cannon(150)
triangles = {} --basic enemies
hitpoints = 5

function state:init()
    Timer.addPeriodic(1, function() self.createFighter() end, 5)

    playerImg = love.graphics.newImage("graphics/hexagon.png")
end

function state:update(dt)
    cannon:update(dt)

    for i,tri in ipairs(triangles) do
        if not tri:hasCollided(150) then
            tri:update(dt)
        else
            table.remove(triangles, i)
            Signals.emit('circle_hit')
        end
    end
end

function state:draw()
    cannon:draw()
    love.graphics.circle("line", winWidth/2, winHeight/2, 150, 360)
    for i,tri in ipairs(triangles) do
        tri:draw()
    end

    love.graphics.draw(playerImg, love.mouse.getX()-16, love.mouse.getY()-16, 0)


    love.graphics.print(hitpoints, winWidth/2, winHeight/2)

end

function state:createFighter()
    love.graphics.print("Test", 100, 50)
    enemyTri = EnemyTriangle(vector.new(50, 50))
    enemyTri:load()
    table.insert(triangles, enemyTri)
end

Signals.register('circle_hit', function(i)
    hitpoints = hitpoints - 1
end)