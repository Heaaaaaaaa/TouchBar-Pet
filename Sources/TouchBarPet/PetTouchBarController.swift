import AppKit

@MainActor
final class PetTouchBarController: NSObject, NSTouchBarDelegate {
    private enum ItemID {
        static let persistent = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.persistent")
        static let scene = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.scene")
        static let feed = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.feed")
        static let play = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.play")
        static let rest = NSTouchBarItem.Identifier("com.heaaaaaaaa.touchbarpet.rest")
    }

    private let engine: PetEngine
    private let sceneView = PetTouchBarSceneView()
    private let persistentSceneView = PetTouchBarSceneView()
    private var isPersistentInstalled = false
    private lazy var touchBar: NSTouchBar = {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [
            ItemID.scene,
            .flexibleSpace,
            ItemID.feed,
            ItemID.play,
            ItemID.rest
        ]
        touchBar.principalItemIdentifier = ItemID.scene
        return touchBar
    }()

    init(engine: PetEngine) {
        self.engine = engine
        super.init()
        sceneView.onTap = { [weak engine] in
            engine?.play()
        }
        persistentSceneView.onTap = { [weak self] in
            self?.presentPersistentTouchBar()
        }
    }

    func makeTouchBar() -> NSTouchBar {
        return touchBar
    }

    func render(_ state: PetState) {
        sceneView.state = state
        persistentSceneView.state = state
    }

    func installPersistentTouchBar() {
        guard !isPersistentInstalled else {
            presentPersistentTouchBar()
            return
        }

        isPersistentInstalled = PersistentTouchBarAPI.install(
            view: persistentSceneView,
            identifier: ItemID.persistent
        )
        presentPersistentTouchBar()
    }

    func presentPersistentTouchBar() {
        _ = PersistentTouchBarAPI.present(
            touchBar: makeTouchBar(),
            identifier: ItemID.persistent
        )
    }

    func removePersistentTouchBar() {
        _ = PersistentTouchBarAPI.remove(identifier: ItemID.persistent)
        isPersistentInstalled = false
    }

    func touchBar(
        _ touchBar: NSTouchBar,
        makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        switch identifier {
        case ItemID.scene:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = sceneView
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
