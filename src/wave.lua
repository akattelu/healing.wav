local dbg = require "src.dbg"

--- Direction of wave expansion
local Direction = {
  RIGHT = math.pi * 0 / 4,
  RIGHTDOWN = math.pi * 1 / 4,
  DOWN = math.pi * 2 / 4,
  DOWNLEFT = math.pi * 3 / 4,
  LEFT = math.pi,
  LEFTUP = math.pi * 5 / 4,
  UP = math.pi * 6 / 4,
  UPRIGHT = math.pi * 7 / 4
}

local ExtensionMode = {
  EXTENDING = 1,
  COOLDOWN = 2,
}

local DEFAULT_SEGMENTS = 90
local BASE_RADIUS = 64


--- Wave class
local wave = function(cx, cy, stats, direction)
  return {
    -- Arc positioning
    cx = cx,
    cy = cy,
    direction = direction,
    mode = ExtensionMode.COOLDOWN,

    -- Stat-based parameters
    stats = stats,
    wavelength = stats.wavelength,
    extensionDuration = stats.range,
    cooldown = stats.period,
    expansionSpeed = stats.frequency,

    -- Animation constants
    currentTimer = 0,
    radius = BASE_RADIUS, -- Ring start pos away from character center
    segments = DEFAULT_SEGMENTS,

    --- Load
    load = function(self)

    end,

    --- Update
    update = function(self, dt)
      if (self.mode == ExtensionMode.EXTENDING) then
        self.currentTimer = self.currentTimer + dt
        self.radius = self.radius + self.expansionSpeed
        if (self.currentTimer > self.extensionDuration) then
          self.currentTimer = self.currentTimer - self.extensionDuration
          self.mode = ExtensionMode.COOLDOWN
        end
      else -- cooldown
        self.currentTimer = self.currentTimer + dt
        if (self.currentTimer > self.cooldown) then
          self.currentTimer = self.currentTimer - self.cooldown
          self.mode = ExtensionMode.EXTENDING
          self.radius = BASE_RADIUS
        end
      end
    end,

    --- Draw
    draw = function(self)
      if (self.mode == ExtensionMode.COOLDOWN) then
        return
      end
      local arcStart = Direction[self.direction] - (self.wavelength / 2)
      local arcEnd = Direction[self.direction] + (self.wavelength / 2)
      love.graphics.arc("line", "open", self.cx, self.cy, self.radius, arcStart, arcEnd,
        self.segments)
    end
  }
end

return {
  direction = Direction,
  new = wave
}
