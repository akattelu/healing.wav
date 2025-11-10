-- Pause menu scene - overlay for pausing battle
local pause = {}

function pause:load(resumeCallback, restartCallback, titleCallback, debugPanelToggleCallback)
  -- Store callbacks for button actions
  self.resumeCallback = resumeCallback
  self.restartCallback = restartCallback
  self.titleCallback = titleCallback
  self.debugPanelToggleCallback = debugPanelToggleCallback

  -- Initialize buttons
  self.buttons = {
    {
      label = "Resume",
      x = 0, y = 0, width = 300, height = 60,
      hovered = false,
      action = function()
        if self.resumeCallback then
          self.resumeCallback()
        end
      end
    },
    {
      label = "Restart Wave",
      x = 0, y = 0, width = 300, height = 60,
      hovered = false,
      action = function()
        if self.restartCallback then
          self.restartCallback()
        end
      end
    },
    {
      label = "Toggle Debug Panel",
      x = 0, y = 0, width = 300, height = 60,
      hovered = false,
      action = function()
        if self.debugPanelToggleCallback then
          self.debugPanelToggleCallback()
        end
      end
    },
    {
      label = "Return to Title",
      x = 0, y = 0, width = 300, height = 60,
      hovered = false,
      action = function()
        if self.titleCallback then
          self.titleCallback()
        end
      end
    }
  }
end

function pause:update(dt)
  -- Update button hover states
  local mx, my = love.mouse.getPosition()
  for _, button in ipairs(self.buttons) do
    button.hovered = mx >= button.x and mx <= button.x + button.width and
                     my >= button.y and my <= button.y + button.height
  end
end

function pause:draw()
  love.graphics.push("all")

  -- Semi-transparent dark overlay
  local screen_w, screen_h = love.window.getMode()
  love.graphics.setColor(0, 0, 0, 0.7)
  love.graphics.rectangle("fill", 0, 0, screen_w, screen_h)

  -- Calculate button positions (centered vertically)
  local menuWidth = 300
  local menuStartY = screen_h / 2 - 120
  local buttonSpacing = 80

  for i, button in ipairs(self.buttons) do
    button.x = screen_w / 2 - menuWidth / 2
    button.y = menuStartY + (i - 1) * buttonSpacing
  end

  -- Draw "PAUSED" title
  love.graphics.setColor(1, 1, 1, 1)
  local font = love.graphics.getFont()
  local titleText = "PAUSED"
  local titleWidth = font:getWidth(titleText)
  love.graphics.print(titleText, screen_w / 2 - titleWidth / 2, menuStartY - 80)

  -- Draw buttons
  for _, button in ipairs(self.buttons) do
    -- Button background
    if button.hovered then
      love.graphics.setColor(0.4, 0.6, 0.8, 1)
    else
      love.graphics.setColor(0.3, 0.5, 0.7, 1)
    end
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, 8, 8)

    -- Button border
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", button.x, button.y, button.width, button.height, 8, 8)

    -- Button label
    local labelWidth = font:getWidth(button.label)
    local labelX = button.x + button.width / 2 - labelWidth / 2
    local labelY = button.y + button.height / 2 - font:getHeight() / 2
    love.graphics.print(button.label, labelX, labelY)
  end

  love.graphics.pop()
end

function pause:keypressed(key)
  -- ESC key resumes the game
  if key == "escape" then
    if self.resumeCallback then
      self.resumeCallback()
    end
    return true
  end
  return false
end

function pause:mousepressed(x, y, button)
  -- Handle button clicks
  if button == 1 then
    for _, btn in ipairs(self.buttons) do
      if btn.hovered then
        btn.action()
        return true
      end
    end
  end
  return false
end

return pause
