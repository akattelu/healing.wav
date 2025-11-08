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
  local stats = require "src.lib.stats"
  local titleScene = require "src.scene.title"
  local battleScene = require "src.scene.battle"
  local creditsScene = require "src.scene.credits"
  local waveIntroScene = require "src.scene.wave_intro"
  local rewardSelectScene = require "src.scene.reward_select"

  -- Parse settings early so sound module can access it
  S.settings = settings.parse()

  -- Set default filter mode for crisp pixel art
  love.graphics.setDefaultFilter("nearest", "nearest")

  -- Initialize wave tracking
  S.currentWave = 1

  -- Initialize global stats (persists across waves for upgrades)
  S.stats = stats.new()

  -- Initialize scene manager
  S.sceneManager = scene.new()
  S.sceneManager:register("title", titleScene)
  S.sceneManager:register("battle", battleScene)
  S.sceneManager:register("credits", creditsScene)
  S.sceneManager:register("wave_intro", waveIntroScene)
  S.sceneManager:register("reward_select", rewardSelectScene)

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
