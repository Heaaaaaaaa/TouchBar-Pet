import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let store = PetStore()
    private lazy var engine = PetEngine(initialState: store.load())
    private lazy var touchBarController = PetTouchBarController(engine: engine)
    private var windowController: PetWindowController?
    private var statusItem: NSStatusItem?
    private var tickTimer: Timer?
    private var touchBarKeepAliveTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildMenu()
        buildStatusItem()
        touchBarController.installPersistentTouchBar()
        startPetLoop()
        startTouchBarKeepAlive()

        engine.onChange = { [weak self] state in
            self?.windowController?.render(state)
            self?.touchBarController.render(state)
            self?.store.save(state)
        }

        engine.publish()
    }

    func applicationWillTerminate(_ notification: Notification) {
        store.save(engine.state)
        touchBarController.removePersistentTouchBar()
        tickTimer?.invalidate()
        touchBarKeepAliveTimer?.invalidate()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
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

    private func startTouchBarKeepAlive() {
        touchBarKeepAliveTimer = Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(refreshPersistentTouchBar),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func refreshPersistentTouchBar() {
        touchBarController.presentPersistentTouchBar()
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

    private func buildStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.title = "TBP"
        item.button?.toolTip = "TouchBar Pet"

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Window", action: #selector(showWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Hide Window", action: #selector(hideWindow), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Feed", action: #selector(feed), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Play", action: #selector(play), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Rest", action: #selector(rest), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Show Touch Bar Pet", action: #selector(showPersistentTouchBar), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit TouchBar Pet", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        item.menu = menu
        statusItem = item
    }

    private func activeWindowController() -> PetWindowController {
        if let windowController {
            return windowController
        }

        let controller = PetWindowController(engine: engine)
        controller.installTouchBar(touchBarController)
        controller.render(engine.state)
        windowController = controller
        return controller
    }

    @objc private func showWindow() {
        let controller = activeWindowController()
        controller.showWindow(nil)
        controller.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func hideWindow() {
        windowController?.window?.orderOut(nil)
    }

    @objc private func showPersistentTouchBar() {
        touchBarController.presentPersistentTouchBar()
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
