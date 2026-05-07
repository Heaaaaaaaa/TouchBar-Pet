import Foundation

enum PetSpecies: String, Codable, CaseIterable, Equatable {
    case cat
    case pufferFish
    case ghost
    case dragon
    case plantBuddy

    var displayName: String {
        switch self {
        case .cat:
            return "Cat"
        case .pufferFish:
            return "Puffer Fish"
        case .ghost:
            return "Ghost"
        case .dragon:
            return "Dragon"
        case .plantBuddy:
            return "Plant Buddy"
        }
    }

    var defaultBackground: PetBackground {
        switch self {
        case .cat:
            return .grass
        case .pufferFish:
            return .aquarium
        case .ghost:
            return .night
        case .dragon:
            return .cozy
        case .plantBuddy:
            return .grass
        }
    }
}

enum PetBackground: String, Codable, CaseIterable, Equatable {
    case auto
    case aquarium
    case night
    case grass
    case cozy

    var displayName: String {
        switch self {
        case .auto:
            return "Auto"
        case .aquarium:
            return "Aquarium"
        case .night:
            return "Night Sky"
        case .grass:
            return "Grass"
        case .cozy:
            return "Cozy Room"
        }
    }
}

enum PetBehaviorMode: String, Codable, Equatable {
    case idle
    case walk
    case eat
    case play
    case sleep
    case special
}

enum PetDirection: String, Codable, Equatable {
    case left
    case right

    var multiplier: Double {
        self == .right ? 1 : -1
    }
}

struct PetState: Codable, Equatable {
    var hunger: Int
    var mood: Int
    var energy: Int
    var animationFrame: Int
    var lastUpdated: Date
    var species: PetSpecies
    var background: PetBackground
    var behaviorMode: PetBehaviorMode
    var direction: PetDirection
    var positionX: Double
    var velocityX: Double
    var actionTicksRemaining: Int

    static let initial = PetState(
        hunger: 20,
        mood: 80,
        energy: 75,
        animationFrame: 0,
        lastUpdated: Date(),
        species: .cat,
        background: .auto,
        behaviorMode: .walk,
        direction: .right,
        positionX: 0.42,
        velocityX: 0.018,
        actionTicksRemaining: 0
    )

    var activeBackground: PetBackground {
        background == .auto ? species.defaultBackground : background
    }

    var face: String {
        if behaviorMode == .sleep || energy <= 15 {
            return "(-_-) z"
        }

        if hunger >= 85 {
            return "(>_<)"
        }

        if mood <= 25 {
            return "(._.)"
        }

        return animationFrame.isMultiple(of: 2) ? "(^_^)" : "(^o^)"
    }

    var statusLine: String {
        "\(species.displayName)  Hunger \(hunger)  Mood \(mood)  Energy \(energy)"
    }

    var careHint: String {
        if hunger >= 75 {
            return "Hungry: feed me"
        }

        if energy <= 25 {
            return "Tired: let me rest"
        }

        if mood <= 35 {
            return "Bored: play with me"
        }

        return "Happy and cozy"
    }

    var touchBarStatsLine: String {
        switch species {
        case .cat:
            return "HP\(healthLevel) Hu\(hungerLevel) So\(socialLevel)"
        case .pufferFish:
            return "HP\(healthLevel) Hu\(hungerLevel) Ca\(calmLevel)"
        case .ghost:
            return "Gl\(glowLevel) Hu\(hungerLevel) Mo\(socialLevel)"
        case .dragon:
            return "HP\(healthLevel) Hu\(hungerLevel) Fi\(fireLevel)"
        case .plantBuddy:
            return "Wa\(waterLevel) Su\(sunLevel) Gr\(growthLevel)"
        }
    }

    private var healthLevel: Int {
        let raw = ((100 - hunger) + mood + energy) / 30
        return raw.clamped(to: 0...10)
    }

    private var hungerLevel: Int {
        (hunger / 10).clamped(to: 0...10)
    }

    private var socialLevel: Int {
        (mood / 10).clamped(to: 0...10)
    }

    private var calmLevel: Int {
        ((mood + energy) / 20).clamped(to: 0...10)
    }

    private var glowLevel: Int {
        ((mood + energy) / 20).clamped(to: 0...10)
    }

    private var fireLevel: Int {
        ((mood + energy + (100 - hunger)) / 30).clamped(to: 0...10)
    }

    private var waterLevel: Int {
        ((100 - hunger) / 10).clamped(to: 0...10)
    }

    private var sunLevel: Int {
        (energy / 10).clamped(to: 0...10)
    }

    private var growthLevel: Int {
        ((mood + energy + (100 - hunger)) / 30).clamped(to: 0...10)
    }

    private enum CodingKeys: String, CodingKey {
        case hunger
        case mood
        case energy
        case animationFrame
        case lastUpdated
        case species
        case background
        case behaviorMode
        case direction
        case positionX
        case velocityX
        case actionTicksRemaining
    }

    init(
        hunger: Int,
        mood: Int,
        energy: Int,
        animationFrame: Int,
        lastUpdated: Date,
        species: PetSpecies,
        background: PetBackground,
        behaviorMode: PetBehaviorMode = .walk,
        direction: PetDirection = .right,
        positionX: Double = 0.42,
        velocityX: Double = 0.018,
        actionTicksRemaining: Int = 0
    ) {
        self.hunger = hunger
        self.mood = mood
        self.energy = energy
        self.animationFrame = animationFrame
        self.lastUpdated = lastUpdated
        self.species = species
        self.background = background
        self.behaviorMode = behaviorMode
        self.direction = direction
        self.positionX = positionX
        self.velocityX = velocityX
        self.actionTicksRemaining = actionTicksRemaining
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        hunger = try container.decodeIfPresent(Int.self, forKey: .hunger) ?? PetState.initial.hunger
        mood = try container.decodeIfPresent(Int.self, forKey: .mood) ?? PetState.initial.mood
        energy = try container.decodeIfPresent(Int.self, forKey: .energy) ?? PetState.initial.energy
        animationFrame = try container.decodeIfPresent(Int.self, forKey: .animationFrame) ?? 0
        lastUpdated = try container.decodeIfPresent(Date.self, forKey: .lastUpdated) ?? Date()
        species = try container.decodeIfPresent(PetSpecies.self, forKey: .species) ?? .cat
        background = try container.decodeIfPresent(PetBackground.self, forKey: .background) ?? .auto
        behaviorMode = try container.decodeIfPresent(PetBehaviorMode.self, forKey: .behaviorMode) ?? .walk
        direction = try container.decodeIfPresent(PetDirection.self, forKey: .direction) ?? .right
        positionX = try container.decodeIfPresent(Double.self, forKey: .positionX) ?? 0.42
        velocityX = try container.decodeIfPresent(Double.self, forKey: .velocityX) ?? 0.018
        actionTicksRemaining = try container.decodeIfPresent(Int.self, forKey: .actionTicksRemaining) ?? 0
    }
}

extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
