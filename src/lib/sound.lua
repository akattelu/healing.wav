-- Create a silent dummy source that can be safely called
local function createDummySource()
  local dummySource = {
    play = function() end,
    stop = function() end,
    pause = function() end,
    setVolume = function() end,
    getVolume = function() return 0 end,
    isPlaying = function() return false end
  }
  return dummySource
end

local function beep(frequency, duration)
  -- Check if sound is disabled globally
  if S and S.settings and not S.settings.soundEnabled then
    return createDummySource()
  end

  local rate = 44100
  local samples = duration * rate
  local soundData = love.sound.newSoundData(samples, rate, 16, 1)
  for i = 0, samples - 1 do
    local t = i / rate
    -- Simple sine wave at desired frequency
    local v = math.sin(2 * math.pi * frequency * t)
    soundData:setSample(i, v)
  end
  return love.audio.newSource(soundData)
end


return {
  beep = beep
}
