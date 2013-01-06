Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Cannon"
require ".classes.EnemyTriangle"
require ".classes.Stars"
require ".classes.ParticleSystems"
require ".classes.Player"

local cannon = Cannon()
local pSystems = ParticleSystems()
local stars = Stars()
local player = Player()

local hitpoints = 500
local currentCircleRadius = hitpoints/6
local triangles = {} --basic enemies
local tCount = 0

function state:init()
    player:load()
    stars:load()

    pSystems:initTriangleExplosion()
    pSystems:initCircleHit()
end

function state:enter()
    self:startGame()
end

function state:update(dt)
    currentCircleRadius = hitpoints/6

    cannon:update(dt, currentCircleRadius)

    -- add fighters
    if tCount < 7 then
        if Player.score <= 100 then
            minSpawn = 3
            maxSpawn = 5
            period = 2
        elseif Player.score > 100 then
            minSpawn = 4
            maxSpawn = 8
            period = 1.5
        elseif Player.score > 250 then
            minSpawn = 6
            maxSpawn = 12
            period = 1
        elseif Player.score > 300 then
            minSpawn = 12
            maxSpawn = 15
            period = 0.25
        end

        local randomAdd = math.random(minSpawn, maxSpawn)

        Timer.addPeriodic(period, function() self:createFighter() end, randomAdd)
        tCount = tCount + randomAdd
    end

    if Player.enabled then
        player:update()
    end

    for i,triangle in ipairs(triangles) do
        if not triangle:hasCollided(currentCircleRadius) then
            triangle:update(dt)
        else
            Signals.emit('circle_hit', triangle.position)
            Signals.emit('triangle_destroyed', triangle.position)
            table.remove(triangles, i)
        end
    end

    -- shot <-> triangle collision
    for i,shot in ipairs(Cannon.cannonShots) do
        for j,triangle in ipairs(triangles) do
            if shot:checkCollision(triangle) then
                Signals.emit('triangle_destroyed', triangle.position)
                Player.score = Player.score + 5
                table.remove(triangles, j)
                table.remove(Cannon.cannonShots, i)
            end
        end
    end

    -- triangle <-> player collision
    for i,triangle in ipairs(triangles) do
        if player:hasCollided(triangle) then
            Signals.emit('triangle_destroyed', triangle.position)
            Signals.emit('player_destroyed', player.position)
            table.remove(triangles, i)
        end
    end

    if hitpoints <= 0 or Player.lives == 0 then
        Gamestate.switch(Gamestate.gameover)
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

    player:draw()

    -- draw hitpoints
    love.graphics.print("HP: "..hitpoints, 80, winHeight-20)
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

function state:keyreleased(key)
    if key == 'F10' then
        Gamestate.switch(Gamestate.menu)
    end
end

function state:focus(f)
    if not f then
        Gamestate.switch(Gamestate.menu)
    end
end

function state:startGame()
    --remove enemies
    for k in pairs (triangles) do
        triangles [k] = nil
    end

    --clear timers
    Timer.clear()

    --reset hitpoints
    hitpoints = 500

    --reset player lives
    Player.lives = 5

    --draw player
    Player.enabled = true

    --allow cannon fire
    Cannon.allowFire = true
end

Signals.register('circle_hit', function(position)
    pSystems[2]:setPosition(position.x, position.y)
    pSystems[2]:start()
    hitpoints = hitpoints - EnemyTriangle.damage
end)

Signals.register('triangle_destroyed', function(position)
    pSystems[1]:setPosition(position.x, position.y)
    pSystems[1]:start()

    tCount = tCount - 1
end)

Signals.register('player_destroyed', function(position)
    pSystems[2]:setPosition(position.x, position.y)
    pSystems[2]:start()
    Player.lives = Player.lives - 1
    Player.enabled = false
    Cannon.allowFire = false
    Timer.add(5, function()
        Player.enabled = true
        Cannon.allowFire = true
    end)
end)