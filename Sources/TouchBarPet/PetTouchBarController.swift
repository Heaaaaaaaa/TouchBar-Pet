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
    private var persistentSceneView = PetTouchBarSceneView()
    private let windowSceneView = PetTouchBarSceneView()
    private let trayView = PetTouchBarTrayView()
    private var latestState = PetState.initial
    private var isPersistentInstalled = false
    private lazy var persistentTouchBar = makeTouchBar()
    private lazy var windowTouchBar = makeTouchBar()

    init(engine: PetEngine) {
        self.engine = engine
        super.init()
        configureSceneView(persistentSceneView)
        configureSceneView(windowSceneView)
        trayView.onTap = { [weak self] in
            self?.presentPersistentTouchBar()
        }
    }

    func makeWindowTouchBar() -> NSTouchBar {
        return windowTouchBar
    }

    func render(_ state: PetState) {
        latestState = state
        persistentSceneView.state = state
        windowSceneView.state = state
        trayView.petState = state
    }

    @discardableResult
    func installPersistentTouchBar() -> Bool {
        if !isPersistentInstalled {
            isPersistentInstalled = PersistentTouchBarAPI.install(
                view: trayView,
                identifier: ItemID.persistent
            )
        }

        return presentPersistentTouchBar()
    }

    @discardableResult
    func presentPersistentTouchBar(forceReinstall: Bool = false) -> Bool {
        if forceReinstall {
            resetPersistentTouchBarState()
        }

        if !isPersistentInstalled {
            isPersistentInstalled = PersistentTouchBarAPI.install(
                view: trayView,
                identifier: ItemID.persistent
            )
        }

        if PersistentTouchBarAPI.present(
            touchBar: persistentTouchBar,
            identifier: ItemID.persistent
        ) {
            return true
        }

        resetPersistentTouchBarState()
        isPersistentInstalled = PersistentTouchBarAPI.install(
            view: trayView,
            identifier: ItemID.persistent
        )

        guard isPersistentInstalled else {
            return false
        }

        return PersistentTouchBarAPI.present(
            touchBar: persistentTouchBar,
            identifier: ItemID.persistent
        )
    }

    func removePersistentTouchBar() {
        _ = PersistentTouchBarAPI.remove(identifier: ItemID.persistent)
        isPersistentInstalled = false
    }

    private func resetPersistentTouchBarState() {
        _ = PersistentTouchBarAPI.remove(identifier: ItemID.persistent)
        isPersistentInstalled = false
        persistentSceneView = PetTouchBarSceneView()
        configureSceneView(persistentSceneView)
        persistentSceneView.state = latestState
        persistentTouchBar = makeTouchBar()
    }

    func touchBar(
        _ touchBar: NSTouchBar,
        makeItemForIdentifier identifier: NSTouchBarItem.Identifier
    ) -> NSTouchBarItem? {
        switch identifier {
        case ItemID.scene:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = touchBar === persistentTouchBar ? persistentSceneView : windowSceneView
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

    private func makeTouchBar() -> NSTouchBar {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [ItemID.scene]
        touchBar.principalItemIdentifier = ItemID.scene
        return touchBar
    }

    private func configureSceneView(_ view: PetTouchBarSceneView) {
        view.onAction = { [weak engine] action in
            switch action {
            case .petTap:
                engine?.tapPet()
            case .feed:
                engine?.feed()
            case .play:
                engine?.play()
            case .rest:
                engine?.rest()
            }
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
