--- @class love
local love = require "love"
local lick = require "vendor.lick" -- hot reloading
local tbl = require "src.lib.table"

-- Lick config
lick.reset = true
lick.updateAllFiles = true
lick.clearPackages = true

S = {}

function love.load()
  local settings = require "src.lib.settings"
  local cleric = require "src.entity.cleric"
  local skeleton = require "src.entity.skeleton"
  local wave = require "src.entity.wave"
  local cursor_debug = require "src.entity.cursor_debug"
  local stats = require "src.lib.stats"

  -- Parse settings early so sound module can access it
  S.settings = settings.parse()

  S.cl = cleric("lpc/cleric/walk.png")
  S.skeletons = {}
  S.stats = stats.new()
  S.wave = wave.new(S.stats, S.cl)
  S.cursor_debug = cursor_debug()

  -- Set default filter mode for crisp pixel art
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Load cleric
  S.cl:load()

  -- Initialize skeletons
  local screen_w, screen_h = love.window.getMode()

  -- Define corner spawn zones (just outside screen bounds)
  local corners = {
    -- Top-left
    function()
      return love.math.random(-80, -20), love.math.random(-80, -20)
    end,
    -- Top-right
    function()
      return screen_w + love.math.random(20, 80), love.math.random(-80, -20)
    end,
    -- Bottom-left
    function()
      return love.math.random(-80, -20), screen_h + love.math.random(20, 80)
    end,
    -- Bottom-right
    function()
      return screen_w + love.math.random(20, 80), screen_h + love.math.random(20, 80)
    end
  }

  -- Spawn 5 skeletons from each corner (20 total)
  for cornerIndex = 1, 4 do
    for _ = 1, 5 do
      local x, y = corners[cornerIndex]()
      local skele = skeleton("lpc/skeleton/walk.png", S.cl, x, y)
      skele:load()
      table.insert(S.skeletons, skele)
    end
  end

  S.wave:load()
end

function love.update(dt)
  S.cl:update(dt)
  for _, s in pairs(S.skeletons) do
    s:update(dt)
  end
  S.wave:update(dt)
  local collidedSkeletons = S.wave:collisions(S.skeletons)
  for _, c in pairs(collidedSkeletons) do
    c:damage(S.stats.amplitude)
    if (c.health:isDead()) then -- remove skeleton from main map
      tbl.remove(S.skeletons, c)
    end
  end
end

function love.draw()
  love.graphics.draw(S.cl.sheet, S.cl:frame(), S.cl.x, S.cl.y)
  for _, s in pairs(S.skeletons) do
    s:draw()
  end
  S.wave:draw()
  S.cursor_debug:draw()
end
