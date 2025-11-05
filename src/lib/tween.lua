local BASE_BIAS = 64 -- Starting arc radius is 64 (roughly player size)
return {
  --- Linear easing
  linear = function(dEnd, t, tEnd)
    local dStart = BASE_BIAS
    local d = dEnd - dStart
    local tCoeff = t / tEnd
    return dStart + (tCoeff * d)
  end,

  --- Cubic easing
  cubic = function(dEnd, t, tEnd)
    local x = t / tEnd
    if (x < 0.5) then
      return (4 * math.pow(x, 3)) * (dEnd - BASE_BIAS) + BASE_BIAS
    else
      return (1 - math.pow(-2 * x + 2, 3) / 2) * (dEnd - BASE_BIAS) + BASE_BIAS
    end
  end
}
