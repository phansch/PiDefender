Class = require ".libraries.hump.class"
require ".classes.Shot"
require ".classes.aoe"

Cannon = Class{function(self) self.angle = 0 end}
Cannon.speed = 5
Cannon.circ = 0.6
Cannon.radius = 4
Cannon.cannonShots = {}
Cannon.aoeShots = {}

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

    for i,aoeshot in ipairs(Cannon.aoeShots) do
        aoeshot:update(dt)

        -- remove aoeshot when out of bounds
        if not aoeshot:isInBounds() then
            table.remove(Cannon.aoeShots, i)
        end
    end
end

function Cannon:draw()
    for i,shot in ipairs(Cannon.cannonShots) do
        shot:draw()
    end

    for i,aoeshot in ipairs(Cannon.aoeShots) do
        aoeshot:draw()
    end

    love.graphics.setColor(255, 255, 255, 100)
    love.graphics.arc("line", winCenter.x, winCenter.y, self.circleRadius+Cannon.radius, self.angle, self.angle + Cannon.circ)
    love.graphics.setColor(255, 255, 255, 255)
    local cannonCenter = vector.new(getCirclePoint(winCenter, self.angle + Cannon.circ/2, self.circleRadius).x, getCirclePoint(winCenter, self.angle + Cannon.circ/2, self.circleRadius).y)
end

function Cannon:shoot(cannon, circleRadius)
    shot = Shot(mousePos, cannon.angle + Cannon.circ / 7, circleRadius + Cannon.radius)
    table.insert(Cannon.cannonShots, shot)

    shot2 = Shot(mousePos, cannon.angle + Cannon.circ/2, circleRadius + Cannon.radius)
    table.insert(Cannon.cannonShots, shot2)

    shot3 = Shot(mousePos, cannon.angle + Cannon.circ, circleRadius + Cannon.radius)
    table.insert(Cannon.cannonShots, shot3)
end

function Cannon:shootAOE(cannon, circleRadius)
    aoeshot = aoe(mousePos, cannon.angle + Cannon.circ/2, circleRadius + Cannon.radius)
    table.insert(Cannon.aoeShots, aoeshot)
end

Signals.register('cannon_shoot', function(cannon, angle)
    if Cannon.allowFire then
        --love.audio.play(sfx_pew)
        --love.audio.rewind(sfx_pew)
        Cannon:shoot(cannon, angle)
    end
end)

Signals.register('cannon_shootAOE', function(cannon, angle)
    if Cannon.allowFire then
        --love.audio.play(sfx_pew)
        --love.audio.rewind(sfx_pew)
        Cannon:shootAOE(cannon, angle)
    end
end)