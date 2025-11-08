-- Title screen scene
local title = {}

function title:load()
  -- Get screen dimensions
  self.screenW, self.screenH = love.window.getMode()

  -- Title text
  self.titleText = "healing.wav"
  self.titleFont = love.graphics.newFont(48)

  -- Play button
  self.buttonFont = love.graphics.newFont(24)
  self.playButton = {
    text = "Play",
    width = 200,
    height = 60,
    x = (self.screenW - 200) / 2,
    y = self.screenH / 2 + 50,
    hovered = false
  }

  -- Credits button
  self.creditsButton = {
    text = "Credits",
    width = 200,
    height = 60,
    x = (self.screenW - 200) / 2,
    y = self.screenH / 2 + 130,
    hovered = false
  }
end

function title:update(dt)
  -- Check if mouse is hovering over buttons
  local mx, my = love.mouse.getPosition()

  self.playButton.hovered = mx >= self.playButton.x and mx <= self.playButton.x + self.playButton.width
      and my >= self.playButton.y and my <= self.playButton.y + self.playButton.height

  self.creditsButton.hovered = mx >= self.creditsButton.x and mx <= self.creditsButton.x + self.creditsButton.width
      and my >= self.creditsButton.y and my <= self.creditsButton.y + self.creditsButton.height
end

function title:draw()
  -- Clear background
  love.graphics.clear(0.1, 0.1, 0.15)

  -- Draw title
  love.graphics.setFont(self.titleFont)
  local titleWidth = self.titleFont:getWidth(self.titleText)
  love.graphics.setColor(0.9, 0.9, 1)
  love.graphics.print(self.titleText, (self.screenW - titleWidth) / 2, self.screenH / 2 - 100)

  -- Draw buttons
  love.graphics.setFont(self.buttonFont)
  self:drawButton(self.playButton)
  self:drawButton(self.creditsButton)

  -- Reset color
  love.graphics.setColor(1, 1, 1)
end

function title:drawButton(button)
  -- Button background (changes color on hover)
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

  -- Button text
  local textWidth = self.buttonFont:getWidth(button.text)
  local textHeight = self.buttonFont:getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(
    button.text,
    button.x + (button.width - textWidth) / 2,
    button.y + (button.height - textHeight) / 2
  )
end

function title:mousepressed(x, y, button)
  if button == 1 then
    if self.playButton.hovered then
      -- Reset wave counter and stats for new game
      S.currentWave = 1
      local stats = require "src.lib.stats"
      S.stats = stats.new()
      S.sceneManager:switch("wave_intro")
    elseif self.creditsButton.hovered then
      -- Switch to credits scene
      S.sceneManager:switch("credits")
    end
  end
end

return title
