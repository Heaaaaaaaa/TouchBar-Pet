# Pixel Art Assets

## Generated Asset Sheet

File:

- `pet-background-concept-sheet.png`

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

Dimensions:

- `1254 x 1254`
- PNG, RGB

## Intended Use

Use this as the visual reference/source sheet for the next sprite implementation step. The current app still draws pixel pets in code; the next implementation can either:

- crop sprites from this sheet into separate PNG assets, or
- manually translate the best sprite shapes into deterministic AppKit drawing code.

Recommended first extraction:

1. Cat idle/walk/sleep frames.
2. Cyan aquarium background or grassy daytime background for the default Touch Bar strip.
3. Puffer fish frames after the cat animation system works.

## Extracted App Sprites

The app now uses extracted bitmap pets from this generated sheet.

Generated sprite files live at:

- `Sources/TouchBarPet/Resources/PixelArt/Sprites/`

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
