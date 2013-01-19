-- Starting to collect useful functions.
-- Eventually will be converted to classes

-- Returns a point (hump.vector) on a circle's circumference
function getCirclePoint(center, angle, radius)
    local x = math.cos(angle) * radius + center.x;
    local y = math.sin(angle) * radius + center.y;
    return vector.new(x, y)
end

function drawArc(x, y, r, angle1, angle2, segments)
  local i = angle1
  local j = 0
  local step = math.pi*2 / segments

  while i < angle2 do
    j = angle2 - i < step and angle2 or i + step
    love.graphics.line(x + (math.cos(i) * r), y - (math.sin(i) * r), x + (math.cos(j) * r), y - (math.sin(j) * r))
    i = j
  end
end