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
return function(cx, cy, r)
  return {
    -- Arc sizes
    segments = 90,
    cx = cx,
    cy = cy,
    radius = r,

    -- Animation constants
    extensionDuration = 0.5,
    currentTimer = 0,

    --- Load
    load = function(self)

    end,

    --- Update
    update = function(self, dt)
      self.radius = self.radius + 1
      self.currentTimer = self.currentTimer + dt
      if (self.currentTimer > self.extensionDuration) then
        self.radius = 0

        -- Temporary
        self.radius = 50
        self.currentTimer = 0
      end
    end,

    --- Draw
    draw = function(self)
      love.graphics.arc("line", "open", self.cx, self.cy, self.radius, Direction.RIGHT, Direction.UP, self.segments)
    end
  }
end
