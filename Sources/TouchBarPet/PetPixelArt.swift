import AppKit

@MainActor
enum PetPixelArt {
    static func drawPet(species: PetSpecies, state: PetState, origin: NSPoint, scale: CGFloat) {
        switch species {
        case .cat:
            drawCat(state: state, origin: origin, scale: scale)
        case .pufferFish:
            drawPufferFish(state: state, origin: origin, scale: scale)
        case .ghost:
            drawGhost(state: state, origin: origin, scale: scale)
        case .dragon:
            drawDragon(state: state, origin: origin, scale: scale)
        case .plantBuddy:
            drawPlantBuddy(state: state, origin: origin, scale: scale)
        }
    }

    private static func drawCat(state: PetState, origin: NSPoint, scale: CGFloat) {
        let orange = NSColor(calibratedRed: 1.0, green: 0.52, blue: 0.06, alpha: 1.0)
        let darkOrange = NSColor(calibratedRed: 0.72, green: 0.28, blue: 0.02, alpha: 1.0)
        let cream = NSColor(calibratedRed: 1.0, green: 0.78, blue: 0.36, alpha: 1.0)
        let black = NSColor.black
        let tailLift = state.animationFrame.isMultiple(of: 2) ? 0 : -1

        drawPixels([
            (2, 0, orange), (3, 0, orange), (4, 0, orange), (5, 0, orange),
            (1, 1, orange), (2, 1, orange), (3, 1, cream), (4, 1, cream), (5, 1, orange), (6, 1, orange),
            (0, 2, darkOrange), (1, 2, orange), (2, 2, black), (3, 2, cream), (4, 2, black), (5, 2, orange), (6, 2, darkOrange),
            (1, 3, orange), (2, 3, cream), (3, 3, darkOrange), (4, 3, cream), (5, 3, orange),
            (2, 4, orange), (3, 4, orange), (4, 4, orange), (5, 4, orange), (6, 4, orange),
            (5, 5, darkOrange), (6, 5, orange), (7, 5, orange),
            (7, 4 + tailLift, orange), (8, 3 + tailLift, orange)
        ], origin: origin, scale: scale)
    }

    private static func drawPufferFish(state: PetState, origin: NSPoint, scale: CGFloat) {
        let fish = NSColor(calibratedRed: 1.0, green: 0.66, blue: 0.12, alpha: 1.0)
        let belly = NSColor(calibratedRed: 1.0, green: 0.87, blue: 0.58, alpha: 1.0)
        let fin = NSColor(calibratedRed: 0.16, green: 0.62, blue: 0.93, alpha: 1.0)
        let black = NSColor.black
        let puff = state.hunger > 70 || state.animationFrame % 6 == 0

        let body: [(Int, Int, NSColor)] = puff ? [
            (2, 0, fish), (3, 0, fish), (4, 0, fish),
            (1, 1, fish), (2, 1, fish), (3, 1, fish), (4, 1, fish), (5, 1, fish),
            (0, 2, fin), (1, 2, fish), (2, 2, black), (3, 2, belly), (4, 2, black), (5, 2, fish), (6, 2, fin),
            (1, 3, fish), (2, 3, belly), (3, 3, belly), (4, 3, belly), (5, 3, fish),
            (2, 4, fish), (3, 4, fish), (4, 4, fish)
        ] : [
            (1, 1, fin), (2, 0, fish), (3, 0, fish), (4, 1, fish),
            (1, 2, fish), (2, 2, black), (3, 2, belly), (4, 2, fish), (5, 2, fin),
            (2, 3, fish), (3, 3, belly), (4, 3, fish)
        ]

        drawPixels(body, origin: origin, scale: scale)
        drawBubble(origin: NSPoint(x: origin.x + 8 * scale, y: origin.y), scale: scale)
    }

    private static func drawGhost(state: PetState, origin: NSPoint, scale: CGFloat) {
        let white = NSColor(calibratedRed: 0.84, green: 0.93, blue: 1.0, alpha: 1.0)
        let blue = NSColor(calibratedRed: 0.54, green: 0.76, blue: 1.0, alpha: 1.0)
        let eye = NSColor(calibratedRed: 0.02, green: 0.16, blue: 0.42, alpha: 1.0)
        let blink = state.animationFrame % 5 == 0

        drawPixels([
            (2, 0, white), (3, 0, white), (4, 0, white),
            (1, 1, white), (2, 1, white), (3, 1, white), (4, 1, white), (5, 1, white),
            (1, 2, white), (2, 2, blink ? blue : eye), (3, 2, white), (4, 2, blink ? blue : eye), (5, 2, white),
            (0, 3, blue), (1, 3, white), (2, 3, white), (3, 3, white), (4, 3, white), (5, 3, white), (6, 3, blue),
            (1, 4, white), (2, 4, blue), (3, 4, white), (4, 4, blue), (5, 4, white)
        ], origin: origin, scale: scale)
    }

    private static func drawDragon(state: PetState, origin: NSPoint, scale: CGFloat) {
        let green = NSColor(calibratedRed: 0.28, green: 0.78, blue: 0.24, alpha: 1.0)
        let darkGreen = NSColor(calibratedRed: 0.10, green: 0.42, blue: 0.12, alpha: 1.0)
        let wing = NSColor(calibratedRed: 0.95, green: 0.35, blue: 0.08, alpha: 1.0)
        let horn = NSColor(calibratedRed: 1.0, green: 0.78, blue: 0.28, alpha: 1.0)
        let black = NSColor.black

        drawPixels([
            (2, 0, horn), (5, 0, horn),
            (2, 1, green), (3, 1, green), (4, 1, green), (5, 1, green),
            (1, 2, wing), (2, 2, green), (3, 2, black), (4, 2, green), (5, 2, green), (6, 2, darkGreen),
            (0, 3, wing), (1, 3, green), (2, 3, green), (3, 3, green), (4, 3, green), (5, 3, green),
            (2, 4, darkGreen), (3, 4, green), (4, 4, green), (5, 4, darkGreen),
            (0, 5, darkGreen), (1, 5, green), (2, 5, green)
        ], origin: origin, scale: scale)

        if state.animationFrame % 4 == 0 || state.mood > 80 {
            let flame = NSColor(calibratedRed: 1.0, green: 0.31, blue: 0.04, alpha: 1.0)
            drawPixels([(7, 2, flame), (8, 2, flame), (7, 3, flame)], origin: origin, scale: scale)
        }
    }

    private static func drawPlantBuddy(state: PetState, origin: NSPoint, scale: CGFloat) {
        let pot = NSColor(calibratedRed: 0.74, green: 0.38, blue: 0.14, alpha: 1.0)
        let potDark = NSColor(calibratedRed: 0.42, green: 0.20, blue: 0.08, alpha: 1.0)
        let leaf = NSColor(calibratedRed: 0.32, green: 0.82, blue: 0.20, alpha: 1.0)
        let flower = NSColor(calibratedRed: 1.0, green: 0.33, blue: 0.54, alpha: 1.0)
        let black = NSColor.black
        let blooming = state.mood > 55

        var pixels: [(Int, Int, NSColor)] = [
            (2, 0, leaf), (4, 0, leaf),
            (1, 1, leaf), (2, 1, leaf), (3, 1, leaf), (4, 1, leaf), (5, 1, leaf),
            (3, 2, leaf),
            (1, 3, pot), (2, 3, pot), (3, 3, pot), (4, 3, pot), (5, 3, pot),
            (1, 4, pot), (2, 4, black), (3, 4, pot), (4, 4, black), (5, 4, pot),
            (2, 5, potDark), (3, 5, potDark), (4, 5, potDark)
        ]

        if blooming {
            pixels += [(3, 0, flower), (3, -1, flower), (2, 0, flower), (4, 0, flower)]
        }

        drawPixels(pixels, origin: origin, scale: scale)
    }

    private static func drawBubble(origin: NSPoint, scale: CGFloat) {
        NSColor(calibratedRed: 0.62, green: 0.92, blue: 1.0, alpha: 0.9).setFill()
        NSRect(x: origin.x, y: origin.y + scale, width: scale, height: scale).fill()
        NSRect(x: origin.x + 2 * scale, y: origin.y - scale, width: scale, height: scale).fill()
    }

    private static func drawPixels(_ pixels: [(Int, Int, NSColor)], origin: NSPoint, scale: CGFloat) {
        for (x, y, color) in pixels {
            color.setFill()
            NSRect(
                x: origin.x + CGFloat(x) * scale,
                y: origin.y + CGFloat(y) * scale,
                width: scale,
                height: scale
            ).fill()
        }
    }
}
