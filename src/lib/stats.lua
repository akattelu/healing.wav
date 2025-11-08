local stats = {}

function stats.new()
  local s = {
    -- Base stat values
    amplitude = 1,            -- Damage
    wavelength = math.pi / 2, -- Arc Length
    frequency = 200,          -- Speed
    period = 0.1,             -- Cooldown
    range = 1,                -- Duration

    -- Multipliers for percentage-based upgrades (1.0 = base, 1.2 = 20% increase)
    multipliers = {
      amplitude = 1.0,
      wavelength = 1.0,
      frequency = 1.0,
      period = 1.0,
      range = 1.0,
    }
  }

  -- Method to apply percentage-based upgrade
  function s:applyUpgrade(statName, percent)
    if self.multipliers[statName] then
      -- For period (cooldown), lower is better, so we subtract the percentage
      if statName == "period" then
        self.multipliers[statName] = self.multipliers[statName] * (1 - percent / 100)
      else
        self.multipliers[statName] = self.multipliers[statName] * (1 + percent / 100)
      end
    end
  end

  -- Method to get actual stat value with multiplier applied
  function s:getValue(statName)
    local baseValue = self[statName]
    local multiplier = self.multipliers[statName] or 1.0
    return baseValue * multiplier
  end

  -- Method to set base value directly (for debug panel)
  function s:setBaseValue(statName, value)
    if self[statName] ~= nil then
      self[statName] = value
    end
  end

  -- Method to set multiplier directly (for debug panel)
  function s:setMultiplier(statName, value)
    if self.multipliers[statName] then
      self.multipliers[statName] = value
    end
  end

  -- Method to get base value
  function s:getBaseValue(statName)
    return self[statName]
  end

  -- Method to get multiplier
  function s:getMultiplier(statName)
    return self.multipliers[statName] or 1.0
  end

  return s
end

return stats
