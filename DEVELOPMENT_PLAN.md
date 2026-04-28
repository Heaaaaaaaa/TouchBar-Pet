# TouchBar Pet Development Plan

## Project Goal

Build a native macOS app called TouchBar Pet for an M1 MacBook with Touch Bar. The pet appears in the Touch Bar while the app is active, shows a small animated ASCII face, and lets the user feed, play with, and rest the pet from Touch Bar controls.

The first version uses Apple-supported AppKit Touch Bar APIs through `NSTouchBar`. It is app-focused, not a system-wide always-on Touch Bar modification.

References:

- Apple Touch Bar documentation: https://developer.apple.com/documentation/appkit/touch-bar
- Creating and customizing the Touch Bar: https://developer.apple.com/documentation/appkit/creating-and-customizing-the-touch-bar

## MVP Definition

The MVP is complete when:

- The app opens a small macOS window.
- The Touch Bar appears while the app is active.
- The pet face animates over time.
- The pet tracks hunger, mood, and energy.
- Touch Bar buttons can feed, play, and rest the pet.
- The same actions are available in the app window.
- Pet state is saved locally and restored on the next launch.
- The project can be built locally and pushed to a private GitHub repo.

## Setup Checklist

- [x] Create this development plan before app code.
- [x] Refresh GitHub CLI login for `Heaaaaaaaa`.
- [x] Create private GitHub repo `Heaaaaaaaa/TouchBar-Pet`.
- [ ] Install full Xcode.
- [ ] Switch command line tools to full Xcode with `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`.
- [x] Create native Swift/AppKit project scaffold.
- [x] Add Touch Bar pet MVP code.
- [x] Add README with setup and run instructions.
- [ ] Build and run inside full Xcode.
- [ ] Verify the Swift package builds with current Command Line Tools.
- [x] Verify Swift source type-checks with `swiftc`.
- [ ] Verify on the physical Touch Bar.
- [x] Push initial commits to GitHub.

## Development Steps

1. Create `DEVELOPMENT_PLAN.md`.
2. Initialize Git on branch `main`.
3. Create the first native AppKit Swift project.
4. Add the pet state model and local persistence.
5. Add the main app window.
6. Add `NSTouchBar` controls and animated pet display.
7. Add a timer loop for animation and stat changes.
8. Add README instructions.
9. Commit each completed milestone.
10. Create and push to the private GitHub repo.

## Completion Log Template

Use this template after each completed file or milestone:

```md
### YYYY-MM-DD - File or Milestone Name

What was done:
- ...

What can be improved:
- ...

What next:
- ...
```

## Development Log

### 2026-04-28 - DEVELOPMENT_PLAN.md

What was done:
- Created the first project plan and working log before app code.
- Defined the MVP, setup checklist, development steps, and completion log format.

What can be improved:
- Add screenshots and build notes after the app runs in Xcode and on the real Touch Bar.

What next:
- Add the Swift/AppKit project scaffold and update this log after the first build check.

### 2026-04-28 - Swift/AppKit MVP Scaffold

What was done:
- Added a Swift package named `TouchBarPet`.
- Built the app with AppKit, `NSTouchBar`, local JSON persistence, a small window UI, and feed/play/rest pet actions.
- Added an animation/stat tick loop so the pet face and status change over time.
- Added a README and `.gitignore`.
- Fixed the clamp helper after Swift type-checking caught a name-resolution issue.
- Verified source type-check with `swiftc -typecheck`.

What can be improved:
- Convert the Swift package into a full `.xcodeproj` after full Xcode is installed.
- Add image-based pet sprites later if ASCII faces feel too simple on the Touch Bar.
- Add a menu bar companion after the app-focused MVP is stable.
- Current local Command Line Tools have a SwiftPM/SDK mismatch, so `swift build` is blocked until full Xcode or matching Command Line Tools are installed.

What next:
- Refresh GitHub login, initialize Git, commit the scaffold, create the private repo, and push.
- After Xcode is installed, run `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` and `swift build`.

### 2026-04-28 - GitHub Repo Created

What was done:
- Refreshed GitHub CLI login for `Heaaaaaaaa`.
- Initialized Git on branch `main`.
- Created the private GitHub repo `Heaaaaaaaa/TouchBar-Pet`.
- Pushed the initial app scaffold commit to GitHub.

What can be improved:
- Add release tags later once the app can be run from a signed `.app` bundle.
- Add screenshots or short demo media after physical Touch Bar testing.

What next:
- Install full Xcode, switch command line tools to Xcode, and run the app from Xcode.
- Test the Touch Bar controls on the real MacBook Touch Bar.
