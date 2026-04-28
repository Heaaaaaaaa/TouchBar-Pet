import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let store = PetStore()
    private lazy var engine = PetEngine(initialState: store.load())
    private lazy var windowController = PetWindowController(engine: engine)
    private lazy var touchBarController = PetTouchBarController(engine: engine)
    private var tickTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildMenu()
        windowController.showWindow(nil)
        windowController.window?.makeKeyAndOrderFront(nil)
        windowController.installTouchBar(touchBarController)
        startPetLoop()

        engine.onChange = { [weak self] state in
            self?.windowController.render(state)
            self?.touchBarController.render(state)
            self?.store.save(state)
        }

        engine.publish()
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ notification: Notification) {
        store.save(engine.state)
        tickTimer?.invalidate()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private func startPetLoop() {
        tickTimer = Timer.scheduledTimer(
            timeInterval: 1.5,
            target: self,
            selector: #selector(tickPet),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func tickPet() {
        engine.tick()
    }

    private func buildMenu() {
        let menu = NSMenu()
        let appItem = NSMenuItem()
        let appMenu = NSMenu()

        appMenu.addItem(
            NSMenuItem(
                title: "Quit TouchBar Pet",
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: "q"
            )
        )

        appItem.submenu = appMenu
        menu.addItem(appItem)
        NSApp.mainMenu = menu
    }
}
