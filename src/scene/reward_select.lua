-- Reward selection scene - appears after completing a wave
local reward_select = {}

-- Available stat upgrades with their display names and upgrade percentages
local STAT_UPGRADES = {
  { stat = "amplitude", name = "Damage", percent = 20, description = "Increase wave damage" },
  { stat = "wavelength", name = "Arc Width", percent = 15, description = "Wider healing wave" },
  { stat = "frequency", name = "Speed", percent = 25, description = "Faster wave expansion" },
  { stat = "period", name = "Cooldown", percent = 15, description = "Shorter cooldown (inverse)" },
  { stat = "range", name = "Duration", percent = 20, description = "Wave lasts longer" },
  { stat = "movementSpeed", name = "Movement Speed", percent = 20, description = "Move faster across the battlefield" },
  { stat = "knockback", name = "Knockback", percent = 25, description = "Push enemies back harder" },
}

function reward_select:load()
  -- Get screen dimensions
  self.screenW, self.screenH = love.window.getMode()

  -- Fonts
  self.titleFont = love.graphics.newFont(36)
  self.buttonFont = love.graphics.newFont(20)
  self.descFont = love.graphics.newFont(16)

  -- Header text
  self.headerText = "Wave " .. (S.currentWave - 1) .. " Complete!"

  -- Select 3 random rewards
  self.rewards = self:selectRandomRewards(3)

  -- Create buttons for each reward
  self.buttons = {}
  local buttonWidth = 400
  local buttonHeight = 100
  local buttonSpacing = 30
  local startY = self.screenH / 2 - (3 * buttonHeight + 2 * buttonSpacing) / 2

  for i = 1, 3 do
    local reward = self.rewards[i]
    self.buttons[i] = {
      reward = reward,
      text = "+" .. reward.percent .. "% " .. reward.name,
      description = reward.description,
      width = buttonWidth,
      height = buttonHeight,
      x = (self.screenW - buttonWidth) / 2,
      y = startY + (i - 1) * (buttonHeight + buttonSpacing),
      hovered = false
    }
  end
end

function reward_select:selectRandomRewards(count)
  -- Create a copy of available upgrades
  local available = {}
  for _, upgrade in ipairs(STAT_UPGRADES) do
    table.insert(available, upgrade)
  end

  -- Shuffle and select
  local selected = {}
  for i = 1, math.min(count, #available) do
    local index = love.math.random(1, #available)
    table.insert(selected, available[index])
    table.remove(available, index)
  end

  return selected
end

function reward_select:update(dt)
  -- Check if mouse is hovering over buttons
  local mx, my = love.mouse.getPosition()

  for _, button in ipairs(self.buttons) do
    button.hovered = mx >= button.x and mx <= button.x + button.width
        and my >= button.y and my <= button.y + button.height
  end
end

function reward_select:draw()
  -- Clear background
  love.graphics.clear(0.1, 0.1, 0.15)

  -- Draw header
  love.graphics.setFont(self.titleFont)
  local headerWidth = self.titleFont:getWidth(self.headerText)
  love.graphics.setColor(0.8, 0.9, 1)
  love.graphics.print(self.headerText, (self.screenW - headerWidth) / 2, 100)

  -- Draw instruction text
  love.graphics.setFont(self.descFont)
  local instructText = "Choose your reward:"
  local instructWidth = self.descFont:getWidth(instructText)
  love.graphics.setColor(0.7, 0.8, 0.9)
  love.graphics.print(instructText, (self.screenW - instructWidth) / 2, 170)

  -- Draw buttons
  love.graphics.setFont(self.buttonFont)
  for _, button in ipairs(self.buttons) do
    self:drawButton(button)
  end

  -- Reset color
  love.graphics.setColor(1, 1, 1)
end

function reward_select:drawButton(button)
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

  -- Button text (main upgrade)
  love.graphics.setFont(self.buttonFont)
  local textWidth = self.buttonFont:getWidth(button.text)
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(
    button.text,
    button.x + (button.width - textWidth) / 2,
    button.y + 25
  )

  -- Description text
  love.graphics.setFont(self.descFont)
  local descWidth = self.descFont:getWidth(button.description)
  love.graphics.setColor(0.8, 0.8, 0.9)
  love.graphics.print(
    button.description,
    button.x + (button.width - descWidth) / 2,
    button.y + 60
  )
end

function reward_select:mousepressed(x, y, button)
  if button == 1 then
    for _, btn in ipairs(self.buttons) do
      if btn.hovered then
        -- Apply the selected upgrade
        self:applyUpgrade(btn.reward)
        -- Increment wave counter
        S.currentWave = S.currentWave + 1
        -- Transition to wave intro
        S.sceneManager:switch("wave_intro")
        return
      end
    end
  end
end

function reward_select:applyUpgrade(reward)
  -- Apply percentage-based upgrade to the stat
  if S.stats then
    S.stats:applyUpgrade(reward.stat, reward.percent)
  end
end

return reward_select
