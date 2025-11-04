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
    directionX = Direction.IDLE,
    directionY = Direction.IDLE,
    spriteDirection = Direction.IDLE,
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
        self.directionY = Direction.UP
        self.spriteDirection = Direction.UP
      elseif love.keyboard.isDown("down", "s") then
        self.y = self.y + self.speed * dt
        self.directionY = Direction.DOWN
        self.spriteDirection = Direction.DOWN
      end
      if love.keyboard.isDown("left", "a") then
        self.x = self.x - self.speed * dt
        self.directionX = Direction.LEFT
        self.spriteDirection = Direction.LEFT
      elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + self.speed * dt
        self.directionX = Direction.RIGHT
        self.spriteDirection = Direction.RIGHT
      end
      if not love.keyboard.isDown("left", "up", "down", "right", "w", "a", "s", "d") then
        self.spriteDirection = Direction.IDLE
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
      local map = {
        IDLE = 0,
        RIGHT = 1,
        LEFT = -1,
        DOWN = 1,
        UP = -1,
      }
      return map[self.directionX], map[self.directionY]
    end
  }
end
