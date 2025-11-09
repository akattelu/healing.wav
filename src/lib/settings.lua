--- Parse command-line arguments and return game settings
local function parseSettings()
  local settings = {
    soundEnabled = false,     -- Default: sound disabled (controlled at runtime via debug panel)
    debugPanelEnabled = false -- Default: debug panel disabled
  }

  -- Check command-line arguments
  for i = 1, #arg do
    if arg[i] == "--with-config-panel" then
      settings.debugPanelEnabled = true
    end
  end

  return settings
end

return {
  parse = parseSettings
}
