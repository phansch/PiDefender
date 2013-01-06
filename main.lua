Gamestate = require "libraries.hump.gamestate"
Signals = require "libraries.hump.signal"
vector = require ".libraries.hump.vector"

winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()
winCenter = vector.new(winWidth / 2, winHeight/2)

music_background = love.audio.newSource("audio/Insistent.ogg")

local menu = require('states.menu')
local game = require('states.game')
local gameover = require('states.gameover')

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Gamestate.menu)
end

function love.update(dt)
    Timer.update(dt)
    mousePos = vector(love.mouse.getX(), love.mouse.getY())
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end