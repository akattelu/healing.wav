--- Parse command-line arguments and return game settings
local function parseSettings()
  local settings = {
    soundEnabled = false     -- Default: sound disabled (controlled at runtime via debug panel)
  }

  return settings
end

return {
  parse = parseSettings
}
