Gamestate = require "libraries.hump.gamestate"
Signals = require "libraries.hump.signal"

winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()

local menu = require('states.menu')
local game = require('states.game')

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Gamestate.game)
end

function love.update(dt)
    Timer.update(dt)
    mousePos = vector(love.mouse.getX(), love.mouse.getY())
end