# TouchBar Pet Agent Handoff

## Current State

- Repo: `https://github.com/Heaaaaaaaa/TouchBar-Pet`
- Local path: `/Users/hea/Library/CloudStorage/OneDrive-Heriot-WattUniversity/HW/TouchBar Pet`
- Branch: `main`
- Latest pushed commit at handoff time: `0aa3311 Add custom Touch Bar scene`
- Goal: native macOS Touch Bar pet for an M1 MacBook Pro Touch Bar.
- User wants the pet on the physical Touch Bar like the reference photo: cyan strip, pixel pet, and compact stats.

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

## Architecture Notes

- The app is AppKit, not SwiftUI.
- The custom Touch Bar is provided through `TouchBarHostingView.makeTouchBar()`.
- `PetWindowController.installTouchBar(_:)` sets both `window.touchBar` and the root view responder provider.
- `PetTouchBarSceneView` draws the reference-style strip manually.
- Feed, Play, and Rest are still available in the app window and as Touch Bar items after the scene where space allows.
- Saved state is stored in Application Support under `TouchBarPet/pet-state.json`.

## Known Issue / User Blocker

The user reported: window opens, but physical Touch Bar still shows brightness/volume controls.

Most likely causes:

- macOS Keyboard setting is showing `Expanded Control Strip` instead of app controls.
- Another app named `Touchbar Pet` with bundle id `com.graceavery.TouchbarPetPersistence` was observed running and may conflict/confuse testing.
- Xcode may remain the active app after Run; user must click the TouchBar Pet window.

Tell user to check:

1. System Settings -> Keyboard.
2. Set `Touch Bar shows` to `App Controls` or `App Controls with Control Strip`.
3. Quit other Touch Bar pet apps.
4. Run this app again and click its window.

## Next Best Tasks

1. Confirm physical Touch Bar display after the Keyboard setting change.
2. If still not visible, move Touch Bar ownership into a custom `NSWindow` or `NSViewController` subclass and test again.
3. Add a reset/debug action because testing can leave the pet hungry/tired.
4. Improve the pixel pet sprite and animation frames.
5. Add app icon and signing/export workflow.
6. Consider a menu bar companion later, but keep v1 app-focused and Apple-supported.

## Do Not Forget

- Keep updating `DEVELOPMENT_PLAN.md` after each completed file/milestone.
- Run `swift build` before committing.
- Run `Scripts/build-app.sh` if the clickable app bundle needs refreshing.
- Commit and push changes to `main`.
