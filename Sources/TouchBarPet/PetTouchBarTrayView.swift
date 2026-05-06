import AppKit

@MainActor
final class PetTouchBarTrayView: NSButton {
    var petState: PetState = .initial {
        didSet {
            setAccessibilityLabel("TouchBar Pet. \(petState.touchBarStatsLine)")
            needsDisplay = true
        }
    }

    var onTap: (() -> Void)?

    override var isFlipped: Bool {
        true
    }

    override var intrinsicContentSize: NSSize {
        NSSize(width: 46, height: 30)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        title = ""
        isBordered = false
        bezelStyle = .regularSquare
        target = self
        action = #selector(tapped)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        nil
    }

    @objc private func tapped() {
        onTap?()
    }

    override func draw(_ dirtyRect: NSRect) {
        let background = NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 2), xRadius: 7, yRadius: 7)
        trayColor(for: petState.activeBackground).setFill()
        background.fill()

        PetPixelArt.drawPet(
            species: petState.species,
            state: petState,
            origin: NSPoint(x: 13, y: 8),
            scale: 2.0
        )
    }

    private func trayColor(for background: PetBackground) -> NSColor {
        switch background {
        case .auto:
            return trayColor(for: petState.species.defaultBackground)
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
}
