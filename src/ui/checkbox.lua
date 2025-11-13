--- Checkbox component with label and hover state
local checkbox = {}

function checkbox.new(args)
  local cb = {
    -- Required properties
    label = args.label or "",
    x = args.x or 0,
    y = args.y or 0,

    -- State
    checked = args.checked or false,

    -- Optional callback
    onChange = args.onChange, -- function(checked) called when state changes

    -- Styling (with defaults)
    width = args.width or 20,
    height = args.height or 20,
    bgColor = args.bgColor or {0.2, 0.3, 0.4},
    bgColorHover = args.bgColorHover or {0.3, 0.4, 0.5},
    borderColor = args.borderColor or {0.5, 0.7, 0.9},
    checkColor = args.checkColor or {0.3, 1, 0.3},
    labelColor = args.labelColor or {0.9, 0.9, 0.9},

    cornerRadius = args.cornerRadius or 2,
    borderWidth = args.borderWidth or 1,

    -- Font
    font = args.font or love.graphics.newFont(10),

    -- State
    hovered = false,
  }

  function cb:update(dt)
    local mx, my = love.mouse.getPosition()
    self.hovered = mx >= self.x and mx <= self.x + self.width and
                   my >= self.y and my <= self.y + self.height
  end

  function cb:draw()
    love.graphics.push("all")

    -- Checkbox background
    if self.hovered then
      love.graphics.setColor(self.bgColorHover[1], self.bgColorHover[2], self.bgColorHover[3], self.bgColorHover[4] or 1)
    else
      love.graphics.setColor(self.bgColor[1], self.bgColor[2], self.bgColor[3], self.bgColor[4] or 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)

    -- Checkbox border
    love.graphics.setColor(self.borderColor[1], self.borderColor[2], self.borderColor[3], self.borderColor[4] or 1)
    love.graphics.setLineWidth(self.borderWidth)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)

    -- Checkmark if checked
    if self.checked then
      love.graphics.setColor(self.checkColor[1], self.checkColor[2], self.checkColor[3], self.checkColor[4] or 1)
      love.graphics.setLineWidth(2)
      love.graphics.line(self.x + 4, self.y + 10, self.x + 8, self.y + 14)
      love.graphics.line(self.x + 8, self.y + 14, self.x + 16, self.y + 6)
    end

    -- Label
    if self.label and self.label ~= "" then
      love.graphics.setFont(self.font)
      love.graphics.setColor(self.labelColor[1], self.labelColor[2], self.labelColor[3], self.labelColor[4] or 1)
      love.graphics.print(self.label, self.x + self.width + 5, self.y + 5)
    end

    love.graphics.pop()
  end

  function cb:mousepressed(x, y, button)
    if button == 1 and self.hovered then
      self:toggle()
      return true
    end
    return false
  end

  function cb:toggle()
    self.checked = not self.checked
    if self.onChange then
      self.onChange(self.checked)
    end
  end

  function cb:setChecked(checked)
    if self.checked ~= checked then
      self.checked = checked
      if self.onChange then
        self.onChange(self.checked)
      end
    end
  end

  function cb:setPosition(x, y)
    self.x = x
    self.y = y
  end

  return cb
end

return checkbox
