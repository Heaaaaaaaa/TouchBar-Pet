import Foundation

struct PetState: Codable, Equatable {
    var hunger: Int
    var mood: Int
    var energy: Int
    var animationFrame: Int
    var lastUpdated: Date

    static let initial = PetState(
        hunger: 20,
        mood: 80,
        energy: 75,
        animationFrame: 0,
        lastUpdated: Date()
    )

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
        "Hunger \(hunger)  Mood \(mood)  Energy \(energy)"
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
}

extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
