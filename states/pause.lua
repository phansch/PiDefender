Gamestate.pause = Gamestate.new()
local state = Gamestate.pause

function state:draw()
    love.graphics.print("Press [p] to continue.", winWidth/2-100, winHeight/2-50)
end

function state:keyreleased(key)
    if key == 'p' then
        Gamestate.switch(Gamestate.game)
    end
end