-- Starting to collect useful functions.
-- Eventually will be converted to classes

-- Returns a point (hump.vector) on a circle's circumference
function getCirclePoint(center, angle, radius)
    local x = math.cos(angle) * radius + center.x;
    local y = math.sin(angle) * radius + center.y;
    return vector.new(x, y)
end