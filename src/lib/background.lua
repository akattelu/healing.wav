-- Procedural background generator
-- Creates a simple grassy field pattern for the battle scene

local background = {}

function background.new()
  local self = {
    grassBlades = {},
    screenWidth = 0,
    screenHeight = 0
  }

  -- Generate grass blade positions and sizes
  function self:load()
    self.screenWidth, self.screenHeight = love.window.getMode()

    -- Use a fixed seed for consistent grass pattern
    local oldSeed = love.math.getRandomSeed()
    love.math.setRandomSeed(42)

    -- Generate grass blade data (position, height, shade)
    -- Create ~500 grass blades across the screen
    local numBlades = 500
    for i = 1, numBlades do
      table.insert(self.grassBlades, {
        x = love.math.random(0, self.screenWidth),
        y = love.math.random(0, self.screenHeight),
        height = love.math.random(8, 20),
        width = love.math.random(2, 4),
        shade = love.math.random() -- 0-1 for color variation
      })
    end

    -- Restore previous random seed
    love.math.setRandomSeed(oldSeed)
  end

  function self:draw()
    -- Draw base grass color (medium-dark green)
    love.graphics.setColor(0.3, 0.5, 0.2)
    love.graphics.rectangle("fill", 0, 0, self.screenWidth, self.screenHeight)

    -- Draw grass blades for texture
    for _, blade in ipairs(self.grassBlades) do
      -- Vary color based on blade's shade value
      if blade.shade < 0.5 then
        -- Darker grass
        love.graphics.setColor(0.2, 0.4, 0.15, 0.6)
      else
        -- Lighter grass
        love.graphics.setColor(0.4, 0.6, 0.3, 0.4)
      end

      -- Draw simple vertical grass blade
      love.graphics.rectangle("fill", blade.x, blade.y, blade.width, blade.height)
    end

    -- Reset color for subsequent drawing
    love.graphics.setColor(1, 1, 1, 1)
  end

  return self
end

return background
