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

  return s
end

return stats
