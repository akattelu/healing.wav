-- Battle scene - main gameplay
local tbl = require "src.lib.table"

local battle = {}

function battle:spawnSkeletons()
  local skeleton = require "src.entity.skeleton"
  local screen_w, screen_h = love.window.getMode()

  -- Clear existing skeletons
  self.skeletons = {}

  -- Define side spawn zones (just outside screen bounds)
  local sides = {
    -- Top side
    function()
      return love.math.random(0, screen_w), love.math.random(-80, -20)
    end,
    -- Bottom side
    function()
      return love.math.random(0, screen_w), screen_h + love.math.random(20, 80)
    end,
    -- Left side
    function()
      return love.math.random(-80, -20), love.math.random(0, screen_h)
    end,
    -- Right side
    function()
      return screen_w + love.math.random(20, 80), love.math.random(0, screen_h)
    end
  }

  -- Spawn 5 skeletons from each side (20 total)
  for sideIndex = 1, 4 do
    for _ = 1, 5 do
      local x, y = sides[sideIndex]()
      local skele = skeleton("lpc/skeleton/walk.png", self.cl, x, y)
      skele:load()
      table.insert(self.skeletons, skele)
    end
  end
end

function battle:load()
  local settings = require "src.lib.settings"
  local cleric = require "src.entity.cleric"
  local wave = require "src.entity.wave"
  local cursor_debug = require "src.entity.cursor_debug"

  -- Parse settings early so sound module can access it
  if not S.settings then
    S.settings = settings.parse()
  end

  -- Initialize battle state
  self.cl = cleric("lpc/cleric/walk.png")
  self.skeletons = {}
  -- Use global stats that persist across waves (for upgrades)
  self.stats = S.stats
  self.wave = wave.new(self.stats, self.cl)
  self.cursor_debug = cursor_debug()

  -- Load debug panel if enabled
  if S.settings.debugPanelEnabled then
    local debugPanel = require "src.lib.debug_panel"
    self.debugPanel = debugPanel.new(self.stats)
    self.debugPanel:load()
  end

  -- Load cleric
  self.cl:load()

  -- Spawn skeletons for this wave
  self:spawnSkeletons()

  self.wave:load()
end

function battle:update(dt)
  self.cl:update(dt)
  for _, s in pairs(self.skeletons) do
    s:update(dt)
  end
  self.wave:update(dt)
  local collidedSkeletons = self.wave:collisions(self.skeletons)
  for _, c in pairs(collidedSkeletons) do
    c:damage(self.stats:getValue("amplitude"))
    if (c.health:isDead()) then -- remove skeleton from main map
      tbl.remove(self.skeletons, c)
    end
  end

  -- Update debug panel if enabled
  if self.debugPanel then
    self.debugPanel:update(dt)
  end

  -- Check for wave completion (all skeletons defeated)
  if #self.skeletons == 0 then
    if S.currentWave < 10 then
      -- Progress to reward selection screen
      S.sceneManager:switch("reward_select")
    else
      -- Player has completed all 10 waves - go to credits
      S.sceneManager:switch("credits")
    end
  end
end

function battle:draw()
  love.graphics.draw(self.cl.sheet, self.cl:frame(), self.cl.x, self.cl.y)
  for _, s in pairs(self.skeletons) do
    s:draw()
  end
  self.wave:draw()
  self.cursor_debug:draw()

  -- Draw debug panel on top of everything
  if self.debugPanel then
    self.debugPanel:draw()
  end
end

function battle:keypressed(key)
  -- Handle debug panel input
  if self.debugPanel then
    if self.debugPanel:keypressed(key) then
      return
    end
  end
end

function battle:mousepressed(x, y, button)
  -- Handle debug panel input
  if self.debugPanel then
    if self.debugPanel:mousepressed(x, y, button) then
      return
    end
  end
end

function battle:mousereleased(x, y, button)
  -- Handle debug panel input
  if self.debugPanel then
    self.debugPanel:mousereleased(x, y, button)
  end
end

return battle
