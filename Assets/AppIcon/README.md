# App Icon Assets

Generated with the built-in `imagegen` skill for TouchBar Pet.

## Files

- `app-icon-source.png`: full-size generated macOS app icon source.
- `menu-bar-icon-source.png`: generated chroma-key source for the tiny menu-bar icon.
- `menu-bar-icon-transparent-full.png`: chroma-key background removed with the `imagegen` skill helper.
- `menu-bar-icon-preview-18.png`: 18 px preview for checking menu-bar readability.
- `menu-bar-icon-dark-preview.png`: dark-background preview for quick visual QA.

Runtime files:

- `Resources/AppIcon.icns`
- `Sources/TouchBarPet/Resources/Icons/menu-bar-icon.png`

## Prompts

App icon:

```text
Use case: logo-brand
Asset type: macOS app icon for a Touch Bar pet app
Primary request: Create a polished macOS app icon for an app named TouchBar Pet, no text.
Subject: a cute orange pixel cat sitting on a glowing cyan Touch Bar strip, with a tiny sparkle and rounded friendly silhouette.
Style/medium: high-quality app icon, pixel-art subject inside a modern macOS icon, crisp and readable, slightly 3D rounded-square icon base, not photorealistic.
Composition/framing: centered square icon, generous padding, cat and Touch Bar strip are the first read, rounded-square app-icon base.
Lighting/mood: playful, cozy, bright, premium but cute.
Color palette: dark navy background, cyan Touch Bar glow, orange cat, subtle purple-blue rim light.
Materials/textures: soft glassy macOS icon base, crisp pixel-art cat and strip, clean highlights.
Constraints: no text, no watermark, no Apple logo, no MacBook logo, no UI screenshot, no labels, no extra pets.
```

Menu-bar icon:

```text
Use case: logo-brand
Asset type: tiny macOS menu bar / toolbar icon concept for TouchBar Pet
Primary request: Create a simple high-contrast toolbar icon mark for TouchBar Pet, no text.
Subject: a tiny sleeping pet face above a short Touch Bar capsule, simplified to a bold white silhouette/icon.
Style/medium: macOS menu bar template icon, clean monochrome glyph, vector-like but rendered as bitmap, pixel-pet charm, very simple.
Composition/framing: centered icon with generous padding, square canvas, the pet head and small Touch Bar capsule must remain readable at 18 px.
Color palette: pure white icon on a perfectly flat solid #00ff00 chroma-key background for background removal. Do not use #00ff00 anywhere in the icon.
Materials/textures: solid white/very light gray glyph, crisp edges, no shadows, no glow, no gradients.
Constraints: no text, no watermark, no letters, no background texture, no rounded square app base, no detailed scene, no black icon; background must be uniformly #00ff00.
```
