--- Tab container component with multiple tabs
local tab = {}

function tab.new(args)
  local tc = {
    -- Required properties
    tabs = args.tabs or {}, -- Array of {name = "Tab Name", key = value}
    x = args.x or 0,
    y = args.y or 0,
    width = args.width or 300,

    -- Optional properties
    height = args.height or 28,
    activeTab = args.activeTab or 1, -- Index of active tab
    onTabChange = args.onTabChange, -- function(tabIndex, tab) called when tab changes

    -- Styling (with defaults)
    bgColorActive = args.bgColorActive or {0.4, 0.6, 0.8},
    bgColorInactive = args.bgColorInactive or {0.25, 0.35, 0.45},
    borderColor = args.borderColor or {0.5, 0.7, 0.9},
    textColor = args.textColor or {1, 1, 1},

    cornerRadius = args.cornerRadius or 4,
    borderWidth = args.borderWidth or 1,

    -- Font
    font = args.font or love.graphics.newFont(12),
  }

  function tc:update(dt)
    -- Tabs don't need hover state tracking for this implementation
  end

  function tc:draw()
    love.graphics.push("all")

    local tabCount = #self.tabs
    if tabCount == 0 then
      love.graphics.pop()
      return
    end

    local tabWidth = self.width / tabCount

    for i, tab in ipairs(self.tabs) do
      local tabX = self.x + ((i - 1) * tabWidth)

      -- Tab background
      if self.activeTab == i then
        love.graphics.setColor(self.bgColorActive[1], self.bgColorActive[2], self.bgColorActive[3], self.bgColorActive[4] or 1)
      else
        love.graphics.setColor(self.bgColorInactive[1], self.bgColorInactive[2], self.bgColorInactive[3], self.bgColorInactive[4] or 1)
      end
      love.graphics.rectangle("fill", tabX, self.y, tabWidth, self.height, self.cornerRadius, self.cornerRadius)

      -- Tab border
      love.graphics.setColor(self.borderColor[1], self.borderColor[2], self.borderColor[3], self.borderColor[4] or 1)
      love.graphics.setLineWidth(self.borderWidth)
      love.graphics.rectangle("line", tabX, self.y, tabWidth, self.height, self.cornerRadius, self.cornerRadius)

      -- Tab label (centered)
      love.graphics.setFont(self.font)
      love.graphics.setColor(self.textColor[1], self.textColor[2], self.textColor[3], self.textColor[4] or 1)
      local textWidth = self.font:getWidth(tab.name)
      love.graphics.print(tab.name, tabX + (tabWidth - textWidth) / 2, self.y + 7)
    end

    love.graphics.pop()
  end

  function tc:mousepressed(x, y, button)
    if button ~= 1 then return false end

    local tabCount = #self.tabs
    if tabCount == 0 then return false end

    local tabWidth = self.width / tabCount

    for i, tab in ipairs(self.tabs) do
      local tabX = self.x + ((i - 1) * tabWidth)
      if x >= tabX and x <= tabX + tabWidth and y >= self.y and y <= self.y + self.height then
        self:switchTab(i)
        return true
      end
    end

    return false
  end

  function tc:switchTab(tabIndex)
    if tabIndex >= 1 and tabIndex <= #self.tabs then
      local oldTab = self.activeTab
      self.activeTab = tabIndex
      if self.onTabChange and oldTab ~= tabIndex then
        self.onTabChange(tabIndex, self.tabs[tabIndex])
      end
    end
  end

  function tc:getActiveTab()
    return self.activeTab
  end

  function tc:getActiveTabData()
    return self.tabs[self.activeTab]
  end

  function tc:setPosition(x, y)
    self.x = x
    self.y = y
  end

  return tc
end

return tab
