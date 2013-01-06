Gamestate.menu = Gamestate.new()
local state = Gamestate.menu


function state:draw()
    love.graphics.print("Press Enter to continue", winWidth/2-100, winHeight/2-12)
end

function state:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(Gamestate.game)
    end
end