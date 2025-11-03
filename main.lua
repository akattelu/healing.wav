--- @class love
local love = require "love"
local dbg = require "src.dbg"
local cleric = require "src.cleric"
local skeleton = require "src.skeleton"
local wave = require "src.wave"

local cl = cleric("lpc/cleric/walk.png")
local skeletons = {}
local singleWave = wave(400, 300, 50)

function love.load()
  -- Set default filter mode for crisp pixel art
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Load cleric
  cl:load()

  -- Initialize skeletons
  local screen_w, screen_h = love.window.getMode()

  for _ = 1, 100 do
    local x = love.math.random(0, screen_w)
    local y = love.math.random(0, screen_h)

    local skele = skeleton("lpc/skeleton/walk.png", screen_w / 2, screen_h / 2, x, y)
    skele:load()
    table.insert(skeletons, skele)
  end

  -- Sample wave
  singleWave:load()
end

function love.update(dt)
  cl:update(dt)
  for _, s in pairs(skeletons) do
    s:update(dt)
  end
  singleWave:update(dt)
end

function love.draw()
  love.graphics.draw(cl.sheet, cl:frame(), cl.x, cl.y)
  for _, s in pairs(skeletons) do
    love.graphics.draw(s.sheet, s:frame(), s.x, s.y)
  end
  singleWave:draw()
end
