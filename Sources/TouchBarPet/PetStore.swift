import Foundation

final class PetStore {
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        let supportDirectory = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent("TouchBarPet", isDirectory: true)

        try? fileManager.createDirectory(
            at: supportDirectory,
            withIntermediateDirectories: true
        )

        self.fileURL = supportDirectory.appendingPathComponent("pet-state.json")
    }

    func load() -> PetState {
        guard
            let data = try? Data(contentsOf: fileURL),
            let state = try? JSONDecoder().decode(PetState.self, from: data)
        else {
            return .initial
        }

        return state
    }

    func save(_ state: PetState) {
        guard let data = try? JSONEncoder().encode(state) else {
            return
        }

        try? data.write(to: fileURL, options: [.atomic])
    }
}
