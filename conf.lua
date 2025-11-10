function love.conf(t)
  t.window.width = 1280
  t.window.height = 1024
  t.window.vsync = 1
  t.window.title = "Healing Wave"
  t.window.resizable = true
  t.window.depth = 16  -- Depth buffer for web compatibility
  -- Note: Do NOT set t.version (causes TextDecoder errors in love.js)
end
