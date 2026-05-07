import AppKit

final class PetWindowController: NSWindowController, NSWindowDelegate {
    private let engine: PetEngine
    private let rootView = TouchBarHostingView()
    private let summaryView = PetSummaryView()
    var onWindowHidden: (() -> Void)?

    init(engine: PetEngine) {
        self.engine = engine

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 260),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "TouchBar Pet"
        window.isReleasedWhenClosed = false
        window.center()
        window.contentView = rootView

        super.init(window: window)
        window.delegate = self
        buildContent(in: window)
    }

    required init?(coder: NSCoder) {
        nil
    }

    func render(_ state: PetState) {
        summaryView.state = state
    }

    func installTouchBar(_ controller: PetTouchBarController) {
        rootView.touchBarProvider = { controller.makeTouchBar() }
        window?.touchBar = controller.makeTouchBar()
        window?.makeFirstResponder(rootView)
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        onWindowHidden?()
        return false
    }

    private func buildContent(in window: NSWindow) {
        rootView.wantsLayer = true
        rootView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor

        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false

        summaryView.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = NSStackView()
        buttonStack.orientation = .horizontal
        buttonStack.spacing = 10
        buttonStack.alignment = .centerY

        buttonStack.addArrangedSubview(makeButton(title: "Feed", action: #selector(feed)))
        buttonStack.addArrangedSubview(makeButton(title: "Play", action: #selector(play)))
        buttonStack.addArrangedSubview(makeButton(title: "Rest", action: #selector(rest)))

        stack.addArrangedSubview(summaryView)
        stack.addArrangedSubview(buttonStack)

        rootView.addSubview(stack)

        NSLayoutConstraint.activate([
            summaryView.widthAnchor.constraint(equalToConstant: 340),
            summaryView.heightAnchor.constraint(equalToConstant: 160),
            stack.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: rootView.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: rootView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: rootView.trailingAnchor, constant: -24)
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
