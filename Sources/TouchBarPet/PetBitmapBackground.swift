import AppKit

@MainActor
enum PetBitmapBackground {
    private static var imageCache: [String: NSImage] = [:]

    @discardableResult
    static func drawBackground(_ background: PetBackground, in rect: NSRect) -> Bool {
        guard let image = image(for: imageName(for: background)) else {
            return false
        }

        let clipPath = NSBezierPath(roundedRect: rect, xRadius: 8, yRadius: 8)

        NSGraphicsContext.saveGraphicsState()
        clipPath.addClip()
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

    private static func imageName(for background: PetBackground) -> String {
        switch background {
        case .auto:
            return "grass"
        case .aquarium:
            return "aquarium"
        case .night:
            return "night"
        case .grass:
            return "grass"
        case .cozy:
            return "cozy"
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
            subdirectory: "PixelArt/Backgrounds"
        ) {
            return bundledURL
        }

        let sourceResourceURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/PixelArt/Backgrounds/\(name).png")

        if FileManager.default.fileExists(atPath: sourceResourceURL.path) {
            return sourceResourceURL
        }

        return nil
    }
}
