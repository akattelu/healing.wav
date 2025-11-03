--- @class love
local love = require "love"
local dbg = require "src.dbg"
local cleric = require "src.cleric"

local cl = cleric("lpcsprites/standard/walk.png")

function love.load()
  -- Set default filter mode for crisp pixel art
  love.graphics.setDefaultFilter("nearest", "nearest")

  cl:load()
end

function love.update(dt)
  cl:update(dt)
end

function love.draw()
  love.graphics.draw(cl.sheet, cl:frame(), cl.x, cl.y)
end

function love.keypressed(key)
  
end
