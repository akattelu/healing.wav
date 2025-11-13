-- Game Over scene - displayed when player dies
local game_over = {}
local button = require "src.ui.button"

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
  self.restartButton = button.new({
    text = "Restart Wave",
    width = buttonWidth,
    height = buttonHeight,
    x = centerX - buttonWidth / 2,
    y = centerY + 60,
    font = self.buttonFont,
    action = function()
      S.sceneManager:switch("battle")
    end
  })

  -- Create Main Menu button
  self.menuButton = button.new({
    text = "Main Menu",
    width = buttonWidth,
    height = buttonHeight,
    x = centerX - buttonWidth / 2,
    y = centerY + 60 + buttonSpacing,
    font = self.buttonFont,
    action = function()
      S.currentWave = 0
      S.sceneManager:switch("title")
    end
  })

  -- Store wave info for display
  self.finalWave = S.currentWave + 1 -- Display as 1-indexed for player
end

function game_over:update(dt)
  self.restartButton:update(dt)
  self.menuButton:update(dt)
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
  self.restartButton:draw()
  self.menuButton:draw()
end

function game_over:mousepressed(x, y, button)
  if self.restartButton:mousepressed(x, y, button) then return end
  if self.menuButton:mousepressed(x, y, button) then return end
end

function game_over:mousereleased(x, y, button)
  self.restartButton:mousereleased(x, y, button)
  self.menuButton:mousereleased(x, y, button)
end

return game_over
