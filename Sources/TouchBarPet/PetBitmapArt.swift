import AppKit

@MainActor
enum PetBitmapArt {
    private struct SpriteMotion {
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var scaleX: CGFloat = 1
        var scaleY: CGFloat = 1
        var rotationDegrees: CGFloat = 0
        var opacity: CGFloat = 1
    }

    private static var imageCache: [String: NSImage] = [:]

    static func preferredSize(species: PetSpecies, state: PetState, scale: CGFloat) -> NSSize? {
        guard image(for: spriteName(species: species, state: state)) != nil else {
            return nil
        }

        return stableSlotSize(species: species, scale: scale)
    }

    @discardableResult
    static func drawPet(species: PetSpecies, state: PetState, origin: NSPoint, scale: CGFloat) -> Bool {
        let name = spriteName(species: species, state: state)

        guard
            let image = image(for: name),
            let size = preferredSize(species: species, state: state, scale: scale)
        else {
            return false
        }

        let motion = spriteMotion(species: species, state: state, scale: scale)
        let baseRect = drawRect(for: image, species: species, state: state, in: NSRect(origin: origin, size: size))
        let rect = animatedRect(baseRect, motion: motion)
        draw(image: image, in: rect, direction: direction(for: species, state: state), motion: motion)
        return true
    }

    private static func spriteName(species: PetSpecies, state: PetState) -> String {
        switch species {
        case .cat:
            if state.behaviorMode == .sleep {
                return "cat-sleep"
            }

            if state.behaviorMode == .play || state.behaviorMode == .special || state.behaviorMode == .walk || state.behaviorMode == .eat {
                return "cat-walk"
            }

            return "cat-idle"
        case .pufferFish:
            if state.behaviorMode == .sleep {
                return "puffer-idle"
            }

            if state.behaviorMode == .special || state.hunger > 72 {
                return "puffer-puff"
            }

            if state.behaviorMode == .walk || state.behaviorMode == .eat || state.behaviorMode == .play {
                return "puffer-swim"
            }

            return "puffer-idle"
        case .ghost:
            if state.behaviorMode == .sleep {
                return "ghost-sleep"
            }

            if state.behaviorMode == .special || state.behaviorMode == .walk || state.behaviorMode == .play {
                return "ghost-dash"
            }

            return "ghost-idle"
        case .dragon:
            if state.behaviorMode == .special || state.behaviorMode == .play {
                return "dragon-fire"
            }

            if state.behaviorMode == .walk || state.behaviorMode == .eat {
                return "dragon-run"
            }

            return "dragon-idle"
        case .plantBuddy:
            if state.behaviorMode == .sleep {
                return "plant-sprout"
            }

            if state.hunger > 72 || state.energy < 22 {
                return "plant-thirsty"
            }

            if state.behaviorMode == .play || state.mood > 58 {
                return "plant-flower"
            }

            return "plant-sprout"
        }
    }

    private static func stableSlotSize(species: PetSpecies, scale: CGFloat) -> NSSize {
        switch species {
        case .cat:
            return NSSize(width: 14.8 * scale, height: 8.6 * scale)
        case .pufferFish:
            return NSSize(width: 13.4 * scale, height: 8.6 * scale)
        case .ghost:
            return NSSize(width: 11.8 * scale, height: 8.6 * scale)
        case .dragon:
            return NSSize(width: 15.8 * scale, height: 8.7 * scale)
        case .plantBuddy:
            return NSSize(width: 11.0 * scale, height: 8.7 * scale)
        }
    }

    private static func drawRect(for image: NSImage, species: PetSpecies, state: PetState, in slot: NSRect) -> NSRect {
        let maxHeight = slot.height * heightFill(species: species, state: state)
        let maxWidth = slot.width * widthFill(species: species, state: state)
        let ratio = image.size.width / max(image.size.height, 1)
        var drawHeight = maxHeight
        var drawWidth = drawHeight * ratio

        if drawWidth > maxWidth {
            drawWidth = maxWidth
            drawHeight = drawWidth / max(ratio, 0.01)
        }

        return NSRect(
            x: slot.midX - drawWidth / 2,
            y: slot.maxY - drawHeight,
            width: drawWidth,
            height: drawHeight
        )
    }

    private static func animatedRect(_ rect: NSRect, motion: SpriteMotion) -> NSRect {
        let width = rect.width * motion.scaleX
        let height = rect.height * motion.scaleY

        return NSRect(
            x: rect.midX - width / 2 + motion.offsetX,
            y: rect.maxY - height + motion.offsetY,
            width: width,
            height: height
        )
    }

    private static func heightFill(species: PetSpecies, state: PetState) -> CGFloat {
        switch species {
        case .cat:
            return state.behaviorMode == .sleep ? 0.88 : 0.98
        case .pufferFish:
            return state.behaviorMode == .special || state.hunger > 72 ? 0.98 : 0.92
        case .ghost:
            return 0.98
        case .dragon:
            return 0.98
        case .plantBuddy:
            return state.behaviorMode == .play || state.mood > 58 ? 0.98 : 0.92
        }
    }

    private static func widthFill(species: PetSpecies, state: PetState) -> CGFloat {
        switch species {
        case .dragon:
            return state.behaviorMode == .special || state.behaviorMode == .play ? 1.0 : 0.90
        case .cat:
            return state.behaviorMode == .sleep ? 0.98 : 0.92
        case .pufferFish, .ghost, .plantBuddy:
            return 0.94
        }
    }

    private static func direction(for species: PetSpecies, state: PetState) -> PetDirection {
        species == .plantBuddy ? .right : state.direction
    }

    private static func spriteMotion(species: PetSpecies, state: PetState, scale: CGFloat) -> SpriteMotion {
        let frame = Double(state.animationFrame)

        switch species {
        case .cat:
            return catMotion(state: state, frame: frame, scale: scale)
        case .pufferFish:
            return pufferMotion(state: state, frame: frame, scale: scale)
        case .ghost:
            return ghostMotion(state: state, frame: frame, scale: scale)
        case .dragon:
            return dragonMotion(state: state, frame: frame, scale: scale)
        case .plantBuddy:
            return plantMotion(state: state, frame: frame, scale: scale)
        }
    }

    private static func catMotion(state: PetState, frame: Double, scale: CGFloat) -> SpriteMotion {
        switch state.behaviorMode {
        case .walk, .eat:
            let phase = frame * .pi / 4
            let lift = abs(sin(phase)) * 0.42 * scale
            let contact = abs(cos(phase))
            return SpriteMotion(
                offsetY: -lift,
                scaleX: 1.0 + CGFloat(contact) * 0.018,
                scaleY: 1.0 - CGFloat(contact) * 0.012,
                rotationDegrees: CGFloat(sin(phase)) * 1.0
            )
        case .play, .special:
            let phase = frame * .pi / 6
            return SpriteMotion(
                offsetY: -abs(sin(phase)) * 1.1 * scale,
                scaleX: 1.0 - CGFloat(abs(sin(phase))) * 0.018,
                scaleY: 1.0 + CGFloat(abs(sin(phase))) * 0.024,
                rotationDegrees: CGFloat(sin(phase)) * 2.2
            )
        case .idle:
            let breath = CGFloat(sin(frame * .pi / 20))
            return SpriteMotion(offsetY: -breath * 0.08 * scale, scaleY: 1.0 + breath * 0.010)
        case .sleep:
            let breath = CGFloat(sin(frame * .pi / 24))
            return SpriteMotion(offsetY: -breath * 0.05 * scale, scaleX: 1.0 + breath * 0.006)
        }
    }

    private static func pufferMotion(state: PetState, frame: Double, scale: CGFloat) -> SpriteMotion {
        if state.behaviorMode == .sleep {
            let drift = CGFloat(sin(frame * .pi / 18))
            return SpriteMotion(
                offsetY: -drift * 0.16 * scale,
                scaleX: 1.0 + drift * 0.004,
                opacity: 0.82
            )
        }

        if state.behaviorMode == .special || state.hunger > 72 {
            let puff = CGFloat(sin(frame * .pi / 8))
            return SpriteMotion(
                offsetY: -puff * 0.12 * scale,
                scaleX: 1.0 + puff * 0.026,
                scaleY: 1.0 + puff * 0.026
            )
        }

        let wave = CGFloat(sin(frame * .pi / 7))
        return SpriteMotion(
            offsetX: CGFloat(cos(frame * .pi / 9)) * 0.16 * scale,
            offsetY: -wave * 0.32 * scale,
            scaleX: 1.0 + wave * 0.010,
            rotationDegrees: wave * 1.2
        )
    }

    private static func ghostMotion(state: PetState, frame: Double, scale: CGFloat) -> SpriteMotion {
        let float = CGFloat(sin(frame * .pi / 10))

        if state.behaviorMode == .special || state.behaviorMode == .play || state.behaviorMode == .walk {
            return SpriteMotion(
                offsetX: CGFloat(cos(frame * .pi / 5)) * 0.18 * scale,
                offsetY: -0.45 * scale - float * 0.32 * scale,
                scaleX: 1.0 + float * 0.012,
                scaleY: 1.0 - float * 0.010,
                opacity: 0.92 + abs(float) * 0.08
            )
        }

        return SpriteMotion(
            offsetY: -float * 0.34 * scale,
            scaleX: 1.0 + float * 0.010,
            opacity: 0.88 + abs(float) * 0.12
        )
    }

    private static func dragonMotion(state: PetState, frame: Double, scale: CGFloat) -> SpriteMotion {
        if state.behaviorMode == .special || state.behaviorMode == .play {
            let hover = CGFloat(sin(frame * .pi / 5))
            return SpriteMotion(
                offsetY: -0.7 * scale - hover * 0.32 * scale,
                scaleX: 1.0 + hover * 0.010,
                rotationDegrees: hover * 1.3
            )
        }

        if state.behaviorMode == .walk || state.behaviorMode == .eat {
            let phase = frame * .pi / 4
            let lift = abs(sin(phase)) * 0.35 * scale
            return SpriteMotion(
                offsetY: -lift,
                scaleX: 1.0 + CGFloat(abs(cos(phase))) * 0.012,
                rotationDegrees: CGFloat(sin(phase)) * 0.9
            )
        }

        return SpriteMotion(offsetY: -CGFloat(sin(frame * .pi / 18)) * 0.08 * scale)
    }

    private static func plantMotion(state: PetState, frame: Double, scale: CGFloat) -> SpriteMotion {
        let sway = CGFloat(sin(frame * .pi / 14))

        if state.hunger > 72 || state.energy < 22 {
            return SpriteMotion(offsetY: abs(sway) * 0.06 * scale, rotationDegrees: sway * 0.7)
        }

        return SpriteMotion(
            offsetY: -abs(sway) * 0.08 * scale,
            scaleX: 1.0 + sway * 0.012,
            scaleY: 1.0 - abs(sway) * 0.008,
            rotationDegrees: sway * 0.9
        )
    }

    private static func image(for name: String) -> NSImage? {
        if let cached = imageCache[name] {
            return cached
        }

        guard let url = resourceURL(for: name), let image = NSImage(contentsOf: url) else {
            return nil
        }

        imageCache[name] = image
        return image
    }

    private static func resourceURL(for name: String) -> URL? {
        if let bundledURL = Bundle.main.url(
            forResource: name,
            withExtension: "png",
            subdirectory: "PixelArt/Sprites"
        ) {
            return bundledURL
        }

        let sourceResourceURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/PixelArt/Sprites/\(name).png")

        if FileManager.default.fileExists(atPath: sourceResourceURL.path) {
            return sourceResourceURL
        }

        return nil
    }

    private static func draw(image: NSImage, in rect: NSRect, direction: PetDirection, motion: SpriteMotion) {
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current?.imageInterpolation = .none

        if direction == .left || motion.rotationDegrees != 0 {
            let signedRotation = direction == .left ? -motion.rotationDegrees : motion.rotationDegrees
            let transform = NSAffineTransform()
            transform.translateX(by: rect.midX, yBy: rect.maxY)

            if direction == .left {
                transform.scaleX(by: -1, yBy: 1)
            }

            if signedRotation != 0 {
                transform.rotate(byDegrees: signedRotation)
            }

            transform.translateX(by: -rect.midX, yBy: -rect.maxY)
            transform.concat()
        }

        image.draw(
            in: rect,
            from: .zero,
            operation: .sourceOver,
            fraction: motion.opacity,
            respectFlipped: true,
            hints: [.interpolation: NSImageInterpolation.none]
        )

        NSGraphicsContext.restoreGraphicsState()
    }
}
