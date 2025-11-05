local dbg = require "src.lib.dbg"
local tween = require "src.lib.tween"

local DEFAULT_SEGMENTS = 90
local BASE_RADIUS = 64


--- Direction of wave expansion
local Direction = {
  RIGHT = math.pi * 0 / 4,
  RIGHTDOWN = math.pi * 1 / 4,
  DOWN = math.pi * 2 / 4,
  DOWNLEFT = math.pi * 3 / 4,
  LEFT = math.pi,
  LEFTUP = math.pi * 5 / 4,
  UP = math.pi * 6 / 4,
  UPRIGHT = math.pi * 7 / 4,

  fromHVTuple = function(h, v)
    local idx = tostring(h) .. tostring(v)
    local map = {
      ["-1-1"] = "LEFTUP",
      ["-10"] = "LEFT",
      ["-11"] = "DOWNLEFT",
      ["0-1"] = "UP",
      ["00"] = "DOWN",
      ["01"] = "DOWN",
      ["1-1"] = "UPRIGHT",
      ["10"] = "RIGHT",
      ["11"] = "RIGHTDOWN",
    }
    return map[idx]
  end,
}

local ExtensionMode = {
  EXTENDING = 1,
  COOLDOWN = 2,
}

--- Wave class
local wave = function(stats, player)
  local cx = player:centerX()
  local cy = player:centerY()
  local Wave = {
    -- Arc positioning
    cx                = cx,
    cy                = cy,
    direction         = "DOWN",
    mode              = ExtensionMode.COOLDOWN,
    player            = player,

    -- Stat-based parameters
    stats             = stats,
    wavelength        = stats.wavelength,
    extensionDuration = stats.range,
    cooldown          = stats.period,
    expansionSpeed    = stats.frequency,

    -- Animation constants
    currentTimer      = 0,
    radius            = BASE_RADIUS, -- Ring start pos away from character center
    segments          = DEFAULT_SEGMENTS,
  }

  function Wave.load(_)

  end

  function Wave.update(self, dt)
    self.currentTimer = self.currentTimer + dt

    if (self.mode == ExtensionMode.EXTENDING) then -- Extension
      self.radius = tween.cubic(self.stats.range * self.stats.frequency, self.currentTimer, self.stats.range)
      print(self.currentTimer)
      if (self.currentTimer > self.extensionDuration) then -- Reset to cooldown
        self.currentTimer = self.currentTimer - self.extensionDuration
        self.mode = ExtensionMode.COOLDOWN
      end
    else -- Cooldown
      if (self.currentTimer > self.cooldown) then
        -- Reset into extension mode
        self.currentTimer = self.currentTimer - self.cooldown
        self.mode = ExtensionMode.EXTENDING
        -- Reset to t=0
        self.radius = tween.cubic(self.stats.range * self.stats.frequency, 0, self.stats.range)

        -- Reassign center based on stored player reference
        self.cx = self.player:centerX()
        self.cy = self.player:centerY()

        -- Pick a wave direction based on how the player is moving
        local h, v = self.player:getDirections()
        self.direction = Direction.fromHVTuple(h, v)
      end
    end
  end

  function Wave.draw(self)
    -- Hide wave on cooldown
    if (self.mode == ExtensionMode.COOLDOWN) then
      return
    end

    -- Draw arc
    local arcStart = Direction[self.direction] - (self.wavelength / 2)
    local arcEnd = Direction[self.direction] + (self.wavelength / 2)
    love.graphics.arc("line", "open", self.cx, self.cy, self.radius, arcStart, arcEnd,
      self.segments)
  end

  return Wave
end

return {
  direction = Direction,
  new = wave
}
