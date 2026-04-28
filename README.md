# TouchBar Pet

TouchBar Pet is a native macOS AppKit app for MacBook models with a Touch Bar. It shows a small pet in the Touch Bar while the app is active, with buttons to feed, play, and rest.

GitHub repo: https://github.com/Heaaaaaaaa/TouchBar-Pet

## Current Status

The first MVP scaffold is implemented as a Swift package so it can build with the current Swift Command Line Tools. Full Xcode is still recommended for normal Mac app development, signing, and Touch Bar testing.

## Requirements

- macOS on Apple Silicon
- A MacBook with Touch Bar for real Touch Bar testing
- Full Xcode for the intended development workflow
- Swift Command Line Tools for basic package builds

## Build From Terminal

```sh
swift build
```

## Run From Terminal

```sh
swift run TouchBarPet
```

When the app is active, the Touch Bar should show the pet face and action buttons.

## Xcode Setup

After installing full Xcode:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
open Package.swift
```

Then run the `TouchBarPet` executable target from Xcode.

## MVP Features

- App-focused Touch Bar pet using `NSTouchBar`
- Animated ASCII pet face
- Hunger, mood, and energy stats
- Feed, play, and rest actions
- Local saved state in Application Support
- Simple app window with matching controls

## Development Log

Project progress is tracked in `DEVELOPMENT_PLAN.md`.
