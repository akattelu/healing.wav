--- Number control with +/- buttons for value adjustment
local numberControl = {}

function numberControl.new(label, x, y, width, minValue, maxValue, initialValue, step, onChange)
  local nc = {
    label = label,
    x = x,
    y = y,
    width = width,
    height = 24,
    minValue = minValue,
    maxValue = maxValue,
    value = initialValue or minValue,
    step = step or 1, -- Default increment/decrement amount
    onChange = onChange, -- Callback function when value changes

    -- Visual settings
    font = love.graphics.newFont(12),
    buttonWidth = 24,
    buttonHeight = 24,

    -- Button state
    minusHovered = false,
    plusHovered = false,
    minusPressed = false,
    plusPressed = false,
  }

  -- Calculate smart step size based on value range
  function nc:getSmartStep()
    local range = self.maxValue - self.minValue
    if range <= 1 then
      return 0.01 -- Very small range (like 0-1)
    elseif range <= 10 then
      return 0.1 -- Small range
    elseif range <= 100 then
      return 1 -- Medium range
    else
      return 10 -- Large range
    end
  end

  function nc:setValue(value)
    local newValue = math.max(self.minValue, math.min(self.maxValue, value))
    if newValue ~= self.value then
      self.value = newValue
      if self.onChange then
        self.onChange(newValue)
      end
    end
  end

  function nc:increment()
    local step = self.step or self:getSmartStep()
    self:setValue(self.value + step)
  end

  function nc:decrement()
    local step = self.step or self:getSmartStep()
    self:setValue(self.value - step)
  end

  function nc:update(dt)
    local mx, my = love.mouse.getPosition()

    -- Calculate button positions
    local minusX = self.x + self.width - (self.buttonWidth * 2) - 5
    local plusX = self.x + self.width - self.buttonWidth
    local buttonY = self.y

    -- Check hover state
    self.minusHovered = mx >= minusX and mx <= minusX + self.buttonWidth
                        and my >= buttonY and my <= buttonY + self.buttonHeight

    self.plusHovered = mx >= plusX and mx <= plusX + self.buttonWidth
                       and my >= buttonY and my <= buttonY + self.buttonHeight
  end

  function nc:draw()
    love.graphics.push("all")

    -- Draw label
    love.graphics.setFont(self.font)
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.print(self.label .. ":", self.x, self.y + 5)

    -- Calculate positions
    local labelWidth = self.font:getWidth(self.label .. ":")
    local valueX = self.x + labelWidth + 10
    local minusX = self.x + self.width - (self.buttonWidth * 2) - 5
    local plusX = self.x + self.width - self.buttonWidth
    local buttonY = self.y

    -- Draw value
    love.graphics.setColor(1, 1, 1)
    local valueText = string.format("%.2f", self.value)
    love.graphics.print(valueText, valueX, self.y + 5)

    -- Draw minus button
    if self.minusPressed then
      love.graphics.setColor(0.3, 0.4, 0.5)
    elseif self.minusHovered then
      love.graphics.setColor(0.4, 0.5, 0.6)
    else
      love.graphics.setColor(0.3, 0.4, 0.5)
    end
    love.graphics.rectangle("fill", minusX, buttonY, self.buttonWidth, self.buttonHeight, 4, 4)
    love.graphics.setColor(0.9, 0.9, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", minusX, buttonY, self.buttonWidth, self.buttonHeight, 4, 4)

    -- Draw minus symbol
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(2)
    local minusCenterX = minusX + self.buttonWidth / 2
    local minusCenterY = buttonY + self.buttonHeight / 2
    love.graphics.line(minusCenterX - 6, minusCenterY, minusCenterX + 6, minusCenterY)

    -- Draw plus button
    if self.plusPressed then
      love.graphics.setColor(0.3, 0.4, 0.5)
    elseif self.plusHovered then
      love.graphics.setColor(0.4, 0.5, 0.6)
    else
      love.graphics.setColor(0.3, 0.4, 0.5)
    end
    love.graphics.rectangle("fill", plusX, buttonY, self.buttonWidth, self.buttonHeight, 4, 4)
    love.graphics.setColor(0.9, 0.9, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", plusX, buttonY, self.buttonWidth, self.buttonHeight, 4, 4)

    -- Draw plus symbol
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(2)
    local plusCenterX = plusX + self.buttonWidth / 2
    local plusCenterY = buttonY + self.buttonHeight / 2
    love.graphics.line(plusCenterX - 6, plusCenterY, plusCenterX + 6, plusCenterY)
    love.graphics.line(plusCenterX, plusCenterY - 6, plusCenterX, plusCenterY + 6)

    love.graphics.pop()
  end

  function nc:mousepressed(x, y, button)
    if button ~= 1 then return false end

    local minusX = self.x + self.width - (self.buttonWidth * 2) - 5
    local plusX = self.x + self.width - self.buttonWidth
    local buttonY = self.y

    if self.minusHovered then
      self.minusPressed = true
      self:decrement()
      return true
    elseif self.plusHovered then
      self.plusPressed = true
      self:increment()
      return true
    end

    return false
  end

  function nc:mousereleased(x, y, button)
    if button == 1 then
      self.minusPressed = false
      self.plusPressed = false
    end
  end

  return nc
end

return numberControl
