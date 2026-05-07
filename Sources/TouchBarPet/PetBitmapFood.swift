import AppKit

@MainActor
enum PetBitmapFood {
    private static var imageCache: [String: NSImage] = [:]

    @discardableResult
    static func drawFood(species: PetSpecies, centeredAt center: NSPoint) -> Bool {
        guard let image = image(for: imageName(for: species)) else {
            return false
        }

        let rect = drawRect(for: image, species: species, centeredAt: center)

        NSColor.black.withAlphaComponent(0.20).setFill()
        NSBezierPath(
            ovalIn: NSRect(
                x: center.x - rect.width * 0.28,
                y: rect.maxY - 2,
                width: rect.width * 0.56,
                height: 2.5
            )
        ).fill()

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current?.imageInterpolation = .none
        image.draw(
            in: rect,
            from: .zero,
            operation: .sourceOver,
            fraction: 1,
            respectFlipped: true,
            hints: [.interpolation: NSImageInterpolation.none]
        )
        NSGraphicsContext.restoreGraphicsState()

        return true
    }

    private static func drawRect(for image: NSImage, species: PetSpecies, centeredAt center: NSPoint) -> NSRect {
        let maxSize = maximumSize(for: species)
        let ratio = image.size.width / max(image.size.height, 1)
        var width = maxSize.height * ratio
        var height = maxSize.height

        if width > maxSize.width {
            width = maxSize.width
            height = width / max(ratio, 0.01)
        }

        return NSRect(
            x: center.x - width / 2,
            y: center.y - height / 2 + verticalOffset(for: species),
            width: width,
            height: height
        )
    }

    private static func maximumSize(for species: PetSpecies) -> NSSize {
        switch species {
        case .cat:
            return NSSize(width: 28, height: 18)
        case .pufferFish:
            return NSSize(width: 30, height: 21)
        case .ghost:
            return NSSize(width: 25, height: 22)
        case .dragon:
            return NSSize(width: 25, height: 21)
        case .plantBuddy:
            return NSSize(width: 27, height: 21)
        }
    }

    private static func verticalOffset(for species: PetSpecies) -> CGFloat {
        switch species {
        case .cat, .pufferFish:
            return 0
        case .ghost:
            return -1
        case .dragon:
            return -0.5
        case .plantBuddy:
            return -1
        }
    }

    private static func imageName(for species: PetSpecies) -> String {
        switch species {
        case .cat:
            return "cat-fish"
        case .pufferFish:
            return "puffer-pellets"
        case .ghost:
            return "ghost-star"
        case .dragon:
            return "dragon-meat"
        case .plantBuddy:
            return "plant-water"
        }
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
            subdirectory: "PixelArt/Foods"
        ) {
            return bundledURL
        }

        let sourceResourceURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/PixelArt/Foods/\(name).png")

        if FileManager.default.fileExists(atPath: sourceResourceURL.path) {
            return sourceResourceURL
        }

        return nil
    }
}
