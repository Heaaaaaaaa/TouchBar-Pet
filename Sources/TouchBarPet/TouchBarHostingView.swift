import AppKit

@MainActor
final class TouchBarHostingView: NSView {
    var touchBarProvider: (() -> NSTouchBar?)?

    override var acceptsFirstResponder: Bool {
        true
    }

    override func makeTouchBar() -> NSTouchBar? {
        touchBarProvider?()
    }
}
