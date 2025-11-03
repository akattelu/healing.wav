local dbg = require "src.dbg"

--- Direction Enum
local Direction = {
  UP = 1,
  LEFT = 2,
  DOWN = 3,
  RIGHT = 4,
  IDLE = 5
}

--- Cleric core object
return function(spritePath)
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
    x = 0,
    y = 0,
    speed = 200,
    direction = Direction.IDLE,

    -- Animation constants
    frameTimer = 0,
    frameDuration = 0.1,

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
      if love.keyboard.isDown("up", "w") then
        self.y = self.y - self.speed * dt
        self.direction = Direction.UP
      elseif love.keyboard.isDown("down", "s") then
        self.y = self.y + self.speed * dt
        self.direction = Direction.DOWN
      end
      if love.keyboard.isDown("left", "a") then
        self.x = self.x - self.speed * dt
        self.direction = Direction.LEFT
      elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + self.speed * dt
        self.direction = Direction.RIGHT
      end
      if not love.keyboard.isDown("left", "up", "down", "right", "w", "a", "s", "d") then
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
    end,

    --- CX
    centerX = function(self)
      return self.x + (self.frameWidth / 2)
    end,

    --- CY
    centerY = function(self)
      return self.y + (self.frameHeight / 2)
    end
  }
end
