Gamestate = require "libraries.hump.gamestate"
Timer = require 'libraries.hump.timer'

local menu = require('states.menu')
local game = require('states.game')

function love.load( )
    Gamestate.registerEvents()
    Gamestate.switch(Gamestate.menu)
end