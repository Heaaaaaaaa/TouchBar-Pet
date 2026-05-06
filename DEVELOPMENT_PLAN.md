# TouchBar Pet Development Plan

## Project Goal

Build a native macOS app called TouchBar Pet for an M1 MacBook with Touch Bar. The pet appears in the Touch Bar while the app is active, shows a small animated ASCII face, and lets the user feed, play with, and rest the pet from Touch Bar controls.

The first version started with Apple-supported AppKit Touch Bar APIs through `NSTouchBar`. The current build adds an experimental always-present mode using private Touch Bar APIs because public `NSTouchBar` disappears when another app becomes frontmost.

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
- [x] Install full Xcode.
- [x] Switch command line tools to full Xcode with `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`.
- [x] Create native Swift/AppKit project scaffold.
- [x] Add Touch Bar pet MVP code.
- [x] Add README with setup and run instructions.
- [x] Add fallback `.app` bundle build script.
- [ ] Build and run inside the Xcode IDE.
- [x] Verify the Swift package builds with full Xcode toolchain.
- [x] Verify Swift source type-checks with `swiftc`.
- [x] Verify fallback `.app` bundle builds and launches.
- [x] Verify window controls update visible pet state.
- [x] Verify saved state restores after quit and reopen.
- [ ] Verify experimental persistent mode on the physical Touch Bar while another app is frontmost.
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

### 2026-04-28 - README Verification Notes

What was done:
- Updated README wording after rechecking `swift build`.
- Clarified that source type-checking passes, but full SwiftPM builds are blocked by the current Command Line Tools SwiftPM/SDK mismatch.

What can be improved:
- Replace the warning with a successful build note after full Xcode is installed and selected.

What next:
- Install full Xcode and rerun `swift build` or run the package from Xcode.

### 2026-04-28 - Fallback App Bundle Build

What was done:
- Added `Resources/Info.plist` for a basic macOS app bundle.
- Added `Scripts/build-app.sh` to compile the AppKit app directly with `swiftc`.
- The script outputs `Build/TouchBar Pet.app` so the app can be opened from Finder without waiting for SwiftPM to work.
- Verified the generated binary is an arm64 Mach-O executable and the app bundle plist is valid.

What can be improved:
- Replace the manual bundle path with a normal Xcode archive/export workflow later.
- Add an app icon and code signing once the app is ready to share.

What next:
- Commit and push the fallback build workflow.

### 2026-04-28 - Launch Check And Window Styling

What was done:
- Opened the generated app bundle successfully.
- Confirmed the app process/window appears as `TouchBar Pet` with Feed, Play, and Rest controls.
- Improved the window label colors so the pet face, stat line, and hint are easier to see in dark mode.
- Reworked the window summary into one fixed-size attributed label after launch testing showed separate labels could visually collapse after updates.
- Replaced the summary text field with a custom drawing view because live updates still caused text-field rendering problems.

What can be improved:
- Test the actual Touch Bar strip interaction by hand on the MacBook hardware.
- Add a proper app icon and richer pet visuals.

What next:
- Rebuild the app bundle, relaunch it, and commit the launch/style polish.

### 2026-04-28 - App Launch And Persistence Verification

What was done:
- Rebuilt `Build/TouchBar Pet.app`.
- Relaunched the app after quitting the old running process.
- Verified the custom-drawn pet summary stays visible after pressing Feed.
- Verified the pet state is saved and restored after quitting and reopening the app.

What can be improved:
- Add a reset/debug action for development so testing does not leave the pet tired or hungry.
- Add direct Touch Bar hardware screenshots or notes after manual testing on the physical Touch Bar.

What next:
- Commit and push the launch/persistence polish.
- Test the Touch Bar controls by hand on the MacBook Touch Bar.

### 2026-04-28 - Full Xcode Build Verified

What was done:
- Confirmed Xcode is installed at `/Applications/Xcode.app`.
- Confirmed `xcode-select` points to `/Applications/Xcode.app/Contents/Developer`.
- Accepted the Xcode license agreement so build tools can run.
- Fixed Swift 6 main-actor isolation issues in the AppKit and Touch Bar controllers.
- Replaced the top-level `main.swift` entry point with an explicit `@main` app entry point for Swift 6 compatibility.
- Verified `swift build` completes successfully with the full Xcode toolchain.
- Verified `Scripts/build-app.sh` still creates `Build/TouchBar Pet.app`.
- Verified `swift run TouchBarPet` launches the app window.

What can be improved:
- Open the package in the Xcode IDE and run from the IDE scheme.
- Add a signed app archive/export workflow later.

What next:
- Commit and push the Xcode build fix.
- Test the Touch Bar controls on the physical Touch Bar.

### 2026-04-28 - Touch Bar Strip Layout Fix

What was done:
- Added a first-responder hosting view that explicitly provides the app Touch Bar from the active window.
- Rebuilt the Touch Bar item as a wide custom scene closer to the reference photo: cyan strip, pixel pet, and compact Health/Hunger/Social stats.
- Kept Feed, Play, and Rest as Touch Bar items after the scene where space allows.

What can be improved:
- If macOS is set to show the Expanded Control Strip, the user still needs to change Keyboard settings to App Controls or App Controls with Control Strip.
- Add proper sprite frames later instead of the simple drawn pixel pet.

What next:
- Build, run, and ask the user to check the physical Touch Bar again.

### 2026-04-28 - Touch Bar Troubleshooting Notes

What was done:
- Added README guidance for the case where the app window opens but the physical Touch Bar still shows brightness/volume controls.
- Documented that macOS Keyboard settings must show App Controls or App Controls with Control Strip.
- Noted that other Touch Bar pet apps should be quit while testing.

What can be improved:
- Add an in-app warning or checklist for Touch Bar system settings.

What next:
- User should switch Keyboard Touch Bar settings and rerun the app from Xcode.

### 2026-04-28 - Agent Handoff

What was done:
- Added `AGENT_HANDOFF.md` so another agent can continue the project quickly.
- Summarized current state, verified commands, key files, known Touch Bar blocker, and next tasks.

What can be improved:
- Update the handoff after physical Touch Bar testing confirms the strip works.

What next:
- Commit and push the handoff file.

### 2026-05-06 - Background And Persistent Touch Bar Experiment

What was done:
- Changed launch behavior to a menu-bar/background app using activation policy `accessory`.
- Stopped opening the main window automatically; the `TBP` menu-bar item can show or hide it.
- Added menu-bar Feed, Play, Rest, and Show Touch Bar Pet actions.
- Added an Objective-C bridge to experimental private Touch Bar APIs for system-tray/persistent Touch Bar presentation.
- Updated the fallback app-bundle build script to compile the Objective-C bridge.

What can be improved:
- Confirm whether the private persistent API still works on this exact macOS/Xcode version.
- If private API behavior differs, inspect the installed Grace Avery persistence app bundle for hints.
- Improve the menu-bar icon beyond the simple `TBP` text.

What next:
- Build, run, and test by putting another app frontmost while watching the physical Touch Bar.

### 2026-05-06 - Persistent Tray Item Correction

What was done:
- Confirmed the previous commit `78359db` was already clean and pushed before further edits.
- Split the persistent Control Strip tray item from the full-width pet scene.
- Added a compact tray view with a small pixel pet so the Control Strip item is not just a blank blue rectangle.
- Updated the private API bridge to try both modern `presentSystemModalTouchBar...` and older `presentSystemModalFunctionBar...` selectors.

What can be improved:
- Verify on the physical Touch Bar whether tapping the compact tray item now opens the full pet bar.
- If the full modal still does not present, inspect which private selector exists on this macOS version.

What next:
- Build, rebuild app bundle, test, commit, and push.

### 2026-05-06 - Recover From Touch Bar Close Button

What was done:
- Converted the persistent tray item from a plain custom view into a real borderless `NSButton`, so tapping the small item should reliably request the full pet bar again.
- Added a short keep-alive timer that re-presents the persistent Touch Bar every 2 seconds.
- Called the private close-box setting during tray installation as well as modal presentation.

What can be improved:
- If the close button still appears, investigate private API placement values or a different modal presentation selector.
- Add a user setting to disable keep-alive if it becomes annoying.

What next:
- Build and push this close-button recovery fix.

### 2026-05-06 - Manual Expand Only

What was done:
- Removed the automatic 2-second Touch Bar re-present timer because it interfered with other Touch Bar tools.
- Kept the compact tray button and the `TBP` menu-bar `Show Touch Bar Pet` command as manual ways to expand the pet.

What can be improved:
- Add a setting later for optional auto-expand, defaulting off.

What next:
- Build, commit, and push the manual-expand behavior.

### 2026-05-06 - Pet Design And Movement Plan

What was done:
- Added `PET_DESIGN_PLAN.md`.
- Planned five possible pets: Cat, Puffer Fish, Ghost, Dragon, and Plant Buddy.
- Defined movement patterns, touch actions, stats, implementation order, and shared animation-system ideas.

What can be improved:
- Convert the plan into actual `PetSpecies` and sprite-drawing code.
- Add concept screenshots or generated pixel-art references later.

What next:
- Implement Cat as the first real animated species.

### 2026-05-06 - Pixel Pet And Background Concept Sheet

What was done:
- Used the `imagegen` skill to generate a pixel-art concept sheet.
- Saved the asset into `Assets/PixelArt/pet-background-concept-sheet.png`.
- Added `Assets/PixelArt/README.md` with the prompt, contents, dimensions, and recommended extraction path.
- Linked the generated concept asset from `PET_DESIGN_PLAN.md`.

What can be improved:
- Crop the sheet into separate sprite/background files.
- Convert the best cat frames into actual app rendering.

What next:
- Implement the Cat sprite and default Touch Bar background from the generated asset.

### 2026-05-06 - Selectable Pets And Backgrounds

What was done:
- Added saved `PetSpecies` and `PetBackground` state with backward-compatible defaults for old save files.
- Added code-drawn pixel versions of Cat, Puffer Fish, Ghost, Dragon, and Plant Buddy based on the generated concept sheet.
- Added Touch Bar background styles for Aquarium, Night Sky, Grass, and Cozy Room.
- Added `TBP` menu-bar submenus for choosing pet species and background.
- Updated the Touch Bar tray item, expanded Touch Bar scene, and optional window preview to use the selected pet.

What can be improved:
- Crop and use actual bitmap frames from `Assets/PixelArt/pet-background-concept-sheet.png` for richer animation.
- Add more animation frames and pet-specific actions.

What next:
- Test species/background switching on the physical Touch Bar.

### 2026-05-06 - Asset-Inspired Movement System

What was done:
- Added `PetBehaviorMode`, direction, position, velocity, and action countdown fields to saved pet state.
- Updated the pet engine so feed, play, rest, and normal ticks choose movement modes and move the pet across the Touch Bar strip.
- Reworked `PetPixelArt.swift` to use richer code-drawn sprites based on `Assets/PixelArt/pet-background-concept-sheet.png`.
- Expanded the Touch Bar scene strip so it uses dynamic width, larger moving sprites, shadows, snacks, sleep cues, sparkles, and more detailed background strips.
- Updated pet-specific Touch Bar stats for Cat, Puffer Fish, Ghost, Dragon, and Plant Buddy.

What can be improved:
- Crop the generated concept sheet into actual sprite/background PNG resources if the code-drawn version still looks too simple.
- Add a menu reset action for returning hunger, mood, and energy to testing-friendly values.
- Tune sprite sizes after another physical Touch Bar photo check.

What next:
- Build the app bundle, test on the physical Touch Bar, and adjust scale/spacing from real photos.

### 2026-05-06 - Smoother Animation Loop

What was done:
- Split smooth animation updates from slower care/stat decay.
- Changed the app loop from one redraw every 1.5 seconds to roughly 12 redraws per second.
- Kept hunger, mood, and energy changes on the previous 1.5-second care cadence so stats do not drain too fast.
- Throttled saved-state writes to avoid writing JSON on every animation frame.
- Adjusted movement speed values to be time-based instead of one large jump per old timer tick.

What can be improved:
- If the physical Touch Bar still feels heavy, cache static background strip drawing and redraw only the pet layer.
- Add a menu option for Low Power / Smooth animation speed.

What next:
- Test the rebuilt app on the physical Touch Bar and tune the frame rate if needed.

### 2026-05-06 - Pet Visual Refinement

What was done:
- Added a reusable pixel-outline pass so pets have clearer silhouettes on bright and dark Touch Bar backgrounds.
- Refined Cat, Puffer Fish, Ghost, Dragon, and Plant Buddy with stronger highlights, eyes, markings, wings, fins, leaves, and pot/flower detail.
- Gave the ghost a softer blue outline/glow so it reads better on the night strip.
- Improved the Touch Bar scene frame with a darker outer border, inner highlight, and top shine.

What can be improved:
- Compare against fresh physical Touch Bar photos and tune individual sprite scale if any pet appears too large.
- Crop the generated bitmap concept sheet into sprite frames if the user wants more detailed art than code-drawn pixels.

What next:
- Build the app bundle, test each selected pet/background on the real Touch Bar, and adjust from photos.

### 2026-05-06 - Direct Asset Sprite Rendering

What was done:
- Added `Scripts/extract-pixel-sprites.py` to crop the generated concept sheet into 15 pet pose PNG files.
- Added the extracted sprites under `Sources/TouchBarPet/Resources/PixelArt/Sprites/`.
- Added `PetBitmapArt.swift` so the renderer directly loads and draws the extracted asset sprites for each selected pet and behavior.
- Kept the code-drawn `PetPixelArt` sprites as a fallback if a bitmap asset is missing.
- Updated `Package.swift` so SwiftPM copies resources.
- Updated `Scripts/build-app.sh` so the clickable app bundle includes the sprite PNG resources.

What can be improved:
- Extract the background strips from the concept sheet and use them as bitmap scene backgrounds.
- Fine-tune crop rectangles if physical Touch Bar photos show unwanted dark edges or extra pixels.
- Hand-clean transparent sprite edges if the automatic flood-fill cleanup is not perfect.

What next:
- Build the app bundle, run it, and compare the asset sprites on the real Touch Bar.

### 2026-05-06 - Bitmap Movement Jitter Fix

What was done:
- Fixed a movement bug caused by different bitmap frame crop sizes.
- Changed `PetBitmapArt` so each species draws inside a stable slot size instead of changing the sprite width/height every frame.
- Bottom-centered each bitmap frame inside its slot so idle, walk, sleep, puff, dash, and fire frames do not shift the pet position.
- Centered bitmap sprites in the compact tray item and preview window using the same stable size calculation.

What can be improved:
- Use hand-cleaned sprite canvases with identical dimensions for every frame of a species.
- Tune per-species slot sizes from another physical Touch Bar video/photo if the pet looks too small or too large.

What next:
- Rebuild and test the Touch Bar movement again with the asset sprites.
