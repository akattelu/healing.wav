--- Parse command-line arguments and return game settings
local function parseSettings()
  local settings = {
    soundEnabled = true  -- Default: sound enabled
  }

  -- Check command-line arguments for --no-sound flag
  for i = 1, #arg do
    if arg[i] == "--no-sound" or arg[i] == "--no-sfx" then
      settings.soundEnabled = false
      break
    end
  end

  return settings
end

return {
  parse = parseSettings
}
