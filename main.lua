Gamestate = require "libraries.hump.gamestate"


local menu = require('states.menu')
local game = require('states.game')

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Gamestate.game)

    winWidth = love.graphics.getWidth()
    winHeight = love.graphics.getHeight()
end

function love.update(dt)
    Timer.update(dt)
end