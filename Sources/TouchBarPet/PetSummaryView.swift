import AppKit

final class PetSummaryView: NSView {
    var state: PetState = .initial {
        didSet {
            setAccessibilityLabel("\(state.face) \(state.statusLine) \(state.careHint)")
            needsDisplay = true
        }
    }

    override var isFlipped: Bool {
        true
    }

    override var intrinsicContentSize: NSSize {
        NSSize(width: 340, height: 160)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        PetPixelArt.drawPet(
            species: state.species,
            state: state,
            origin: NSPoint(x: bounds.midX - 24, y: 12),
            scale: 6
        )

        drawCentered(
            state.species.displayName,
            in: NSRect(x: 0, y: 66, width: bounds.width, height: 26),
            font: .systemFont(ofSize: 20, weight: .semibold),
            color: .controlAccentColor
        )

        drawCentered(
            state.statusLine,
            in: NSRect(x: 0, y: 98, width: bounds.width, height: 28),
            font: .systemFont(ofSize: 15, weight: .semibold),
            color: .labelColor
        )

        drawCentered(
            state.careHint,
            in: NSRect(x: 0, y: 132, width: bounds.width, height: 24),
            font: .systemFont(ofSize: 15, weight: .medium),
            color: .secondaryLabelColor
        )
    }

    private func drawCentered(
        _ text: String,
        in rect: NSRect,
        font: NSFont,
        color: NSColor
    ) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph
        ]

        NSString(string: text).draw(
            with: rect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes
        )
    }
}
