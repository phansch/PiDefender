function love.conf(t)
    t.title = "PiDefender"
    t.author = "Philipp Hansch"
    t.version = "0.8.0"

    t.screen.width = 1280
    t.screen.height = 900

    -- disabling modules
    t.modules.joystick = false
    t.modules.physics = false
end