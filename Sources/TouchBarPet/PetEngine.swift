import Foundation

final class PetEngine {
    private(set) var state: PetState
    var onChange: ((PetState) -> Void)?

    init(initialState: PetState) {
        self.state = initialState
        applyOfflineProgress()
    }

    func publish() {
        onChange?(state)
    }

    func feed() {
        state.hunger = (state.hunger - 25).clamped(to: 0...100)
        state.mood = (state.mood + 5).clamped(to: 0...100)
        state.energy = (state.energy - 2).clamped(to: 0...100)
        state.lastUpdated = Date()
        publish()
    }

    func play() {
        state.hunger = (state.hunger + 10).clamped(to: 0...100)
        state.mood = (state.mood + 22).clamped(to: 0...100)
        state.energy = (state.energy - 12).clamped(to: 0...100)
        state.lastUpdated = Date()
        publish()
    }

    func rest() {
        state.hunger = (state.hunger + 4).clamped(to: 0...100)
        state.mood = (state.mood + 4).clamped(to: 0...100)
        state.energy = (state.energy + 24).clamped(to: 0...100)
        state.lastUpdated = Date()
        publish()
    }

    func tick() {
        state.animationFrame += 1
        state.hunger = (state.hunger + 1).clamped(to: 0...100)
        state.energy = (state.energy - 1).clamped(to: 0...100)

        if state.hunger > 70 || state.energy < 30 {
            state.mood = (state.mood - 2).clamped(to: 0...100)
        } else {
            state.mood = (state.mood + 1).clamped(to: 0...100)
        }

        state.lastUpdated = Date()
        publish()
    }

    private func applyOfflineProgress() {
        let elapsed = max(0, Date().timeIntervalSince(state.lastUpdated))
        let elapsedMinutes = min(Int(elapsed / 60), 120)

        guard elapsedMinutes > 0 else {
            return
        }

        state.hunger = (state.hunger + elapsedMinutes / 4).clamped(to: 0...100)
        state.energy = (state.energy - elapsedMinutes / 6).clamped(to: 0...100)

        if state.hunger > 70 || state.energy < 30 {
            state.mood = (state.mood - elapsedMinutes / 5).clamped(to: 0...100)
        }

        state.lastUpdated = Date()
    }
}
