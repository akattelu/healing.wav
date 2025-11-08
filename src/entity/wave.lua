local dbg              = require "src.lib.dbg"
local tween            = require "src.lib.tween"

local DEFAULT_SEGMENTS = 90
local BASE_RADIUS      = 64
local NUM_LAYERS       = 100


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

    -- Stat-based parameters (stored as reference to stats object)
    stats             = stats,

    -- Animation constants
    currentTimer      = 0,
    radius            = BASE_RADIUS, -- Ring start pos away from character center
    segments          = DEFAULT_SEGMENTS,

    -- Collisions
    collidedSprites   = {},
  }

  -- Helper methods to get current stat values with multipliers
  function Wave:getWavelength()
    return self.stats:getValue("wavelength")
  end

  function Wave:getExtensionDuration()
    return self.stats:getValue("range")
  end

  function Wave:getCooldown()
    return self.stats:getValue("period")
  end

  function Wave:getExpansionSpeed()
    return self.stats:getValue("frequency")
  end

  function Wave.load(_)

  end

  function Wave.update(self, dt)
    self.currentTimer = self.currentTimer + dt

    local range = self:getExtensionDuration()
    local frequency = self:getExpansionSpeed()
    local cooldown = self:getCooldown()

    if (self.mode == ExtensionMode.EXTENDING) then         -- Extension
      self.radius = tween.cubic(range * frequency, self.currentTimer, range)
      if (self.currentTimer >= range) then -- Reset to cooldown
        self.currentTimer = 0 -- Reset timer to start cooldown from 0
        self.mode = ExtensionMode.COOLDOWN
        self.collidedSprites = {} -- Reset this every expansion/cooldown cycle
      end
    else                          -- Cooldown
      if (self.currentTimer >= cooldown) then
        -- Reset into extension mode
        self.currentTimer = 0 -- Reset timer to start extension from 0
        self.mode = ExtensionMode.EXTENDING
        -- Reset to t=0
        self.radius = tween.cubic(range * frequency, 0, range)

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

    -- Draw thickening arc with radial gradient
    local wavelength = self:getWavelength()
    local arcStart = Direction[self.direction] - (wavelength / 2)
    local arcEnd = Direction[self.direction] + (wavelength / 2)

    -- Inner edge stays fixed, outer edge expands
    local innerRadius = BASE_RADIUS
    local outerRadius = self.radius
    local thickness = outerRadius - innerRadius

    -- Only draw if there's thickness to render
    if thickness <= 0 then
      return
    end

    -- Golden yellow sunlight color
    local r, g, b = 1, 0.9, 0.55

    -- Draw multiple concentric arcs to create gradient effect
    love.graphics.push("all")
    love.graphics.setLineWidth(2)

    for i = 0, NUM_LAYERS do
      local t = i / NUM_LAYERS
      local currentRadius = innerRadius + (thickness * t)

      -- Alpha gradient: 0.2 at inner edge, 1.0 at outer edge
      local alpha = 0.0 + (0.8 * t)

      love.graphics.setColor(r, g, b, alpha)
      love.graphics.arc("line", "open", self.cx, self.cy, currentRadius, arcStart, arcEnd,
        self.segments)
    end

    -- Reset color and line width
    love.graphics.pop()
  end

  function Wave.collisions(self, objects)
    -- Skip collision detection if wave is not active
    if self.mode == ExtensionMode.COOLDOWN then
      return {}
    end

    local tickCollisions = {}
    local wavelength = self:getWavelength()
    local arcStart = Direction[self.direction] - (wavelength / 2)
    local arcEnd = Direction[self.direction] + (wavelength / 2)
    local innerRadius = BASE_RADIUS
    local outerRadius = self.radius

    -- Helper function to check if a point is within the arc region
    local function pointInArc(px, py)
      -- Calculate distance from wave center
      local dx = px - self.cx
      local dy = py - self.cy
      local distance = math.sqrt(dx * dx + dy * dy)

      -- Check if distance is within arc's radial bounds
      if distance < innerRadius or distance > outerRadius then
        return false
      end

      -- If wavelength is >= full circle, hit everything in range
      if wavelength >= (2 * math.pi) then
        return true
      end

      -- Calculate angle from wave center to point
      local angle = math.atan2(dy, dx)
      if angle < 0 then
        angle = angle + (2 * math.pi)
      end

      -- Normalize arc angles to [0, 2π]
      local arcStartNorm = arcStart % (2 * math.pi)
      local arcEndNorm = arcEnd % (2 * math.pi)

      -- Handle wraparound case (e.g., arc crosses 0/2π boundary)
      if arcStartNorm > arcEndNorm then
        return angle >= arcStartNorm or angle <= arcEndNorm
      else
        return angle >= arcStartNorm and angle <= arcEndNorm
      end
    end

    for _, o in pairs(objects) do
      -- Skip if already collided this wave cycle
      local alreadyCollided = false
      for _, collided in pairs(self.collidedSprites) do
        if collided == o then
          alreadyCollided = true
          break
        end
      end

      if not alreadyCollided then
        local x, y, w, h = o:getPosition()

        -- Check all 4 corners of the bounding box
        local corners = {
          { x,     y },     -- Top-left
          { x + w, y },     -- Top-right
          { x,     y + h }, -- Bottom-left
          { x + w, y + h }  -- Bottom-right
        }

        local collided = false
        for _, corner in pairs(corners) do
          if pointInArc(corner[1], corner[2]) then
            collided = true
            break
          end
        end

        if collided then
          table.insert(self.collidedSprites, o)
          table.insert(tickCollisions, o)
        end
      end
    end

    return tickCollisions
  end

  return Wave
end

return {
  direction = Direction,
  new = wave
}
