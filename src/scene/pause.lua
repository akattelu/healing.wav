-- Pause menu scene - overlay for pausing battle
local pause = {}
local button = require "src.ui.button"

function pause:load(resumeCallback, restartCallback, titleCallback, debugPanelToggleCallback)
  -- Create fonts
  self.titleFont = love.graphics.newFont(32)
  self.buttonFont = love.graphics.newFont(20)

  -- Initialize buttons
  self.buttons = {
    button.new({
      text = "Resume",
      x = 0, y = 0, width = 300, height = 60,
      font = self.buttonFont,
      action = function()
        if resumeCallback then
          resumeCallback()
        end
      end
    }),
    button.new({
      text = "Restart Wave",
      x = 0, y = 0, width = 300, height = 60,
      font = self.buttonFont,
      action = function()
        if restartCallback then
          restartCallback()
        end
      end
    }),
    button.new({
      text = "Toggle Debug Panel",
      x = 0, y = 0, width = 300, height = 60,
      font = self.buttonFont,
      action = function()
        if debugPanelToggleCallback then
          debugPanelToggleCallback()
        end
      end
    }),
    button.new({
      text = "Return to Title",
      x = 0, y = 0, width = 300, height = 60,
      font = self.buttonFont,
      action = function()
        if titleCallback then
          titleCallback()
        end
      end
    })
  }
end

function pause:update(dt)
  -- Update buttons (positions set dynamically in draw)
  for _, btn in ipairs(self.buttons) do
    btn:update(dt)
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

  for i, btn in ipairs(self.buttons) do
    btn:setPosition(screen_w / 2 - menuWidth / 2, menuStartY + (i - 1) * buttonSpacing)
  end

  -- Draw "PAUSED" title
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(self.titleFont)
  local titleText = "PAUSED"
  local titleWidth = self.titleFont:getWidth(titleText)
  love.graphics.print(titleText, screen_w / 2 - titleWidth / 2, menuStartY - 80)

  -- Draw buttons
  for _, btn in ipairs(self.buttons) do
    btn:draw()
  end

  love.graphics.pop()
end

function pause:keypressed(key)
  -- ESC key resumes the game
  if key == "escape" then
    if self.buttons[1] and self.buttons[1].action then
      self.buttons[1].action()
    end
    return true
  end
  return false
end

function pause:mousepressed(x, y, button)
  for _, btn in ipairs(self.buttons) do
    if btn:mousepressed(x, y, button) then
      return true
    end
  end
  return false
end

function pause:mousereleased(x, y, button)
  for _, btn in ipairs(self.buttons) do
    btn:mousereleased(x, y, button)
  end
end

return pause
