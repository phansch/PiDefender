function love.conf(t)
    t.title = "PiDefender"
    t.author = "Philipp Hansch"
    t.version = "0.8.0"
    t.url = "http://phansch.net"
    --t.release = true

    -- disabling modules
    t.modules.joystick = false
    t.modules.physics = false
end