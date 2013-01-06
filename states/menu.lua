Gamestate.menu = Gamestate.new()
local state = Gamestate.menu

state.text = "Thanks for trying out the game.\n\n"
            .."Instructions: Your goal is to hold out as long as possible by "
            .."killing and avoiding enemies. Use [space] to shoot.\n\n\n"
            .."Now press [space] to continue."

function state:init()
    love.audio.play(music_background)

end

function state:draw()
    love.graphics.printf(self.text, winWidth/2-200, winHeight/2-200, 400, "center")

    love.graphics.setNewFont(11)
    love.graphics.print("Pi Defender Alpha. Submit bugs at http://github.com/phansch/PiDefender.", 15, winHeight-20)
    love.graphics.setNewFont(12)
end

function state:keyreleased(key, code)
    if key == ' ' then
        Gamestate.switch(Gamestate.game)
    end
end