Gamestate = require "libraries.hump.gamestate"
Signals = require "libraries.hump.signal"
vector = require ".libraries.hump.vector"
camera = require ".libraries.hump.camera"
require ".options"

music_background = love.audio.newSource("audio/Insistent.ogg")
sfx_explosion = love.audio.newSource("audio/Explosion280.wav")
sfx_pew = love.audio.newSource("audio/Laser_Shoot46.wav")

Shotimg = love.graphics.newImage("graphics/bullet.png")
ShotimgSize = vector.new(Shotimg:getWidth(), Shotimg:getHeight())
aoeimg = love.graphics.newImage("graphics/bullet.png")
aoeimgSize = vector.new(aoeimg:getWidth(), aoeimg:getHeight())

sfx_pew:setVolume(1)
sfx_explosion:setVolume(1)

winWidth = love.graphics.getWidth()
winHeight = love.graphics.getHeight()
winCenter = vector.new(winWidth / 2, winHeight/2)

local menu = require('states.menu')
local game = require('states.game')
local pause = require('states.pause')
local gameover = require('states.gameover')

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Gamestate.menu)

    cam = camera()
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