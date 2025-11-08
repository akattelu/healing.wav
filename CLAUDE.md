# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# healingwave

healingwave is a roguelike 2D game written in Lua using the LÖVE2D framework. The player controls a cleric character that emits healing waves to survive 10 increasingly difficult waves of undead enemies.

## Game Design

**Core Loop**:
- Survive 10 waves of skeleton enemies
- Each wave features enemies with progressively more health
- Between waves, select from power-ups or special abilities to enhance your character
- Win condition: Successfully defeat all 10 waves

**Progression System**:
- Wave-based difficulty scaling through enemy health increases
- Strategic character building through power-up selection
- Roguelike elements: ability choices create unique builds each playthrough

## Running the Game

```bash
# Run the game
love .

# With debug panel (D to toggle, R to reset, 1/2/3 to switch tabs)
love . --with-config-panel

# Disable sound
love . --no-sound

# Hot reloading is enabled via lick (vendor/lick.lua)
# Changes to .lua files will automatically reload the game
```

## Project Structure

### Architecture Overview

The game uses a simple entity-component architecture with scene management:

- **main.lua**: Entry point with LÖVE lifecycle callbacks (load, update, draw). Initializes scene manager and delegates to active scene. Uses a global `S` table to store game state
- **conf.lua**: LÖVE window configuration (1280x1024, vsync enabled)
- **src/scene/**: Game scenes (title, battle, wave_intro, reward_select, credits) - each scene is a table with load/update/draw methods
- **src/entity/**: Game entities (cleric, skeleton, wave, health) - each entity is a factory function returning a table with load/update/draw methods
- **src/lib/**: Utility libraries for stats, tweening, debugging, and scene management
- **src/ui/**: Reusable UI components (number controls, sliders)
- **vendor/**: Third-party libraries (lick for hot reloading)
- **lpc/**: Sprite assets (64x64 pixel sprite sheets)

### Key Game Mechanics

**Global State Pattern** (S table):
- `S.sceneManager` - Singleton scene manager
- `S.settings` - Parsed CLI arguments (soundEnabled, debugPanelEnabled)
- `S.stats` - Persistent stat object across waves (survives scene switches)
- `S.currentWave` - Wave counter (1-10)

**Scene System** (src/lib/scene.lua):
- Manages different game screens/modes
- Scene manager handles registration, switching, and callback delegation
- Delegates LÖVE callbacks (update, draw, keypressed, mousepressed, mousereleased) to active scene
- Each scene implements: `load()`, `update(dt)`, `draw()`, and optional input handlers
- Scene switching: `S.sceneManager:switch("scene_name")` triggers `load()` on new scene

**Scene Flow**:
1. **title** → Play button switches to wave_intro
2. **wave_intro** → Displays "Wave X / 10" for 2 seconds, auto-switches to battle
3. **battle** → Main gameplay; when all skeletons defeated:
   - If wave < 10: switches to reward_select
   - If wave == 10: switches to credits
4. **reward_select** → Offers 3 random stat upgrades; selecting one increments S.currentWave and switches to wave_intro
5. **credits** → End screen

**Wave System** (src/entity/wave.lua):
The healing wave is the most complex mechanic:
- Waves are directional arcs that emanate from the cleric
- Wave direction is determined by player movement (8 directions + down default)
- Waves have two modes: EXTENDING (visible arc expanding) and COOLDOWN (hidden)
- Wave behavior is driven by stats (wavelength, range, frequency, period)
- Uses cubic easing for smooth expansion animation (see src/lib/tween.lua)
- **Rendering**: Draws 100 concentric arcs with alpha gradient (0.0 inner → 0.8 outer) in golden yellow (1, 0.9, 0.55)
- **Collision detection**:
  - Checks if any of 4 corners of enemy bounding box fall within arc region
  - Arc region defined by: innerRadius (64px), outerRadius (animated), arcStart angle, arcEnd angle
  - Uses `collidedSprites` array to ensure each enemy is only hit once per wave cycle
  - Special case: if wavelength >= 2π, hits everything in range (full circle)
- **Wave positioning**: Wave center (cx, cy) is updated to player:centerX(), player:centerY() at start of each EXTENDING cycle

**Stats System** (src/lib/stats.lua):
Wave properties are defined through stat metaphors:
- `amplitude`: Damage dealt (base: 1)
- `wavelength`: Arc length in radians (base: π/2)
- `frequency`: Speed of expansion (base: 200)
- `period`: Cooldown duration between waves (base: 0.1s) - inverse upgrade (lower is better)
- `range`: Duration of wave extension (base: 1s)

Each stat has:
- Base value (set in stats.lua or debug panel)
- Multiplier (applied by power-ups, default 1.0)
- Final value = base × multiplier (accessed via `stats:getValue(statName)`)

**Entity Pattern**:
Both cleric and skeleton use the same factory function pattern (NOT classes):
```lua
return function(args)
  return {
    -- State fields
    x = 0, y = 0,

    -- Methods
    load = function(self) ... end,
    update = function(self, dt) ... end,
    draw = function(self) ... end
  }
end
```

**Sprite Animation Pattern**:
- Direction enum (UP, LEFT, DOWN, RIGHT, IDLE)
- Frame-based sprite animation with configurable frameDuration (0.1s)
- 64x64 pixel sprite frames loaded from sprite sheets
- Frames stored as 2D array: `frames[direction][frameIndex]`
- IDLE direction uses first frame of DOWN animation

**Coordinate System**:
- Cleric tracks separate directionX/directionY for movement
- Wave positioning uses centerX() and centerY() methods (x + frameWidth/2, y + frameHeight/2)
- Direction angles use radians with 0 = RIGHT, π/2 = DOWN, π = LEFT, 3π/2 = UP
- Angles normalized to [0, 2π] for collision wraparound detection

**Collision Interface**:
Objects must implement:
- `getPosition()` returning (x, y, width, height) tuple
- Enemies must implement `damage(dmg)` and `health:isDead()`

## Code Conventions

- Use factory functions (not classes) that return tables with methods
- Methods use `function(self)` or `function Table.method(self)` syntax
- Global game state stored in `S` table (S.sceneManager, S.settings, etc.)
- Scene-specific state stored in scene tables (battle scene has self.cl, self.skeletons, self.wave, self.stats)
- LÖVE uses "nearest" filter mode for pixel art rendering
- Entity lifecycle: load() for initialization, update(dt) for logic, draw() for rendering
- Scene lifecycle: Same as entities - load(), update(dt), draw(), plus optional input handlers (keypressed, mousepressed, mousereleased)
- Use love.graphics.push("all") / pop() for isolated graphics state changes
- Settings are parsed via CLI args: `--no-sound`, `--with-config-panel`

### Adding New Scenes

To add a new scene (e.g., pause menu, game over screen):

1. Create a new file in `src/scene/` following the scene pattern
2. Implement required methods: `load()`, `update(dt)`, `draw()`
3. Add optional input handlers: `keypressed(key)`, `mousepressed(x, y, button)`, `mousereleased(x, y, button)`
4. Register the scene in `main.lua` using `S.sceneManager:register(name, sceneTable)`
5. Switch to the scene using `S.sceneManager:switch(name)`

### Wave Expansion Math

The wave expansion uses cubic easing from src/lib/tween.lua:
- First half accelerates: `4x³`
- Second half decelerates: `1 - (-2x+2)³/2`
- Always starts from BASE_BIAS (64px)
- Formula: `tween.cubic(dEnd, t, tEnd)` where dEnd = range × frequency, t = elapsed time, tEnd = range
