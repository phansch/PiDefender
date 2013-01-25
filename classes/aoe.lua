Class = require ".libraries.hump.class"
require ".libraries.Helper"

aoe = Class{function(self)
    self.ParticleSystems = {}
    self.radius = 150
    self.maxRadius = winWidth/2 + 100
    self.emitted = true
end}
aoe.speed = 300

function aoe:update(dt)
    if self:isInBounds() then
        --Update particle systems
        for i,system in ipairs(self.ParticleSystems) do
            system:update(dt)
            --remove inactive particle systems
            if system.ps:isEmpty() then
                table.remove(self.ParticleSystems, i)
            end
        end
        self.radius = self.radius + aoe.speed * dt
    end
end

function aoe:draw()
    if self:isInBounds() then
        --love.graphics.circle("line", winCenter.x, winCenter.y, self.radius, 360)

        --draw particle systems
        for i,system in ipairs(self.ParticleSystems) do
            system:draw()
        end
    end
end

function aoe:isInBounds()
    return self.radius <= self.maxRadius
end

Signals.register('aoe_init', function(aoe)
    --yes, this slows the game down quite a bit
    Timer.addPeriodic(0.01, function()
        for i=1,360,2 do
            local position = getCirclePoint(winCenter, i, aoe.radius)
            local pSystem = ParticleSystem(options[2], position)
            table.insert(aoe.ParticleSystems, pSystem)
            pSystem:play()
        end
    end, 40)
end)