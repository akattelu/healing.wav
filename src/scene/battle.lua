-- Battle scene - main gameplay
local tbl = require "src.lib.table"

local battle = {}

function battle:spawnSkeletons()
  local skeleton = require "src.entity.skeleton"
  local screen_w, screen_h = love.window.getMode()

  -- Clear existing skeletons
  self.skeletons = {}

  -- Calculate wave-based difficulty
  local baseCount = 20
  local baseHealth = 3
  local baseSpeed = 20

  -- Exponential skeleton count: 20 * 1.7^wave (S.currentWave is 0-indexed)
  local totalSkeletons = math.floor(baseCount * math.pow(1.7, S.currentWave))

  -- Aggressive health scaling: base + 2.5 per wave (S.currentWave is 0-indexed)
  local skeletonHealth = math.floor(baseHealth + S.currentWave * 2.5)

  -- Linear movement speed scaling: base + 3 per wave (S.currentWave is 0-indexed)
  local skeletonSpeed = baseSpeed + S.currentWave * 3

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

  -- Randomly distribute skeletons across all 4 sides
  for _ = 1, totalSkeletons do
    local randomSide = love.math.random(1, 4)
    local x, y = sides[randomSide]()
    local skele = skeleton("lpc/skeleton/walk.png", self.cl, x, y, skeletonHealth, skeletonSpeed)
    skele:load()
    table.insert(self.skeletons, skele)
  end
end

function battle:load()
  local settings = require "src.lib.settings"
  local cleric = require "src.entity.cleric"
  local wave = require "src.entity.wave"
  local cursor_debug = require "src.entity.cursor_debug"
  local pauseScene = require "src.scene.pause"

  -- Parse settings early so sound module can access it
  if not S.settings then
    S.settings = settings.parse()
  end

  -- Initialize battle state
  -- Use global stats that persist across waves (for upgrades)
  self.stats = S.stats
  self.cl = cleric("lpc/cleric/walk.png", self.stats, 10) -- 10 starting health
  self.skeletons = {}
  self.wave = wave.new(self.stats, self.cl)
  self.cursor_debug = cursor_debug()

  -- Collision tracking for skeleton-player damage (to prevent multiple hits per frame)
  self.skeletonCollisionCooldowns = {} -- Maps skeleton -> cooldown timer

  -- Load debug panel (always available, hidden by default)
  local debugPanel = require "src.lib.debug_panel"
  self.debugPanel = debugPanel.new(self.stats)
  self.debugPanel:load()

  -- Initialize pause state and scene
  self.paused = false
  self.pauseScene = pauseScene
  self.pauseScene:load(
    function() -- Resume callback
      self.paused = false
    end,
    function() -- Restart wave callback
      self:load()
    end,
    function() -- Return to title callback
      S.sceneManager:switch("title")
    end,
    function() -- Toggle debug panel callback
      self.debugPanel:toggle()
    end
  )

  -- Load cleric
  self.cl:load()

  -- Center cleric on stage
  local screen_w, screen_h = love.window.getMode()
  self.cl.x = (screen_w - self.cl.frameWidth) / 2
  self.cl.y = (screen_h - self.cl.frameHeight) / 2

  -- Spawn skeletons for this wave
  self:spawnSkeletons()

  self.wave:load()
end

function battle:update(dt)
  -- Only update game logic when not paused
  if not self.paused then
    self.cl:update(dt)
    for _, s in pairs(self.skeletons) do
      s:update(dt)
    end
    self.wave:update(dt)
    local collidedSkeletons = self.wave:collisions(self.skeletons)
    for _, c in pairs(collidedSkeletons) do
      c:damage(self.stats:getValue("amplitude"))

      -- Apply knockback impulse
      local waveCenterX = self.wave.cx
      local waveCenterY = self.wave.cy
      local skeletonCenterX = c.x + c.frameWidth / 2
      local skeletonCenterY = c.y + c.frameHeight / 2

      -- Calculate direction vector (skeleton relative to wave center)
      local dx = skeletonCenterX - waveCenterX
      local dy = skeletonCenterY - waveCenterY

      -- Normalize and apply knockback
      local distance = math.sqrt(dx * dx + dy * dy)
      if distance > 0 then
        dx = dx / distance
        dy = dy / distance
        local knockbackForce = self.stats:getValue("knockback")
        c.velocityX = c.velocityX + dx * knockbackForce
        c.velocityY = c.velocityY + dy * knockbackForce
      end

      if (c.health:isDead()) then -- remove skeleton from main map
        tbl.remove(self.skeletons, c)
      end
    end

    -- Check for skeleton-player collisions
    local SKELETON_DAMAGE = 1
    local COLLISION_COOLDOWN = 1.0 -- 1 second cooldown between hits from same skeleton
    local px, py, pw, ph = self.cl:getPosition()

    for _, s in pairs(self.skeletons) do
      local sx, sy, sw, sh = s:getPosition()

      -- Simple AABB collision detection
      if px < sx + sw and px + pw > sx and py < sy + sh and py + ph > sy then
        -- Check cooldown before applying damage
        local cooldown = self.skeletonCollisionCooldowns[s] or 0
        if cooldown <= 0 then
          self.cl:damage(SKELETON_DAMAGE)
          self.skeletonCollisionCooldowns[s] = COLLISION_COOLDOWN
        end
      end
    end

    -- Update cooldowns
    for skeleton, cooldown in pairs(self.skeletonCollisionCooldowns) do
      self.skeletonCollisionCooldowns[skeleton] = cooldown - dt
    end

    -- Check for player death
    if self.cl.health:isDead() then
      -- Switch to game over screen
      S.sceneManager:switch("game_over")
      return
    end

    -- Check for wave completion (all skeletons defeated)
    if #self.skeletons == 0 then
      -- Increment wave counter (tracks number of waves completed)
      S.currentWave = S.currentWave + 1

      if S.currentWave < 10 then
        -- Progress to reward selection screen
        S.sceneManager:switch("reward_select")
      else
        -- Player has completed all 10 waves - go to credits
        S.sceneManager:switch("credits")
      end
    end
  end

  -- Update debug panel even when paused (if enabled)
  if self.debugPanel then
    self.debugPanel:update(dt)
  end

  -- Update pause scene if paused
  if self.paused then
    self.pauseScene:update(dt)
  end
end

function battle:draw()
  self.cl:draw()
  for _, s in pairs(self.skeletons) do
    s:draw()
  end
  self.wave:draw()
  self.cursor_debug:draw()

  -- Draw pause scene overlay if paused
  if self.paused then
    self.pauseScene:draw()
  end

  -- Draw debug panel on top of everything
  if self.debugPanel then
    self.debugPanel:draw()
  end
end

function battle:keypressed(key)
  -- Handle pause scene input if paused
  if self.paused then
    if self.pauseScene:keypressed(key) then
      return
    end
  end

  -- Toggle pause with ESC key
  if key == "escape" then
    self.paused = not self.paused
    return
  end
end

function battle:mousepressed(x, y, button)
  -- Handle pause scene input if paused
  if self.paused then
    if self.pauseScene:mousepressed(x, y, button) then
      return
    end
  end

  -- Handle debug panel input (only when not paused)
  if not self.paused and self.debugPanel then
    if self.debugPanel:mousepressed(x, y, button) then
      return
    end
  end
end

function battle:mousereleased(x, y, button)
  -- Handle debug panel input (only when not paused)
  if not self.paused and self.debugPanel then
    self.debugPanel:mousereleased(x, y, button)
  end
end

return battle
