-- Reward selection scene - appears after completing a wave
local reward_select = {}
local button = require "src.ui.button"

-- Load stat upgrades from library
local STAT_UPGRADES = require("src.lib.stat_upgrades")

function reward_select:load()
  -- Get screen dimensions
  self.screenW, self.screenH = love.window.getMode()

  -- Fonts
  self.titleFont = love.graphics.newFont(36)
  self.buttonFont = love.graphics.newFont(20)
  self.descFont = love.graphics.newFont(16)

  -- Initialize selection counter if not set
  if not S.rewardSelectionNumber then
    S.rewardSelectionNumber = 1
  end

  -- Header text (shows the wave just completed and selection progress)
  self.headerText = "Wave " .. S.currentWave .. " Complete! - Reward " .. S.rewardSelectionNumber .. "/3"

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
    self.buttons[i] = button.new({
      text = "+" .. reward.percent .. "% " .. reward.name,
      description = reward.description,
      width = buttonWidth,
      height = buttonHeight,
      x = (self.screenW - buttonWidth) / 2,
      y = startY + (i - 1) * (buttonHeight + buttonSpacing),
      font = self.buttonFont,
      descriptionFont = self.descFont,
      payload = reward,
      action = function()
        -- Apply the selected upgrade
        self:applyUpgrade(reward)

        -- Increment selection counter
        S.rewardSelectionNumber = S.rewardSelectionNumber + 1

        -- Check if player has made all 3 selections
        if S.rewardSelectionNumber <= 3 then
          -- Reload reward_select with new random rewards
          S.sceneManager:switch("reward_select")
        else
          -- All 3 selections complete - transition to wave intro
          S.sceneManager:switch("wave_intro")
        end
      end
    })
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
  for _, btn in ipairs(self.buttons) do
    btn:update(dt)
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
  for _, btn in ipairs(self.buttons) do
    btn:draw()
  end

  -- Reset color
  love.graphics.setColor(1, 1, 1)
end

function reward_select:mousepressed(x, y, button)
  for _, btn in ipairs(self.buttons) do
    if btn:mousepressed(x, y, button) then
      return
    end
  end
end

function reward_select:mousereleased(x, y, button)
  for _, btn in ipairs(self.buttons) do
    btn:mousereleased(x, y, button)
  end
end

function reward_select:applyUpgrade(reward)
  -- Apply percentage-based upgrade to the stat
  if S.stats then
    S.stats:applyUpgrade(reward.stat, reward.percent)
  end
end

return reward_select
