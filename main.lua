local love = require "love"

-- Game state
local gameState = "title"  -- Can be "title", "game", "sprites", or "credits"

-- Title screen variables
local titleFont
local buttonFont
local menuItems = {"START", "SPRITES", "CREDITS"}
local menuItemHeight = 60
local menuItemWidth = 200
local menuStartY = 300
local hoveredMenuItem = nil

-- Sprite preview variables
local spriteSheets = {}
local spriteMetadata = {}
local animationTimes = {}
local spriteFont

-- Credits screen variables
local creditsText = ""
local creditsScrollY = 0
local creditsFont

function love.load()
    -- Set up fonts for pixel art style
    titleFont = love.graphics.newFont(72)  -- Large font for "HEAL"
    buttonFont = love.graphics.newFont(24)  -- Font for menu items
    spriteFont = love.graphics.newFont(14)  -- Smaller font for sprite labels
    creditsFont = love.graphics.newFont(16)  -- Font for credits text

    -- Set default filter mode for crisp pixel art
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Load sprites
    loadSprites()

    -- Load credits
    loadCredits()
end

function loadSprites()
    -- Hardcoded frame counts from metadata.json
    local frameCounts = {
        spellcast = 7,
        thrust = 8,
        walk = 9,
        slash = 6,
        shoot = 13,
        hurt = 6,
        climb = 6,
        idle = 2,
        jump = 5,
        sit = 3,
        emote = 3,
        run = 8,
        combat_idle = 2,
        backslash = 13,
        halfslash = 7
    }

    -- Load all sprite sheets from standard directory
    local animations = {"idle", "combat_idle", "walk", "run", "jump", "climb",
                       "sit", "thrust", "slash", "backslash", "halfslash",
                       "shoot", "spellcast", "hurt", "emote"}

    for _, animName in ipairs(animations) do
        local path = "lpcsprites/standard/" .. animName .. ".png"
        if love.filesystem.getInfo(path) then
            spriteSheets[animName] = {
                image = love.graphics.newImage(path),
                frameCount = frameCounts[animName] or 1,
                currentFrame = 0
            }
        end
        animationTimes[animName] = 0
    end
end

function loadCredits()
    -- Load credits text
    local creditsPath = "lpcsprites/credits/credits.txt"
    creditsText = love.filesystem.read(creditsPath) or "Credits file not found."
end

function love.update(dt)
    if gameState == "title" then
        -- Check if mouse is hovering over menu items
        local mx, my = love.mouse.getPosition()
        hoveredMenuItem = nil

        local menuX = (love.graphics.getWidth() - menuItemWidth) / 2
        for i, item in ipairs(menuItems) do
            local itemY = menuStartY + (i - 1) * menuItemHeight
            if mx >= menuX and mx <= menuX + menuItemWidth and
               my >= itemY and my <= itemY + (menuItemHeight - 10) then
                hoveredMenuItem = i
                break
            end
        end
    elseif gameState == "sprites" then
        -- Update sprite animations
        for animName, sheet in pairs(spriteSheets) do
            animationTimes[animName] = animationTimes[animName] + dt
            local frameDuration = 0.1  -- 100ms per frame
            if animationTimes[animName] >= frameDuration then
                sheet.currentFrame = (sheet.currentFrame + 1) % sheet.frameCount
                animationTimes[animName] = 0
            end
        end
    end
end

function love.draw()
    love.graphics.clear(0, 0, 0)  -- Black background

    if gameState == "title" then
        drawTitleScreen()
    elseif gameState == "game" then
        drawGameScreen()
    elseif gameState == "sprites" then
        drawSpritesScreen()
    elseif gameState == "credits" then
        drawCreditsScreen()
    end
end

function drawTitleScreen()
    -- Draw "HEAL" title
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)  -- White color
    local titleText = "HEAL"
    local titleWidth = titleFont:getWidth(titleText)
    local titleX = (love.graphics.getWidth() - titleWidth) / 2
    local titleY = 100
    love.graphics.print(titleText, titleX, titleY)

    -- Draw menu items
    love.graphics.setFont(buttonFont)
    local menuX = (love.graphics.getWidth() - menuItemWidth) / 2

    for i, item in ipairs(menuItems) do
        local itemY = menuStartY + (i - 1) * menuItemHeight
        local isHovered = (hoveredMenuItem == i)

        -- Button background
        if isHovered then
            love.graphics.setColor(1, 1, 1)  -- White when hovered
        else
            love.graphics.setColor(0.3, 0.3, 0.3)  -- Gray when not hovered
        end
        love.graphics.rectangle("fill", menuX, itemY, menuItemWidth, menuItemHeight - 10)

        -- Button border
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", menuX, itemY, menuItemWidth, menuItemHeight - 10)

        -- Button text
        if isHovered then
            love.graphics.setColor(0, 0, 0)  -- Black text when hovered
        else
            love.graphics.setColor(1, 1, 1)  -- White text when not hovered
        end
        local textWidth = buttonFont:getWidth(item)
        local textHeight = buttonFont:getHeight()
        local textX = menuX + (menuItemWidth - textWidth) / 2
        local textY = itemY + ((menuItemHeight - 10) - textHeight) / 2
        love.graphics.print(item, textX, textY)
    end
end

function drawGameScreen()
    -- Placeholder for game screen
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(buttonFont)
    love.graphics.print("Game Started! (Press ESC to return to title)", 50, 50)
end

function drawSpritesScreen()
    love.graphics.setColor(1, 1, 1)

    -- Draw title
    love.graphics.setFont(buttonFont)
    love.graphics.print("SPRITE PREVIEW", 20, 20)

    -- Draw instruction
    love.graphics.setFont(spriteFont)
    love.graphics.print("Press ESC to return to menu", 20, 50)

    -- Grid layout for animations (4 per row)
    local animOrder = {"idle", "combat_idle", "walk", "run", "jump", "climb",
                      "sit", "thrust", "slash", "backslash", "halfslash",
                      "shoot", "spellcast", "hurt", "emote"}

    local cols = 4
    local startX = 60
    local startY = 90
    local cellWidth = 280
    local cellHeight = 220

    for i, animName in ipairs(animOrder) do
        local sheet = spriteSheets[animName]
        if sheet and sheet.image then
            local col = (i - 1) % cols
            local row = math.floor((i - 1) / cols)
            local x = startX + col * cellWidth
            local y = startY + row * cellHeight

            -- Draw animation label
            love.graphics.setFont(spriteFont)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(animName, x, y)

            -- Draw current frame of animation
            local frameWidth = sheet.image:getWidth() / sheet.frameCount
            local frameHeight = 64  -- Single direction height
            local directionRow = 2  -- Show "down" direction (0=up, 1=right, 2=down, 3=left)

            -- Create quad for current frame and direction
            local quad = love.graphics.newQuad(
                sheet.currentFrame * frameWidth,
                directionRow * 64,
                frameWidth,
                frameHeight,
                sheet.image:getWidth(), sheet.image:getHeight()
            )

            -- Scale up sprites to make them more visible
            local scale = 2.5

            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(sheet.image, quad, x, y + 20, 0, scale, scale)
        end
    end
end

function drawCreditsScreen()
    love.graphics.setColor(1, 1, 1)

    -- Draw title
    love.graphics.setFont(buttonFont)
    love.graphics.print("CREDITS", 20, 20)

    -- Draw instruction
    love.graphics.setFont(spriteFont)
    love.graphics.print("Press ESC to return to menu | Arrow keys to scroll", 20, 50)

    -- Draw credits text with scrolling
    love.graphics.setFont(creditsFont)
    love.graphics.setColor(1, 1, 1)

    -- Use scissor to clip text to viewport
    local viewportY = 80
    local viewportHeight = love.graphics.getHeight() - 100
    love.graphics.setScissor(0, viewportY, love.graphics.getWidth(), viewportHeight)

    -- Wrap text and draw
    local wrappedText = {}
    local maxWidth = love.graphics.getWidth() - 40
    local _, wrappedLines = creditsFont:getWrap(creditsText, maxWidth)

    for i, line in ipairs(wrappedLines) do
        local lineY = viewportY + (i - 1) * creditsFont:getHeight() - creditsScrollY
        love.graphics.print(line, 20, lineY)
    end

    love.graphics.setScissor()
end

function love.mousepressed(x, y, button)
    if button == 1 and gameState == "title" then  -- Left mouse button
        if hoveredMenuItem then
            if hoveredMenuItem == 1 then
                gameState = "game"
            elseif hoveredMenuItem == 2 then
                gameState = "sprites"
            elseif hoveredMenuItem == 3 then
                gameState = "credits"
                creditsScrollY = 0  -- Reset scroll position
            end
        end
    end
end

function love.keypressed(key)
    -- Press ESC to return to title screen from any screen
    if key == "escape" then
        if gameState == "game" or gameState == "sprites" or gameState == "credits" then
            gameState = "title"
        end
    end

    -- Arrow keys for credits scrolling
    if gameState == "credits" then
        if key == "down" then
            creditsScrollY = creditsScrollY + 30
        elseif key == "up" then
            creditsScrollY = math.max(0, creditsScrollY - 30)
        end
    end
end
