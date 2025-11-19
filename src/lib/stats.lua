local stats = {}

function stats.new()
  local s = {
    -- Base stat values
    amplitude = 3,            -- Damage
    wavelength = math.pi / 2, -- Arc Length
    frequency = 1.5,          -- Attack Speed (attacks per second)
    range = 200,              -- Wave Distance (max radius in pixels)
    movementSpeed = 200,      -- Player movement speed
    knockback = 150,          -- Knockback impulse strength

    -- Multipliers for percentage-based upgrades (1.0 = base, 1.2 = 20% increase)
    multipliers = {
      amplitude = 1.0,
      wavelength = 1.0,
      frequency = 1.0,
      range = 1.0,
      movementSpeed = 1.0,
      knockback = 1.0,
    }
  }

  -- Method to apply percentage-based upgrade
  function s:applyUpgrade(statName, percent)
    if self.multipliers[statName] then
      self.multipliers[statName] = self.multipliers[statName] * (1 + percent / 100)
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
