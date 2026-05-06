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

struct PetState: Codable, Equatable {
    var hunger: Int
    var mood: Int
    var energy: Int
    var animationFrame: Int
    var lastUpdated: Date
    var species: PetSpecies
    var background: PetBackground

    static let initial = PetState(
        hunger: 20,
        mood: 80,
        energy: 75,
        animationFrame: 0,
        lastUpdated: Date(),
        species: .cat,
        background: .auto
    )

    var activeBackground: PetBackground {
        background == .auto ? species.defaultBackground : background
    }

    var face: String {
        if energy <= 15 {
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
        "Health: \(healthLevel)  Hunger: \(hungerLevel)  Social: \(socialLevel)"
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

    private enum CodingKeys: String, CodingKey {
        case hunger
        case mood
        case energy
        case animationFrame
        case lastUpdated
        case species
        case background
    }

    init(
        hunger: Int,
        mood: Int,
        energy: Int,
        animationFrame: Int,
        lastUpdated: Date,
        species: PetSpecies,
        background: PetBackground
    ) {
        self.hunger = hunger
        self.mood = mood
        self.energy = energy
        self.animationFrame = animationFrame
        self.lastUpdated = lastUpdated
        self.species = species
        self.background = background
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
    }
}

extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
