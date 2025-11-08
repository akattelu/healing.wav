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
  self.buttonText = "Play"
  self.buttonWidth = 200
  self.buttonHeight = 60
  self.buttonX = (self.screenW - self.buttonWidth) / 2
  self.buttonY = self.screenH / 2 + 50

  -- Button state
  self.buttonHovered = false
end

function title:update(dt)
  -- Check if mouse is hovering over button
  local mx, my = love.mouse.getPosition()
  self.buttonHovered = mx >= self.buttonX and mx <= self.buttonX + self.buttonWidth
                   and my >= self.buttonY and my <= self.buttonY + self.buttonHeight
end

function title:draw()
  -- Clear background
  love.graphics.clear(0.1, 0.1, 0.15)

  -- Draw title
  love.graphics.setFont(self.titleFont)
  local titleWidth = self.titleFont:getWidth(self.titleText)
  love.graphics.setColor(0.9, 0.9, 1)
  love.graphics.print(self.titleText, (self.screenW - titleWidth) / 2, self.screenH / 2 - 100)

  -- Draw play button
  love.graphics.setFont(self.buttonFont)

  -- Button background (changes color on hover)
  if self.buttonHovered then
    love.graphics.setColor(0.4, 0.6, 0.8)
  else
    love.graphics.setColor(0.3, 0.5, 0.7)
  end
  love.graphics.rectangle("fill", self.buttonX, self.buttonY, self.buttonWidth, self.buttonHeight, 8, 8)

  -- Button border
  love.graphics.setColor(0.9, 0.9, 1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", self.buttonX, self.buttonY, self.buttonWidth, self.buttonHeight, 8, 8)

  -- Button text
  local textWidth = self.buttonFont:getWidth(self.buttonText)
  local textHeight = self.buttonFont:getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(
    self.buttonText,
    self.buttonX + (self.buttonWidth - textWidth) / 2,
    self.buttonY + (self.buttonHeight - textHeight) / 2
  )

  -- Reset color
  love.graphics.setColor(1, 1, 1)
end

function title:mousepressed(x, y, button)
  if button == 1 and self.buttonHovered then
    -- Switch to battle scene
    S.sceneManager:switch("battle")
  end
end

return title
