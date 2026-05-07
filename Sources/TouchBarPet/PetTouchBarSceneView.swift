import AppKit

enum PetTouchBarSceneAction {
    case playWithPet
    case feedAt(Double)
    case rest
}

@MainActor
final class PetTouchBarSceneView: NSView {
    private struct SceneLayout {
        let trackRect: NSRect
        let motionRect: NSRect
        let statsRect: NSRect
    }

    private let statsWidth: CGFloat = 122
    private let foodZoneCount = 12
    private lazy var foodZoneButtons: [NSButton] = (0..<foodZoneCount).map { index in
        makeTouchZoneButton(tag: index, action: #selector(foodZonePressed(_:)))
    }
    private lazy var petTouchButton = makeTouchZoneButton(tag: -1, action: #selector(petPressed))
    private lazy var restTouchButton = makeTouchZoneButton(tag: -2, action: #selector(restPressed))

    var petState: PetState = .initial {
        didSet {
            setAccessibilityLabel("TouchBar Pet. \(petState.touchBarStatsLine). Touch the pet to play, touch empty space to place food, or touch the status badge to rest.")
            updateTouchZones()
            needsDisplay = true
        }
    }

    var onAction: ((PetTouchBarSceneAction) -> Void)?

    override var isFlipped: Bool {
        true
    }

    override var intrinsicContentSize: NSSize {
        NSSize(width: 640, height: 30)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        installTouchZones()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layout() {
        super.layout()
        updateTouchZones()
    }

    override func draw(_ dirtyRect: NSRect) {
        let sceneLayout = layout(in: bounds)
        let petScale = scaleForCurrentSpecies()
        let petOrigin = petOrigin(in: sceneLayout.motionRect, scale: petScale)

        drawTrack(in: sceneLayout.trackRect)
        drawInteractionCue(in: sceneLayout.motionRect, petOrigin: petOrigin, scale: petScale)
        drawPetShadow(in: sceneLayout.trackRect, petOrigin: petOrigin, scale: petScale)
        PetPixelArt.drawPet(
            species: petState.species,
            state: petState,
            origin: petOrigin,
            scale: petScale
        )
        drawStats(in: sceneLayout.statsRect)
    }

    private func installTouchZones() {
        for button in foodZoneButtons {
            addSubview(button)
        }

        addSubview(petTouchButton)
        addSubview(restTouchButton)
        updateTouchZones()
    }

    private func makeTouchZoneButton(tag: Int, action: Selector) -> NSButton {
        let button = NSButton(frame: .zero)
        button.title = ""
        button.tag = tag
        button.target = self
        button.action = action
        button.isBordered = false
        button.isTransparent = true
        button.bezelStyle = .regularSquare
        button.setButtonType(.momentaryChange)
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return button
    }

    private func updateTouchZones() {
        guard bounds.width > 0, bounds.height > 0 else {
            return
        }

        let sceneLayout = layout(in: bounds)
        let petScale = scaleForCurrentSpecies()
        let petOrigin = petOrigin(in: sceneLayout.motionRect, scale: petScale)
        let petHitRect = NSRect(
            x: petOrigin.x - 12,
            y: petOrigin.y - 8,
            width: nominalSpriteWidth(for: petState.species, scale: petScale) + 24,
            height: nominalSpriteHeight(for: petState.species, scale: petScale) + 16
        )
        let zoneWidth = sceneLayout.motionRect.width / CGFloat(foodZoneCount)

        for (index, button) in foodZoneButtons.enumerated() {
            button.frame = NSRect(
                x: sceneLayout.motionRect.minX + CGFloat(index) * zoneWidth,
                y: sceneLayout.motionRect.minY,
                width: zoneWidth,
                height: sceneLayout.motionRect.height
            )
        }

        petTouchButton.frame = petHitRect
        restTouchButton.frame = sceneLayout.statsRect
    }

    @objc private func foodZonePressed(_ sender: NSButton) {
        let sceneLayout = layout(in: bounds)
        let petScale = scaleForCurrentSpecies()
        let point = NSPoint(x: sender.frame.midX, y: sceneLayout.motionRect.midY)
        onAction?(.feedAt(normalizedTouchPosition(for: point, in: sceneLayout.motionRect, scale: petScale)))
    }

    @objc private func petPressed() {
        onAction?(.playWithPet)
    }

    @objc private func restPressed() {
        onAction?(.rest)
    }

    private func layout(in bounds: NSRect) -> SceneLayout {
        // Keep the status badge in the part of the physical Touch Bar that remains
        // visible before the Control Strip compresses or clips trailing content.
        let trackWidth = min(max(340, bounds.width - 4), 580)
        let trackRect = NSRect(x: 0, y: 1, width: trackWidth, height: 28)
        let statsRect = NSRect(x: trackRect.maxX - statsWidth - 8, y: 4, width: statsWidth, height: 22)
        let motionRightEdge = statsRect.minX - 10
        let motionRect = NSRect(
            x: trackRect.minX,
            y: trackRect.minY,
            width: max(190, motionRightEdge - trackRect.minX),
            height: trackRect.height
        )

        return SceneLayout(
            trackRect: trackRect,
            motionRect: motionRect,
            statsRect: statsRect
        )
    }

    private func normalizedTouchPosition(for point: NSPoint, in rect: NSRect, scale: CGFloat) -> Double {
        let spriteWidth = nominalSpriteWidth(for: petState.species, scale: scale)
        let xInset = max(spriteWidth + 8, 28)
        let usableWidth = max(1, rect.width - xInset * 2)
        return Double((point.x - rect.minX - xInset) / usableWidth).clamped(to: 0.06...0.94)
    }

    private func drawTrack(in rect: NSRect) {
        let path = NSBezierPath(roundedRect: rect, xRadius: 8, yRadius: 8)
        let drewAssetBackground = PetBitmapBackground.drawBackground(petState.activeBackground, in: rect)

        if !drewAssetBackground {
            color(for: petState.activeBackground).setFill()
            path.fill()
            drawBackgroundDetails(in: rect, background: petState.activeBackground)
        }

        NSColor.black.withAlphaComponent(0.42).setStroke()
        path.lineWidth = 2
        path.stroke()

        let innerPath = NSBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), xRadius: 6, yRadius: 6)
        NSColor.white.withAlphaComponent(0.34).setStroke()
        innerPath.lineWidth = 1
        innerPath.stroke()

        NSColor.white.withAlphaComponent(0.16).setFill()
        NSRect(x: rect.minX + 8, y: rect.minY + 4, width: rect.width - 16, height: 2).fill()
    }

    private func color(for background: PetBackground) -> NSColor {
        switch background {
        case .auto:
            return color(for: petState.species.defaultBackground)
        case .aquarium:
            return NSColor(calibratedRed: 0.16, green: 0.88, blue: 0.98, alpha: 1.0)
        case .night:
            return NSColor(calibratedRed: 0.08, green: 0.10, blue: 0.34, alpha: 1.0)
        case .grass:
            return NSColor(calibratedRed: 0.34, green: 0.78, blue: 0.24, alpha: 1.0)
        case .cozy:
            return NSColor(calibratedRed: 0.46, green: 0.24, blue: 0.12, alpha: 1.0)
        }
    }

    private func drawBackgroundDetails(in rect: NSRect, background: PetBackground) {
        switch background {
        case .auto:
            drawBackgroundDetails(in: rect, background: petState.species.defaultBackground)
        case .aquarium:
            drawAquariumDetails(in: rect)
        case .night:
            drawNightDetails(in: rect)
        case .grass:
            drawGrassDetails(in: rect)
        case .cozy:
            drawCozyDetails(in: rect)
        }
    }

    private func drawAquariumDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.04, green: 0.62, blue: 0.74, alpha: 0.35).setFill()
        for y in stride(from: rect.minY + 6, to: rect.maxY - 4, by: 5) {
            NSRect(x: rect.minX + 5, y: y, width: rect.width - 10, height: 1).fill()
        }

        NSColor(calibratedWhite: 1.0, alpha: 0.65).setFill()
        for x in stride(from: rect.minX + 28, to: rect.maxX - 30, by: 76) {
            NSRect(x: x, y: rect.minY + 7, width: 2, height: 2).fill()
            NSRect(x: x + 7, y: rect.minY + 13, width: 2, height: 2).fill()
            NSRect(x: x + 12, y: rect.minY + 5, width: 2, height: 2).fill()
        }

        NSColor(calibratedRed: 0.04, green: 0.35, blue: 0.50, alpha: 0.45).setFill()
        for x in stride(from: rect.minX + 54, to: rect.maxX - 60, by: 118) {
            NSBezierPath(ovalIn: NSRect(x: x, y: rect.minY + 11, width: 18, height: 7)).fill()
        }

        NSColor(calibratedRed: 0.12, green: 0.38, blue: 0.42, alpha: 0.7).setFill()
        for x in stride(from: rect.minX + 62, to: rect.maxX - 40, by: 180) {
            NSRect(x: x, y: rect.maxY - 5, width: 18, height: 3).fill()
        }
    }

    private func drawNightDetails(in rect: NSRect) {
        NSColor(calibratedRed: 1.0, green: 0.88, blue: 0.36, alpha: 1.0).setFill()
        NSBezierPath(ovalIn: NSRect(x: rect.minX + 42, y: rect.minY + 5, width: 11, height: 11)).fill()

        NSColor.white.withAlphaComponent(0.82).setFill()
        for x in stride(from: rect.minX + 86, to: rect.maxX - 24, by: 58) {
            NSRect(x: x, y: rect.minY + 8, width: 2, height: 2).fill()
            NSRect(x: x + 28, y: rect.minY + 17, width: 2, height: 2).fill()
        }

        NSColor(calibratedRed: 0.22, green: 0.20, blue: 0.55, alpha: 0.72).setFill()
        for x in stride(from: rect.minX + 120, to: rect.maxX - 80, by: 250) {
            NSRect(x: x, y: rect.maxY - 7, width: 44, height: 3).fill()
            NSRect(x: x + 8, y: rect.maxY - 10, width: 24, height: 3).fill()
        }
    }

    private func drawGrassDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.46, green: 0.90, blue: 0.42, alpha: 0.28).setFill()
        for y in stride(from: rect.minY + 5, to: rect.maxY - 6, by: 3) {
            NSRect(x: rect.minX + 5, y: y, width: rect.width - 10, height: 1).fill()
        }

        NSColor(calibratedRed: 0.18, green: 0.52, blue: 0.12, alpha: 0.75).setFill()
        for x in stride(from: rect.minX + 8, to: rect.maxX - 8, by: 12) {
            NSRect(x: x, y: rect.maxY - 6, width: 3, height: 5).fill()
        }

        NSColor.white.withAlphaComponent(0.9).setFill()
        for x in stride(from: rect.minX + 44, to: rect.maxX - 30, by: 96) {
            NSRect(x: x, y: rect.minY + 11, width: 3, height: 3).fill()
        }

        NSColor(calibratedRed: 0.74, green: 0.82, blue: 0.28, alpha: 0.8).setFill()
        for x in stride(from: rect.minX + 92, to: rect.maxX - 40, by: 180) {
            NSRect(x: x, y: rect.maxY - 8, width: 14, height: 3).fill()
        }
    }

    private func drawCozyDetails(in rect: NSRect) {
        NSColor(calibratedRed: 0.74, green: 0.38, blue: 0.12, alpha: 0.42).setFill()
        NSRect(x: rect.minX + 4, y: rect.minY + 4, width: rect.width - 8, height: rect.height - 8).fill()

        NSColor(calibratedRed: 0.26, green: 0.12, blue: 0.06, alpha: 0.5).setFill()
        for x in stride(from: rect.minX, to: rect.maxX, by: 28) {
            NSRect(x: x, y: rect.midY, width: 22, height: 1).fill()
        }

        NSColor(calibratedRed: 1.0, green: 0.52, blue: 0.08, alpha: 0.9).setFill()
        NSBezierPath(ovalIn: NSRect(x: rect.minX + 245, y: rect.minY + 8, width: 24, height: 10)).fill()

        NSColor(calibratedRed: 0.52, green: 0.12, blue: 0.08, alpha: 0.72).setFill()
        for x in stride(from: rect.minX + 80, to: rect.maxX - 60, by: 260) {
            NSRect(x: x, y: rect.maxY - 8, width: 54, height: 4).fill()
        }
    }

    private func scaleForCurrentSpecies() -> CGFloat {
        switch petState.species {
        case .cat:
            return 2.75
        case .pufferFish:
            return petState.behaviorMode != .sleep && (petState.behaviorMode == .special || petState.hunger > 72) ? 2.55 : 3.0
        case .ghost:
            return 2.95
        case .dragon:
            return 2.55
        case .plantBuddy:
            return 2.65
        }
    }

    private func petOrigin(in rect: NSRect, scale: CGFloat) -> NSPoint {
        let spriteWidth = nominalSpriteWidth(for: petState.species, scale: scale)
        let x = sceneX(for: petState.positionX, in: rect, scale: scale)
        let baseY = rect.maxY - nominalSpriteHeight(for: petState.species, scale: scale) - 4
        let bob = verticalMotion()

        return NSPoint(x: x - spriteWidth / 2, y: baseY + bob)
    }

    private func sceneX(for normalizedPosition: Double, in rect: NSRect, scale: CGFloat) -> CGFloat {
        let spriteWidth = nominalSpriteWidth(for: petState.species, scale: scale)
        let xInset = max(spriteWidth + 8, 28)
        return rect.minX + xInset + CGFloat(normalizedPosition) * max(1, rect.width - xInset * 2)
    }

    private func nominalSpriteWidth(for species: PetSpecies, scale: CGFloat) -> CGFloat {
        if let assetSize = PetBitmapArt.preferredSize(species: species, state: petState, scale: scale) {
            return assetSize.width
        }

        switch species {
        case .cat:
            return 10.0 * scale
        case .pufferFish:
            return 9.0 * scale
        case .ghost:
            return 8.0 * scale
        case .dragon:
            return 12.0 * scale
        case .plantBuddy:
            return 8.0 * scale
        }
    }

    private func nominalSpriteHeight(for species: PetSpecies, scale: CGFloat) -> CGFloat {
        if let assetSize = PetBitmapArt.preferredSize(species: species, state: petState, scale: scale) {
            return assetSize.height
        }

        switch species {
        case .cat:
            return 6.0 * scale
        case .pufferFish:
            return (petState.behaviorMode != .sleep && (petState.behaviorMode == .special || petState.hunger > 72) ? 7.0 : 5.0) * scale
        case .ghost:
            return 6.0 * scale
        case .dragon:
            return 7.0 * scale
        case .plantBuddy:
            return 7.0 * scale
        }
    }

    private func verticalMotion() -> CGFloat {
        let frame = Double(petState.animationFrame)

        switch petState.species {
        case .cat:
            return petState.behaviorMode == .play ? -5 : 0
        case .pufferFish:
            if petState.behaviorMode == .sleep {
                return CGFloat(sin(frame * 0.28) * 0.6)
            }

            return CGFloat(sin(frame * 0.9) * 2.2)
        case .ghost:
            let float = CGFloat(sin(frame * 0.7) * 2.7)
            return petState.behaviorMode == .special ? float - 2 : float
        case .dragon:
            return petState.behaviorMode == .special ? CGFloat(sin(frame * 1.2) * 2.5) - 3 : 0
        case .plantBuddy:
            return 0
        }
    }

    private func drawInteractionCue(in rect: NSRect, petOrigin: NSPoint, scale: CGFloat) {
        if petState.behaviorMode == .eat {
            drawSnack(in: rect)
        }

        if petState.behaviorMode == .play {
            drawPlayCue(in: rect, petOrigin: petOrigin, scale: scale)
        }

        if petState.behaviorMode == .sleep {
            drawTinyText(
                "z",
                at: NSPoint(x: petOrigin.x + nominalSpriteWidth(for: petState.species, scale: scale) + 4, y: rect.minY + 4),
                size: 12,
                color: NSColor(calibratedRed: 0.70, green: 0.90, blue: 1.0, alpha: 0.95)
            )
        }

        if petState.behaviorMode == .special {
            drawSpecialCue(in: rect, petOrigin: petOrigin, scale: scale)
        }
    }

    private func drawSnack(in rect: NSRect) {
        let snackCenterX = sceneX(for: petState.snackPositionX, in: rect, scale: scaleForCurrentSpecies())
        let snackCenter = NSPoint(x: snackCenterX, y: rect.midY)

        if PetBitmapFood.drawFood(species: petState.species, centeredAt: snackCenter) {
            return
        }

        drawSnackShadow(center: snackCenter)

        switch petState.species {
        case .cat:
            drawFishSnack(center: snackCenter)
        case .pufferFish:
            drawPelletSnack(center: snackCenter)
        case .ghost:
            drawSoulStarSnack(center: snackCenter)
        case .dragon:
            drawDragonSnack(center: snackCenter)
        case .plantBuddy:
            drawWaterSnack(center: snackCenter)
        }
    }

    private func drawSnackShadow(center: NSPoint) {
        NSColor.black.withAlphaComponent(0.22).setFill()
        NSBezierPath(ovalIn: NSRect(x: center.x - 8, y: center.y + 5, width: 16, height: 3)).fill()
    }

    private func drawFishSnack(center: NSPoint) {
        let body = NSRect(x: center.x - 8, y: center.y - 4, width: 13, height: 8)
        let tail = NSBezierPath()
        tail.move(to: NSPoint(x: center.x + 5, y: center.y))
        tail.line(to: NSPoint(x: center.x + 10, y: center.y - 4))
        tail.line(to: NSPoint(x: center.x + 10, y: center.y + 4))
        tail.close()

        NSColor.black.withAlphaComponent(0.55).setFill()
        NSBezierPath(ovalIn: body.insetBy(dx: -1, dy: -1)).fill()
        tail.fill()

        NSColor(calibratedRed: 0.12, green: 0.70, blue: 0.95, alpha: 1.0).setFill()
        NSBezierPath(ovalIn: body).fill()
        NSColor(calibratedRed: 0.05, green: 0.48, blue: 0.88, alpha: 1.0).setFill()
        tail.fill()

        NSColor.white.withAlphaComponent(0.95).setFill()
        NSRect(x: center.x - 4, y: center.y - 2, width: 2, height: 5).fill()
        NSColor.black.withAlphaComponent(0.78).setFill()
        NSRect(x: center.x - 7, y: center.y - 1, width: 2, height: 2).fill()
    }

    private func drawPelletSnack(center: NSPoint) {
        let pelletPoints = [
            NSPoint(x: center.x - 5, y: center.y + 1),
            NSPoint(x: center.x, y: center.y - 3),
            NSPoint(x: center.x + 5, y: center.y + 2)
        ]

        drawSnackGlow(center: center, color: NSColor(calibratedRed: 1.0, green: 0.82, blue: 0.22, alpha: 1.0))

        for point in pelletPoints {
            NSColor.black.withAlphaComponent(0.55).setFill()
            NSBezierPath(ovalIn: NSRect(x: point.x - 3, y: point.y - 3, width: 6, height: 6)).fill()
            NSColor(calibratedRed: 1.0, green: 0.76, blue: 0.20, alpha: 1.0).setFill()
            NSBezierPath(ovalIn: NSRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4)).fill()
            NSColor.white.withAlphaComponent(0.85).setFill()
            NSRect(x: point.x - 1, y: point.y - 2, width: 1, height: 1).fill()
        }
    }

    private func drawSoulStarSnack(center: NSPoint) {
        drawSnackGlow(center: center, color: NSColor(calibratedRed: 0.80, green: 0.92, blue: 1.0, alpha: 1.0))

        NSColor.black.withAlphaComponent(0.45).setFill()
        drawDiamond(center: center, radius: 8)
        NSColor(calibratedRed: 0.78, green: 0.92, blue: 1.0, alpha: 1.0).setFill()
        drawDiamond(center: center, radius: 6)

        NSColor.white.withAlphaComponent(0.95).setFill()
        NSRect(x: center.x - 1, y: center.y - 6, width: 2, height: 12).fill()
        NSRect(x: center.x - 6, y: center.y - 1, width: 12, height: 2).fill()

        NSColor(calibratedRed: 0.64, green: 0.56, blue: 1.0, alpha: 0.9).setFill()
        NSRect(x: center.x + 8, y: center.y + 3, width: 2, height: 2).fill()
        NSRect(x: center.x - 10, y: center.y - 4, width: 2, height: 2).fill()
    }

    private func drawDragonSnack(center: NSPoint) {
        let meat = NSRect(x: center.x - 6, y: center.y - 5, width: 12, height: 9)
        drawSnackGlow(center: center, color: NSColor(calibratedRed: 1.0, green: 0.32, blue: 0.08, alpha: 1.0))

        NSColor.black.withAlphaComponent(0.55).setFill()
        NSBezierPath(ovalIn: meat.insetBy(dx: -1, dy: -1)).fill()
        NSColor(calibratedRed: 0.92, green: 0.18, blue: 0.08, alpha: 1.0).setFill()
        NSBezierPath(ovalIn: meat).fill()

        NSColor(calibratedRed: 1.0, green: 0.82, blue: 0.28, alpha: 1.0).setFill()
        NSRect(x: center.x - 2, y: center.y - 7, width: 4, height: 9).fill()
        NSColor(calibratedRed: 1.0, green: 0.95, blue: 0.52, alpha: 1.0).setFill()
        NSRect(x: center.x - 1, y: center.y - 5, width: 2, height: 4).fill()

        NSColor(calibratedRed: 1.0, green: 0.78, blue: 0.58, alpha: 1.0).setFill()
        NSRect(x: center.x + 2, y: center.y - 2, width: 3, height: 3).fill()
    }

    private func drawWaterSnack(center: NSPoint) {
        drawSnackGlow(center: center, color: NSColor(calibratedRed: 0.32, green: 0.92, blue: 1.0, alpha: 1.0))
        drawWaterDrop(center: NSPoint(x: center.x - 4, y: center.y), size: 7)
        drawWaterDrop(center: NSPoint(x: center.x + 5, y: center.y + 2), size: 5)

        NSColor(calibratedRed: 0.72, green: 1.0, blue: 0.72, alpha: 0.9).setFill()
        NSRect(x: center.x - 1, y: center.y + 5, width: 3, height: 2).fill()
        NSRect(x: center.x + 1, y: center.y + 3, width: 4, height: 2).fill()
    }

    private func drawSnackGlow(center: NSPoint, color: NSColor) {
        color.withAlphaComponent(0.22).setFill()
        NSBezierPath(ovalIn: NSRect(x: center.x - 10, y: center.y - 9, width: 20, height: 18)).fill()
    }

    private func drawDiamond(center: NSPoint, radius: CGFloat) {
        let path = NSBezierPath()
        path.move(to: NSPoint(x: center.x, y: center.y - radius))
        path.line(to: NSPoint(x: center.x + radius, y: center.y))
        path.line(to: NSPoint(x: center.x, y: center.y + radius))
        path.line(to: NSPoint(x: center.x - radius, y: center.y))
        path.close()
        path.fill()
    }

    private func drawWaterDrop(center: NSPoint, size: CGFloat) {
        let outline = NSBezierPath()
        outline.move(to: NSPoint(x: center.x, y: center.y - size))
        outline.curve(
            to: NSPoint(x: center.x, y: center.y + size * 0.72),
            controlPoint1: NSPoint(x: center.x - size * 0.82, y: center.y - size * 0.05),
            controlPoint2: NSPoint(x: center.x - size * 0.70, y: center.y + size * 0.72)
        )
        outline.curve(
            to: NSPoint(x: center.x, y: center.y - size),
            controlPoint1: NSPoint(x: center.x + size * 0.70, y: center.y + size * 0.72),
            controlPoint2: NSPoint(x: center.x + size * 0.82, y: center.y - size * 0.05)
        )
        outline.close()

        NSColor.black.withAlphaComponent(0.45).setFill()
        outline.fill()

        let fill = NSBezierPath()
        fill.move(to: NSPoint(x: center.x, y: center.y - size + 1))
        fill.curve(
            to: NSPoint(x: center.x, y: center.y + size * 0.52),
            controlPoint1: NSPoint(x: center.x - size * 0.60, y: center.y),
            controlPoint2: NSPoint(x: center.x - size * 0.50, y: center.y + size * 0.52)
        )
        fill.curve(
            to: NSPoint(x: center.x, y: center.y - size + 1),
            controlPoint1: NSPoint(x: center.x + size * 0.50, y: center.y + size * 0.52),
            controlPoint2: NSPoint(x: center.x + size * 0.60, y: center.y)
        )
        fill.close()

        NSColor(calibratedRed: 0.30, green: 0.86, blue: 1.0, alpha: 1.0).setFill()
        fill.fill()
        NSColor.white.withAlphaComponent(0.9).setFill()
        NSRect(x: center.x - 1, y: center.y - size * 0.35, width: 1, height: 2).fill()
    }

    private func drawPlayCue(in rect: NSRect, petOrigin: NSPoint, scale: CGFloat) {
        switch petState.species {
        case .cat:
            let toyPosition = (petState.positionX + 0.10 * petState.direction.multiplier).clamped(to: 0.06...0.94)
            let toyX = sceneX(for: toyPosition, in: rect, scale: scale) - 3
            NSColor(calibratedRed: 1.0, green: 0.32, blue: 0.58, alpha: 1.0).setFill()
            NSBezierPath(ovalIn: NSRect(x: toyX, y: rect.midY - 2, width: 6, height: 6)).fill()
            NSColor.white.withAlphaComponent(0.8).setFill()
            NSRect(x: toyX + 2, y: rect.midY - 5, width: 2, height: 3).fill()
        case .pufferFish:
            drawBubble(at: NSPoint(x: petOrigin.x - 7, y: rect.minY + 7), size: 4)
            drawBubble(at: NSPoint(x: petOrigin.x - 14, y: rect.minY + 14), size: 3)
        case .ghost:
            drawSparkle(at: NSPoint(x: petOrigin.x - 8, y: rect.minY + 9))
            drawSparkle(at: NSPoint(x: petOrigin.x + 30, y: rect.minY + 5))
        case .dragon:
            drawFlame(at: NSPoint(x: petOrigin.x + nominalSpriteWidth(for: petState.species, scale: scale) - 2, y: rect.minY + 11))
        case .plantBuddy:
            drawSunSpark(at: NSPoint(x: petOrigin.x + nominalSpriteWidth(for: petState.species, scale: scale) + 5, y: rect.minY + 6))
            drawSparkle(at: NSPoint(x: petOrigin.x - 8, y: rect.minY + 10))
        }
    }

    private func drawSpecialCue(in rect: NSRect, petOrigin: NSPoint, scale: CGFloat) {
        switch petState.species {
        case .cat:
            drawPlayCue(in: rect, petOrigin: petOrigin, scale: scale)
        case .pufferFish:
            drawBubble(at: NSPoint(x: petOrigin.x - 8, y: rect.minY + 6), size: 5)
            drawBubble(at: NSPoint(x: petOrigin.x + 28, y: rect.minY + 8), size: 4)
            drawBubble(at: NSPoint(x: petOrigin.x + 12, y: rect.minY + 3), size: 3)
        case .ghost:
            drawTinyText(
                "boo",
                at: NSPoint(x: petOrigin.x + nominalSpriteWidth(for: petState.species, scale: scale) + 3, y: rect.minY + 5),
                size: 10,
                color: NSColor(calibratedRed: 0.78, green: 0.92, blue: 1.0, alpha: 0.98)
            )
            drawSparkle(at: NSPoint(x: petOrigin.x - 8, y: rect.minY + 9))
        case .dragon:
            drawFlame(at: NSPoint(x: petOrigin.x + nominalSpriteWidth(for: petState.species, scale: scale) + 1, y: rect.minY + 9))
        case .plantBuddy:
            drawSunSpark(at: NSPoint(x: petOrigin.x + 24, y: rect.minY + 5))
        }
    }

    private func drawPetShadow(in rect: NSRect, petOrigin: NSPoint, scale: CGFloat) {
        guard petState.species != .ghost else {
            return
        }

        let phase = abs(sin(Double(petState.animationFrame) * .pi / 4))
        let isMoving = petState.behaviorMode == .walk || petState.behaviorMode == .eat || petState.behaviorMode == .play || petState.behaviorMode == .special
        var width = nominalSpriteWidth(for: petState.species, scale: scale) * 0.68
        var height: CGFloat = 3
        var alpha: CGFloat = petState.species == .pufferFish ? 0.12 : 0.22

        if isMoving {
            width *= 1.0 + CGFloat(phase) * 0.10
            height = 2.4 + CGFloat(1.0 - phase) * 0.9
            alpha *= 0.75 + CGFloat(1.0 - phase) * 0.25
        }

        NSColor.black.withAlphaComponent(alpha).setFill()
        NSBezierPath(ovalIn: NSRect(x: petOrigin.x + width * 0.18, y: rect.maxY - 5, width: width, height: height)).fill()
    }

    private func drawSparkle(at point: NSPoint) {
        NSColor(calibratedRed: 1.0, green: 0.90, blue: 0.32, alpha: 1.0).setFill()
        NSRect(x: point.x + 2, y: point.y, width: 2, height: 6).fill()
        NSRect(x: point.x, y: point.y + 2, width: 6, height: 2).fill()
    }

    private func drawBubble(at point: NSPoint, size: CGFloat) {
        NSColor.white.withAlphaComponent(0.85).setStroke()
        let bubble = NSBezierPath(ovalIn: NSRect(x: point.x, y: point.y, width: size, height: size))
        bubble.lineWidth = 1
        bubble.stroke()
    }

    private func drawFlame(at point: NSPoint) {
        NSColor(calibratedRed: 1.0, green: 0.30, blue: 0.06, alpha: 0.95).setFill()
        NSRect(x: point.x, y: point.y + 2, width: 7, height: 5).fill()
        NSColor(calibratedRed: 1.0, green: 0.82, blue: 0.18, alpha: 0.98).setFill()
        NSRect(x: point.x + 2, y: point.y, width: 4, height: 7).fill()
        NSColor(calibratedRed: 1.0, green: 0.95, blue: 0.52, alpha: 1.0).setFill()
        NSRect(x: point.x + 3, y: point.y + 2, width: 2, height: 3).fill()
    }

    private func drawSunSpark(at point: NSPoint) {
        NSColor(calibratedRed: 1.0, green: 0.88, blue: 0.22, alpha: 0.98).setFill()
        NSBezierPath(ovalIn: NSRect(x: point.x, y: point.y, width: 8, height: 8)).fill()
        NSColor(calibratedRed: 1.0, green: 0.96, blue: 0.55, alpha: 0.95).setFill()
        NSRect(x: point.x + 3, y: point.y - 3, width: 2, height: 3).fill()
        NSRect(x: point.x + 3, y: point.y + 8, width: 2, height: 3).fill()
        NSRect(x: point.x - 3, y: point.y + 3, width: 3, height: 2).fill()
        NSRect(x: point.x + 8, y: point.y + 3, width: 3, height: 2).fill()
    }

    private func drawTinyText(_ text: String, at point: NSPoint, size: CGFloat, color: NSColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: size, weight: .bold),
            .foregroundColor: color
        ]

        NSString(string: text).draw(at: point, withAttributes: attributes)
    }

    private func drawStats(in rect: NSRect) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let pill = NSBezierPath(roundedRect: rect.insetBy(dx: 0, dy: 1), xRadius: 7, yRadius: 7)
        NSColor.black.withAlphaComponent(0.58).setFill()
        pill.fill()

        NSColor.white.withAlphaComponent(0.38).setStroke()
        pill.lineWidth = 1
        pill.stroke()

        let textShadow = NSShadow()
        textShadow.shadowColor = NSColor.black.withAlphaComponent(0.85)
        textShadow.shadowOffset = NSSize(width: 0, height: 0)
        textShadow.shadowBlurRadius = 1

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: 12, weight: .heavy),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraph,
            .shadow: textShadow
        ]

        NSString(string: petState.touchBarStatsLine).draw(
            with: rect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes
        )
    }

}
