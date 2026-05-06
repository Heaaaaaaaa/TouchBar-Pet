import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private enum MenuTag {
        static let speciesBase = 1_000
        static let backgroundBase = 2_000
    }

    private let store = PetStore()
    private lazy var engine = PetEngine(initialState: store.load())
    private lazy var touchBarController = PetTouchBarController(engine: engine)
    private var windowController: PetWindowController?
    private var statusItem: NSStatusItem?
    private var tickTimer: Timer?
    private var saveTimer: Timer?
    private var lastFrameDate = Date()
    private var selectedMenuSpecies: PetSpecies?
    private var selectedMenuBackground: PetBackground?

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildMenu()
        buildStatusItem()
        touchBarController.installPersistentTouchBar()
        startPetLoop()

        engine.onChange = { [weak self] state in
            self?.windowController?.render(state)
            self?.touchBarController.render(state)
            self?.updateMenuSelectionIfNeeded(state)
            self?.scheduleSave()
        }

        engine.publish()
    }

    func applicationWillTerminate(_ notification: Notification) {
        store.save(engine.state)
        touchBarController.removePersistentTouchBar()
        tickTimer?.invalidate()
        saveTimer?.invalidate()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    private func startPetLoop() {
        lastFrameDate = Date()

        let timer = Timer(
            timeInterval: 1.0 / 12.0,
            target: self,
            selector: #selector(tickPet),
            userInfo: nil,
            repeats: true
        )

        timer.tolerance = 0.015
        RunLoop.main.add(timer, forMode: .common)
        tickTimer = timer
    }

    @objc private func tickPet() {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastFrameDate)
        lastFrameDate = now

        engine.tick(elapsed: elapsed)
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
        menu.addItem(speciesMenuItem())
        menu.addItem(backgroundMenuItem())
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Show Touch Bar Pet", action: #selector(showPersistentTouchBar), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit TouchBar Pet", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        item.menu = menu
        statusItem = item
        updateMenuSelection(engine.state)
    }

    private func speciesMenuItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Pet", action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: "Pet")

        for (index, species) in PetSpecies.allCases.enumerated() {
            let speciesItem = NSMenuItem(
                title: species.displayName,
                action: #selector(selectSpecies(_:)),
                keyEquivalent: ""
            )
            speciesItem.target = self
            speciesItem.representedObject = species.rawValue
            speciesItem.tag = MenuTag.speciesBase + index
            submenu.addItem(speciesItem)
        }

        item.submenu = submenu
        return item
    }

    private func backgroundMenuItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Background", action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: "Background")

        for (index, background) in PetBackground.allCases.enumerated() {
            let backgroundItem = NSMenuItem(
                title: background.displayName,
                action: #selector(selectBackground(_:)),
                keyEquivalent: ""
            )
            backgroundItem.target = self
            backgroundItem.representedObject = background.rawValue
            backgroundItem.tag = MenuTag.backgroundBase + index
            submenu.addItem(backgroundItem)
        }

        item.submenu = submenu
        return item
    }

    private func updateMenuSelection(_ state: PetState) {
        guard let menu = statusItem?.menu else {
            return
        }

        updateMenuItems(in: menu, baseTag: MenuTag.speciesBase, selectedRawValue: state.species.rawValue)
        updateMenuItems(in: menu, baseTag: MenuTag.backgroundBase, selectedRawValue: state.background.rawValue)
        selectedMenuSpecies = state.species
        selectedMenuBackground = state.background
    }

    private func updateMenuSelectionIfNeeded(_ state: PetState) {
        guard selectedMenuSpecies != state.species || selectedMenuBackground != state.background else {
            return
        }

        updateMenuSelection(state)
    }

    private func updateMenuItems(in menu: NSMenu, baseTag: Int, selectedRawValue: String) {
        for item in menu.items {
            if item.tag >= baseTag && item.tag < baseTag + 100 {
                item.state = item.representedObject as? String == selectedRawValue ? .on : .off
            }

            if let submenu = item.submenu {
                updateMenuItems(in: submenu, baseTag: baseTag, selectedRawValue: selectedRawValue)
            }
        }
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

    private func scheduleSave() {
        guard saveTimer == nil else {
            return
        }

        saveTimer = Timer.scheduledTimer(
            timeInterval: 6.0,
            target: self,
            selector: #selector(flushScheduledSave),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func flushScheduledSave() {
        saveTimer?.invalidate()
        saveTimer = nil
        store.save(engine.state)
    }

    @objc private func selectSpecies(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let species = PetSpecies(rawValue: rawValue)
        else {
            return
        }

        engine.selectSpecies(species)
        touchBarController.presentPersistentTouchBar()
    }

    @objc private func selectBackground(_ sender: NSMenuItem) {
        guard
            let rawValue = sender.representedObject as? String,
            let background = PetBackground(rawValue: rawValue)
        else {
            return
        }

        engine.selectBackground(background)
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
