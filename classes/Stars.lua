Class = require ".libraries.hump.class"

Stars = Class{function(self)

end}

function Stars:load()
    --create stars
    for i=1,winHeight,1 do
        self[i] = { ["x"] = math.random(0, winWidth), ["y"] = i }
    end
end

function Stars:draw()
    --draw stars
    for i=1,winHeight,1 do
        love.graphics.point(self[i].x, self[i].y)
    end
end