-- Available stat upgrades with their display names, upgrade percentages, and tiers
-- Tiers: "common" (safe choices), "rare" (moderate trade-offs), "legendary" (high risk/reward)

local STAT_UPGRADES = {
  -- COMMON TIER (Small bonuses, minimal/no trade-offs)
  {
    tier = "common",
    stat = "amplitude",
    name = "Minor Damage",
    percent = 15,
    description = "Slightly increase wave damage",
    tradeoff = nil
  },
  {
    tier = "common",
    stat = "frequency",
    name = "Minor Attack Speed",
    percent = 15,
    description = "Attack a bit more frequently",
    tradeoff = nil
  },
  {
    tier = "common",
    stat = "range",
    name = "Minor Range",
    percent = 15,
    description = "Waves reach a bit further",
    tradeoff = nil
  },
  {
    tier = "common",
    stat = "movementSpeed",
    name = "Minor Movement",
    percent = 15,
    description = "Move slightly faster",
    tradeoff = nil
  },
  {
    tier = "common",
    stat = "wavelength",
    name = "Minor Arc",
    percent = 12,
    description = "Slightly wider healing wave",
    tradeoff = nil
  },
  {
    tier = "common",
    stat = "knockback",
    name = "Minor Knockback",
    percent = 15,
    description = "Push enemies back a bit harder",
    tradeoff = nil
  },

  -- RARE TIER (Medium bonuses with meaningful trade-offs)
  {
    tier = "rare",
    stat = "amplitude",
    name = "Glass Cannon",
    percent = 40,
    description = "Devastating damage at a cost",
    tradeoff = {
      stat = "movementSpeed",
      percent = -20
    }
  },
  {
    tier = "rare",
    stat = "frequency",
    name = "Rapid Fire",
    percent = 40,
    description = "Much faster attacks, shorter reach",
    tradeoff = {
      stat = "range",
      percent = -20
    }
  },
  {
    tier = "rare",
    stat = "range",
    name = "Long Distance",
    percent = 40,
    description = "Extended range, slower attacks",
    tradeoff = {
      stat = "frequency",
      percent = -20
    }
  },
  {
    tier = "rare",
    stat = "movementSpeed",
    name = "Swift Striker",
    percent = 35,
    description = "Greater mobility, less damage",
    tradeoff = {
      stat = "amplitude",
      percent = -15
    }
  },
  {
    tier = "rare",
    stat = "knockback",
    name = "Heavy Impact",
    percent = 40,
    description = "Massive knockback, slower movement",
    tradeoff = {
      stat = "movementSpeed",
      percent = -15
    }
  },
  {
    tier = "rare",
    stat = "wavelength",
    name = "Wide Arc",
    percent = 35,
    description = "Much wider wave, reduced range",
    tradeoff = {
      stat = "range",
      percent = -15
    }
  },

  -- LEGENDARY TIER (High bonuses with significant trade-offs)
  {
    tier = "legendary",
    stat = "amplitude",
    name = "Overwhelming Force",
    percent = 75,
    description = "Devastating power, but slow and vulnerable",
    tradeoff = {
      stat = "frequency",
      percent = -35
    }
  },
  {
    tier = "legendary",
    stat = "frequency",
    name = "Berserker Rage",
    percent = 60,
    description = "Relentless assault, minimal control",
    tradeoff = {
      stat = "knockback",
      percent = -40
    }
  },
  {
    tier = "legendary",
    stat = "range",
    name = "Titan's Reach",
    percent = 70,
    description = "Extreme range, very weak hits",
    tradeoff = {
      stat = "amplitude",
      percent = -35
    }
  },
  {
    tier = "legendary",
    stat = "movementSpeed",
    name = "Lightning Reflexes",
    percent = 65,
    description = "Incredible speed, tiny wave arc",
    tradeoff = {
      stat = "wavelength",
      percent = -40
    }
  },
  {
    tier = "legendary",
    stat = "knockback",
    name = "Unstoppable Force",
    percent = 70,
    description = "Enemies fly away, but waves are narrow",
    tradeoff = {
      stat = "wavelength",
      percent = -35
    }
  },
  {
    tier = "legendary",
    stat = "wavelength",
    name = "Omnidirectional",
    percent = 60,
    description = "Massive arc coverage, slow attacks",
    tradeoff = {
      stat = "frequency",
      percent = -30
    }
  },
}

return STAT_UPGRADES
