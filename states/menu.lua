Gamestate.menu = Gamestate.new()
local state = Gamestate.menu

function state:init()
    Introimg = love.graphics.newImage("graphics/intro.png")
    IntroimgSize = vector.new(Introimg:getWidth(), Introimg:getHeight())
end

function state:draw()
    love.graphics.draw(Introimg, winWidth/2-IntroimgSize.x/2, winHeight/2-IntroimgSize.y/2, 0)
end

function state:keyreleased(key, code)
    if key == ' ' then
        Gamestate.switch(Gamestate.game)
    end
end