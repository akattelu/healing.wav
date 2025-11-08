local WaveIntro = {}

function WaveIntro:load()
  self.timer = 0
  self.displayDuration = 2.0 -- Show wave number for 2 seconds

  -- Get current wave from global state
  self.waveNumber = S.currentWave or 1
end

function WaveIntro:update(dt)
  self.timer = self.timer + dt

  -- Auto-transition to battle scene after display duration
  if self.timer >= self.displayDuration then
    S.sceneManager:switch('battle')
  end
end

function WaveIntro:draw()
  love.graphics.setColor(1, 1, 1)

  -- Draw wave number centered on screen
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()

  local font = love.graphics.getFont()
  local waveText = "Wave " .. self.waveNumber .. " / 10"
  local textWidth = font:getWidth(waveText)
  local textHeight = font:getHeight()

  love.graphics.print(
    waveText,
    (screenWidth - textWidth) / 2,
    (screenHeight - textHeight) / 2
  )
end

return WaveIntro
