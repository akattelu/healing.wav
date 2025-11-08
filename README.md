# healing.wav

A roguelike 2D game where you play as a cleric wielding healing waves to survive 10 increasingly difficult waves of undead enemies.

## Game Overview

**Objective**: Survive all 10 waves of enemies to win the game.

**Gameplay**:
- Control a cleric character that emits healing waves to damage approaching skeletons
- Each wave spawns enemies with progressively more health
- Between waves, choose from a selection of power-ups or special abilities to enhance your character
- Use strategy to build your abilities and survive until the final wave

## Running the Game

```bash
love .
```

Hot reloading is enabled via lick - changes to `.lua` files will automatically reload the game.

## Technical Overview

### Scene System

The game uses a scene management system to handle different screens and game modes:

- **src/lib/scene.lua**: Scene manager that handles scene registration, switching, and delegation
- **src/scene/title.lua**: Title screen with "healing.wav" branding and play button
- **src/scene/battle.lua**: Main gameplay scene with combat mechanics

Each scene implements `load()`, `update(dt)`, and `draw()` methods. The scene manager delegates LÖVE callbacks to the active scene.

### Adding New Scenes

To add a new scene (e.g., pause menu, credits, reward selection):

1. Create a new file in `src/scene/` (e.g., `pause.lua`)
2. Implement the scene methods:
   ```lua
   local pause = {}

   function pause:load()
     -- Initialize scene
   end

   function pause:update(dt)
     -- Update logic
   end

   function pause:draw()
     -- Render scene
   end

   function pause:mousepressed(x, y, button)
     -- Handle clicks (optional)
   end

   return pause
   ```
3. Register and use it in `main.lua`:
   ```lua
   local pauseScene = require "src.scene.pause"
   S.sceneManager:register("pause", pauseScene)
   S.sceneManager:switch("pause")
   ```

## Credits:

* https://codeberg.org/usysrc/lick
