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

# Hot reloading is enabled via lick (vendor/lick.lua)
# Changes to .lua files will automatically reload the game
```

## Project Structure

### Architecture Overview

The game uses a simple entity-component architecture with scene management:

- **main.lua**: Entry point with LÖVE lifecycle callbacks (load, update, draw). Initializes scene manager and delegates to active scene. Uses a global `S` table to store game state
- **conf.lua**: LÖVE window configuration (1280x1024, vsync enabled)
- **src/scene/**: Game scenes (title, battle) - each scene is a table with load/update/draw methods
- **src/entity/**: Game entities (cleric, skeleton, wave) - each entity is a factory function returning a table with load/update/draw methods
- **src/lib/**: Utility libraries for stats, tweening, debugging, and scene management
- **vendor/**: Third-party libraries (lick for hot reloading)

### Key Game Mechanics

**Scene System** (src/lib/scene.lua):
- Manages different game screens/modes (title, battle, etc.)
- Scene manager handles registration, switching, and callback delegation
- Delegates LÖVE callbacks (update, draw, keypressed, mousepressed) to active scene
- Each scene implements: `load()`, `update(dt)`, `draw()`, and optional input handlers
- Global scene manager stored in `S.sceneManager`

**Available Scenes**:
- **title** (src/scene/title.lua): Title screen with "healing.wav" branding and play button
- **battle** (src/scene/battle.lua): Main gameplay with cleric, skeletons, and wave combat

**Wave System** (src/entity/wave.lua):
- Waves are directional arcs that emanate from the cleric
- Wave direction is determined by player movement (8 directions + down default)
- Waves have two modes: EXTENDING (visible arc expanding) and COOLDOWN (hidden)
- Wave behavior is driven by stats (wavelength, range, frequency, period)
- Uses cubic easing for smooth expansion animation (see src/lib/tween.lua)

**Stats System** (src/lib/stats.lua):
Wave properties are defined through stat metaphors:
- `amplitude`: Damage dealt
- `wavelength`: Arc length (in radians)
- `frequency`: Speed of expansion
- `period`: Cooldown duration between waves
- `range`: Duration of wave extension

**Entity Pattern**:
Both cleric and skeleton use the same sprite animation pattern:
- Factory functions that return tables with methods
- Direction enum (UP, LEFT, DOWN, RIGHT, IDLE)
- Frame-based sprite animation with configurable frameDuration
- 64x64 pixel sprite frames loaded from sprite sheets

**Coordinate System**:
- Cleric tracks separate directionX/directionY for movement
- Wave positioning uses centerX() and centerY() methods
- Direction angles use radians with 0 = RIGHT, π/2 = DOWN, etc.

## Code Conventions

- Use factory functions (not classes) that return tables with methods
- Methods use `function(self)` or `function Table.method(self)` syntax
- Global game state stored in `S` table (S.sceneManager, S.settings, etc.)
- Scene-specific state stored in scene tables (battle scene has self.cl, self.skeletons, self.wave, self.stats)
- LÖVE uses "nearest" filter mode for pixel art rendering
- Entity lifecycle: load() for initialization, update(dt) for logic, draw() for rendering
- Scene lifecycle: Same as entities - load(), update(dt), draw(), plus optional input handlers (keypressed, mousepressed)

### Adding New Scenes

To add a new scene (e.g., pause menu, credits, reward selection):

1. Create a new file in `src/scene/` following the scene pattern
2. Implement required methods: `load()`, `update(dt)`, `draw()`
3. Add optional input handlers: `keypressed(key)`, `mousepressed(x, y, button)`
4. Register the scene in `main.lua` using `S.sceneManager:register(name, sceneTable)`
5. Switch to the scene using `S.sceneManager:switch(name)`
