# TouchBar Pet Agent Handoff

## Current State

- Repo: `https://github.com/Heaaaaaaaa/TouchBar-Pet`
- Local path: `/Users/hea/Library/CloudStorage/OneDrive-Heriot-WattUniversity/HW/TouchBar Pet`
- Branch: `main`
- Latest pushed commit before the asset-inspired movement work: `801ad21 Add selectable pixel pets and backgrounds`
- Goal: native macOS Touch Bar pet for an M1 MacBook Pro Touch Bar.
- User wants the pet to stay on the physical Touch Bar while other apps are frontmost, like Grace Avery's persistent Touchbar Pet: cyan strip, pixel pet, compact stats.

## Verified Commands

```sh
swift build
Scripts/build-app.sh
open "Build/TouchBar Pet.app"
```

`swift build` passes with full Xcode selected. `Scripts/build-app.sh` builds a clickable app bundle at `Build/TouchBar Pet.app`.

## Important Files

- `DEVELOPMENT_PLAN.md`: project plan and development log.
- `README.md`: user-facing setup/run/troubleshooting.
- `Package.swift`: SwiftPM package.
- `Scripts/build-app.sh`: fallback direct `swiftc` app-bundle builder.
- `Sources/TouchBarPet/AppDelegate.swift`: app lifecycle, timer, persistence wiring.
- `Sources/TouchBarPet/PetEngine.swift`: pet stat changes and tick loop.
- `Sources/TouchBarPet/PetState.swift`: state model, derived Touch Bar stats.
- `Sources/TouchBarPet/PetWindowController.swift`: main window UI.
- `Sources/TouchBarPet/TouchBarHostingView.swift`: first-responder view that provides custom Touch Bar.
- `Sources/TouchBarPet/PetTouchBarController.swift`: `NSTouchBarDelegate` and Touch Bar item setup.
- `Sources/TouchBarPet/PetTouchBarSceneView.swift`: cyan strip / pixel pet / stats drawing for Touch Bar.
- `Sources/TouchBarPet/PetTouchBarTrayView.swift`: compact persistent Control Strip tray item.
- `Sources/TouchBarPet/PersistentTouchBarAPI.swift`: Swift wrapper around experimental private persistent Touch Bar bridge.
- `Sources/TouchBarPrivate/`: Objective-C bridge for private Touch Bar system-tray/modal APIs.
- `PET_DESIGN_PLAN.md`: pet species and movement design plan.
- `Assets/PixelArt/pet-background-concept-sheet.png`: generated pixel-art concept sheet.
- `Assets/PixelArt/README.md`: generated asset prompt and extraction notes.
- `Sources/TouchBarPet/PetPixelArt.swift`: code-drawn pixel pets used by the Touch Bar and preview window.

## Architecture Notes

- The app is AppKit, not SwiftUI.
- It now launches as a menu-bar/accessory app with `TBP` in the menu bar and no normal window by default.
- The normal public Touch Bar fallback is provided through `TouchBarHostingView.makeTouchBar()`.
- The experimental always-present mode uses private APIs through `TouchBarPrivate`.
- The persistent Control Strip item is intentionally compact; tapping it or choosing `TBP` -> `Show Touch Bar Pet` should present the full modal Touch Bar.
- Auto-expand was removed because it interfered with other Touch Bar tools. Expansion is manual via the small tray pet or `TBP` -> `Show Touch Bar Pet`.
- `TBP` menu now has `Pet` and `Background` submenus. Species/background choices are saved in `PetState`.
- `PetWindowController.installTouchBar(_:)` sets both `window.touchBar` and the root view responder provider.
- `PetTouchBarSceneView` draws the reference-style strip manually.
- `PetState` now stores `PetBehaviorMode`, direction, normalized Touch Bar position, velocity, and action countdown so movement survives redraws/saves.
- `PetEngine` chooses walk, eat, play, sleep, and special modes during ticks and user actions.
- The app loop now calls `PetEngine.tick(elapsed:)` at roughly 12 FPS. `PetEngine` separately accumulates care/stat ticks every 1.5 seconds so animation is smooth without making hunger/energy change too fast.
- `AppDelegate` throttles state saves to every 6 seconds instead of saving on every animation frame.
- `PetPixelArt.swift` translates the generated concept sheet into larger code-drawn poses for every selected pet.
- `PetPixelArt.drawPixels` now adds a one-pixel outline pass before drawing sprite colors; use the optional `outlineColor` argument for special cases such as the ghost.
- `PetTouchBarSceneView` computes the pet position dynamically across the long strip and draws snacks, shadows, sleep cues, sparkles, and asset-inspired strip details.
- Feed, Play, and Rest are still available in the app window and as Touch Bar items after the scene where space allows.
- Saved state is stored in Application Support under `TouchBarPet/pet-state.json`.

## Known Issue / User Blocker

The user reported: Touch Bar shows the pet only when this app is frontmost, then disappears when another app comes frontmost.

Most likely causes:

- Public `NSTouchBar` is frontmost-app only by design.
- Always-present behavior requires private Touch Bar APIs and may vary by macOS version.
- A stale Xcode debug process may keep an old app copy running.
- Another app named `Touchbar Pet` with bundle id `com.graceavery.TouchbarPetPersistence` was observed previously and may conflict/confuse testing.

Tell user to check:

1. Stop old Xcode runs before testing.
2. Launch `Build/TouchBar Pet.app`.
3. Confirm `TBP` appears in the menu bar and no window opens.
4. Put Safari/Xcode/another app frontmost and watch the physical Touch Bar.
5. If it does not appear, use the `TBP` menu-bar item -> `Show Touch Bar Pet`.

## Next Best Tasks

1. Confirm whether the private persistent Touch Bar appears while another app is frontmost.
2. If not, inspect runtime availability of `presentSystemModalFunctionBar:systemTrayItemIdentifier:` and `DFRElementSetControlStripPresenceForIdentifier`.
3. Add a reset/debug action because testing can leave the pet hungry/tired.
4. Tune sprite sizes/spacing from another physical Touch Bar photo.
5. Add app icon and signing/export workflow.
6. Decide whether to keep private persistent APIs in main or make them an opt-in build.

## Do Not Forget

- Keep updating `DEVELOPMENT_PLAN.md` after each completed file/milestone.
- Run `swift build` before committing.
- Run `Scripts/build-app.sh` if the clickable app bundle needs refreshing.
- Commit and push changes to `main`.
