--- Button component with hover states and optional callbacks
local button = {}

function button.new(args)
  local btn = {
    -- Required properties
    text = args.text or "",
    x = args.x or 0,
    y = args.y or 0,
    width = args.width or 200,
    height = args.height or 60,

    -- Optional properties
    description = args.description, -- Optional second line of text
    action = args.action, -- Optional callback function
    payload = args.payload, -- Optional data payload

    -- Styling (with defaults)
    bgColor = args.bgColor or {0.3, 0.5, 0.7},
    bgColorHover = args.bgColorHover or {0.4, 0.6, 0.8},
    borderColor = args.borderColor or {0.9, 0.9, 1},
    textColor = args.textColor or {1, 1, 1},
    descriptionColor = args.descriptionColor or {0.8, 0.8, 0.9},

    borderWidth = args.borderWidth or 2,
    cornerRadius = args.cornerRadius or 8,

    -- Fonts
    font = args.font or love.graphics.getFont(),
    descriptionFont = args.descriptionFont or love.graphics.getFont(),

    -- State
    hovered = false,
    pressed = false,
  }

  function btn:update(dt)
    local mx, my = love.mouse.getPosition()
    self.hovered = mx >= self.x and mx <= self.x + self.width and
                   my >= self.y and my <= self.y + self.height
  end

  function btn:draw()
    love.graphics.push("all")

    -- Button background
    if self.pressed then
      -- Slightly darker when pressed
      love.graphics.setColor(self.bgColor[1] * 0.8, self.bgColor[2] * 0.8, self.bgColor[3] * 0.8, self.bgColor[4] or 1)
    elseif self.hovered then
      love.graphics.setColor(self.bgColorHover[1], self.bgColorHover[2], self.bgColorHover[3], self.bgColorHover[4] or 1)
    else
      love.graphics.setColor(self.bgColor[1], self.bgColor[2], self.bgColor[3], self.bgColor[4] or 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)

    -- Button border
    love.graphics.setColor(self.borderColor[1], self.borderColor[2], self.borderColor[3], self.borderColor[4] or 1)
    love.graphics.setLineWidth(self.borderWidth)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)

    -- Button text (main)
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.textColor[1], self.textColor[2], self.textColor[3], self.textColor[4] or 1)
    local textHeight = self.font:getHeight()

    if self.description then
      -- Multi-line mode: use printf for text wrapping with padding
      local padding = 20
      local textLimit = self.width - (padding * 2)

      -- Use printf with center alignment
      love.graphics.printf(self.text, self.x + padding, self.y + 15, textLimit, "center")

      -- Description text (supports multi-line with \n)
      love.graphics.setFont(self.descriptionFont)

      -- Split description by newlines
      local lines = {}
      for line in self.description:gmatch("[^\n]+") do
        table.insert(lines, line)
      end

      -- Draw each line
      local lineHeight = self.descriptionFont:getHeight()
      local startY = self.y + 60
      for i, line in ipairs(lines) do
        -- Check if line starts with negative sign for trade-off styling
        if line:match("^%-") then
          love.graphics.setColor(1.0, 0.5, 0.5, self.descriptionColor[4] or 1) -- Red for penalties
        else
          love.graphics.setColor(self.descriptionColor[1], self.descriptionColor[2], self.descriptionColor[3], self.descriptionColor[4] or 1)
        end
        love.graphics.printf(line, self.x + padding, startY + (i - 1) * (lineHeight + 4), textLimit, "center")
      end
    else
      -- Single-line mode: centered
      local textWidth = self.font:getWidth(self.text)
      love.graphics.print(self.text,
        self.x + (self.width - textWidth) / 2,
        self.y + (self.height - textHeight) / 2)
    end

    love.graphics.pop()
  end

  function btn:mousepressed(x, y, mouseButton)
    if mouseButton == 1 and self.hovered then
      self.pressed = true
      if self.action then
        self.action()
      end
      return true
    end
    return false
  end

  function btn:mousereleased(x, y, mouseButton)
    if mouseButton == 1 then
      self.pressed = false
    end
  end

  -- Helper to set position
  function btn:setPosition(x, y)
    self.x = x
    self.y = y
  end

  return btn
end

return button
