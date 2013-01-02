Gamestate.menu = Gamestate.new()
local state = Gamestate.menu


function state:draw()
    love.graphics.print("Press Enter to continue", 10, 10)
end

function state:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end