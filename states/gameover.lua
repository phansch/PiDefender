Gamestate.gameover = Gamestate.new()
local state = Gamestate.gameover

function state:draw()
    love.graphics.printf("Game Over!\n\n\nPress [space] to retry.\nPress [escape] to exit.", winWidth/2-100, winHeight/2-50, 150, "center")
end

function state:keyreleased(key)
    if key == 'return' then
        Gamestate.switch(Gamestate.game)
    end
end