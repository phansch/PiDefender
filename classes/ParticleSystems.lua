Class = require ".libraries.hump.class"

ParticleSystem = Class{function(self, options, position)
    self.ps = love.graphics.newParticleSystem(options.image, 10)
    self.ps:setEmissionRate(options.emissionRate)
    self.ps:setSpeed(options.speed1, options.speed2)
    self.ps:setSizes(options.sizes[1], options.sizes[2])
    self.ps:setColors(unpack(options.colors))
    self.ps:setLifetime(options.lifetime)
    self.ps:setParticleLife(options.particleLifetime)
    self.ps:setDirection(options.direction)
    self.ps:setSpread(options.spread)
    self.ps:setTangentialAcceleration(options.tangentialAcceleration)
    self.ps:setRadialAcceleration(options.radialAcceleration)
    self.ps:setPosition(position.x, position.y)
    self.ps:stop()
end}

function ParticleSystem:play()
    self.ps:start()
end

function ParticleSystem:draw()
    love.graphics.setBlendMode("additive")
    love.graphics.draw(self.ps, 0, 0)
    love.graphics.setBlendMode("alpha")
end

function ParticleSystem:update(dt)
    self.ps:update(dt)
end