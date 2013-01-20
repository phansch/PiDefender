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

local hitpoints, hitpointsMax = 500, 500
local hitpointsPC = 100
local circleRadius = 150
local triangles = {} --basic enemies
local Planet = {}
local tCount = 0

function state:init()
    player:load()
    stars:load()

    Planet.img = love.graphics.newImage("graphics/planet.png")
    Planet.imgSize = vector.new(Planet.img:getWidth(), Planet.img:getHeight())

    pSystems:initTriangleExplosion()
    pSystems:initCircleHit()
end

function state:enter(previous)
    love.mouse.setVisible(false)
    if previous == Gamestate.menu or previous == Gamestate.gameover then
        self:startGame()
    end
end

function state:update(dt)
    cannon:update(dt, circleRadius)
    hitpointsPC = 100 / hitpointsMax * hitpoints

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
        if not triangle:hasCollided(circleRadius) then
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
    cam:attach()
    stars:draw()
    cannon:draw()
    love.graphics.draw(Planet.img, winWidth/2-Planet.imgSize.x/2, winHeight/2-Planet.imgSize.y/2, 0)


    for i,triangle in ipairs(triangles) do
        triangle:draw()
    end

    player:draw()

    -- draw hitpoints
    love.graphics.print(hitpointsPC.."%", winWidth/2-12, winHeight/2-135)

    love.graphics.setLineWidth(10)
    love.graphics.setColor(255, 255, 255, 200)
    love.graphics.circle("line", winWidth/2, winHeight/2, circleRadius, 360)
    love.graphics.setColor(255, 9, 0)
    --print(hitpointsPC)
    --drawArc(winWidth/2, winHeight/2, circleRadius-4, math.pi/2.5, math.pi/1.5, 50)

    love.graphics.setLineWidth(1)
    love.graphics.setColor(255, 255, 255)
    pSystems:draw()
    cam:detach()
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
        Signals.emit('cannon_shoot', cannon, circleRadius)
    end
end

function state:keyreleased(key)
    if key == 'p' then
        Gamestate.switch(Gamestate.pause)
    end
end

function state:focus(f)
    if not f then
        Gamestate.switch(Gamestate.pause)
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

    tCount = 0
end

Signals.register('circle_hit', function(position)
    pSystems[2]:setPosition(position.x, position.y)
    pSystems[2]:start()
    hitpoints = hitpoints - EnemyTriangle.damage
    shakeCamera(0.2, 1)
end)

Signals.register('triangle_destroyed', function(position)
    pSystems[1]:setPosition(position.x, position.y)
    pSystems[1]:start()

    --love.audio.play(sfx_explosion)
    --love.audio.rewind(sfx_explosion)

    tCount = tCount - 1
end)

Signals.register('player_destroyed', function(position)
    pSystems[2]:setPosition(position.x, position.y)
    pSystems[2]:start()

    --love.audio.play(sfx_explosion)
    --love.audio.rewind(sfx_explosion)
    shakeCamera(0.4, 2)

    Player.lives = Player.lives - 1
    Player.enabled = false
    Cannon.allowFire = false
    love.mouse.setVisible(true)
    Timer.add(5, function()
        Player.enabled = true
        Cannon.allowFire = true
        love.mouse.setVisible(false)
    end)
end)