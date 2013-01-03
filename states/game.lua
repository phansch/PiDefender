Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Cannon"
require ".classes.EnemyTriangle"

local hitpoints = 1000
local currentCircleRadius = hitpoints/6
local cannon = Cannon(currentCircleRadius)
local triangles = {} --basic enemies

local paused = false

function state:init()
    Timer.addPeriodic(0.25, function() self.createFighter() end, 1000)

    playerImg = love.graphics.newImage("graphics/hexagon.png")
end

function state:update(dt)
    currentCircleRadius = hitpoints/6
    cannon:update(dt, currentCircleRadius)

    for i,tri in ipairs(triangles) do
        if not tri:hasCollided(currentCircleRadius) then
            tri:update(dt)
        else
            table.remove(triangles, i)
            Signals.emit('circle_hit')
        end
    end
end

function state:draw()
    cannon:draw()
    love.graphics.circle("line", winWidth/2, winHeight/2, currentCircleRadius, 360)
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
    elseif origin == 3 then -- spawn from bottom side
        y = winHeight + 10
        x = math.random(-10, winWidth+10)
    elseif origin == 4 then -- spawn from top side
        y = -10
        x = math.random(-10, winWidth+10)
    end

    enemyTri = EnemyTriangle(vector.new(x, y))
    enemyTri:load()
    table.insert(triangles, enemyTri)
end

function state:keypressed(key)
    if key == ' ' then
        Signals.emit('cannon_shoot')
    end
end

Signals.register('circle_hit', function(i)
    hitpoints = hitpoints - 1
end)