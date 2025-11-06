local function beep(frequency, duration)
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
