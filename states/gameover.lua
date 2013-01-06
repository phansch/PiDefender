Gamestate.gameover = Gamestate.new()
local state = Gamestate.gameover

function state:draw()
    love.graphics.printf("Game Over!\n\n\nYour score: "..Player.score.."\n\nPress [space] to retry.\nPress [escape] to exit.", winWidth/2-100, winHeight/2-50, 180, "center")
end

function state:keyreleased(key)
    if key == ' ' then
        Gamestate.switch(Gamestate.game)
    end
end