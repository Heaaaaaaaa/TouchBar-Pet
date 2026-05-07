import Foundation

final class PetEngine {
    private let careTickInterval: TimeInterval = 3.0
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
        applyAction(.feed)
    }

    func play() {
        applyAction(.play)
    }

    func rest() {
        applyAction(.rest)
    }

    func tapPet() {
        applyAction(.tap)
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

        let profile = state.species.profile

        switch state.behaviorMode {
        case .sleep:
            state.energy = (state.energy + profile.sleepEnergyRecovery).clamped(to: 0...100)
        case .play, .special:
            state.energy = (state.energy - profile.specialEnergyDrain).clamped(to: 0...100)
        case .walk, .eat:
            state.energy = (state.energy - profile.walkEnergyDrain).clamped(to: 0...100)
        case .idle:
            if state.species != .plantBuddy {
                state.energy = (state.energy - profile.idleEnergyDrain).clamped(to: 0...100)
            } else if state.mood > 62 && state.hunger < 72 {
                state.energy = (state.energy + 1).clamped(to: 0...100)
            }
        }

        if state.hunger > 70 || (state.energy < 30 && state.behaviorMode != .sleep) {
            state.mood = (state.mood - 2).clamped(to: 0...100)
        } else if state.behaviorMode == .sleep && state.hunger < 82 {
            state.mood = (state.mood + 1).clamped(to: 0...100)
        } else {
            state.mood = (state.mood + 1).clamped(to: 0...100)
        }
    }

    private func chooseBehaviorMode() {
        guard state.actionTicksRemaining == 0 else {
            return
        }

        if state.species == .plantBuddy {
            choosePlantBehaviorMode()
            return
        }

        let profile = state.species.profile

        if state.behaviorMode == .sleep && state.energy < profile.wakeEnergyThreshold {
            state.velocityX = 0
            return
        }

        if state.energy <= profile.sleepEnergyThreshold {
            beginSleep()
            return
        }

        if state.hunger >= 82 {
            state.behaviorMode = .walk
            return
        }

        let cycleFrame = state.animationFrame % profile.behaviorCycleFrames

        if shouldUseAutomaticSpecial(profile: profile, cycleFrame: cycleFrame) {
            state.behaviorMode = .special
            return
        }

        state.behaviorMode = cycleFrame < profile.activeFrames ? .walk : .idle
    }

    private func choosePlantBehaviorMode() {
        let profile = state.species.profile
        state.velocityX = 0
        state.positionX = 0.5

        if state.hunger >= 82 {
            state.behaviorMode = .idle
            return
        }

        let cycleFrame = state.animationFrame % profile.behaviorCycleFrames
        state.behaviorMode = cycleFrame < profile.activeFrames && state.energy > 32 ? .play : .idle
    }

    private func beginSleep() {
        state.behaviorMode = .sleep
        state.velocityX = 0
    }

    private func shouldUseAutomaticSpecial(profile: PetProfile, cycleFrame: Int) -> Bool {
        guard profile.automaticSpecialFrames > 0 else {
            return false
        }

        switch state.species {
        case .cat:
            return state.energy >= 78 && state.mood >= 58 && cycleFrame < profile.automaticSpecialFrames
        case .pufferFish:
            return state.hunger >= 72 || cycleFrame < profile.automaticSpecialFrames
        case .ghost:
            return state.mood >= 74 && cycleFrame < profile.automaticSpecialFrames
        case .dragon:
            return state.energy >= 62 && state.mood >= 54 && cycleFrame < profile.automaticSpecialFrames
        case .plantBuddy:
            return false
        }
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
            if state.species == .plantBuddy {
                state.velocityX = 0
                state.positionX = 0.5
            } else {
                moveInCurrentDirection(step: max(baseSpeed * 2.1, 0.055) * elapsed)
            }
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

    private func applyAction(_ action: PetAction) {
        let effect = state.species.effect(for: action)
        state.hunger = (state.hunger + effect.hungerDelta).clamped(to: 0...100)
        state.mood = (state.mood + effect.moodDelta).clamped(to: 0...100)
        state.energy = (state.energy + effect.energyDelta).clamped(to: 0...100)
        state.behaviorMode = effect.mode
        state.actionTicksRemaining = effect.durationFrames

        if effect.mode == .sleep || state.species == .plantBuddy {
            state.velocityX = 0
        }

        if state.species == .plantBuddy {
            state.positionX = 0.5
        }

        state.lastUpdated = Date()
        publish()
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
    var profile: PetProfile {
        switch self {
        case .cat:
            return PetProfile(
                baseMovementSpeed: 0.052,
                defaultPositionX: 0.36,
                snackPositionX: 0.76,
                sleepEnergyThreshold: 16,
                wakeEnergyThreshold: 56,
                behaviorCycleFrames: 420,
                activeFrames: 300,
                automaticSpecialFrames: 48
            )
        case .pufferFish:
            return PetProfile(
                baseMovementSpeed: 0.038,
                defaultPositionX: 0.58,
                snackPositionX: 0.68,
                sleepEnergyThreshold: 14,
                wakeEnergyThreshold: 52,
                behaviorCycleFrames: 360,
                activeFrames: 300,
                automaticSpecialFrames: 26,
                idleEnergyDrain: 0,
                walkEnergyDrain: 1,
                specialEnergyDrain: 1,
                sleepEnergyRecovery: 2
            )
        case .ghost:
            return PetProfile(
                baseMovementSpeed: 0.034,
                defaultPositionX: 0.52,
                snackPositionX: 0.72,
                sleepEnergyThreshold: 12,
                wakeEnergyThreshold: 48,
                behaviorCycleFrames: 390,
                activeFrames: 280,
                automaticSpecialFrames: 34,
                idleEnergyDrain: 0,
                walkEnergyDrain: 1,
                specialEnergyDrain: 1,
                sleepEnergyRecovery: 2
            )
        case .dragon:
            return PetProfile(
                baseMovementSpeed: 0.060,
                defaultPositionX: 0.46,
                snackPositionX: 0.70,
                sleepEnergyThreshold: 20,
                wakeEnergyThreshold: 62,
                behaviorCycleFrames: 430,
                activeFrames: 290,
                automaticSpecialFrames: 42,
                specialEnergyDrain: 2,
                sleepEnergyRecovery: 3
            )
        case .plantBuddy:
            return PetProfile(
                baseMovementSpeed: 0,
                defaultPositionX: 0.5,
                snackPositionX: 0.50,
                sleepEnergyThreshold: 0,
                wakeEnergyThreshold: 0,
                behaviorCycleFrames: 500,
                activeFrames: 310,
                automaticSpecialFrames: 0,
                idleEnergyDrain: 0,
                walkEnergyDrain: 0,
                specialEnergyDrain: 0,
                sleepEnergyRecovery: 1
            )
        }
    }

    var baseMovementSpeed: Double {
        profile.baseMovementSpeed
    }

    var defaultPositionX: Double {
        profile.defaultPositionX
    }

    var snackPositionX: Double {
        profile.snackPositionX
    }

    var specialPlayMode: PetBehaviorMode {
        switch self {
        case .pufferFish, .ghost, .dragon:
            return .special
        case .cat, .plantBuddy:
            return .play
        }
    }

    func effect(for action: PetAction) -> PetActionEffect {
        switch (self, action) {
        case (.cat, .feed):
            return PetActionEffect(hungerDelta: -28, moodDelta: 6, energyDelta: -1, mode: .eat, durationFrames: 54)
        case (.cat, .play), (.cat, .tap):
            return PetActionEffect(hungerDelta: 8, moodDelta: 20, energyDelta: -8, mode: .play, durationFrames: 58)
        case (.cat, .rest):
            return PetActionEffect(hungerDelta: 4, moodDelta: 5, energyDelta: 24, mode: .sleep, durationFrames: 90)

        case (.pufferFish, .feed):
            return PetActionEffect(hungerDelta: -24, moodDelta: 4, energyDelta: -1, mode: .eat, durationFrames: 54)
        case (.pufferFish, .play):
            return PetActionEffect(hungerDelta: 8, moodDelta: 18, energyDelta: -7, mode: .play, durationFrames: 58)
        case (.pufferFish, .tap):
            return PetActionEffect(hungerDelta: 2, moodDelta: 10, energyDelta: -3, mode: .special, durationFrames: 44)
        case (.pufferFish, .rest):
            return PetActionEffect(hungerDelta: 3, moodDelta: 4, energyDelta: 20, mode: .sleep, durationFrames: 86)

        case (.ghost, .feed):
            return PetActionEffect(hungerDelta: -22, moodDelta: 8, energyDelta: -1, mode: .eat, durationFrames: 52)
        case (.ghost, .play):
            return PetActionEffect(hungerDelta: 6, moodDelta: 20, energyDelta: -6, mode: .play, durationFrames: 58)
        case (.ghost, .tap):
            return PetActionEffect(hungerDelta: 1, moodDelta: 12, energyDelta: -2, mode: .special, durationFrames: 42)
        case (.ghost, .rest):
            return PetActionEffect(hungerDelta: 2, moodDelta: 5, energyDelta: 18, mode: .sleep, durationFrames: 82)

        case (.dragon, .feed):
            return PetActionEffect(hungerDelta: -30, moodDelta: 6, energyDelta: -2, mode: .eat, durationFrames: 54)
        case (.dragon, .play):
            return PetActionEffect(hungerDelta: 10, moodDelta: 22, energyDelta: -11, mode: .special, durationFrames: 62)
        case (.dragon, .tap):
            return PetActionEffect(hungerDelta: 2, moodDelta: 12, energyDelta: -5, mode: .special, durationFrames: 46)
        case (.dragon, .rest):
            return PetActionEffect(hungerDelta: 5, moodDelta: 5, energyDelta: 26, mode: .sleep, durationFrames: 96)

        case (.plantBuddy, .feed):
            return PetActionEffect(hungerDelta: -30, moodDelta: 8, energyDelta: 2, mode: .eat, durationFrames: 58)
        case (.plantBuddy, .play), (.plantBuddy, .tap):
            return PetActionEffect(hungerDelta: 3, moodDelta: 16, energyDelta: 12, mode: .play, durationFrames: 72)
        case (.plantBuddy, .rest):
            return PetActionEffect(hungerDelta: 2, moodDelta: 3, energyDelta: 8, mode: .idle, durationFrames: 60)
        }
    }
}

private enum PetAction {
    case feed
    case play
    case tap
    case rest
}

private struct PetActionEffect {
    let hungerDelta: Int
    let moodDelta: Int
    let energyDelta: Int
    let mode: PetBehaviorMode
    let durationFrames: Int
}

private struct PetProfile {
    let baseMovementSpeed: Double
    let defaultPositionX: Double
    let snackPositionX: Double
    let sleepEnergyThreshold: Int
    let wakeEnergyThreshold: Int
    let behaviorCycleFrames: Int
    let activeFrames: Int
    let automaticSpecialFrames: Int
    var idleEnergyDrain: Int = 1
    var walkEnergyDrain: Int = 1
    var specialEnergyDrain: Int = 2
    var sleepEnergyRecovery: Int = 2
}
