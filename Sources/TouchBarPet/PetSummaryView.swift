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

        drawCentered(
            state.face,
            in: NSRect(x: 0, y: 6, width: bounds.width, height: 64),
            font: .monospacedSystemFont(ofSize: 42, weight: .semibold),
            color: .controlAccentColor
        )

        drawCentered(
            state.statusLine,
            in: NSRect(x: 0, y: 84, width: bounds.width, height: 28),
            font: .systemFont(ofSize: 18, weight: .semibold),
            color: .labelColor
        )

        drawCentered(
            state.careHint,
            in: NSRect(x: 0, y: 126, width: bounds.width, height: 24),
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
