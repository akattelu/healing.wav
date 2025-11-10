local health = require "src.entity.health"

--- Direction Enum
local Direction = {
  UP = 1,
  LEFT = 2,
  DOWN = 3,
  RIGHT = 4,
  IDLE = 5
}

--- Cleric core object
return function(spritePath, stats, initialHealth)
  return {
    -- Sprite metadata
    spritePath = spritePath,
    stats = stats,
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

    -- Collision box (narrower than sprite)
    collisionWidth = 64 * 0.5,  -- 50% width (25% cut each side)
    collisionHeight = 64,
    collisionOffsetX = 64 * 0.25, -- Center the narrower box

    -- Position
    x = 0,
    y = 0,
    directionX = Direction.IDLE,
    directionY = Direction.IDLE,
    spriteDirection = Direction.IDLE,
    lastNonIdleDirection = Direction.DOWN,
    -- Animation constants
    frameTimer = 0,
    frameDuration = 0.1,

    -- Stats
    health = health.new(0, 0, initialHealth),

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
      -- Direction and movement management
      local moveSpeed = self.stats:getValue("movementSpeed")
      if love.keyboard.isDown("up", "w") then
        self.y = self.y - moveSpeed * dt
        self.directionY = Direction.UP
        self.spriteDirection = Direction.UP
        self.lastNonIdleDirection = Direction.UP
      elseif love.keyboard.isDown("down", "s") then
        self.y = self.y + moveSpeed * dt
        self.directionY = Direction.DOWN
        self.spriteDirection = Direction.DOWN
        self.lastNonIdleDirection = Direction.DOWN
      end
      if love.keyboard.isDown("left", "a") then
        self.x = self.x - moveSpeed * dt
        self.directionX = Direction.LEFT
        self.spriteDirection = Direction.LEFT
        self.lastNonIdleDirection = Direction.LEFT
      elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + moveSpeed * dt
        self.directionX = Direction.RIGHT
        self.spriteDirection = Direction.RIGHT
        self.lastNonIdleDirection = Direction.RIGHT
      end
      if not love.keyboard.isDown("left", "up", "down", "right", "w", "a", "s", "d") then
        -- Update IDLE to show first frame of last direction moved
        self.frames[Direction.IDLE] = { self.frames[self.lastNonIdleDirection][1] }
        self.spriteDirection = Direction.IDLE
        self.currentFrame = 1
        self.directionX = Direction.IDLE
        self.directionY = Direction.IDLE
      end

      -- Frame timer loop
      self.frameTimer = self.frameTimer + dt
      if (self.frameTimer >= self.frameDuration) then
        self.frameTimer = self.frameTimer - self.frameDuration
        self.currentFrame = self.currentFrame + 1
      end

      if self.currentFrame > #self.frames[self.spriteDirection] then
        self.currentFrame = 1
      end

      -- Update health bar position
      self.health:setTopLeft(self.x, self.y + self.frameHeight)
    end,

    --- Get current frame quad
    frame = function(self)
      return self.frames[self.spriteDirection][self.currentFrame]
    end,

    --- CX
    centerX = function(self)
      return self.x + (self.frameWidth / 2)
    end,

    --- CY
    centerY = function(self)
      return self.y + (self.frameHeight / 2)
    end,

    --- Get movement direction
    --- Returns 1/0/-1 for right, down
    getDirections = function(self)
      -- If stationary, use last direction moved
      if self.directionX == Direction.IDLE and self.directionY == Direction.IDLE then
        local directionMap = {
          [Direction.UP] = {0, -1},
          [Direction.DOWN] = {0, 1},
          [Direction.LEFT] = {-1, 0},
          [Direction.RIGHT] = {1, 0},
        }
        local dir = directionMap[self.lastNonIdleDirection]
        return dir[1], dir[2]
      end

      local map = {
        [Direction.IDLE] = 0,
        [Direction.RIGHT] = 1,
        [Direction.LEFT] = -1,
        [Direction.DOWN] = 1,
        [Direction.UP] = -1,
      }
      return map[self.directionX], map[self.directionY]
    end,

    --- Draw cleric and health bar
    draw = function(self)
      love.graphics.push("all")
      love.graphics.draw(self.sheet, self:frame(), self.x, self.y)
      self.health:draw()
      love.graphics.pop()
    end,

    --- Get position for collision detection
    getPosition = function(self)
      return self.x + self.collisionOffsetX, self.y, self.collisionWidth, self.collisionHeight
    end,

    --- Take damage
    damage = function(self, dmg)
      self.health:damage(dmg)
    end
  }
end
