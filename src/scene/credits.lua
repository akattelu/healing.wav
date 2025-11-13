local credits = {}
local button = require "src.ui.button"

function credits:load()
  self.scrollOffset = 0
  self.scrollSpeed = 50 -- pixels per second
  self.maxScroll = 2000 -- will adjust based on content

  -- Back button
  self.backButton = button.new({
    text = "< Back",
    x = 40,
    y = 40,
    width = 120,
    height = 50,
    bgColor = {0.3, 0.3, 0.4},
    bgColorHover = {0.4, 0.4, 0.5},
    borderColor = {1, 1, 1},
    action = function()
      S.sceneManager:switch("title")
    end
  })
end

function credits:update(dt)
  -- Update button
  self.backButton:update(dt)

  -- Auto-scroll credits
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    self.scrollOffset = math.min(self.scrollOffset + self.scrollSpeed * dt, self.maxScroll)
  end

  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    self.scrollOffset = math.max(self.scrollOffset - self.scrollSpeed * dt, 0)
  end
end

function credits:draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  -- Background
  love.graphics.setColor(0.1, 0.1, 0.15, 1)
  love.graphics.rectangle("fill", 0, 0, width, height)

  -- Draw back button
  self.backButton:draw()

  -- Title
  love.graphics.setColor(1, 1, 1, 1)
  local title = "CREDITS"
  local titleWidth = love.graphics.getFont():getWidth(title)
  love.graphics.print(title, (width - titleWidth) / 2, 40)

  -- Credits content
  local y = 120 - self.scrollOffset
  local x = 60
  local lineHeight = 25

  -- Game credits
  love.graphics.setColor(0.8, 0.9, 1, 1)
  y = self:drawText("GAME DEVELOPMENT", x, y, lineHeight)
  love.graphics.setColor(1, 1, 1, 1)
  y = self:drawText("Hot Reloading: lick by usysrc", x + 20, y, lineHeight)
  y = self:drawText("  https://codeberg.org/usysrc/lick", x + 20, y, lineHeight)
  y = y + lineHeight

  -- Skeleton sprites
  love.graphics.setColor(0.8, 0.9, 1, 1)
  y = self:drawText("SKELETON SPRITES", x, y, lineHeight)
  love.graphics.setColor(1, 1, 1, 1)
  y = self:drawText("Licenses: OGA-BY 3.0, CC-BY-SA 3.0, GPL 3.0", x + 20, y, lineHeight)
  y = self:drawText("Authors:", x + 20, y, lineHeight)
  y = self:drawText("  bluecarrot16", x + 40, y, lineHeight)
  y = self:drawText("  Johannes Sjolund (wulax)", x + 40, y, lineHeight)
  y = self:drawText("  Stephen Challener (Redshrike)", x + 40, y, lineHeight)
  y = self:drawText("Links:", x + 20, y, lineHeight)
  y = self:drawText("  opengameart.org/content/lpc-skeleton", x + 40, y, lineHeight)
  y = self:drawText("  opengameart.org/content/lpc-character-bases", x + 40, y, lineHeight)
  y = y + lineHeight

  -- Cleric sprites
  love.graphics.setColor(0.8, 0.9, 1, 1)
  y = self:drawText("CLERIC SPRITES", x, y, lineHeight)
  love.graphics.setColor(1, 1, 1, 1)

  y = self:drawText("Shadow:", x + 20, y, lineHeight)
  y = self:drawText("  License: CC0", x + 40, y, lineHeight)
  y = self:drawText("  Author: drjamgo@hotmail.com", x + 40, y, lineHeight)
  y = self:drawText("  opengameart.org/content/shadow-for-lpc-sprite", x + 40, y, lineHeight)
  y = y + lineHeight / 2

  y = self:drawText("Body, Head, Hat, Clothing:", x + 20, y, lineHeight)
  y = self:drawText("  Licenses: OGA-BY 3.0, CC-BY-SA 3.0, GPL 3.0", x + 40, y, lineHeight)
  y = self:drawText("  Authors:", x + 40, y, lineHeight)
  y = self:drawText("    bluecarrot16, JaidynReiman", x + 60, y, lineHeight)
  y = self:drawText("    Benjamin K. Smith (BenCreating)", x + 60, y, lineHeight)
  y = self:drawText("    Evert, Eliza Wyatt (ElizaWy)", x + 60, y, lineHeight)
  y = self:drawText("    TheraHedwig, MuffinElZangano, Durrani", x + 60, y, lineHeight)
  y = self:drawText("    Johannes Sjolund (wulax)", x + 60, y, lineHeight)
  y = self:drawText("    Stephen Challener (Redshrike)", x + 60, y, lineHeight)
  y = self:drawText("    Pierre Vigier (pvigier)", x + 60, y, lineHeight)
  y = self:drawText("    Napsio, Michael Whitlock (bigbeargames), Tracy", x + 60, y, lineHeight)
  y = self:drawText("  opengameart.org/content/lpc-character-bases", x + 40, y, lineHeight)
  y = self:drawText("  opengameart.org/content/lpc-medieval-fantasy-character-sprites", x + 40, y, lineHeight)
  y = y + lineHeight / 2

  y = self:drawText("Magic Weapons:", x + 20, y, lineHeight)
  y = self:drawText("  Licenses: OGA-BY 3.0+, GPL 3.0, CC-BY 4.0", x + 40, y, lineHeight)
  y = self:drawText("  Author: bluecarrot16", x + 40, y, lineHeight)
  y = self:drawText("  opengameart.org/content/lpc-more-weapons", x + 40, y, lineHeight)
  y = y + lineHeight

  -- Footer
  love.graphics.setColor(0.6, 0.6, 0.7, 1)
  y = y + lineHeight
  y = self:drawText("Use UP/DOWN or W/S to scroll", x, y, lineHeight)

  -- Update max scroll based on content length
  self.maxScroll = math.max(0, y - height + 100)
end

function credits:drawText(text, x, y, lineHeight)
  love.graphics.print(text, x, y)
  return y + lineHeight
end

function credits:mousepressed(x, y, button)
  self.backButton:mousepressed(x, y, button)
end

function credits:mousereleased(x, y, button)
  self.backButton:mousereleased(x, y, button)
end

function credits:keypressed(key)
  if key == "escape" then
    S.sceneManager:switch("title")
  end
end

return credits
