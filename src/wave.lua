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


--- Wave class
local wave = function(cx, cy, stats, direction)
  return {
    -- Arc positioning
    cx = cx,
    cy = cy,
    direction = direction,

    -- Stat-based parameters
    stats = stats,
    wavelength = stats.wavelength,
    extensionDuration = stats.range,

    -- Animation constants
    currentTimer = 0,
    radius = 64, -- Ring start pos away from character center
    segments = 90,

    --- Load
    load = function(self)

    end,

    --- Update
    update = function(self, dt)
      self.radius = self.radius + 1
      self.currentTimer = self.currentTimer + dt
      if (self.currentTimer > self.extensionDuration) then
        self.radius = 64
        self.currentTimer = -1 * self.stats.period -- "Cooldown" mechanism
      end
    end,

    --- Draw
    draw = function(self)
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
