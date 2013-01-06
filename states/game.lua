Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Cannon"
require ".classes.EnemyTriangle"
require ".classes.Stars"
require ".classes.ParticleSystems"

local cannon = Cannon(currentCircleRadius)
local pSystems = ParticleSystems()
local stars = Stars()

local hitpoints = 500
local currentCircleRadius = hitpoints/6
local triangles = {} --basic enemies
local paused = false

function state:init()
    Timer.addPeriodic(1, function() self.createFighter() end, 50)

    playerImg = love.graphics.newImage("graphics/hexagon.png")

    stars:load()
    pSystems:initTriangleExplosion()
    pSystems:initCircleHit()
end

function state:update(dt)
    currentCircleRadius = hitpoints/6
    cannon:update(dt, currentCircleRadius)

    for i,triangle in ipairs(triangles) do
        if not triangle:hasCollided(currentCircleRadius) then
            triangle:update(dt)
        else
            Signals.emit('circle_hit', triangle.position)
            table.remove(triangles, i)
        end
    end

    for i,shot in ipairs(Cannon.cannonShots) do
        for j,triangle in ipairs(triangles) do
            if shot:checkCollision(triangle) then
                Signals.emit('triangle_destroyed', triangle.position)
                table.remove(triangles, j)
                table.remove(Cannon.cannonShots, i)
            end
        end
    end

    pSystems:update(dt)
end

function state:draw()
    stars:draw()
    cannon:draw()
    love.graphics.circle("fill", winWidth/2, winHeight/2, currentCircleRadius, 360)

    for i,triangle in ipairs(triangles) do
        triangle:draw()
    end

    love.graphics.draw(playerImg, love.mouse.getX()-16, love.mouse.getY()-16, 0)

    -- draw hitpoints
    love.graphics.setColor(0, 0, 0)
    love.graphics.setNewFont(24)
    love.graphics.print(hitpoints, winWidth/2, winHeight/2)
    love.graphics.setColor(255, 255, 255)

    pSystems:draw()
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

Signals.register('circle_hit', function(position)
    pSystems[2]:setPosition(position.x, position.y)
    pSystems[2]:start()
    hitpoints = hitpoints - EnemyTriangle.damage
end)

Signals.register('triangle_destroyed', function(position)
    pSystems[1]:setPosition(position.x, position.y)
    pSystems[1]:start()
end)

Signals.register('player_destroyed', function(position)

end)