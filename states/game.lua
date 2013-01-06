Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Cannon"
require ".classes.EnemyTriangle"
require ".classes.Stars"

local hitpoints = 1000
local currentCircleRadius = hitpoints/6
local cannon = Cannon(currentCircleRadius)
local stars = Stars()
local triangles = {} --basic enemies
local paused = false

function state:init()
    Timer.addPeriodic(1, function() self.createFighter() end, 50)

    playerImg = love.graphics.newImage("graphics/hexagon.png")

    stars:load()
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

    for i,shot in ipairs(Cannon.cannonShots) do
        for j,triangle in ipairs(triangles) do
            if shot:checkCollision(triangle) then
                table.remove(triangles, j)
                table.remove(Cannon.cannonShots, i)
            end
        end
    end
end

function state:draw()
    stars:draw()
    cannon:draw()
    love.graphics.circle("fill", winWidth/2, winHeight/2, currentCircleRadius, 360)
    for i,tri in ipairs(triangles) do
        tri:draw()
    end

    love.graphics.draw(playerImg, love.mouse.getX()-16, love.mouse.getY()-16, 0)

    -- draw hitpoints
    love.graphics.setColor(0, 0, 0)
    love.graphics.setNewFont(24)
    love.graphics.print(hitpoints, winWidth/2, winHeight/2)
    love.graphics.setColor(255, 255, 255)
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
        Signals.emit('cannon_shoot', cannon, currentCircleRadius)
    end
end

Signals.register('circle_hit', function()
    hitpoints = hitpoints - 1
end)