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
        drawPixelPet(origin: NSPoint(x: 308, y: 6), scale: 2.4)
        drawStats(in: NSRect(x: 520, y: 3, width: 330, height: 24))
    }

    private func drawTrack(in rect: NSRect) {
        let path = NSBezierPath(roundedRect: rect, xRadius: 8, yRadius: 8)
        NSColor(calibratedRed: 0.24, green: 0.94, blue: 1.0, alpha: 1.0).setFill()
        path.fill()

        NSColor(calibratedWhite: 1.0, alpha: 0.28).setStroke()
        path.lineWidth = 1
        path.stroke()
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

    private func drawPixelPet(origin: NSPoint, scale: CGFloat) {
        let orange = NSColor(calibratedRed: 1.0, green: 0.52, blue: 0.06, alpha: 1.0)
        let darkOrange = NSColor(calibratedRed: 0.72, green: 0.28, blue: 0.02, alpha: 1.0)
        let black = NSColor.black
        let cream = NSColor(calibratedRed: 1.0, green: 0.78, blue: 0.36, alpha: 1.0)

        let pixels: [(Int, Int, NSColor)] = [
            (2, 0, orange), (3, 0, orange), (4, 0, orange), (5, 0, orange),
            (1, 1, orange), (2, 1, orange), (3, 1, cream), (4, 1, cream), (5, 1, orange), (6, 1, orange),
            (0, 2, darkOrange), (1, 2, orange), (2, 2, black), (3, 2, cream), (4, 2, black), (5, 2, orange), (6, 2, darkOrange),
            (1, 3, orange), (2, 3, cream), (3, 3, darkOrange), (4, 3, cream), (5, 3, orange),
            (2, 4, orange), (3, 4, orange), (4, 4, orange), (5, 4, orange), (6, 4, orange),
            (5, 5, darkOrange), (6, 5, orange), (7, 5, orange)
        ]

        for (x, y, color) in pixels {
            color.setFill()
            NSRect(
                x: origin.x + CGFloat(x) * scale,
                y: origin.y + CGFloat(y) * scale,
                width: scale,
                height: scale
            ).fill()
        }
    }
}
