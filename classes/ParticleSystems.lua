ParticleSystems = Class{function(self) end}

function ParticleSystems:draw()
    love.graphics.setBlendMode("additive")

    for i,system in ipairs(self) do
        love.graphics.draw(system, 0, 0)
    end

    love.graphics.setBlendMode("alpha")
end

function ParticleSystems:update(dt)
    for i,system in ipairs(self) do
        system:update(dt)
    end
end

function ParticleSystems:initExplosion()
    local particle_explosion = love.graphics.newImage("graphics/particle_explosion.png")
    local p = love.graphics.newParticleSystem(particle_explosion, 10)
    p:setEmissionRate(1000)
    p:setSpeed(300, 400)
    p:setSizes(3, 1)
    p:setColors(220, 255, 255, 255, 255, 255, 255, 255)
    p:setLifetime(0.1)
    p:setParticleLife(0.1)
    p:setDirection(0)
    p:setSpread(360)
    p:setTangentialAcceleration(10)
    p:setRadialAcceleration(500)
    p:stop()
    table.insert(self, p)
end