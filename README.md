# TouchBar Pet

TouchBar Pet is a native macOS AppKit app for MacBook models with a Touch Bar. It shows a small pet in the Touch Bar while the app is active, with buttons to feed, play, and rest.

GitHub repo: https://github.com/Heaaaaaaaa/TouchBar-Pet

## Current Status

The first MVP scaffold is implemented as a Swift package. It builds with the full Xcode toolchain and can also create a clickable fallback app bundle with `Scripts/build-app.sh`.

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

When the app is active, the Touch Bar should show the pet face and action buttons.

## Xcode Setup

After installing full Xcode:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
open Package.swift
```

Then run the `TouchBarPet` executable target from Xcode.

## Touch Bar Troubleshooting

If the app window opens but the Touch Bar still shows only brightness, volume, or other system controls:

1. Open System Settings.
2. Go to Keyboard.
3. Set Touch Bar shows to `App Controls` or `App Controls with Control Strip`.
4. Quit any other Touch Bar pet apps while testing.
5. Click the TouchBar Pet window so it is the active app.

The app now provides its custom Touch Bar from the active window responder chain. The Touch Bar should show a cyan pet strip with a pixel pet and Health/Hunger/Social stats.

## MVP Features

- App-focused Touch Bar pet using `NSTouchBar`
- Animated ASCII pet face
- Hunger, mood, and energy stats
- Feed, play, and rest actions
- Local saved state in Application Support
- Simple app window with matching controls
- Fallback `.app` bundle build script

## Development Log

Project progress is tracked in `DEVELOPMENT_PLAN.md`.
