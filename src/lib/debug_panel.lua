--- Debug panel for adjusting game stats in real-time (Tabbed UI)
local numberControl = require "src.ui.number_control"

local debugPanel = {}

function debugPanel.new(stats)
  local panel = {
    visible = false,
    stats = stats,
    controls = {},
    soundCheckbox = {
      x = 0, y = 0,
      width = 20, height = 20,
      hovered = false
    },

    -- Current active tab (1=Base, 2=Multipliers, 3=Overview)
    activeTab = 1,

    -- Panel layout
    x = 20,
    y = 20,
    width = 380,
    height = 320,
    padding = 10,
    controlSpacing = 30,

    -- Fonts
    titleFont = love.graphics.newFont(14),
    tabFont = love.graphics.newFont(12),
    labelFont = love.graphics.newFont(12),
    smallFont = love.graphics.newFont(10),

    -- Stat configurations
    statConfigs = {
      { name = "amplitude", label = "Damage", min = 0, max = 20, default = 1, step = 0.1 },
      { name = "wavelength", label = "Arc Length", min = 0, max = math.pi * 2, default = math.pi / 2, step = 0.1 },
      { name = "frequency", label = "Speed", min = 50, max = 500, default = 200, step = 10 },
      { name = "period", label = "Cooldown", min = 0.01, max = 2, default = 0.1, step = 0.01 },
      { name = "range", label = "Duration", min = 0.1, max = 5, default = 1, step = 0.1 },
      { name = "movementSpeed", label = "Move Speed", min = 50, max = 500, default = 200, step = 10 },
      { name = "knockback", label = "Knockback", min = 0, max = 500, default = 150, step = 10 },
    },

    -- Tab definitions
    tabs = {
      { name = "Base Values", key = 1 },
      { name = "Multipliers", key = 2 },
      { name = "Overview", key = 3 },
    }
  }

  -- Create controls for base values and multipliers
  function panel:createControls()
    local currentY = self.y + 70
    local controlWidth = self.width - (self.padding * 2)
    local controlX = self.x + self.padding

    for _, config in ipairs(self.statConfigs) do
      local statName = config.name

      -- Base value control
      local baseControl = numberControl.new(
        config.label,
        controlX,
        currentY,
        controlWidth,
        config.min,
        config.max,
        self.stats:getBaseValue(statName),
        config.step,
        function(value)
          self.stats:setBaseValue(statName, value)
        end
      )

      -- Multiplier control
      local multControl = numberControl.new(
        config.label,
        controlX,
        currentY,
        controlWidth,
        0.1,
        5.0,
        self.stats:getMultiplier(statName),
        0.1,
        function(value)
          self.stats:setMultiplier(statName, value)
        end
      )

      table.insert(self.controls, {
        stat = statName,
        label = config.label,
        base = baseControl,
        mult = multControl,
        config = config,
      })

      currentY = currentY + self.controlSpacing
    end
  end

  function panel:load()
    self:createControls()

    -- Position sound checkbox in header area
    self.soundCheckbox.x = self.x + self.width - 80
    self.soundCheckbox.y = self.y + self.padding + 2
  end

  function panel:update(dt)
    if not self.visible then return end

    -- Update checkbox hover state
    local mx, my = love.mouse.getPosition()
    self.soundCheckbox.hovered =
      mx >= self.soundCheckbox.x and
      mx <= self.soundCheckbox.x + self.soundCheckbox.width and
      my >= self.soundCheckbox.y and
      my <= self.soundCheckbox.y + self.soundCheckbox.height

    -- Update controls for active tab
    if self.activeTab == 1 then -- Base values
      for _, ctrl in ipairs(self.controls) do
        ctrl.base:update(dt)
      end
    elseif self.activeTab == 2 then -- Multipliers
      for _, ctrl in ipairs(self.controls) do
        ctrl.mult:update(dt)
      end
    end
    -- Overview tab has no interactive controls
  end

  function panel:drawTabs()
    local tabWidth = self.width / 3
    local tabHeight = 28
    local tabY = self.y + 30

    for i, tab in ipairs(self.tabs) do
      local tabX = self.x + ((i - 1) * tabWidth)

      -- Tab background
      if self.activeTab == i then
        love.graphics.setColor(0.4, 0.6, 0.8) -- Active tab
      else
        love.graphics.setColor(0.25, 0.35, 0.45) -- Inactive tab
      end
      love.graphics.rectangle("fill", tabX, tabY, tabWidth, tabHeight, 4, 4)

      -- Tab border
      love.graphics.setColor(0.5, 0.7, 0.9)
      love.graphics.setLineWidth(1)
      love.graphics.rectangle("line", tabX, tabY, tabWidth, tabHeight, 4, 4)

      -- Tab label
      love.graphics.setFont(self.tabFont)
      love.graphics.setColor(1, 1, 1)
      local textWidth = self.tabFont:getWidth(tab.name)
      love.graphics.print(
        tab.name,
        tabX + (tabWidth - textWidth) / 2,
        tabY + 7
      )
    end
  end

  function panel:drawBaseValues()
    local startY = self.y + 70

    for i, ctrl in ipairs(self.controls) do
      ctrl.base:draw()

      -- Draw range hint
      love.graphics.setFont(self.smallFont)
      love.graphics.setColor(0.6, 0.6, 0.6)
      local rangeText = string.format("(%.1f - %.1f)", ctrl.config.min, ctrl.config.max)
      love.graphics.print(rangeText, ctrl.base.x + 130, ctrl.base.y + 7)
    end
  end

  function panel:drawMultipliers()
    for i, ctrl in ipairs(self.controls) do
      ctrl.mult:draw()

      -- Draw range hint
      love.graphics.setFont(self.smallFont)
      love.graphics.setColor(0.6, 0.6, 0.6)
      love.graphics.print("(0.1 - 5.0)", ctrl.mult.x + 130, ctrl.mult.y + 7)
    end
  end

  function panel:drawOverview()
    local startY = self.y + 70
    local currentY = startY

    love.graphics.setFont(self.labelFont)

    for _, ctrl in ipairs(self.controls) do
      -- Label
      love.graphics.setColor(0.9, 0.9, 0.9)
      love.graphics.print(ctrl.label .. ":", self.x + self.padding, currentY + 3)

      -- Base value
      love.graphics.setColor(0.7, 0.9, 1)
      local baseText = string.format("%.2f", self.stats:getBaseValue(ctrl.stat))
      love.graphics.print(baseText, self.x + 120, currentY + 3)

      -- Multiplier
      love.graphics.setColor(0.9, 0.8, 1)
      local multText = string.format("× %.2f", self.stats:getMultiplier(ctrl.stat))
      love.graphics.print(multText, self.x + 180, currentY + 3)

      -- Final value
      love.graphics.setColor(1, 1, 0.5)
      local finalText = string.format("= %.2f", self.stats:getValue(ctrl.stat))
      love.graphics.print(finalText, self.x + 245, currentY + 3)

      currentY = currentY + self.controlSpacing
    end
  end

  function panel:draw()
    if not self.visible then return end

    love.graphics.push("all")

    -- Draw semi-transparent background
    love.graphics.setColor(0, 0, 0, 0.88)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 8, 8)

    -- Draw border
    love.graphics.setColor(0.4, 0.6, 0.8)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 8, 8)

    -- Draw title
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(0.9, 0.9, 1)
    love.graphics.print("Debug Panel", self.x + self.padding, self.y + self.padding)

    -- Draw sound toggle checkbox
    local cb = self.soundCheckbox
    -- Checkbox background
    if cb.hovered then
      love.graphics.setColor(0.3, 0.4, 0.5)
    else
      love.graphics.setColor(0.2, 0.3, 0.4)
    end
    love.graphics.rectangle("fill", cb.x, cb.y, cb.width, cb.height, 2, 2)

    -- Checkbox border
    love.graphics.setColor(0.5, 0.7, 0.9)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", cb.x, cb.y, cb.width, cb.height, 2, 2)

    -- Checkmark if sound is enabled
    if S.settings.soundEnabled then
      love.graphics.setColor(0.3, 1, 0.3)
      love.graphics.setLineWidth(2)
      love.graphics.line(cb.x + 4, cb.y + 10, cb.x + 8, cb.y + 14)
      love.graphics.line(cb.x + 8, cb.y + 14, cb.x + 16, cb.y + 6)
    end

    -- Checkbox label
    love.graphics.setFont(self.smallFont)
    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.print("Sound", cb.x + cb.width + 5, cb.y + 5)

    -- Draw tabs
    self:drawTabs()

    -- Draw content based on active tab
    if self.activeTab == 1 then
      self:drawBaseValues()
    elseif self.activeTab == 2 then
      self:drawMultipliers()
    elseif self.activeTab == 3 then
      self:drawOverview()
    end

    -- Draw footer
    love.graphics.setFont(self.smallFont)
    love.graphics.setColor(0.7, 0.7, 0.7)
    local footerY = self.y + self.height - 20
    love.graphics.print("Toggle via Pause Menu (ESC) • Click tabs to switch", self.x + self.padding, footerY)

    love.graphics.pop()
  end

  function panel:toggle()
    self.visible = not self.visible
  end

  function panel:switchTab(tabIndex)
    if tabIndex >= 1 and tabIndex <= #self.tabs then
      self.activeTab = tabIndex
    end
  end

  function panel:resetToDefaults()
    for _, config in ipairs(self.statConfigs) do
      self.stats:setBaseValue(config.name, config.default)
      self.stats:setMultiplier(config.name, 1.0)
    end

    -- Update control values
    for _, ctrl in ipairs(self.controls) do
      ctrl.base:setValue(self.stats:getBaseValue(ctrl.stat))
      ctrl.mult:setValue(self.stats:getMultiplier(ctrl.stat))
    end
  end

  function panel:keypressed(key)
    -- No keyboard shortcuts for debug panel
    return false
  end

  function panel:mousepressed(x, y, button)
    if not self.visible then return false end

    -- Check sound checkbox click
    local cb = self.soundCheckbox
    if x >= cb.x and x <= cb.x + cb.width and
       y >= cb.y and y <= cb.y + cb.height then
      S.settings.soundEnabled = not S.settings.soundEnabled
      return true
    end

    -- Check tab clicks
    local tabWidth = self.width / 3
    local tabHeight = 28
    local tabY = self.y + 30

    for i, tab in ipairs(self.tabs) do
      local tabX = self.x + ((i - 1) * tabWidth)
      if x >= tabX and x <= tabX + tabWidth and y >= tabY and y <= tabY + tabHeight then
        self:switchTab(i)
        return true
      end
    end

    -- Check control clicks based on active tab
    if self.activeTab == 1 then -- Base values
      for _, ctrl in ipairs(self.controls) do
        if ctrl.base:mousepressed(x, y, button) then
          return true
        end
      end
    elseif self.activeTab == 2 then -- Multipliers
      for _, ctrl in ipairs(self.controls) do
        if ctrl.mult:mousepressed(x, y, button) then
          return true
        end
      end
    end

    return false
  end

  function panel:mousereleased(x, y, button)
    if not self.visible then return end

    -- Release all controls
    for _, ctrl in ipairs(self.controls) do
      ctrl.base:mousereleased(x, y, button)
      ctrl.mult:mousereleased(x, y, button)
    end
  end

  return panel
end

return debugPanel
