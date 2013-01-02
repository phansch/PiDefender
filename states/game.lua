Gamestate.game = Gamestate.new()
local state = Gamestate.game

require ".classes.Player"
player = Player(200)

function state:draw()
    player:draw()
    love.graphics.circle("line", winWidth/2, winHeight/2, 200, 360)

end

function state:update(dt)
    player:update(dt, Player)
end