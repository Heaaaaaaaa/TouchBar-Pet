import AppKit

@MainActor
final class PetTouchBarSceneView: NSView {
    var state: PetState = .initial {
        didSet {
            setAccessibilityLabel(state.touchBarStatsLine)
            needsDisplay = true
        }
    }

    var onTap: (() -> Void)?

    override var isFlipped: Bool {
        true
    }

    override var intrinsicContentSize: NSSize {
        NSSize(width: 860, height: 30)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func mouseDown(with event: NSEvent) {
        onTap?()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let statsWidth: CGFloat = bounds.width >= 780 ? 265 : 210
        let trackWidth = max(360, bounds.width - statsWidth - 14)
        let trackRect = NSRect(x: 0, y: 1, width: trackWidth, height: 28)
        let petScale = scaleForCurrentSpecies()
        let petOrigin = petOrigin(in: trackRect, scale: petScale)

        drawTrack(in: trackRect)
        drawInteractionCue(in: trackRect, petOrigin: petOrigin, scale: petScale)
        drawPetShadow(in: trackRect, petOrigin: petOrigin, scale: petScale)
        PetPixelArt.drawPet(
            species: state.species,
            state: state,
            origin: petOrigin,
            scale: petScale
        )
        drawStats(in: NSRect(x: trackRect.maxX + 14, y: 3, width: statsWidth, height: 24))
    }

    private func drawTrack(in rect: NSRect) {
        let path = NSBezierPath(roundedRect: rect, xRadius: 8, yRadius: 8)
        color(for: state.activeBackground).setFill()
        path.fill()

        drawBackgroundDetails(in: rect, background: state.activeBackground)

        NSColor(calibratedWhite: 1.0, alpha: 0.28).setStroke()
        path.lineWidth = 1
        path.stroke()
    }

    private func color(for background: PetBackground) -> NSColor {
        switch background {
        case .auto:
            return color(for: state.species.defaultBackground)
        case .aquarium:
            return NSColor(calibratedRed: 0.16, green: 0.88, blue: 0.98, alpha: 1.0)
        case .night:
            return NSColor(calibratedRed: 0.08, green: 0.10, blue: 0.34, alpha: 1.0)
        case .grass:
            return NSColor(calibratedRed: 0.34, green: 0.78, blue: 0.24, alpha: 1.0)
        case .cozy:
            return NSColor(calibratedRed: 0.46, green: 0.24, blue: 0.12, alpha: 1.0)
        }
    }

    private func drawBackgroundDetails(in rect: NSRect, background: PetBackground) {
        switch background {
        case .auto:
            drawBackgroundDetails(in: rect, background: state.species.defaultBackground)
        case .aquarium:
            drawAquariumDetails(in: rect)
        case .night:
            drawNightDetails(in: rect)
        case .grass:
            drawGrassDetails(in: rect)
        case .cozy:
            drawCozyDetails(in: rect)
        }
    }

    private func drawAquariumDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.04, green: 0.62, blue: 0.74, alpha: 0.35).setFill()
        for y in stride(from: rect.minY + 6, to: rect.maxY - 4, by: 5) {
            NSRect(x: rect.minX + 5, y: y, width: rect.width - 10, height: 1).fill()
        }

        NSColor(calibratedWhite: 1.0, alpha: 0.65).setFill()
        for x in stride(from: rect.minX + 28, to: rect.maxX - 30, by: 76) {
            NSRect(x: x, y: rect.minY + 7, width: 2, height: 2).fill()
            NSRect(x: x + 7, y: rect.minY + 13, width: 2, height: 2).fill()
            NSRect(x: x + 12, y: rect.minY + 5, width: 2, height: 2).fill()
        }

        NSColor(calibratedRed: 0.04, green: 0.35, blue: 0.50, alpha: 0.45).setFill()
        for x in stride(from: rect.minX + 54, to: rect.maxX - 60, by: 118) {
            NSBezierPath(ovalIn: NSRect(x: x, y: rect.minY + 11, width: 18, height: 7)).fill()
        }

        NSColor(calibratedRed: 0.12, green: 0.38, blue: 0.42, alpha: 0.7).setFill()
        for x in stride(from: rect.minX + 62, to: rect.maxX - 40, by: 180) {
            NSRect(x: x, y: rect.maxY - 5, width: 18, height: 3).fill()
        }
    }

    private func drawNightDetails(in rect: NSRect) {
        NSColor(calibratedRed: 1.0, green: 0.88, blue: 0.36, alpha: 1.0).setFill()
        NSBezierPath(ovalIn: NSRect(x: rect.minX + 42, y: rect.minY + 5, width: 11, height: 11)).fill()

        NSColor.white.withAlphaComponent(0.82).setFill()
        for x in stride(from: rect.minX + 86, to: rect.maxX - 24, by: 58) {
            NSRect(x: x, y: rect.minY + 8, width: 2, height: 2).fill()
            NSRect(x: x + 28, y: rect.minY + 17, width: 2, height: 2).fill()
        }

        NSColor(calibratedRed: 0.22, green: 0.20, blue: 0.55, alpha: 0.72).setFill()
        for x in stride(from: rect.minX + 120, to: rect.maxX - 80, by: 250) {
            NSRect(x: x, y: rect.maxY - 7, width: 44, height: 3).fill()
            NSRect(x: x + 8, y: rect.maxY - 10, width: 24, height: 3).fill()
        }
    }

    private func drawGrassDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.46, green: 0.90, blue: 0.42, alpha: 0.28).setFill()
        for y in stride(from: rect.minY + 5, to: rect.maxY - 6, by: 3) {
            NSRect(x: rect.minX + 5, y: y, width: rect.width - 10, height: 1).fill()
        }

        NSColor(calibratedRed: 0.18, green: 0.52, blue: 0.12, alpha: 0.75).setFill()
        for x in stride(from: rect.minX + 8, to: rect.maxX - 8, by: 12) {
            NSRect(x: x, y: rect.maxY - 6, width: 3, height: 5).fill()
        }

        NSColor.white.withAlphaComponent(0.9).setFill()
        for x in stride(from: rect.minX + 44, to: rect.maxX - 30, by: 96) {
            NSRect(x: x, y: rect.minY + 11, width: 3, height: 3).fill()
        }

        NSColor(calibratedRed: 0.74, green: 0.82, blue: 0.28, alpha: 0.8).setFill()
        for x in stride(from: rect.minX + 92, to: rect.maxX - 40, by: 180) {
            NSRect(x: x, y: rect.maxY - 8, width: 14, height: 3).fill()
        }
    }

    private func drawCozyDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.74, green: 0.38, blue: 0.12, alpha: 0.42).setFill()
        NSRect(x: rect.minX + 4, y: rect.minY + 4, width: rect.width - 8, height: rect.height - 8).fill()

        NSColor(calibratedRed: 0.26, green: 0.12, blue: 0.06, alpha: 0.5).setFill()
        for x in stride(from: rect.minX, to: rect.maxX, by: 28) {
            NSRect(x: x, y: rect.midY, width: 22, height: 1).fill()
        }

        NSColor(calibratedRed: 1.0, green: 0.52, blue: 0.08, alpha: 0.9).setFill()
        NSBezierPath(ovalIn: NSRect(x: rect.minX + 245, y: rect.minY + 8, width: 24, height: 10)).fill()

        NSColor(calibratedRed: 0.52, green: 0.12, blue: 0.08, alpha: 0.72).setFill()
        for x in stride(from: rect.minX + 80, to: rect.maxX - 60, by: 260) {
            NSRect(x: x, y: rect.maxY - 8, width: 54, height: 4).fill()
        }
    }

    private func scaleForCurrentSpecies() -> CGFloat {
        switch state.species {
        case .cat:
            return 2.75
        case .pufferFish:
            return state.behaviorMode == .special || state.hunger > 72 ? 2.55 : 3.0
        case .ghost:
            return 2.95
        case .dragon:
            return 2.55
        case .plantBuddy:
            return 2.65
        }
    }

    private func petOrigin(in rect: NSRect, scale: CGFloat) -> NSPoint {
        let spriteWidth = nominalSpriteWidth(for: state.species, scale: scale)
        let xInset = max(spriteWidth + 8, 28)
        let x = rect.minX + xInset + CGFloat(state.positionX) * max(1, rect.width - xInset * 2)
        let baseY = rect.maxY - nominalSpriteHeight(for: state.species, scale: scale) - 4
        let bob = verticalMotion()

        return NSPoint(x: x - spriteWidth / 2, y: baseY + bob)
    }

    private func nominalSpriteWidth(for species: PetSpecies, scale: CGFloat) -> CGFloat {
        switch species {
        case .cat:
            return 10.0 * scale
        case .pufferFish:
            return 9.0 * scale
        case .ghost:
            return 8.0 * scale
        case .dragon:
            return 12.0 * scale
        case .plantBuddy:
            return 8.0 * scale
        }
    }

    private func nominalSpriteHeight(for species: PetSpecies, scale: CGFloat) -> CGFloat {
        switch species {
        case .cat:
            return 6.0 * scale
        case .pufferFish:
            return (state.behaviorMode == .special || state.hunger > 72 ? 7.0 : 5.0) * scale
        case .ghost:
            return 6.0 * scale
        case .dragon:
            return 7.0 * scale
        case .plantBuddy:
            return 7.0 * scale
        }
    }

    private func verticalMotion() -> CGFloat {
        let frame = Double(state.animationFrame)

        switch state.species {
        case .cat:
            return state.behaviorMode == .play ? -5 : 0
        case .pufferFish:
            return CGFloat(sin(frame * 0.9) * 2.2)
        case .ghost:
            let float = CGFloat(sin(frame * 0.7) * 2.7)
            return state.behaviorMode == .special ? float - 2 : float
        case .dragon:
            return state.behaviorMode == .special ? CGFloat(sin(frame * 1.2) * 2.5) - 3 : 0
        case .plantBuddy:
            return 0
        }
    }

    private func drawInteractionCue(in rect: NSRect, petOrigin: NSPoint, scale: CGFloat) {
        if state.behaviorMode == .eat {
            drawSnack(in: rect)
        }

        if state.behaviorMode == .sleep {
            drawTinyText(
                "z",
                at: NSPoint(x: petOrigin.x + nominalSpriteWidth(for: state.species, scale: scale) + 4, y: rect.minY + 4),
                size: 12,
                color: NSColor(calibratedRed: 0.70, green: 0.90, blue: 1.0, alpha: 0.95)
            )
        }

        if state.behaviorMode == .special && state.species == .ghost {
            drawSparkle(at: NSPoint(x: petOrigin.x - 8, y: rect.minY + 9))
            drawSparkle(at: NSPoint(x: petOrigin.x + 28, y: rect.minY + 5))
        }
    }

    private func drawSnack(in rect: NSRect) {
        let snackX = rect.minX + CGFloat(snackPositionX(for: state.species)) * rect.width
        let snackY = rect.midY - 3

        switch state.species {
        case .cat:
            NSColor(calibratedRed: 0.16, green: 0.50, blue: 0.70, alpha: 1.0).setFill()
            NSRect(x: snackX, y: snackY, width: 11, height: 5).fill()
            NSRect(x: snackX - 3, y: snackY + 1, width: 3, height: 3).fill()
        case .pufferFish:
            NSColor(calibratedRed: 1.0, green: 0.86, blue: 0.20, alpha: 1.0).setFill()
            NSRect(x: snackX, y: snackY, width: 5, height: 5).fill()
        case .ghost:
            drawSparkle(at: NSPoint(x: snackX, y: snackY))
        case .dragon:
            NSColor(calibratedRed: 0.95, green: 0.30, blue: 0.08, alpha: 1.0).setFill()
            NSRect(x: snackX, y: snackY, width: 8, height: 6).fill()
            NSColor(calibratedRed: 1.0, green: 0.80, blue: 0.28, alpha: 1.0).setFill()
            NSRect(x: snackX + 2, y: snackY + 1, width: 3, height: 3).fill()
        case .plantBuddy:
            NSColor(calibratedRed: 0.40, green: 0.90, blue: 1.0, alpha: 1.0).setFill()
            NSRect(x: snackX, y: snackY - 5, width: 3, height: 6).fill()
            NSRect(x: snackX + 4, y: snackY - 1, width: 3, height: 6).fill()
        }
    }

    private func drawPetShadow(in rect: NSRect, petOrigin: NSPoint, scale: CGFloat) {
        guard state.species != .ghost else {
            return
        }

        NSColor.black.withAlphaComponent(0.22).setFill()
        let width = nominalSpriteWidth(for: state.species, scale: scale) * 0.75
        NSBezierPath(ovalIn: NSRect(x: petOrigin.x + width * 0.15, y: rect.maxY - 5, width: width, height: 3)).fill()
    }

    private func drawSparkle(at point: NSPoint) {
        NSColor(calibratedRed: 1.0, green: 0.90, blue: 0.32, alpha: 1.0).setFill()
        NSRect(x: point.x + 2, y: point.y, width: 2, height: 6).fill()
        NSRect(x: point.x, y: point.y + 2, width: 6, height: 2).fill()
    }

    private func drawTinyText(_ text: String, at point: NSPoint, size: CGFloat, color: NSColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: size, weight: .bold),
            .foregroundColor: color
        ]

        NSString(string: text).draw(at: point, withAttributes: attributes)
    }

    private func snackPositionX(for species: PetSpecies) -> Double {
        switch species {
        case .cat:
            return 0.76
        case .pufferFish:
            return 0.68
        case .ghost:
            return 0.72
        case .dragon:
            return 0.70
        case .plantBuddy:
            return 0.50
        }
    }

    private func drawStats(in rect: NSRect) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraph
        ]

        NSString(string: state.touchBarStatsLine).draw(
            with: rect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes
        )
    }

}
