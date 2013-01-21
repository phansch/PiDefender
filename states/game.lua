Gamestate.game = Gamestate.new()
local state = Gamestate.game

Timer = require 'libraries.hump.timer'
require ".classes.Cannon"
require ".classes.EnemyTriangle"
require ".classes.EnemyBomber"
require ".classes.Stars"
require ".classes.ParticleSystems"
require ".classes.Player"

local cannon = Cannon()
local psManager = ParticleSystemManager()
local stars = Stars()
local player = Player()

local hitpoints, hitpointsMax = 500, 500
local hitpointsPC = 100
local circleRadius = 150
local triangles = {} --basic enemies
local Planet = {}
local tCount = 0 --amount of triangleEnemies
local drawCircle = true
local bomberCreated = false
local circleColor = {255, 255, 255, 200}

function state:init()
    player:load()
    stars:load()

    Planet.img = love.graphics.newImage("graphics/planet.png")
    Planet.imgSize = vector.new(Planet.img:getWidth(), Planet.img:getHeight())

    psManager:load()
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

    if bomber ~= nil then
        bomber:update(dt, player)
    end

    self:spawnEmemies()

    if Player.enabled then
        player:update()
    end


    -- ## collision checks ##
    for i,triangle in ipairs(triangles) do
        triangle:update(dt)

        -- triangle <-> circle collision
        if triangle:hasCollided(circleRadius) then
            Signals.emit('circle_hit', triangle.position, EnemyTriangle.damage)
            Signals.emit('triangle_destroyed', triangle.position)
            table.remove(triangles, i)
        end

        -- triangle <-> player collision
        if player:hasCollided(triangle) then
            Signals.emit('triangle_destroyed', triangle.position)
            Signals.emit('player_destroyed', player.position)
            table.remove(triangles, i)
        end
    end

    for i,shot in ipairs(Cannon.cannonShots) do
        for j,triangle in ipairs(triangles) do

            -- shot <-> triangle collision
            if shot:checkCollision(triangle) then
                Signals.emit('triangle_destroyed', triangle.position)
                Player.score = Player.score + 5
                table.remove(triangles, j)
                table.remove(Cannon.cannonShots, i)
            end
        end

        --bomber <-> shot collision
        if bomber ~= nil then
            if bomber:hasCollided(shot) then
                if bomber.hp <= 0 then
                    Signals.emit('bomber_destroyed', bomber.position)
                else
                    Signals.emit('bomber_hit', bomber)
                end
            end
        end

        -- shot <-> player collision
        if Player.enabled then
            if shot:checkCollision(player) then
                Signals.emit('player_destroyed', player.position)
                table.remove(Cannon.cannonShots, i)
            end
        end
    end

    --bomber <-> player collision
    if bomber ~= nil then
        if bomber:hasCollided(player) then
            if Player.enabled then
                Signals.emit('player_destroyed', player.position)
                Signals.emit('bomber_hit', bomber)
                if bomber.hp <= 0 then
                    Signals.emit('bomber_destroyed', bomber.position)
                end
            end
        end

        for i,bomberShot in ipairs(bomber.shots) do
            --bomberShot <-> player collision
            if bomberShot:playerCollision(player) then
                Signals.emit('player_destroyed', player.position)
                table.remove(bomber.shots, i)
                bomber.shotCount = 0
            end

            --bomberShot <-> circle collision
            if bomberShot:circleCollision(circleRadius+10) then
                Signals.emit('circle_hit', bomberShot.position, EnemyBomber.damage)
                table.remove(bomber.shots, i)
                bomber.shotCount = 0
            end
        end
    end


    if Player.lives == 0 then
        Gamestate.switch(Gamestate.gameover)
    end

    psManager:update(dt)
end

function state:draw()
    cam:attach()
    stars:draw()

    if drawCircle then
        cannon:draw()
    end

    if bomber ~= nil then
        bomber:draw()
    end

    love.graphics.draw(Planet.img, winWidth/2-Planet.imgSize.x/2, winHeight/2-Planet.imgSize.y/2, 0)


    for i,triangle in ipairs(triangles) do
        triangle:draw()
    end

    if drawCircle then
        player:draw()

        -- draw hitpoints
        love.graphics.setColor(circleColor)
        love.graphics.print(hitpointsPC.."%", winWidth/2-12, winHeight/2-135)
        love.graphics.setLineWidth(10)

        love.graphics.circle("line", winWidth/2, winHeight/2, circleRadius, 360)
        love.graphics.setColor(255, 9, 0)
    end
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255, 255, 255)
    psManager:draw()
    cam:detach()
end

function state:spawnEmemies()
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

    if hitpoints <= 0 and tCount <= 50 then
        --TODO:
        --stop drawing the big circle
        --make the circle explode
        --decrease circle radius to planet radius
        --stop showing the points
        --maybe create a new gamestate for that
        --spawn 100 enemies
        circleRadius = Planet.imgSize.x / 2
        drawCircle = false
        self:createFighter() -- creates lots of fighters
        tCount = tCount + 1

        Timer.add(10, function() Gamestate.switch(Gamestate.gameover) end)
    end
    --spawn bomber
    if Player.score >= 150 and bomber == nil and bomberCreated == false then
        Signals.emit('create_bomber')
    end
end

function state:createBomber()
    bomber = EnemyBomber()
    bomber:load()
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

    bomber = nil
    bomberCreated = false

    circleRadius = 150
    drawCircle = true

    tCount = 0
end

Signals.register('circle_hit', function(position, damage)
    psManager:play("p", position)
    hitpoints = hitpoints - damage
    --change circle color for a short amount of time
    circleColor = { 255, 0, 0, 200}
    Timer.add(0.01, function() circleColor = { 255, 255, 255, 200} end)

    shakeCamera(0.2, 1)
end)

Signals.register('triangle_destroyed', function(position)
    psManager:play("p", position)

    --love.audio.rewind(sfx_explosion)
    --love.audio.play(sfx_explosion)

    tCount = tCount - 1
end)

Signals.register('player_destroyed', function(position)
    psManager:play("p", position)

    --love.audio.rewind(sfx_explosion)
    --love.audio.play(sfx_explosion)

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

Signals.register('bomber_hit', function(bomber)
    -- change color of bomber quickly
    bomber.hp = bomber.hp - 5
    shakeCamera(0.2, 1)
end)

Signals.register('bomber_destroyed', function(position)
    bomberCreated = false
    psManager:play("p", position)
    shakeCamera(0.2, 1)
    bomber = nil
end)

Signals.register('create_bomber', function()
    --TODO: Remove bomber actually
    print("create bomber")
    Timer.add(5, function() state:createBomber() end)
    bomberCreated = true
end)