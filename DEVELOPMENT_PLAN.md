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

### 2026-05-06 - Asset Pose Flicker Fix

What was done:
- Inspected the new physical Touch Bar video in QuickTime using Computer Use.
- Confirmed the visible movement issue was not only crop-size jitter: the renderer was also alternating incompatible asset poses every animation frame.
- Stopped Cat from rapidly switching between `cat-walk` and `cat-idle` while moving.
- Stopped Ghost from rapidly switching between `ghost-dash` and `ghost-idle` while moving.
- Stopped Dragon from rapidly switching between `dragon-run` and `dragon-idle` while moving.
- Each behavior now keeps one stable bitmap pose until the behavior mode changes.

What can be improved:
- Generate or hand-draw true same-canvas walk animation frames for each pet.
- Add subtle code-driven bobbing/shadow movement so a single moving pose still feels alive without flicker.

What next:
- Rebuild and compare against the next physical Touch Bar video.

### 2026-05-07 - Natural Bitmap Motion Layer

What was done:
- Inspected the latest physical Touch Bar video in QuickTime using Computer Use.
- Confirmed the remaining issue: the pet looked like a static sticker sliding across the strip.
- Increased the redraw loop from roughly 12 FPS to 18 FPS.
- Added procedural motion on top of bitmap sprites:
  - Cat gets walk bob, squash/stretch, and small body tilt.
  - Puffer Fish gets swim bob, side wobble, and puff pulsing.
  - Ghost gets float, subtle fade, and drift.
  - Dragon gets run bounce, hover, and tilt.
  - Plant Buddy gets gentle sway.
- Added a matching animated shadow so walking/flying feels less pasted onto the strip.

What can be improved:
- Replace procedural transforms with true same-canvas multi-frame sprite sheets later.
- Add a Smooth/Low Power menu setting if 18 FPS is too much for the Touch Bar.

What next:
- Test another short physical Touch Bar video and tune motion strength from what is visible.

### 2026-05-07 - Clean Ghost Crops And Compact Stats

What was done:
- Tightened the generated ghost sprite crop rectangles so `ghost-idle`, `ghost-dash`, and `ghost-sleep` no longer include dragon-row pixels below the ghost.
- Regenerated all extracted asset sprites with `Scripts/extract-pixel-sprites.py`.
- Shortened Touch Bar stats from long words to compact labels such as `Gl8 Hu2 Mo7`.
- Reduced the Touch Bar stats font size and moved the stats closer to the scene strip so the text is less likely to be hidden by the Control Strip.

What can be improved:
- Hand-clean the extracted PNG edges if any source-sheet background pixels remain visible.
- Add a user setting to hide stats entirely if the Control Strip leaves too little room.

What next:
- Test the ghost again on the physical Touch Bar and confirm the stat text is readable.

### 2026-05-07 - Inline Touch Bar Status Badge

What was done:
- Moved the Touch Bar status text into the pet scene strip instead of drawing it beside the strip near the Control Strip.
- Shortened the status labels again to compact forms such as `G10 H2 M7`.
- Capped the drawn scene width so the status badge stays in the visible Touch Bar area even when macOS clips trailing content.
- Reserved space inside the scene track so the pet movement does not run under the status badge.

What can be improved:
- Add a menu toggle to hide the status badge completely for users who want maximum pet/background space.
- Add an auto-width badge if future stats need longer names or icons.

What next:
- Rebuild the app bundle, reopen it, and verify from a physical Touch Bar photo that the compact badge is visible.

### 2026-05-07 - Wider Scene And Clearer Badge

What was done:
- Extended the Touch Bar scene width after confirming the inline badge no longer needs a separate right-side status item.
- Increased the safe scene cap so the bar reaches farther across the Touch Bar while still leaving room before the Control Strip.
- Changed stat labels to clearer colon-separated text such as `P:0 H:10 C:0`.
- Made the status capsule darker, wider, slightly taller, and used heavier white monospaced text with a small shadow.

What can be improved:
- Add small stat icons later if letter labels still feel unclear on the physical Touch Bar.
- Tune the exact scene cap again from another straight-on Touch Bar photo.

What next:
- Rebuild the app bundle and verify the aquarium background/status badge on the physical Touch Bar.

### 2026-05-07 - README Status Legend

What was done:
- Added a README section explaining the Touch Bar status badge.
- Documented that badge numbers run from `0` to `10`.
- Clarified that `H` is hunger, so higher `H` means the pet is more hungry.
- Listed the per-species stat letters for Cat, Puffer Fish, Ghost, Dragon, and Plant Buddy.

What can be improved:
- Replace letter labels with tiny stat icons in the Touch Bar UI if the text remains hard to remember.

What next:
- Keep the README legend in sync if the badge labels change again.

### 2026-05-07 - Asset Background Rendering

What was done:
- Extended the extraction script so it crops aquarium, night, grass, and cozy room Touch Bar strips from the generated asset sheet.
- Added `PetBitmapBackground.swift` to load and draw the extracted background PNGs.
- Updated the Touch Bar scene renderer so bitmap backgrounds are used first, with the old AppKit-drawn backgrounds kept as fallback.
- Documented the new `PixelArt/Backgrounds` resource folder in the asset README.

What can be improved:
- Tune each background crop from another physical Touch Bar photo if any edge pixels look too thick after scaling.
- Add an optional lower-detail mode if the asset strips look too busy behind the moving pet and status badge.

What next:
- Rebuild the app bundle and compare all four backgrounds on the physical Touch Bar.

### 2026-05-07 - Pet Activity And Sleep Logic

What was done:
- Slowed the care/stat tick from `1.5` seconds to `3.0` seconds so pets do not get tired too quickly.
- Added a clearer activity cycle: pets spend a longer stretch moving, then idle briefly.
- Added sleep hysteresis: pets sleep only when energy is `18` or lower and stay asleep until energy recovers to `58`.
- Made sleep recover energy faster than normal activity drains it, so sleep feels like a real nap instead of flickering.
- Kept Plant Buddy centered during play/flowering so the pot does not slide across the Touch Bar like a walking pet.

What can be improved:
- Add a menu item to reset the pet's hunger, mood, and energy for testing.
- Add per-species logic later, such as puffer fish swimming more often and ghost sleeping less often.

What next:
- Rebuild the app bundle and watch a longer physical Touch Bar test to tune the exact sleep timing.

### 2026-05-07 - Compact Species Logic Pass

What was done:
- Refactored pet behavior into compact species profiles for movement speed, default position, snack position, activity cycle, sleep threshold, wake threshold, and energy drain/recovery.
- Added species-specific touch effects for Tap, Feed, Play, and Rest.
- Changed scene tap from generic Play to a dedicated pet tap action:
  - Cat jumps toward a toy dot.
  - Puffer Fish puffs and shows bubbles.
  - Ghost says `boo` and sparkles.
  - Dragon breathes fire.
  - Plant Buddy opens toward sun/sparkles.
- Added species-specific action cues in the Touch Bar scene.
- Updated the main-window status line to use the four best stats from `PET_DESIGN_PLAN.md`, while keeping the Touch Bar badge to the most readable three stats.

What can be improved:
- Add true additional sprite frames for cat stretch, fish loop, ghost shy/hide, dragon wing flap, and plant closed-flower rest.
- Add a small reset/debug action for testing all stats without waiting.

What next:
- Rebuild and test each pet's tap/feed/play/rest behavior on the physical Touch Bar.

### 2026-05-07 - Window Close Recovery Fix

What was done:
- Changed the red window close button to hide the window instead of closing/releasing it.
- Kept the `PetWindowController` window alive with `isReleasedWhenClosed = false`.
- Added a window-hidden callback so closing or hiding the window immediately asks the persistent Touch Bar pet to reappear.
- Made `PetTouchBarController.presentPersistentTouchBar()` recover from stale persistent Touch Bar state by removing and reinstalling the persistent tray item if the first present call fails.

What can be improved:
- Add a small debug log or menu item showing whether private Touch Bar present/install calls succeed.
- Consider separating the window fallback Touch Bar object from the persistent Touch Bar object if future AppKit focus changes still disturb persistence.

What next:
- Rebuild the app bundle, open Show Window, press the red close button, then use `TBP` -> `Show Touch Bar Pet` to confirm the bar returns.

### 2026-05-07 - Separate Persistent And Window Touch Bars

What was done:
- Inspected the physical Touch Bar video and confirmed the failure path: the pet is visible, the app window is shown/closed, then `Show Touch Bar Pet` leaves the Touch Bar on system controls.
- Split the persistent Touch Bar and the window fallback Touch Bar into separate `NSTouchBar` instances.
- Split the scene view into separate persistent/window scene views so AppKit window focus/close behavior cannot detach the persistent scene view.
- Changed `TBP` -> `Show Touch Bar Pet`, Hide Window, and red-close recovery to force-remove/reinstall the persistent tray item and create fresh persistent `NSTouchBar` and scene-view objects before presenting.

What can be improved:
- Add a visible debug/status menu item for the private install and present return values.
- If macOS still refuses the private persistent bar after window focus changes, add a stronger reset action that recreates the tray view and private API bridge state too.

What next:
- Rebuild and retest the same video path: show pet, show window, close window, then click `Show Touch Bar Pet`.

### 2026-05-07 - Inline Touch Bar Actions

What was done:
- Changed the drawn Touch Bar pet strip from a passive view into a touchable control.
- Added inline `Feed`, `Play`, and `Rest` chips inside the Touch Bar scene so the physical Touch Bar can trigger care actions without opening the window.
- Kept tapping the moving pet/scene area mapped to the species-specific pet tap action from `PET_DESIGN_PLAN.md`.
- Removed the separate trailing Touch Bar action buttons from the default layout so the inline scene has enough visible width before the Control Strip.

What can be improved:
- Replace text chips with tiny pixel icons if the labels feel too busy on the physical Touch Bar.
- Add pressed/highlight feedback on the chip that was touched.

What next:
- Rebuild the app bundle and physically test tap scene, Feed, Play, and Rest from the Touch Bar while the app window is hidden.

### 2026-05-07 - Natural Scene Touch Interaction

What was done:
- Replaced the visible inline action chips with gesture-style scene touches.
- Touching the pet now plays with it.
- Touching empty space on the Touch Bar strip drops food at that exact horizontal spot.
- Added `snackPositionX` to saved pet state so the food cue and movement target can follow the user's touch.
- Updated eating movement so pets walk/swim/fly toward the placed food instead of using only a fixed snack position.
- Chose the right-side status badge as the rest/sleep touch zone, keeping Rest available without another button.

What can be improved:
- Add a tiny non-text sleep icon near the status badge if the rest touch zone is not discoverable enough.
- Delay hunger reduction until the pet actually reaches the food if a stricter simulation feels better.

What next:
- Rebuild the app bundle and physically test three Touch Bar gestures: pet touch, empty-space food placement, and status-badge rest.

### 2026-05-07 - Physical Touch Event Receiver Fix

What was done:
- Inspected the user's physical Touch Bar video and confirmed the pet scene stayed visible but touches did not change behavior.
- Changed `PetTouchBarSceneView` back to a custom drawn `NSButton`, which is a more reliable event receiver for physical Touch Bar items than a plain custom control.
- Renamed the scene's pet data property from `state` to `petState` so it no longer collides with `NSButton.state`.
- Routed button press events through the existing gesture hit zones: pet play, empty-space food placement, and status-badge rest.

What can be improved:
- Add a temporary debug flash or small cue on touch if physical testing still makes it hard to tell whether an event fired.
- Add an optional debug menu that shows the last Touch Bar action received.

What next:
- Rebuild the app bundle, quit the old app, reopen the rebuilt app, and retest physical Touch Bar touches.

### 2026-05-07 - Food Placement Hit Zones

What was done:
- Adjusted the physical Touch Bar interaction after testing showed every touch fired Play because the single scene button did not provide reliable touch coordinates.
- Changed the scene back to a custom drawn `NSView`, but added invisible `NSButton` overlay zones so the physical Touch Bar still receives standard button actions.
- Added 12 hidden food zones across the motion track; tapping empty track space now feeds at the touched zone's midpoint.
- Added a hidden moving pet button above the food zones so touching the pet still plays.
- Kept the hidden status badge button for Rest.

What can be improved:
- Increase the number of food zones if the food placement feels too coarse.
- Add a tiny flash at the chosen food position so touch feedback is obvious even before the pet arrives.

What next:
- Rebuild, reopen the app, and test touching left/middle/right empty spaces to confirm food appears in different positions.

### 2026-05-07 - Refined Pixel Food Design

What was done:
- Replaced simple block snacks with species-specific pixel food drawings.
- Cat now gets a tiny blue fish snack with tail, stripe, and eye.
- Puffer Fish gets glowing golden pellet clusters.
- Ghost gets a glowing soul-star snack.
- Dragon gets a small flame/meat snack.
- Plant Buddy gets water-drop food with a small green sprout cue.
- Added shared snack glow and shadow helpers so placed food reads clearly on bright and dark backgrounds.

What can be improved:
- Extract food sprites from a generated asset sheet later if the code-drawn versions still look too simple.
- Add a short sparkle/flash when food is first placed.

What next:
- Rebuild the app bundle and test each pet species on the physical Touch Bar.
