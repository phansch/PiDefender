ParticleSystems = {} -- list of particle systems
activeSystems = {}

ParticleSystemManager = Class{}

function ParticleSystemManager:load()
    -- create particle systems
    local particle_explosion = love.graphics.newImage("graphics/particle_explosion.png")

    ParticleSystems["p"] = love.graphics.newParticleSystem(particle_explosion, 10)
    ParticleSystems["p"]:setEmissionRate(30000)
    ParticleSystems["p"]:setSpeed(100, 150)
    ParticleSystems["p"]:setSizes(5, 3)
    ParticleSystems["p"]:setColors(220, 105, 20, 100, 194, 30, 18, 0)
    ParticleSystems["p"]:setLifetime(0.3)
    ParticleSystems["p"]:setParticleLife(0.3)
    ParticleSystems["p"]:setDirection(0)
    ParticleSystems["p"]:setSpread(360)
    ParticleSystems["p"]:setTangentialAcceleration(0)
    ParticleSystems["p"]:setRadialAcceleration(0)
    ParticleSystems["p"]:stop()

    ParticleSystems["p2"] = love.graphics.newParticleSystem(particle_explosion, 10)
    ParticleSystems["p2"]:setEmissionRate(1000)
    ParticleSystems["p2"]:setSpeed(300, 400)
    ParticleSystems["p2"]:setSizes(3, 1)
    ParticleSystems["p2"]:setColors(220, 105, 20, 100, 194, 30, 18, 0)
    ParticleSystems["p2"]:setLifetime(0.1)
    ParticleSystems["p2"]:setParticleLife(0.1)
    ParticleSystems["p2"]:setDirection(0)
    ParticleSystems["p2"]:setSpread(360)
    ParticleSystems["p2"]:setTangentialAcceleration(10)
    ParticleSystems["p2"]:setRadialAcceleration(500)
    ParticleSystems["p2"]:stop()

    ParticleSystems["trail"] = love.graphics.newParticleSystem(particle_explosion, 10)
    ParticleSystems["trail"]:setEmissionRate(1000)
    ParticleSystems["trail"]:setSpeed(300, 400)
    ParticleSystems["trail"]:setSizes(3, 1)
    ParticleSystems["trail"]:setColors(220, 105, 20, 100, 194, 30, 18, 0)
    ParticleSystems["trail"]:setLifetime(0.1)
    ParticleSystems["trail"]:setParticleLife(0.1)
    ParticleSystems["trail"]:setDirection(0)
    ParticleSystems["trail"]:setSpread(360)
    ParticleSystems["trail"]:setTangentialAcceleration(10)
    ParticleSystems["trail"]:setRadialAcceleration(500)
    ParticleSystems["trail"]:stop()
end

function ParticleSystemManager:play(name, position)
    --add specified particle system to "activeSystems" table
    table.insert(activeSystems, ParticleSystems[name])

    for i,system in ipairs(activeSystems) do
        system:setPosition(position.x, position.y)
        system:start()
    end
end

function ParticleSystemManager:draw()
    love.graphics.setBlendMode("additive")

    for i,system in ipairs(activeSystems) do
        love.graphics.draw(system, 0, 0)
    end

    love.graphics.setBlendMode("alpha")
end

function ParticleSystemManager:update(dt)
    for i,system in ipairs(activeSystems) do
        if system:isActive() == false then
            table.remove(activeSystems, i)
        end
        system:update(dt)
    end
end