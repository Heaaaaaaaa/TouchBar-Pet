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

## Choosing Pets And Backgrounds

Use the `TBP` menu-bar item:

- `Pet` -> choose Cat, Puffer Fish, Ghost, Dragon, or Plant Buddy.
- `Background` -> choose Auto, Aquarium, Night Sky, Grass, or Cozy Room.

`Auto` chooses a matching background for the selected pet.

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

The app uses an experimental persistent Touch Bar path plus the normal active-window fallback. The Touch Bar should show a cyan pet strip with a pixel pet and Health/Hunger/Social stats.

## MVP Features

- Background/menu-bar app with experimental persistent Touch Bar support
- Animated ASCII pet face
- Hunger, mood, and energy stats
- Feed, play, and rest actions
- Local saved state in Application Support
- Simple app window with matching controls
- Fallback `.app` bundle build script
- Selectable pixel pets and Touch Bar backgrounds

## Development Log

Project progress is tracked in `DEVELOPMENT_PLAN.md`.
