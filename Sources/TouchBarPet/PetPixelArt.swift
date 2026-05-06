import AppKit

@MainActor
enum PetPixelArt {
    private struct PixelKey: Hashable {
        let x: Int
        let y: Int
    }

    static func drawPet(species: PetSpecies, state: PetState, origin: NSPoint, scale: CGFloat) {
        if PetBitmapArt.drawPet(species: species, state: state, origin: origin, scale: scale) {
            return
        }

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
        let orange = NSColor(calibratedRed: 1.0, green: 0.52, blue: 0.05, alpha: 1.0)
        let brightOrange = NSColor(calibratedRed: 1.0, green: 0.66, blue: 0.12, alpha: 1.0)
        let shadow = NSColor(calibratedRed: 0.58, green: 0.22, blue: 0.00, alpha: 1.0)
        let cream = NSColor(calibratedRed: 1.0, green: 0.82, blue: 0.55, alpha: 1.0)
        let pink = NSColor(calibratedRed: 1.0, green: 0.46, blue: 0.42, alpha: 1.0)
        let white = NSColor.white
        let black = NSColor.black
        let footStep = state.animationFrame.isMultiple(of: 2) ? 0 : 1

        if state.behaviorMode == .sleep {
            drawPixels([
                (3, 0, orange), (4, 0, orange), (5, 0, orange), (6, 0, orange),
                (2, 1, orange), (3, 1, shadow), (4, 1, brightOrange), (5, 1, orange), (6, 1, cream), (7, 1, orange),
                (1, 2, orange), (2, 2, orange), (3, 2, orange), (4, 2, orange), (5, 2, cream), (6, 2, cream), (7, 2, orange),
                (0, 3, white), (1, 3, orange), (2, 3, brightOrange), (3, 3, cream), (4, 3, cream), (5, 3, orange), (6, 3, orange),
                (2, 4, shadow), (3, 4, orange), (4, 4, orange), (5, 4, shadow)
            ], origin: origin, scale: scale, direction: state.direction)
            return
        }

        if state.behaviorMode == .play || state.behaviorMode == .special {
            drawPixels([
                (1, 0, white), (2, 0, orange), (3, 0, orange), (4, 0, orange), (5, 0, orange),
                (0, 1, orange), (1, 1, orange), (2, 1, brightOrange), (3, 1, shadow), (4, 1, orange), (5, 1, orange), (8, 1, orange), (9, 1, orange),
                (1, 2, orange), (2, 2, orange), (3, 2, orange), (4, 2, brightOrange), (5, 2, orange), (6, 2, orange), (7, 2, orange), (8, 2, cream), (9, 2, black),
                (2, 3, shadow), (3, 3, orange), (4, 3, orange), (5, 3, cream), (6, 3, orange), (7, 3, orange), (8, 3, cream), (9, 3, pink),
                (3, 4, orange), (4, 4, orange), (6, 4, white), (7, 4, orange)
            ], origin: origin, scale: scale, direction: state.direction)
            return
        }

        drawPixels([
            (1, 0, white), (2, 0, orange), (7, 0, orange), (9, 0, orange),
            (0, 1, orange), (1, 1, orange), (2, 1, brightOrange), (3, 1, shadow), (6, 1, orange), (7, 1, cream), (8, 1, orange), (9, 1, orange),
            (1, 2, orange), (2, 2, orange), (3, 2, brightOrange), (4, 2, orange), (5, 2, orange), (6, 2, orange), (7, 2, cream), (8, 2, black), (9, 2, cream),
            (2, 3, orange), (3, 3, orange), (4, 3, shadow), (5, 3, orange), (6, 3, orange), (7, 3, cream), (8, 3, cream), (9, 3, pink),
            (2, 4, orange), (3, 4, orange), (5, 4, orange), (6, 4, orange), (7, 4, white), (8, 4, orange),
            (2 + footStep, 5, shadow), (6 - footStep, 5, shadow)
        ], origin: origin, scale: scale, direction: state.direction)
    }

    private static func drawPufferFish(state: PetState, origin: NSPoint, scale: CGFloat) {
        let gold = NSColor(calibratedRed: 1.0, green: 0.66, blue: 0.10, alpha: 1.0)
        let highlight = NSColor(calibratedRed: 1.0, green: 0.82, blue: 0.24, alpha: 1.0)
        let orange = NSColor(calibratedRed: 0.95, green: 0.40, blue: 0.02, alpha: 1.0)
        let belly = NSColor(calibratedRed: 1.0, green: 0.88, blue: 0.65, alpha: 1.0)
        let fin = NSColor(calibratedRed: 0.12, green: 0.58, blue: 0.86, alpha: 1.0)
        let eyeShine = NSColor.white
        let black = NSColor.black
        let puffed = state.behaviorMode == .special || state.hunger > 72

        if puffed {
            drawPixels([
                (4, 0, orange), (6, 0, orange),
                (2, 1, gold), (3, 1, highlight), (4, 1, gold), (5, 1, gold), (6, 1, gold), (7, 1, gold),
                (1, 2, gold), (2, 2, gold), (3, 2, black), (4, 2, eyeShine), (5, 2, gold), (6, 2, black), (7, 2, eyeShine), (8, 2, gold),
                (0, 3, fin), (1, 3, gold), (2, 3, belly), (3, 3, belly), (4, 3, belly), (5, 3, belly), (6, 3, belly), (7, 3, gold), (8, 3, fin),
                (1, 4, gold), (2, 4, gold), (3, 4, belly), (4, 4, belly), (5, 4, belly), (6, 4, gold), (7, 4, gold),
                (2, 5, orange), (3, 5, gold), (4, 5, gold), (5, 5, gold), (6, 5, orange),
                (3, 6, orange), (5, 6, orange)
            ], origin: origin, scale: scale, direction: state.direction)
        } else {
            drawPixels([
                (1, 1, fin), (2, 0, gold), (3, 0, highlight), (4, 0, gold), (5, 1, gold),
                (0, 2, fin), (1, 2, gold), (2, 2, black), (3, 2, eyeShine), (4, 2, belly), (5, 2, gold), (6, 2, fin),
                (1, 3, gold), (2, 3, belly), (3, 3, belly), (4, 3, belly), (5, 3, gold),
                (2, 4, orange), (3, 4, gold), (4, 4, gold)
            ], origin: origin, scale: scale, direction: state.direction)
        }

        drawBubbles(origin: origin, scale: scale, direction: state.direction)
    }

    private static func drawGhost(state: PetState, origin: NSPoint, scale: CGFloat) {
        let glow = NSColor(calibratedRed: 0.62, green: 0.82, blue: 1.0, alpha: 0.24)
        glow.setFill()
        NSBezierPath(ovalIn: NSRect(x: origin.x - 1.5 * scale, y: origin.y - 0.5 * scale, width: 10 * scale, height: 8 * scale)).fill()

        let white = NSColor(calibratedRed: 0.86, green: 0.94, blue: 1.0, alpha: 1.0)
        let highlight = NSColor.white
        let blue = NSColor(calibratedRed: 0.52, green: 0.74, blue: 1.0, alpha: 1.0)
        let eye = NSColor(calibratedRed: 0.02, green: 0.15, blue: 0.42, alpha: 1.0)
        let dimEye = NSColor(calibratedRed: 0.36, green: 0.54, blue: 0.72, alpha: 1.0)
        let blink = state.animationFrame % 6 == 0 || state.behaviorMode == .sleep
        let mouth = state.behaviorMode == .special ? eye : white

        drawPixels([
            (3, 0, highlight), (4, 0, white),
            (2, 1, white), (3, 1, highlight), (4, 1, white), (5, 1, white),
            (1, 2, white), (2, 2, white), (3, 2, blink ? dimEye : eye), (4, 2, white), (5, 2, blink ? dimEye : eye), (6, 2, white),
            (1, 3, blue), (2, 3, white), (3, 3, white), (4, 3, mouth), (5, 3, white), (6, 3, blue),
            (0, 4, blue), (1, 4, white), (2, 4, white), (3, 4, white), (4, 4, white), (5, 4, white), (6, 4, white), (7, 4, blue),
            (1, 5, white), (2, 5, blue), (3, 5, white), (4, 5, blue), (5, 5, white), (6, 5, blue)
        ], origin: origin, scale: scale, direction: state.direction, outlineColor: NSColor(calibratedRed: 0.02, green: 0.09, blue: 0.28, alpha: 0.78))
    }

    private static func drawDragon(state: PetState, origin: NSPoint, scale: CGFloat) {
        let green = NSColor(calibratedRed: 0.32, green: 0.82, blue: 0.20, alpha: 1.0)
        let brightGreen = NSColor(calibratedRed: 0.52, green: 0.94, blue: 0.24, alpha: 1.0)
        let darkGreen = NSColor(calibratedRed: 0.08, green: 0.38, blue: 0.08, alpha: 1.0)
        let belly = NSColor(calibratedRed: 1.0, green: 0.72, blue: 0.24, alpha: 1.0)
        let wing = NSColor(calibratedRed: 0.96, green: 0.32, blue: 0.06, alpha: 1.0)
        let wingDark = NSColor(calibratedRed: 0.60, green: 0.12, blue: 0.02, alpha: 1.0)
        let horn = NSColor(calibratedRed: 1.0, green: 0.82, blue: 0.34, alpha: 1.0)
        let eyeWhite = NSColor.white
        let black = NSColor.black
        let wingLift = state.animationFrame.isMultiple(of: 2) || state.behaviorMode == .special
        let topWingY = wingLift ? 0 : 1

        drawPixels([
            (3, 0, horn), (6, 0, horn),
            (1, topWingY + 1, wingDark), (2, topWingY, wing), (3, 1, brightGreen), (4, 1, green), (5, 1, green), (6, 1, green), (7, 1, darkGreen),
            (0, topWingY + 2, wing), (1, topWingY + 2, wingDark), (2, 2, green), (3, 2, brightGreen), (4, 2, belly), (5, 2, green), (6, 2, black), (7, 2, eyeWhite), (8, 2, darkGreen),
            (1, 4, darkGreen), (2, 3, green), (3, 3, green), (4, 3, belly), (5, 3, green), (6, 3, green), (7, 3, green), (8, 3, green),
            (0, 5, darkGreen), (1, 5, green), (2, 4, darkGreen), (3, 4, green), (4, 4, belly), (5, 4, green), (6, 4, green),
            (1, 6, darkGreen), (3, 5, darkGreen), (6, 5, darkGreen)
        ], origin: origin, scale: scale, direction: state.direction)

        if state.behaviorMode == .special || state.animationFrame % 7 == 0 || state.mood > 88 {
            let fire = NSColor(calibratedRed: 1.0, green: 0.26, blue: 0.02, alpha: 1.0)
            let flame = NSColor(calibratedRed: 1.0, green: 0.78, blue: 0.08, alpha: 1.0)
            drawPixels([
                (9, 2, fire), (10, 1, flame), (10, 2, fire), (11, 2, flame), (10, 3, fire)
            ], origin: origin, scale: scale, direction: state.direction)
        }
    }

    private static func drawPlantBuddy(state: PetState, origin: NSPoint, scale: CGFloat) {
        let pot = NSColor(calibratedRed: 0.74, green: 0.38, blue: 0.14, alpha: 1.0)
        let potLight = NSColor(calibratedRed: 0.96, green: 0.54, blue: 0.20, alpha: 1.0)
        let potDark = NSColor(calibratedRed: 0.42, green: 0.20, blue: 0.08, alpha: 1.0)
        let leaf = NSColor(calibratedRed: 0.38, green: 0.86, blue: 0.18, alpha: 1.0)
        let leafLight = NSColor(calibratedRed: 0.66, green: 1.0, blue: 0.28, alpha: 1.0)
        let leafDark = NSColor(calibratedRed: 0.18, green: 0.54, blue: 0.10, alpha: 1.0)
        let flower = NSColor(calibratedRed: 1.0, green: 0.34, blue: 0.55, alpha: 1.0)
        let flowerCenter = NSColor(calibratedRed: 1.0, green: 0.86, blue: 0.20, alpha: 1.0)
        let water = NSColor(calibratedRed: 0.40, green: 0.86, blue: 1.0, alpha: 1.0)
        let black = NSColor.black
        let droop = state.hunger > 72 || state.energy < 22
        let blooming = !droop && (state.mood > 58 || state.behaviorMode == .play)

        var pixels: [(Int, Int, NSColor)] = [
            (1, 4, potDark), (2, 4, potLight), (3, 4, potLight), (4, 4, pot), (5, 4, pot), (6, 4, potDark),
            (1, 5, pot), (2, 5, black), (3, 5, potLight), (4, 5, pot), (5, 5, black), (6, 5, pot),
            (2, 6, potDark), (3, 6, potDark), (4, 6, potDark), (5, 6, potDark)
        ]

        if droop {
            pixels += [
                (3, 1, leafDark), (4, 1, leafDark),
                (2, 2, leaf), (3, 2, leafDark), (4, 2, leafDark), (5, 2, leafLight),
                (3, 3, leafDark), (4, 3, leafDark),
                (6, 1, water), (7, 0, water)
            ]
        } else if blooming {
            pixels += [
                (3, 0, flower), (4, 0, flower), (2, 1, flower), (3, 1, flower), (4, 1, flowerCenter), (5, 1, flower),
                (3, 2, leafLight), (4, 2, leaf),
                (2, 3, leaf), (3, 3, leafLight), (4, 3, leaf), (5, 3, leaf)
            ]
        } else {
            let sway = state.animationFrame.isMultiple(of: 2) ? 0 : 1
            pixels += [
                (3, 1, leafLight), (4, 1, leaf),
                (2 - sway, 2, leaf), (3, 2, leafLight), (4, 2, leaf), (5 + sway, 2, leaf),
                (3, 3, leafDark), (4, 3, leafDark)
            ]
        }

        drawPixels(pixels, origin: origin, scale: scale, direction: .right)
    }

    private static func drawBubbles(origin: NSPoint, scale: CGFloat, direction: PetDirection) {
        let bubble = NSColor(calibratedRed: 0.66, green: 0.93, blue: 1.0, alpha: 0.9)
        let offset = direction == .right ? -2.8 * scale : 8.8 * scale

        bubble.setFill()
        NSRect(x: origin.x + offset, y: origin.y + 1.0 * scale, width: scale, height: scale).fill()
        NSRect(
            x: origin.x + offset - CGFloat(direction.multiplier) * 2.0 * scale,
            y: origin.y - 0.8 * scale,
            width: scale,
            height: scale
        ).fill()
    }

    private static func drawPixels(
        _ pixels: [(Int, Int, NSColor)],
        origin: NSPoint,
        scale: CGFloat,
        direction: PetDirection,
        outlineColor: NSColor? = nil
    ) {
        let maxX = pixels.map(\.0).max() ?? 0
        let transformedPixels = pixels.map { x, y, color in
            (x: direction == .right ? x : maxX - x, y: y, color: color)
        }
        let occupiedPixels = Set(transformedPixels.map { PixelKey(x: $0.x, y: $0.y) })
        let outlineColor = outlineColor ?? NSColor(calibratedWhite: 0.0, alpha: 0.72)
        let outlineOffsets = [
            PixelKey(x: -1, y: 0),
            PixelKey(x: 1, y: 0),
            PixelKey(x: 0, y: -1),
            PixelKey(x: 0, y: 1)
        ]

        outlineColor.setFill()
        for pixel in occupiedPixels {
            for offset in outlineOffsets {
                let outlinePixel = PixelKey(x: pixel.x + offset.x, y: pixel.y + offset.y)

                guard !occupiedPixels.contains(outlinePixel) else {
                    continue
                }

                NSRect(
                    x: origin.x + CGFloat(outlinePixel.x) * scale,
                    y: origin.y + CGFloat(outlinePixel.y) * scale,
                    width: scale,
                    height: scale
                ).fill()
            }
        }

        for (x, y, color) in transformedPixels {
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
