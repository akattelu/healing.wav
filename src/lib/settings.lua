--- Parse command-line arguments and return game settings
local function parseSettings()
  local settings = {
    soundEnabled = true, -- Default: sound enabled
    debugPanelEnabled = false -- Default: debug panel disabled
  }

  -- Check command-line arguments
  for i = 1, #arg do
    if arg[i] == "--no-sound" or arg[i] == "--no-sfx" then
      settings.soundEnabled = false
    elseif arg[i] == "--with-config-panel" then
      settings.debugPanelEnabled = true
    end
  end

  return settings
end

return {
  parse = parseSettings
}
