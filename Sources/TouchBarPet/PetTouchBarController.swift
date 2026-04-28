import AppKit

@MainActor
final class PetTouchBarController: NSObject, NSTouchBarDelegate {
    private enum ItemID {
        static let pet = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.pet")
        static let status = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.status")
        static let feed = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.feed")
        static let play = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.play")
        static let rest = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.rest")
    }

    private let engine: PetEngine
    private let petButton = NSButton(title: "(^_^)", target: nil, action: nil)
    private let statusLabel = NSTextField(labelWithString: "")

    init(engine: PetEngine) {
        self.engine = engine
        super.init()
        petButton.target = self
        petButton.action = #selector(play)
        petButton.bezelStyle = .texturedRounded
        petButton.font = .monospacedSystemFont(ofSize: 18, weight: .semibold)
        statusLabel.alignment = .center
    }

    func makeTouchBar() -> NSTouchBar {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [
            ItemID.pet,
            .fixedSpaceSmall,
            ItemID.status,
            .fixedSpaceSmall,
            ItemID.feed,
            ItemID.play,
            ItemID.rest
        ]
        touchBar.principalItemIdentifier = ItemID.pet
        return touchBar
    }

    func render(_ state: PetState) {
        petButton.title = state.face
        statusLabel.stringValue = "\(state.hunger)/\(state.mood)/\(state.energy)"
    }

    func touchBar(
        _ touchBar: NSTouchBar,
        makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        switch identifier {
        case ItemID.pet:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = petButton
            return item
        case ItemID.status:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = statusLabel
            return item
        case ItemID.feed:
            return buttonItem(identifier: identifier, title: "Feed", action: #selector(feed))
        case ItemID.play:
            return buttonItem(identifier: identifier, title: "Play", action: #selector(play))
        case ItemID.rest:
            return buttonItem(identifier: identifier, title: "Rest", action: #selector(rest))
        default:
            return nil
        }
    }

    private func buttonItem(
        identifier: NSTouchBarItem.Identifier,
        title: String,
        action: Selector
    ) -> NSTouchBarItem {
        let item = NSCustomTouchBarItem(identifier: identifier)
        let button = NSButton(title: title, target: self, action: action)
        button.bezelStyle = .texturedRounded
        item.view = button
        return item
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
