--- @class love
local love = require "love"
local lick = require "vendor.lick" -- hot reloading
local scene = require "src.lib.scene"

-- Lick config
lick.reset = true
lick.updateAllFiles = true
lick.clearPackages = true

S = {}

function love.load()
  local settings = require "src.lib.settings"
  local titleScene = require "src.scene.title"
  local battleScene = require "src.scene.battle"

  -- Parse settings early so sound module can access it
  S.settings = settings.parse()

  -- Set default filter mode for crisp pixel art
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Initialize scene manager
  S.sceneManager = scene.new()
  S.sceneManager:register("title", titleScene)
  S.sceneManager:register("battle", battleScene)

  -- Start with title screen
  S.sceneManager:switch("title")
end

function love.update(dt)
  S.sceneManager:update(dt)
end

function love.draw()
  S.sceneManager:draw()
end

function love.mousepressed(x, y, button)
  S.sceneManager:mousepressed(x, y, button)
end

function love.keypressed(key)
  S.sceneManager:keypressed(key)
end
