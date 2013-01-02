Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Player"
require ".classes.EnemyTriangle"

player = Player(150)
triangles = {} --basic enemies

function state:init()
    Timer.addPeriodic(1, function() self.createFighter() end, 5)
end

function state:update(dt)
    player:update(dt)

    for i,tri in ipairs(triangles) do
        if not tri:hasCollided(150) then
            tri:update(dt)
        else
            table.remove(triangles, i)
        end
    end
end

function state:draw()
    player:draw()
    love.graphics.circle("line", winWidth/2, winHeight/2, 150, 360)
    for i,tri in ipairs(triangles) do
        tri:draw()
    end
end

function state:createFighter()
    love.graphics.print("Test", 100, 10)
    enemyTri = EnemyTriangle(vector.new(50, 50))
    enemyTri:load()
    table.insert(triangles, enemyTri)
end