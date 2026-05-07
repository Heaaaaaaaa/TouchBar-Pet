# TouchBar Pet

TouchBar Pet is a native macOS AppKit app for MacBook models with a Touch Bar. It runs from the menu bar and shows a small pet in the Touch Bar with controls to feed, play, and rest.

GitHub repo: https://github.com/Heaaaaaaaa/TouchBar-Pet

## Current Status

The first MVP scaffold is implemented as a Swift package. It builds with the full Xcode toolchain and can also create a clickable fallback app bundle with `Scripts/build-app.sh`.

The background Touch Bar mode uses private macOS Touch Bar APIs because public `NSTouchBar` only stays visible for the frontmost app. This is for personal/local use, not App Store distribution.

## Requirements

- macOS on Apple Silicon
- A MacBook with Touch Bar for real Touch Bar testing
- Full Xcode for the intended development workflow
- Accepted Xcode license agreement

## Build From Terminal

```sh
swift build
```

## Build A Clickable App Bundle

This fallback path avoids SwiftPM and compiles the app directly with `swiftc`:

```sh
Scripts/build-app.sh
```

Output:

```text
Build/TouchBar Pet.app
```

## Run From Terminal

```sh
swift run TouchBarPet
```

If you used the fallback bundle build, open `Build/TouchBar Pet.app` instead.

The app runs as a menu-bar/background app. Use the `TBP` menu-bar item for Show Window, Hide Window, Feed, Play, Rest, and Show Touch Bar Pet.

The red close button on the small window only hides the window. The app keeps running from the `TBP` menu-bar item, and `TBP` -> `Show Touch Bar Pet` forces the persistent Touch Bar item to reinstall and show again.

## Choosing Pets And Backgrounds

Use the `TBP` menu-bar item:

- `Pet` -> choose Cat, Puffer Fish, Ghost, Dragon, or Plant Buddy.
- `Background` -> choose Auto, Aquarium, Night Sky, Grass, or Cozy Room.

`Auto` chooses a matching background for the selected pet.

## Touch Bar Status Badge

The small badge inside the Touch Bar scene shows three short stats. Each number is from `0` to `10`.

Important: `H` means hunger, so a higher `H` means the pet is more hungry and should be fed. Most other stats are better when higher.

The main window shows the full four best stats for each pet. The Touch Bar badge shows the most important three so it stays readable in the narrow strip.

Species badges:

- Cat: `P` = pet health, `H` = hunger, `S` = social mood
- Puffer Fish: `P` = pet health, `H` = hunger, `C` = calm
- Ghost: `G` = glow, `H` = hunger, `M` = mood
- Dragon: `P` = pet health, `H` = hunger, `F` = fire
- Plant Buddy: `W` = water, `S` = sun, `G` = growth

Example: `P:0 H:10 C:0` means the puffer fish has very low health, is very hungry, and has low calm.

## Pet Behavior Logic

Pets normally move for a while, pause briefly, and keep using energy while awake. Sleep timing is species-specific: high-energy pets like dragons tire sooner, while ghosts and puffer fish float for longer. A sleeping pet now stays asleep until it has recovered enough energy, then wakes and starts moving again.

Touch actions are also species-specific:

- Tap the scene: Cat jumps, Puffer Fish puffs, Ghost says `boo`, Dragon breathes fire, Plant Buddy opens toward sun.
- Feed: shows the right snack and lowers hunger/water need.
- Play: increases mood and triggers faster or happier movement.
- Rest: starts a nap or calm rest state.

## Xcode Setup

After installing full Xcode:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
open Package.swift
```

Then run the `TouchBarPet` executable target from Xcode. The window no longer opens automatically; look for the `TBP` menu-bar item.

## Touch Bar Troubleshooting

If the app window opens but the Touch Bar still shows only brightness, volume, or other system controls:

1. Open System Settings.
2. Go to Keyboard.
3. Set Touch Bar shows to `App Controls` or `App Controls with Control Strip`.
4. Quit any other Touch Bar pet apps while testing.
5. Click `TBP` in the menu bar and choose `Show Touch Bar Pet`.

The app uses an experimental persistent Touch Bar path plus the normal active-window fallback. The Touch Bar should show a long pixel-art scene strip with a moving pet and compact stats.

## MVP Features

- Background/menu-bar app with experimental persistent Touch Bar support
- Animated pixel pet scene based on the generated concept asset sheet
- Hunger, mood, and energy stats
- Feed, play, and rest actions
- Local saved state in Application Support
- Simple app window with matching controls
- Fallback `.app` bundle build script
- Selectable pixel pets and Touch Bar backgrounds
- Shared movement model with walk, eat, play, sleep, and special behavior modes
- Smoother animation loop with throttled saved-state writes
- Refined outlined pixel sprites for better readability on the physical Touch Bar
- Direct bitmap sprite rendering from extracted generated asset-sheet pets
- Direct bitmap background rendering from extracted generated asset-sheet Touch Bar strips
- Stable bitmap sprite slots to avoid movement jitter between animation frames
- Stable per-behavior asset poses to avoid rapid walk/idle flicker
- Procedural natural motion over bitmap sprites: bobbing, squash/stretch, hover, drift, and sway
- Inline high-contrast Touch Bar stat badge so text stays visible before the Control Strip

## Development Log

Project progress is tracked in `DEVELOPMENT_PLAN.md`.
