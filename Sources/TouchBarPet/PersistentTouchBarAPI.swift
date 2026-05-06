import AppKit
import TouchBarPrivate

@MainActor
enum PersistentTouchBarAPI {
    static func install(view: NSView, identifier: NSTouchBarItem.Identifier) -> Bool {
        TBPInstallPersistentTouchBarView(view, identifier.rawValue)
    }

    static func present(touchBar: NSTouchBar, identifier: NSTouchBarItem.Identifier) -> Bool {
        TBPPresentPersistentTouchBar(touchBar, identifier.rawValue)
    }

    static func remove(identifier: NSTouchBarItem.Identifier) -> Bool {
        TBPRemovePersistentTouchBar(identifier.rawValue)
    }
}
