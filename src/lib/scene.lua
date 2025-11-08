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
      ---@diagnostic disable-next-line: undefined-field
      self.current:load()
    end
  end

  function manager:update(dt)
    ---@diagnostic disable-next-line: undefined-field
    if self.current and self.current.update then
      ---@diagnostic disable-next-line: undefined-field
      self.current:update(dt)
    end
  end

  function manager:draw()
    ---@diagnostic disable-next-line: undefined-field
    if self.current and self.current.draw then
      ---@diagnostic disable-next-line: undefined-field
      self.current:draw()
    end
  end

  function manager:keypressed(key)
    ---@diagnostic disable-next-line: undefined-field
    if self.current and self.current.keypressed then
      ---@diagnostic disable-next-line: undefined-field
      self.current:keypressed(key)
    end
  end

  function manager:mousepressed(x, y, button)
    ---@diagnostic disable-next-line: undefined-field
    if self.current and self.current.mousepressed then
      ---@diagnostic disable-next-line: undefined-field
      self.current:mousepressed(x, y, button)
    end
  end

  function manager:mousereleased(x, y, button)
    ---@diagnostic disable-next-line: undefined-field
    if self.current and self.current.mousereleased then
      ---@diagnostic disable-next-line: undefined-field
      self.current:mousereleased(x, y, button)
    end
  end

  return manager
end

return scene
