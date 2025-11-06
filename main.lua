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
  local cleric = require "src.entity.cleric"
  local skeleton = require "src.entity.skeleton"
  local wave = require "src.entity.wave"
  local cursor_debug = require "src.entity.cursor_debug"
  local stats = require "src.lib.stats"

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

  for _ = 1, 20 do
    local x = love.math.random(0, screen_w)
    local y = love.math.random(0, screen_h)

    local skele = skeleton("lpc/skeleton/walk.png", screen_w / 2, screen_h / 2, x, y)
    skele:load()
    table.insert(S.skeletons, skele)
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
