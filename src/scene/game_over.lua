-- Game Over scene - displayed when player dies
local game_over = {}

function game_over:load()
  -- Get screen dimensions for centering
  local screen_w, screen_h = love.window.getMode()

  -- Create fonts
  self.titleFont = love.graphics.newFont(72)
  self.infoFont = love.graphics.newFont(32)
  self.buttonFont = love.graphics.newFont(24)

  -- Calculate centered positions
  local centerX = screen_w / 2
  local centerY = screen_h / 2

  -- Button dimensions
  local buttonWidth = 250
  local buttonHeight = 60
  local buttonSpacing = 80

  -- Create Restart button
  self.restartButton = {
    text = "Restart Wave",
    width = buttonWidth,
    height = buttonHeight,
    x = centerX - buttonWidth / 2,
    y = centerY + 60,
    hovered = false
  }

  -- Create Main Menu button
  self.menuButton = {
    text = "Main Menu",
    width = buttonWidth,
    height = buttonHeight,
    x = centerX - buttonWidth / 2,
    y = centerY + 60 + buttonSpacing,
    hovered = false
  }

  -- Store wave info for display
  self.finalWave = S.currentWave + 1 -- Display as 1-indexed for player
end

function game_over:update(dt)
  -- Update button hover states
  local mx, my = love.mouse.getPosition()

  self.restartButton.hovered = mx >= self.restartButton.x and mx <= self.restartButton.x + self.restartButton.width
    and my >= self.restartButton.y and my <= self.restartButton.y + self.restartButton.height

  self.menuButton.hovered = mx >= self.menuButton.x and mx <= self.menuButton.x + self.menuButton.width
    and my >= self.menuButton.y and my <= self.menuButton.y + self.menuButton.height
end

function game_over:draw()
  local screen_w, screen_h = love.window.getMode()
  local centerX = screen_w / 2

  -- Dark background
  love.graphics.clear(0.1, 0.1, 0.15)

  -- Draw "Game Over" title in red/orange
  love.graphics.push("all")
  love.graphics.setFont(self.titleFont)
  love.graphics.setColor(0.9, 0.3, 0.2)
  local titleText = "Game Over"
  local titleWidth = self.titleFont:getWidth(titleText)
  love.graphics.print(titleText, centerX - titleWidth / 2, 150)
  love.graphics.pop()

  -- Draw wave info
  love.graphics.push("all")
  love.graphics.setFont(self.infoFont)
  love.graphics.setColor(0.9, 0.9, 0.9)
  local infoText = "You survived to Wave " .. self.finalWave
  local infoWidth = self.infoFont:getWidth(infoText)
  love.graphics.print(infoText, centerX - infoWidth / 2, 280)
  love.graphics.pop()

  -- Draw buttons
  self:drawButton(self.restartButton)
  self:drawButton(self.menuButton)
end

function game_over:drawButton(button)
  love.graphics.push("all")
  love.graphics.setFont(self.buttonFont)

  -- Button background with hover effect
  if button.hovered then
    love.graphics.setColor(0.4, 0.6, 0.8)
  else
    love.graphics.setColor(0.3, 0.5, 0.7)
  end
  love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, 8, 8)

  -- Button border
  love.graphics.setColor(0.9, 0.9, 1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", button.x, button.y, button.width, button.height, 8, 8)

  -- Button text (centered)
  local textWidth = self.buttonFont:getWidth(button.text)
  local textHeight = self.buttonFont:getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(button.text,
    button.x + (button.width - textWidth) / 2,
    button.y + (button.height - textHeight) / 2)

  love.graphics.pop()
end

function game_over:mousepressed(x, y, button)
  if button == 1 then -- Left click
    -- Check Restart button
    if self.restartButton.hovered then
      -- Reload the battle scene (restarts current wave)
      S.sceneManager:switch("battle")
      return
    end

    -- Check Main Menu button
    if self.menuButton.hovered then
      -- Reset to wave 0 and return to title
      S.currentWave = 0
      S.sceneManager:switch("title")
      return
    end
  end
end

return game_over
