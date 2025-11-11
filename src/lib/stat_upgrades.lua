-- Available stat upgrades with their display names and upgrade percentages
local STAT_UPGRADES = {
  { stat = "amplitude", name = "Damage", percent = 20, description = "Increase wave damage" },
  { stat = "wavelength", name = "Arc Width", percent = 15, description = "Wider healing wave" },
  { stat = "frequency", name = "Speed", percent = 25, description = "Faster wave expansion" },
  { stat = "period", name = "Cooldown", percent = 15, description = "Shorter cooldown (inverse)" },
  { stat = "range", name = "Duration", percent = 20, description = "Wave lasts longer" },
  { stat = "movementSpeed", name = "Movement Speed", percent = 20, description = "Move faster across the battlefield" },
  { stat = "knockback", name = "Knockback", percent = 25, description = "Push enemies back harder" },
}

return STAT_UPGRADES
