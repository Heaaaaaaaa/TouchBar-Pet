# Pixel Art Assets

## Generated Asset Sheet

File:

- `pet-background-concept-sheet.png`
- `food-concept-sheet.png`

Generated with the built-in `imagegen` tool for the TouchBar Pet project.

Contents:

- Cat: idle, moving/play, sleep
- Puffer fish: idle, swim, puff
- Ghost: idle, dash, sleep
- Dragon: idle, run/fly, fire
- Plant buddy: sprout, flower, thirsty/sad
- Background strips:
  - cyan aquarium
  - night sky
  - grassy daytime
  - cozy room/fireplace
- Food concept sheet:
  - blue fish snack for Cat
  - golden pellet cluster for Puffer Fish
  - glowing soul-star for Ghost
  - flame/meat snack for Dragon
  - water drops and sprout cue for Plant Buddy

Dimensions:

- `1254 x 1254`
- PNG, RGB

The food concept sheet is also `1254 x 1254`, PNG, RGB.

## Intended Use

Use this as the visual reference/source sheet for app sprites. The current app loads extracted PNG assets first and keeps code-drawn artwork as a fallback. Future sprite work can either:

- crop sprites from this sheet into separate PNG assets, or
- manually translate the best sprite shapes into deterministic AppKit drawing code.

Recommended first extraction:

1. Cat idle/walk/sleep frames.
2. Cyan aquarium background or grassy daytime background for the default Touch Bar strip.
3. Puffer fish frames after the cat animation system works.

## Extracted App Sprites

The app now uses extracted bitmap pets and Touch Bar backgrounds from this generated sheet.

Generated sprite files live at:

- `Sources/TouchBarPet/Resources/PixelArt/Sprites/`

Generated background strip files live at:

- `Sources/TouchBarPet/Resources/PixelArt/Backgrounds/`

Generated food sprite files live at:

- `Sources/TouchBarPet/Resources/PixelArt/Foods/`

Regenerate them with:

```sh
Scripts/extract-pixel-sprites.py
```

The extraction script crops 15 pet poses:

- Cat: idle, walk, sleep
- Puffer Fish: idle, swim, puff
- Ghost: idle, dash, sleep
- Dragon: idle, run, fire
- Plant Buddy: sprout, flower, thirsty

The Swift renderer loads these PNGs first and falls back to code-drawn sprites if a file is missing.

The background renderer loads the extracted aquarium, night, grass, and cozy PNG strips first and falls back to AppKit-drawn background details if a file is missing.

The food renderer loads the extracted cat fish, puffer pellets, ghost star, dragon snack, and plant water PNGs first and falls back to AppKit-drawn food if a file is missing.

Note: the ghost crop rectangles are intentionally tight vertically because the generated sheet places the dragon row close underneath. Looser ghost crops can pull dragon pixels into the extracted ghost sprites.

Note: the dragon fire crop is intentionally shortened so the large generated fireball does not become a yellow block on the physical Touch Bar, and so the next-row blue pixels do not appear below the dragon foot.

Note: the cozy background is cleaned during extraction to remove generated fireplace/candle/sleeping-pet leftovers that competed with the active pet.

Note: the Plant Buddy food crop is isolated to the blue water drops so green sprout leftovers from the food concept sheet do not appear as another plant.

## Food Asset Sheet Prompt

```text
Use case: stylized-concept
Asset type: pixel-art game asset sheet for a macOS Touch Bar pet app
Primary request: Create a compact pixel-art food sprite sheet matching the provided TouchBar Pet asset genre: chunky cute pixel art, dark navy presentation background, crisp black pixel outlines, bright highlights, soft tiny glow, no text.
Subject: five pet food/snack sprites, arranged in one clean row with generous spacing: 1) tiny blue fish snack for an orange cat, 2) three golden fish pellets for a puffer fish, 3) glowing pale-blue soul star for a ghost, 4) small red-orange flame meat snack for a dragon, 5) two blue water drops with a tiny green sprout sparkle for a plant buddy.
Style/medium: high-quality cute pixel art sprite sheet, 16-bit/32-bit game asset style, same visual language as a cute Touch Bar pet concept sheet.
Composition/framing: square canvas, dark navy background, each food icon centered in its own invisible cell, all sprites small and readable at Touch Bar size, each sprite around 48x48 visual footprint, no labels.
Lighting/mood: playful, clean, charming, clear silhouettes, bright highlights.
Color palette: vivid cyan/blue fish, warm golden pellets, icy blue ghost star, hot red-orange dragon snack, aqua water drops with fresh green accent.
Materials/textures: crisp pixel clusters, black outline, 1-2 pixel highlights, minimal glow, tiny shadow under each food.
Constraints: no text, no watermark, no UI frame, no pets, food sprites only, keep every sprite separated and easy to crop, background must be flat dark navy.
```

## Original Generation Prompt

```text
Use case: stylized-concept
Asset type: pixel art sprite and background concept sheet for a macOS Touch Bar pet app
Primary request: create a clean pixel art asset sheet containing five tiny pets and several Touch Bar background strips.
Subject: five readable tiny pixel pets: orange cat, round puffer fish, little blue-white ghost, tiny green dragon, small plant buddy in a pot.
Scene/backdrop: transparent-looking presentation on a neutral dark preview canvas, with separate long horizontal Touch Bar background strips below the pets.
Style/medium: crisp 16-bit pixel art, chunky low-resolution sprites, no anti-aliased painterly rendering, game asset sheet style.
Composition/framing: one square asset sheet, pets in separate labeled-free rows or columns with generous spacing; include 3 animation poses per pet: idle, moving, special/sleep; include 4 long thin horizontal Touch Bar backgrounds: cyan aquarium strip, night sky strip, grassy strip, warm cozy strip.
Color palette: bright readable colors for small displays, dark UI-friendly backgrounds, cyan accent similar to old Touch Bar pet style.
Materials/textures: flat pixel blocks, clean edges, no photorealism.
Constraints: no text, no watermark, no logos; keep every sprite fully visible; make the pets tiny but readable; backgrounds must be long thin strips suitable for a Touch Bar; avoid complex gradients and avoid blurry edges.
```
