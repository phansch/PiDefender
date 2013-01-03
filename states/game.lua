Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Cannon"
require ".classes.EnemyTriangle"

cannon = Cannon(150)
triangles = {} --basic enemies
hitpoints = 5

function state:init()
    Timer.addPeriodic(0.5, function() self.createFighter() end, 25)

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
    origin = math.random(0, 4)

    -- there must be a better way to make them spawn from different edges
    if origin == 1 then -- spawn from left side
        y = math.random(-10, winHeight+10)
        x = -10
    elseif origin == 2 then -- spawn from right side
        y = math.random(-10, winHeight+10)
        x = winWidth + 10
    elseif origin == 3 then
        y = winHeight + 10
        x = math.random(-10, winWidth+10)
    elseif origin == 4 then -- spawn from top side
        y = -10
        x = math.random(-10, winWidth+10)
    end

    love.graphics.print("Test", 100, 50)
    enemyTri = EnemyTriangle(vector.new(x, y))
    enemyTri:load()
    table.insert(triangles, enemyTri)
end

Signals.register('circle_hit', function(i)
    hitpoints = hitpoints - 1
end)