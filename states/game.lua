Gamestate.game = Gamestate.new()
local state = Gamestate.game

require ".classes.Player"
require ".classes.EnemyTriangle"
player = Player(150)
enemyTri = EnemyTriangle(vector.new(50, 50))

function state:init()
    enemyTri:load()
end

function state:draw()
    player:draw()
    love.graphics.circle("line", winWidth/2, winHeight/2, 150, 360)
    enemyTri:draw()
end

function state:update(dt)
    player:update(dt, Player)
    enemyTri:update(dt)
end