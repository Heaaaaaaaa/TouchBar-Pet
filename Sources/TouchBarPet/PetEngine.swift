import Foundation

final class PetEngine {
    private let careTickInterval: TimeInterval = 1.5
    private var careAccumulator: TimeInterval = 0

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
        state.behaviorMode = .eat
        state.actionTicksRemaining = 32
        state.lastUpdated = Date()
        publish()
    }

    func play() {
        state.hunger = (state.hunger + 10).clamped(to: 0...100)
        state.mood = (state.mood + 22).clamped(to: 0...100)
        state.energy = (state.energy - 12).clamped(to: 0...100)
        state.behaviorMode = state.species.specialPlayMode
        state.actionTicksRemaining = 32
        state.lastUpdated = Date()
        publish()
    }

    func rest() {
        state.hunger = (state.hunger + 4).clamped(to: 0...100)
        state.mood = (state.mood + 4).clamped(to: 0...100)
        state.energy = (state.energy + 24).clamped(to: 0...100)
        state.behaviorMode = .sleep
        state.velocityX = 0
        state.actionTicksRemaining = 44
        state.lastUpdated = Date()
        publish()
    }

    func selectSpecies(_ species: PetSpecies) {
        state.species = species
        resetRuntimeForSelectedSpecies()
        state.lastUpdated = Date()
        publish()
    }

    func selectBackground(_ background: PetBackground) {
        state.background = background
        state.lastUpdated = Date()
        publish()
    }

    func tick(elapsed: TimeInterval) {
        let elapsed = elapsed.clamped(to: 0.0...0.25)
        state.animationFrame = (state.animationFrame + 1) % 10_000

        careAccumulator += elapsed
        let careTicks = min(Int(careAccumulator / careTickInterval), 4)

        if careTicks > 0 {
            careAccumulator -= TimeInterval(careTicks) * careTickInterval

            for _ in 0..<careTicks {
                applyCareTick()
            }
        }

        if state.actionTicksRemaining > 0 {
            state.actionTicksRemaining -= 1
        }

        chooseBehaviorMode()
        updateMovement(elapsed: elapsed)
        state.lastUpdated = Date()
        publish()
    }

    func tick() {
        tick(elapsed: careTickInterval)
    }

    private func applyCareTick() {
        state.hunger = (state.hunger + 1).clamped(to: 0...100)

        if state.behaviorMode == .sleep {
            state.energy = (state.energy + 1).clamped(to: 0...100)
        } else {
            state.energy = (state.energy - 1).clamped(to: 0...100)
        }

        if state.hunger > 70 || state.energy < 30 {
            state.mood = (state.mood - 2).clamped(to: 0...100)
        } else {
            state.mood = (state.mood + 1).clamped(to: 0...100)
        }
    }

    private func chooseBehaviorMode() {
        guard state.actionTicksRemaining == 0 else {
            return
        }

        if state.energy <= 16 {
            state.behaviorMode = .sleep
            return
        }

        if state.species == .plantBuddy {
            state.behaviorMode = .idle
            return
        }

        if state.hunger >= 82 {
            state.behaviorMode = .walk
            return
        }

        state.behaviorMode = state.animationFrame % 72 < 54 ? .walk : .idle
    }

    private func updateMovement(elapsed: TimeInterval) {
        let baseSpeed = state.species.baseMovementSpeed

        switch state.behaviorMode {
        case .sleep:
            state.velocityX = 0
        case .idle:
            updateIdleMovement(baseSpeed: baseSpeed, elapsed: elapsed)
        case .walk:
            moveInCurrentDirection(step: baseSpeed * elapsed)
        case .eat:
            moveTowardSnack(step: max(baseSpeed * 1.4, 0.040) * elapsed)
        case .play:
            moveInCurrentDirection(step: max(baseSpeed * 2.1, 0.055) * elapsed)
        case .special:
            updateSpecialMovement(baseSpeed: baseSpeed, elapsed: elapsed)
        }
    }

    private func updateIdleMovement(baseSpeed: Double, elapsed: TimeInterval) {
        switch state.species {
        case .pufferFish, .ghost:
            moveInCurrentDirection(step: baseSpeed * 0.45 * elapsed)
        case .plantBuddy:
            state.velocityX = 0
            state.positionX = 0.5
        case .cat, .dragon:
            state.velocityX = 0
        }
    }

    private func updateSpecialMovement(baseSpeed: Double, elapsed: TimeInterval) {
        switch state.species {
        case .pufferFish:
            state.velocityX = 0
        case .ghost:
            moveInCurrentDirection(step: max(baseSpeed * 2.4, 0.065) * elapsed)
        case .dragon:
            moveInCurrentDirection(step: max(baseSpeed * 1.8, 0.070) * elapsed)
        case .cat:
            moveInCurrentDirection(step: max(baseSpeed * 2.0, 0.060) * elapsed)
        case .plantBuddy:
            state.velocityX = 0
            state.positionX = 0.5
        }
    }

    private func moveTowardSnack(step: Double) {
        let snackX = state.species.snackPositionX
        let distance = snackX - state.positionX

        guard abs(distance) > step else {
            state.positionX = snackX
            state.velocityX = 0
            return
        }

        state.direction = distance > 0 ? .right : .left
        state.velocityX = state.direction.multiplier * step
        state.positionX = (state.positionX + state.velocityX).clamped(to: 0.04...0.94)
    }

    private func moveInCurrentDirection(step: Double) {
        guard step > 0 else {
            state.velocityX = 0
            return
        }

        state.velocityX = state.direction.multiplier * step
        state.positionX += state.velocityX

        if state.positionX <= 0.04 {
            state.positionX = 0.04
            state.direction = .right
        } else if state.positionX >= 0.94 {
            state.positionX = 0.94
            state.direction = .left
        }
    }

    private func resetRuntimeForSelectedSpecies() {
        state.behaviorMode = state.species == .plantBuddy ? .idle : .walk
        state.direction = .right
        state.positionX = state.species.defaultPositionX
        state.velocityX = state.species.baseMovementSpeed
        state.actionTicksRemaining = 0
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

private extension PetSpecies {
    var baseMovementSpeed: Double {
        switch self {
        case .cat:
            return 0.060
        case .pufferFish:
            return 0.044
        case .ghost:
            return 0.040
        case .dragon:
            return 0.066
        case .plantBuddy:
            return 0
        }
    }

    var defaultPositionX: Double {
        switch self {
        case .cat:
            return 0.36
        case .pufferFish:
            return 0.58
        case .ghost:
            return 0.52
        case .dragon:
            return 0.46
        case .plantBuddy:
            return 0.5
        }
    }

    var snackPositionX: Double {
        switch self {
        case .cat:
            return 0.76
        case .pufferFish:
            return 0.68
        case .ghost:
            return 0.72
        case .dragon:
            return 0.70
        case .plantBuddy:
            return 0.50
        }
    }

    var specialPlayMode: PetBehaviorMode {
        switch self {
        case .pufferFish, .ghost, .dragon:
            return .special
        case .cat, .plantBuddy:
            return .play
        }
    }
}
