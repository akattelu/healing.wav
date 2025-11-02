local love = require "love"

-- Game state
local gameState = "title"  -- Can be "title" or "game"

-- Title screen variables
local titleFont
local buttonFont
local buttonX, buttonY, buttonWidth, buttonHeight
local isButtonHovered = false

function love.load()
    -- Set up fonts for pixel art style
    titleFont = love.graphics.newFont(72)  -- Large font for "HEAL"
    buttonFont = love.graphics.newFont(24)  -- Smaller font for button

    -- Set up button dimensions
    buttonWidth = 150
    buttonHeight = 50
    buttonX = (love.graphics.getWidth() - buttonWidth) / 2
    buttonY = love.graphics.getHeight() / 2 + 100

    -- Set default filter mode for crisp pixel art
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.update(dt)
    if gameState == "title" then
        -- Check if mouse is hovering over the button
        local mx, my = love.mouse.getPosition()
        isButtonHovered = mx >= buttonX and mx <= buttonX + buttonWidth and
                          my >= buttonY and my <= buttonY + buttonHeight
    end
end

function love.draw()
    love.graphics.clear(0, 0, 0)  -- Black background

    if gameState == "title" then
        drawTitleScreen()
    elseif gameState == "game" then
        drawGameScreen()
    end
end

function drawTitleScreen()
    -- Draw "HEAL" title
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)  -- White color
    local titleText = "HEAL"
    local titleWidth = titleFont:getWidth(titleText)
    local titleX = (love.graphics.getWidth() - titleWidth) / 2
    local titleY = love.graphics.getHeight() / 2 - 100
    love.graphics.print(titleText, titleX, titleY)

    -- Draw START button
    love.graphics.setFont(buttonFont)

    -- Button background
    if isButtonHovered then
        love.graphics.setColor(1, 1, 1)  -- White when hovered
    else
        love.graphics.setColor(0.3, 0.3, 0.3)  -- Gray when not hovered
    end
    love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)

    -- Button border
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)

    -- Button text
    if isButtonHovered then
        love.graphics.setColor(0, 0, 0)  -- Black text when hovered
    else
        love.graphics.setColor(1, 1, 1)  -- White text when not hovered
    end
    local buttonText = "START"
    local textWidth = buttonFont:getWidth(buttonText)
    local textHeight = buttonFont:getHeight()
    local textX = buttonX + (buttonWidth - textWidth) / 2
    local textY = buttonY + (buttonHeight - textHeight) / 2
    love.graphics.print(buttonText, textX, textY)
end

function drawGameScreen()
    -- Placeholder for game screen
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(buttonFont)
    love.graphics.print("Game Started! (Press ESC to return to title)", 50, 50)
end

function love.mousepressed(x, y, button)
    if button == 1 and gameState == "title" then  -- Left mouse button
        if isButtonHovered then
            gameState = "game"
        end
    end
end

function love.keypressed(key)
    -- Press ESC to return to title screen
    if key == "escape" and gameState == "game" then
        gameState = "title"
    end
end
