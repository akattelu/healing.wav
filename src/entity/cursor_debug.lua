local function cursor_debug()
  local cd = {}

  function cd:load() end

  function cd:update(dt) end

  function cd:draw()
    local mx, my = love.mouse.getPosition()
    local text = string.format("x: %d, y: %d", mx, my)

    -- Offset from cursor
    local offsetX, offsetY = 15, 15
    local padding = 4

    -- Get text dimensions
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()

    -- Draw background
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", mx + offsetX, my + offsetY, textWidth + padding * 2, textHeight + padding * 2)

    -- Draw text
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, mx + offsetX + padding, my + offsetY + padding)
  end

  return cd
end

return cursor_debug
