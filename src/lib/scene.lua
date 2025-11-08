-- Scene manager for handling different game screens/modes
local scene = {}

function scene.new()
  local manager = {
    scenes = {},
    current = nil,
    currentName = nil
  }

  function manager:register(name, sceneTable)
    self.scenes[name] = sceneTable
  end

  function manager:switch(name)
    if not self.scenes[name] then
      error("Scene '" .. name .. "' not registered")
    end

    self.currentName = name
    self.current = self.scenes[name]

    -- Call load if the scene has it
    if self.current.load then
      self.current:load()
    end
  end

  function manager:update(dt)
    if self.current and self.current.update then
      self.current:update(dt)
    end
  end

  function manager:draw()
    if self.current and self.current.draw then
      self.current:draw()
    end
  end

  function manager:keypressed(key)
    if self.current and self.current.keypressed then
      self.current:keypressed(key)
    end
  end

  function manager:mousepressed(x, y, button)
    if self.current and self.current.mousepressed then
      self.current:mousepressed(x, y, button)
    end
  end

  return manager
end

return scene
