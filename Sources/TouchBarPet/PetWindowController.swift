import AppKit

final class PetWindowController: NSWindowController {
    private let engine: PetEngine
    private let faceLabel = NSTextField(labelWithString: "")
    private let statusLabel = NSTextField(labelWithString: "")
    private let hintLabel = NSTextField(labelWithString: "")

    init(engine: PetEngine) {
        self.engine = engine

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 260),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "TouchBar Pet"
        window.center()

        super.init(window: window)
        buildContent(in: window)
    }

    required init?(coder: NSCoder) {
        nil
    }

    func render(_ state: PetState) {
        faceLabel.stringValue = state.face
        statusLabel.stringValue = state.statusLine
        hintLabel.stringValue = state.careHint
    }

    private func buildContent(in window: NSWindow) {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false

        faceLabel.font = .monospacedSystemFont(ofSize: 44, weight: .semibold)
        faceLabel.alignment = .center

        statusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.alignment = .center

        hintLabel.font = .systemFont(ofSize: 13)
        hintLabel.alignment = .center

        let buttonStack = NSStackView()
        buttonStack.orientation = .horizontal
        buttonStack.spacing = 10
        buttonStack.alignment = .centerY

        buttonStack.addArrangedSubview(makeButton(title: "Feed", action: #selector(feed)))
        buttonStack.addArrangedSubview(makeButton(title: "Play", action: #selector(play)))
        buttonStack.addArrangedSubview(makeButton(title: "Rest", action: #selector(rest)))

        stack.addArrangedSubview(faceLabel)
        stack.addArrangedSubview(statusLabel)
        stack.addArrangedSubview(hintLabel)
        stack.addArrangedSubview(buttonStack)

        window.contentView?.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: window.contentView!.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: window.contentView!.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: window.contentView!.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: window.contentView!.trailingAnchor, constant: -24)
        ])
    }

    private func makeButton(title: String, action: Selector) -> NSButton {
        let button = NSButton(title: title, target: self, action: action)
        button.bezelStyle = .rounded
        return button
    }

    @objc private func feed() {
        engine.feed()
    }

    @objc private func play() {
        engine.play()
    }

    @objc private func rest() {
        engine.rest()
    }
}
