Class = require ".libraries.hump.class"
require ".classes.Shot"
require ".classes.aoe"

Cannon = Class{function(self) self.angle = 0 end}
Cannon.speed = 5
Cannon.circ = 0.6
Cannon.radius = 4
Cannon.cannonShots = {}
Cannon.aoeTimer = 30
Cannon.aoeAllowed = false

function Cannon:load()
    self.icon_aoe = love.graphics.newImage("graphics/icon_aoe.png")
    self.icon_aoe_imgSize = vector.new(self.icon_aoe:getWidth(), self.icon_aoe:getHeight())
end

function Cannon:update(dt, circleradius)
    self.circleRadius = circleradius

    -- Only update cannon direction when mouse is outside of circle and player is enabled
    if(mousePos:dist(winCenter) > self.circleRadius + Cannon.radius) and Player.enabled then
        self.angle = math.atan2(winCenter.y-mousePos.y, winCenter.x-mousePos.x) + math.pi - Cannon.circ/2
        --Also only allow shooting when mouse is outside of Circle
        Cannon.allowFire = true
    else
        Cannon.allowFire = false
    end

    for i,shot in ipairs(Cannon.cannonShots) do
        shot:update(dt)

        -- remove shot when out of bounds
        if not shot:isInBounds() then
            table.remove(Cannon.cannonShots, i)
        end
    end

    if Cannon.aoe ~= nil and Cannon.aoe.emitted then
        Cannon.aoe:update(dt)
        if not Cannon.aoe:isInBounds() then
            Cannon.aoe = nil
        end
    end

    if Cannon.aoeTimer == 0 then
        Cannon.aoeAllowed = true
        Cannon.aoeTimer = 30
    end

end

function Cannon:draw()
    for i,shot in ipairs(Cannon.cannonShots) do
        shot:draw()
    end

    if Cannon.aoe ~= nil and Cannon.aoe.emitted then
        Cannon.aoe:draw()
    end

    love.graphics.setColor(255, 255, 255, 100)
    love.graphics.arc("line", winCenter.x, winCenter.y, self.circleRadius+Cannon.radius, self.angle, self.angle + Cannon.circ)
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.draw(self.icon_aoe, winCenter.x, winCenter.y+80, 0, 0.1, 0.1)
    --love.graphics.rectangle("fill", winCenter.x, winCenter.y+80, self.icon_aoe_imgSize.x * 0.1, self.icon_aoe_imgSize.y * 0.1)


    if Cannon.aoeAllowed then
        love.graphics.print("B", winCenter.x+30, winCenter.y+105)
    elseif Cannon.aoeTimer >= 10 then
        love.graphics.print(Cannon.aoeTimer, winCenter.x+22, winCenter.y+105)
    else
        love.graphics.print(Cannon.aoeTimer, winCenter.x+30, winCenter.y+105)
    end
end

function Cannon:shoot(cannon, circleRadius)
    shot = Shot(mousePos, cannon.angle + Cannon.circ / 7, circleRadius + Cannon.radius)
    table.insert(Cannon.cannonShots, shot)

    shot2 = Shot(mousePos, cannon.angle + Cannon.circ/2, circleRadius + Cannon.radius)
    table.insert(Cannon.cannonShots, shot2)

    shot3 = Shot(mousePos, cannon.angle + Cannon.circ, circleRadius + Cannon.radius)
    table.insert(Cannon.cannonShots, shot3)
end

Signals.register('cannon_shoot', function(cannon, angle)
    if Cannon.allowFire then
        --love.audio.play(sfx_pew)
        --love.audio.rewind(sfx_pew)
        Cannon:shoot(cannon, angle)
    end
end)

Signals.register('cannon_shootAOE', function()
    --love.audio.play(sfx_pew)
    --love.audio.rewind(sfx_pew)
    if Cannon.aoeAllowed == true then
        Cannon.aoe = aoe()
        Signals.emit('aoe_init', Cannon.aoe)
        Cannon.aoeAllowed = false
        Signals.emit('start_aoeCountdown')
    end
end)

Signals.register('start_aoeCountdown', function()
    Timer.addPeriodic(1, function() Cannon.aoeTimer = Cannon.aoeTimer - 1 end, Cannon.aoeTimer)
end)