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

        let trackRect = NSRect(x: 0, y: 2, width: 500, height: 26)
        drawTrack(in: trackRect)
        PetPixelArt.drawPet(
            species: state.species,
            state: state,
            origin: NSPoint(x: 300, y: 7),
            scale: 2.35
        )
        drawStats(in: NSRect(x: 520, y: 3, width: 330, height: 24))
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
        NSColor(calibratedWhite: 1.0, alpha: 0.65).setFill()
        for x in stride(from: rect.minX + 28, to: rect.maxX - 30, by: 76) {
            NSRect(x: x, y: rect.minY + 7, width: 2, height: 2).fill()
            NSRect(x: x + 7, y: rect.minY + 13, width: 2, height: 2).fill()
        }

        NSColor(calibratedRed: 0.04, green: 0.35, blue: 0.50, alpha: 0.45).setFill()
        for x in stride(from: rect.minX + 54, to: rect.maxX - 60, by: 118) {
            NSBezierPath(ovalIn: NSRect(x: x, y: rect.minY + 11, width: 18, height: 7)).fill()
        }
    }

    private func drawNightDetails(in rect: NSRect) {
        NSColor(calibratedRed: 1.0, green: 0.88, blue: 0.36, alpha: 1.0).setFill()
        NSBezierPath(ovalIn: NSRect(x: rect.minX + 42, y: rect.minY + 5, width: 11, height: 11)).fill()

        NSColor.white.withAlphaComponent(0.75).setFill()
        for x in stride(from: rect.minX + 86, to: rect.maxX - 24, by: 58) {
            NSRect(x: x, y: rect.minY + 8, width: 2, height: 2).fill()
        }
    }

    private func drawGrassDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.18, green: 0.52, blue: 0.12, alpha: 0.75).setFill()
        for x in stride(from: rect.minX + 8, to: rect.maxX - 8, by: 12) {
            NSRect(x: x, y: rect.maxY - 6, width: 3, height: 5).fill()
        }

        NSColor.white.withAlphaComponent(0.9).setFill()
        for x in stride(from: rect.minX + 44, to: rect.maxX - 30, by: 96) {
            NSRect(x: x, y: rect.minY + 11, width: 3, height: 3).fill()
        }
    }

    private func drawCozyDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.26, green: 0.12, blue: 0.06, alpha: 0.5).setFill()
        for x in stride(from: rect.minX, to: rect.maxX, by: 28) {
            NSRect(x: x, y: rect.midY, width: 22, height: 1).fill()
        }

        NSColor(calibratedRed: 1.0, green: 0.52, blue: 0.08, alpha: 0.9).setFill()
        NSBezierPath(ovalIn: NSRect(x: rect.minX + 245, y: rect.minY + 8, width: 24, height: 10)).fill()
    }

    private func drawStats(in rect: NSRect) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: 18, weight: .semibold),
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
