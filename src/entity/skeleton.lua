local dbg = require "src.lib.dbg"
local health = require "src.entity.health"

local HIT_DURATION = 0.5

--- Direction Enum
local Direction = {
  UP = 1,
  LEFT = 2,
  DOWN = 3,
  RIGHT = 4,
  IDLE = 5
}

--- Skeleton core object
return function(spritePath, player, startX, startY, initialHealth, initialSpeed)
  return {
    -- Sprite metadata
    spritePath = spritePath,
    sheet = nil,
    frames = {
      [Direction.UP] = {},
      [Direction.LEFT] = {},
      [Direction.DOWN] = {},
      [Direction.RIGHT] = {},
      [Direction.IDLE] = {},
    },
    currentFrame = 1,
    frameWidth = 64,
    frameHeight = 64,

    -- Collision box (narrower and shorter than sprite)
    collisionWidth = 64 * 0.5,  -- 50% width (25% cut each side)
    collisionHeight = 64 * 0.75, -- 75% height (25% cut from top)
    collisionOffsetX = 64 * 0.25, -- Center the narrower box
    collisionOffsetY = 64 * 0.25, -- Shift down by 25%

    -- Position
    x = startX,
    y = startY,
    speed = initialSpeed or 20,
    direction = Direction.IDLE,

    -- Velocity (for knockback)
    velocityX = 0,
    velocityY = 0,
    friction = 5.0,

    -- Animation constants
    frameTimer = 0,
    frameDuration = 0.1,

    -- AI
    player = player,

    -- Stats
    health = health.new(startX + 64, startY, initialHealth),
    hit = false, -- for rendering flash effect and hit markers
    hitTimer = 0,

    --- Load
    load = function(self)
      self.sheet = love.graphics.newImage(self.spritePath)
      local numCols = self.sheet:getWidth() / self.frameWidth
      local numRows = self.sheet:getHeight() / self.frameHeight

      for c = 0, numCols - 1 do
        for r = 0, numRows - 1 do
          self.frames[r + 1][c + 1] = love.graphics.newQuad(c * self.frameWidth, r * self.frameHeight, self.frameWidth,
            self.frameHeight, self.sheet)
        end
      end
      -- Default animation is facing down
      self.frames[Direction.IDLE] = { self.frames[Direction.DOWN][1] }
    end,

    --- Update
    update = function(self, dt)
      -- Apply velocity (knockback) with friction decay
      if self.velocityX ~= 0 or self.velocityY ~= 0 then
        -- Apply velocity to position
        self.x = self.x + self.velocityX * dt
        self.y = self.y + self.velocityY * dt

        -- Apply friction (decay velocity over time)
        local decay = 1 - self.friction * dt
        if decay < 0 then decay = 0 end
        self.velocityX = self.velocityX * decay
        self.velocityY = self.velocityY * decay

        -- Stop very small velocities to prevent floating point drift
        if math.abs(self.velocityX) < 0.1 then self.velocityX = 0 end
        if math.abs(self.velocityY) < 0.1 then self.velocityY = 0 end
      end

      -- Direction and movement management
      local destX = self.player:centerX()
      local destY = self.player:centerY()
      local dx = self.x - destX
      local dy = self.y - destY

      if dy > 0 then
        self.y = self.y - self.speed * dt
        self.direction = Direction.UP
      elseif dy < 0 then
        self.y = self.y + self.speed * dt
        self.direction = Direction.DOWN
      end
      if dx > 0 then
        self.x = self.x - self.speed * dt
        self.direction = Direction.LEFT
      elseif dy < 0 then
        self.x = self.x + self.speed * dt
        self.direction = Direction.RIGHT
      end
      if dx == 0 and dy == 0 then
        self.direction = Direction.IDLE
      end

      -- Frame timer loop
      self.frameTimer = self.frameTimer + dt
      if (self.frameTimer >= self.frameDuration) then
        self.frameTimer = self.frameTimer - self.frameDuration
        self.currentFrame = self.currentFrame + 1
      end

      if self.currentFrame > #self.frames[self.direction] then
        self.currentFrame = 1
      end

      -- Update health bar
      self.health:setTopLeft(self.x, self.y + self.frameHeight)

      if (self.hit) then
        self.hitTimer = self.hitTimer + dt
        if (self.hitTimer > HIT_DURATION) then
          self.hitTimer = 0
          self.hit = false
        end
      end
    end,

    --- Get current frame quad
    frame = function(self)
      return self.frames[self.direction][self.currentFrame]
    end,


    draw = function(self)
      love.graphics.push("all")
      if (self.hit) then
        love.graphics.setColor(1, 1, 1, 0.5)
      end
      love.graphics.draw(self.sheet, self:frame(), self.x, self.y)
      self.health:draw()
      love.graphics.pop()
    end,

    getPosition = function(self)
      return self.x + self.collisionOffsetX, self.y + self.collisionOffsetY, self.collisionWidth, self.collisionHeight
    end,

    damage = function(self, dmg)
      self.hit = true
      self.health:damage(dmg)
    end
  }
end
