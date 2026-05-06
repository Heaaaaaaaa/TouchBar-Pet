import AppKit

@MainActor
enum PetBitmapArt {
    private static var imageCache: [String: NSImage] = [:]

    static func preferredSize(species: PetSpecies, state: PetState, scale: CGFloat) -> NSSize? {
        guard let image = image(for: spriteName(species: species, state: state)) else {
            return nil
        }

        let height = preferredHeight(species: species, state: state, scale: scale)
        let ratio = image.size.width / max(image.size.height, 1)
        return NSSize(width: height * ratio, height: height)
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

        let rect = NSRect(origin: origin, size: size)
        draw(image: image, in: rect, direction: direction(for: species, state: state))
        return true
    }

    private static func spriteName(species: PetSpecies, state: PetState) -> String {
        switch species {
        case .cat:
            if state.behaviorMode == .sleep {
                return "cat-sleep"
            }

            if state.behaviorMode == .play || state.behaviorMode == .special || state.behaviorMode == .walk {
                return state.animationFrame.isMultiple(of: 2) ? "cat-walk" : "cat-idle"
            }

            return "cat-idle"
        case .pufferFish:
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
                return state.animationFrame.isMultiple(of: 2) ? "ghost-dash" : "ghost-idle"
            }

            return "ghost-idle"
        case .dragon:
            if state.behaviorMode == .special || state.behaviorMode == .play {
                return "dragon-fire"
            }

            if state.behaviorMode == .walk || state.behaviorMode == .eat {
                return state.animationFrame.isMultiple(of: 2) ? "dragon-run" : "dragon-idle"
            }

            return "dragon-idle"
        case .plantBuddy:
            if state.hunger > 72 || state.energy < 22 {
                return "plant-thirsty"
            }

            if state.behaviorMode == .play || state.mood > 58 {
                return "plant-flower"
            }

            return "plant-sprout"
        }
    }

    private static func preferredHeight(species: PetSpecies, state: PetState, scale: CGFloat) -> CGFloat {
        switch species {
        case .cat:
            return (state.behaviorMode == .sleep ? 7.4 : 8.3) * scale
        case .pufferFish:
            return (state.behaviorMode == .special || state.hunger > 72 ? 8.4 : 7.9) * scale
        case .ghost:
            return (state.behaviorMode == .sleep ? 7.8 : 8.2) * scale
        case .dragon:
            return (state.behaviorMode == .special || state.behaviorMode == .play ? 8.2 : 8.4) * scale
        case .plantBuddy:
            return (state.behaviorMode == .play || state.mood > 58 ? 8.3 : 7.9) * scale
        }
    }

    private static func direction(for species: PetSpecies, state: PetState) -> PetDirection {
        species == .plantBuddy ? .right : state.direction
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

    private static func draw(image: NSImage, in rect: NSRect, direction: PetDirection) {
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current?.imageInterpolation = .none

        if direction == .left {
            let transform = NSAffineTransform()
            transform.translateX(by: rect.midX, yBy: rect.midY)
            transform.scaleX(by: -1, yBy: 1)
            transform.translateX(by: -rect.midX, yBy: -rect.midY)
            transform.concat()
        }

        image.draw(
            in: rect,
            from: .zero,
            operation: .sourceOver,
            fraction: 1,
            respectFlipped: true,
            hints: [.interpolation: NSImageInterpolation.none]
        )

        NSGraphicsContext.restoreGraphicsState()
    }
}
