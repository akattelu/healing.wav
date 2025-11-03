local dbg = require "src.dbg"

--- Direction Enum
local Direction = {
  UP = 1,
  LEFT = 2,
  DOWN = 3,
  RIGHT = 4,
  IDLE = 5
}

--- Skeleton core object
return function(spritePath, destX, destY, startX, startY)
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

    -- Position
    x = startX,
    y = startY,
    speed = 20,
    direction = Direction.IDLE,

    -- Animation constants
    frameTimer = 0,
    frameDuration = 0.1,

    -- AI
    destX = destX,
    destY = destY,

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
      local dx = self.x - self.destX
      local dy = self.y - self.destY

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
    end,

    --- Get current frame quad
    frame = function(self)
      return self.frames[self.direction][self.currentFrame]
    end
  }
end
