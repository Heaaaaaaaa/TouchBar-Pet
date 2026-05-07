# TouchBar Pet Agent Handoff

## Current State

- Repo: `https://github.com/Heaaaaaaaa/TouchBar-Pet`
- Local path: `/Users/hea/Library/CloudStorage/OneDrive-Heriot-WattUniversity/HW/TouchBar Pet`
- Branch: `main`
- Latest release: `v0.1.0`
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
- `Assets/PixelArt/food-concept-sheet.png`: generated pixel-art food concept sheet matching the pet/background asset genre.
- `Assets/PixelArt/README.md`: generated asset prompt and extraction notes.
- `Assets/AppIcon/`: generated app icon source, menu-bar icon source, and preview images.
- `Resources/AppIcon.icns`: generated macOS app icon used by the manual `.app` bundle.
- `Sources/TouchBarPet/PetPixelArt.swift`: code-drawn pixel pets used by the Touch Bar and preview window.
- `Sources/TouchBarPet/PetBitmapArt.swift`: direct PNG sprite loader/renderer for extracted concept-sheet pets.
- `Sources/TouchBarPet/PetBitmapBackground.swift`: direct PNG background-strip loader/renderer for extracted concept-sheet Touch Bar backgrounds.
- `Sources/TouchBarPet/PetBitmapFood.swift`: direct PNG food loader/renderer for extracted concept-sheet food sprites.
- `Sources/TouchBarPet/Resources/PixelArt/Sprites/`: extracted PNG pet poses used by the app.
- `Sources/TouchBarPet/Resources/PixelArt/Backgrounds/`: extracted PNG Touch Bar background strips used by the app.
- `Sources/TouchBarPet/Resources/PixelArt/Foods/`: extracted PNG food sprites used by the app.
- `Sources/TouchBarPet/Resources/Icons/menu-bar-icon.png`: 36 px transparent menu-bar template icon.
- `Scripts/extract-pixel-sprites.py`: regenerates pet, background, and food PNG assets from the generated concept sheets.
- Ghost crop rectangles are intentionally shorter than the full row so the extracted ghost sprites do not include dragon-row pixels underneath.
- Dragon fire is intentionally cropped shorter than the source sheet so the flame remains visible without becoming a large yellow block, and the next-row blue fragment does not appear under the dragon foot.
- Cozy uses the original generated room background with the fireplace. Do not flatten it back to a plain wood strip unless the user explicitly asks.
- Plant Buddy food is isolated to blue water pixels and rendered smaller than the other food sprites.

## Architecture Notes

- The app is AppKit, not SwiftUI.
- It now launches as a menu-bar/accessory app with `TBP` in the menu bar and no normal window by default.
- The menu-bar item now uses a generated template icon; `TBP` remains the tooltip/menu identity.
- The normal public Touch Bar fallback is provided through `TouchBarHostingView.makeTouchBar()`.
- The experimental always-present mode uses private APIs through `TouchBarPrivate`.
- The persistent Control Strip item is intentionally compact; tapping it or choosing `TBP` -> `Show Touch Bar Pet` should present the full modal Touch Bar.
- Auto-expand was removed because it interfered with other Touch Bar tools. Expansion is manual via the small tray pet or `TBP` -> `Show Touch Bar Pet`.
- The main window red close button is intentionally converted into hide/orderOut via `windowShouldClose`; do not let it release the window because that can detach AppKit Touch Bar state and break persistent presentation.
- `PetTouchBarController` intentionally uses separate persistent/window `NSTouchBar` objects and separate persistent/window scene views. Do not share the same scene view between the window fallback and persistent bar.
- `PetTouchBarController.presentPersistentTouchBar(forceReinstall:)` retries by removing/reinstalling the persistent tray item and creating fresh persistent `NSTouchBar`/scene-view objects if the private present call fails. Menu-driven Show/Hide Window recovery uses `forceReinstall: true`.
- `TBP` menu now has `Pet` and `Background` submenus. Species/background choices are saved in `PetState`.
- `PetWindowController.installTouchBar(_:)` sets both `window.touchBar` and the root view responder provider.
- `PetTouchBarSceneView` draws the reference-style strip manually.
- `PetState` now stores `PetBehaviorMode`, direction, normalized Touch Bar position, velocity, and action countdown so movement survives redraws/saves.
- `PetEngine` chooses walk, eat, play, sleep, and special modes during ticks and user actions. Species-specific movement/touch behavior is centralized in compact `PetProfile` and `PetActionEffect` helpers inside `PetEngine.swift`.
- `PetTouchBarSceneView` is a custom drawn `NSView` with invisible `NSButton` overlay hit zones. The moving pet has its own button for Play, the right status badge has a Rest button, and 12 hidden food-zone buttons across the empty track call `engine.feed(at:)` with their midpoint position. Keep the pet data property named `petState` if converting this view again; `NSButton` already owns `state`.
- The app loop calls `PetEngine.tick(elapsed:)` at roughly 18 FPS. `PetEngine` separately accumulates care/stat ticks every 3.0 seconds so animation is smooth without making hunger/energy change too fast.
- Automatic sleep uses species-specific hysteresis from `PetProfile`; pets enter sleep at low energy and stay asleep until the species wake threshold is reached. This avoids rapid walk/sleep flicker.
- `AppDelegate` throttles state saves to every 6 seconds instead of saving on every animation frame.
- `PetPixelArt.swift` translates the generated concept sheet into larger code-drawn poses for every selected pet.
- `PetPixelArt.drawPixels` now adds a one-pixel outline pass before drawing sprite colors; use the optional `outlineColor` argument for special cases such as the ghost.
- `PetPixelArt.drawPet(...)` first tries `PetBitmapArt.drawPet(...)`; the code-drawn sprites are now the fallback path.
- `PetTouchBarSceneView.drawTrack(...)` first tries `PetBitmapBackground.drawBackground(...)`; the old AppKit-drawn background details are now the fallback path.
- `PetTouchBarSceneView.drawSnack(...)` first tries `PetBitmapFood.drawFood(...)`; the older AppKit-drawn snacks are now the fallback path.
- `PetBitmapArt` uses stable per-species drawing slots so bitmap frames with different crop sizes do not make the pet jump during movement.
- Do not alternate incompatible bitmap poses frame-by-frame; Cat/Ghost/Dragon now keep one moving pose until the behavior mode changes.
- `PetBitmapArt` also applies procedural sprite motion over the bitmap poses: bobbing, squash/stretch, drift, hover, and plant sway. This is the current replacement for true same-canvas walk frames.
- `AppDelegate` currently redraws at roughly 18 FPS; care/stat updates are still accumulated separately in `PetEngine`.
- `PetState.touchBarStatsLine` uses compact colon labels like `G:8 H:2 M:7` because full words were clipped by the Touch Bar Control Strip.
- `PetTouchBarSceneView` draws the status as a darker in-scene badge inside a capped scene strip. Do not move it back into a separate trailing Touch Bar item unless there is a better Control Strip-safe layout.
- `Package.swift` copies `Sources/TouchBarPet/Resources`; `Scripts/build-app.sh` copies `PixelArt` into the built app bundle.
- `PetTouchBarSceneView` computes the pet position dynamically across the long strip and draws asset snacks, shadows, sleep cues, sparkles, and asset-inspired strip details.
- Touch Bar food comes from `Resources/PixelArt/Foods/`: cat fish, puffer pellets, ghost star, dragon meat, and plant water. If a PNG is missing, the code-drawn food fallback still appears.
- Feed, Play, and Rest are available in the app window and the `TBP` menu. In the expanded Touch Bar scene, avoid visible action buttons: empty-space taps place food, pet taps play, and status-badge taps rest.
- Saved state is stored in Application Support under `TouchBarPet/pet-state.json`.

## Persistent Touch Bar Caveats

The user originally reported: Touch Bar shows the pet only when this app is frontmost, then disappears when another app comes frontmost. The current app includes an experimental private persistent Touch Bar path, but this behavior is still macOS-version-sensitive.

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

1. Add a reset/debug action because testing can leave the pet hungry/tired.
2. Tune sprite sizes/spacing from more physical Touch Bar photos.
3. Add a signed/export workflow so release builds open with fewer macOS warnings.
4. Add a screenshot/GIF strip to the README release page.
5. Decide whether private persistent APIs should stay default or become an opt-in build.

## Do Not Forget

- Keep updating `DEVELOPMENT_PLAN.md` after each completed file/milestone.
- Run `swift build` before committing.
- Run `Scripts/build-app.sh` if the clickable app bundle needs refreshing.
- Commit and push changes to `main`.
