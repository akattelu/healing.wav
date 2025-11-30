-- Title screen scene
local title = {}
local button = require "src.ui.button"

function title:load()
  -- Get screen dimensions
  self.screenW, self.screenH = love.window.getMode()

  -- Title text
  self.titleText = "healing.wav"
  self.titleFont = love.graphics.newFont(48)

  -- Button font
  self.buttonFont = love.graphics.newFont(24)

  -- Instructions font and text
  self.instructionsFont = love.graphics.newFont(18)
  self.instructionsText1 = "WASD to move"
  self.instructionsText2 = "ESC to pause"

  -- Play button
  self.playButton = button.new({
    text = "Play",
    width = 200,
    height = 60,
    x = (self.screenW - 200) / 2,
    y = self.screenH / 2 + 50,
    font = self.buttonFont,
    action = function()
      -- Reset wave counter and stats for new game
      S.currentWave = 0
      local stats = require "src.lib.stats"
      S.stats = stats.new()
      S.sceneManager:switch("wave_intro")
    end
  })

  -- Credits button
  self.creditsButton = button.new({
    text = "Credits",
    width = 200,
    height = 60,
    x = (self.screenW - 200) / 2,
    y = self.screenH / 2 + 130,
    font = self.buttonFont,
    action = function()
      S.sceneManager:switch("credits")
    end
  })
end

function title:update(dt)
  self.playButton:update(dt)
  self.creditsButton:update(dt)
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
  self.playButton:draw()
  self.creditsButton:draw()

  -- Draw instructions
  love.graphics.setFont(self.instructionsFont)
  love.graphics.setColor(0.7, 0.7, 0.8)

  local instructionsY = self.screenH / 2 + 210
  local instructions1Width = self.instructionsFont:getWidth(self.instructionsText1)
  local instructions2Width = self.instructionsFont:getWidth(self.instructionsText2)

  love.graphics.print(self.instructionsText1, (self.screenW - instructions1Width) / 2, instructionsY)
  love.graphics.print(self.instructionsText2, (self.screenW - instructions2Width) / 2, instructionsY + 25)

  -- Reset color
  love.graphics.setColor(1, 1, 1)
end

function title:mousepressed(x, y, button)
  if self.playButton:mousepressed(x, y, button) then return end
  if self.creditsButton:mousepressed(x, y, button) then return end
end

function title:mousereleased(x, y, button)
  self.playButton:mousereleased(x, y, button)
  self.creditsButton:mousereleased(x, y, button)
end

return title
