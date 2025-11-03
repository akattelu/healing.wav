return function(spritePath)
  return {
    spritePath = spritePath,
    sheet = nil,
    frames = {},
    x = 0,
    y = 0,
    currentFrame = 0,
    frameWidth = 64,
    frameHeight = 64,

    frameTimer = 0,
    frameDuration = 0.1,

    load = function(self)
      self.sheet = love.graphics.newImage(self.spritePath)
      local numCols = self.sheet:getWidth() / self.frameWidth
      local numRows = self.sheet:getHeight() / self.frameHeight

      for c = 0, numCols - 1 do
        for r = 0, numRows - 1 do
          self.frames[r * numCols + c] = love.graphics.newQuad(c * self.frameWidth, r * self.frameHeight, self
            .frameWidth, self.frameHeight, self.sheet)
        end
      end
    end,

    update = function(self, dt)
      self.frameTimer = self.frameTimer + dt
      if (self.frameTimer >= 1) then
        self.frameTimer = self.frameTimer - 1
        self.currentFrame = self.currentFrame + 1
        if (self.currentFrame == #self.frames) then
          self.currentFrame = 0
        end
      end
    end,

    frame = function(self)
      return self.frames[self.currentFrame]
    end
  }
end
