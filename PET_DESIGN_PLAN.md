# TouchBar Pet Design And Movement Plan

## Design Goal

The pet should feel alive inside the narrow Touch Bar space, not just sit as a static icon. Each pet needs:

- A clear silhouette at tiny size.
- 3-6 simple animation frames.
- Movement that uses the long horizontal Touch Bar shape.
- Stats that map naturally to the pet theme.
- Touch actions that feel playful but do not block normal Touch Bar use.

Recommended visual style: pixel art / chunky low-resolution drawing, because it stays readable on the Touch Bar and is easier to animate frame-by-frame.

## Pet Concepts

### 1. Cat

Visual:
- Small orange or black pixel cat.
- Tail, ears, eyes, and tiny paws should be the main readable features.

Movement:
- Idle: sits and blinks.
- Walk: moves left/right across the cyan strip.
- Stretch: long body stretch when energy is high.
- Sleep: curls into a ball with `z`.
- Play: jumps toward a small toy dot.

Touch actions:
- Tap pet: play/jump.
- Feed: fish icon appears; cat walks to it.
- Rest: cat curls up.

Best stats:
- Health
- Hunger
- Social
- Energy

Why it is good:
- Very readable and cute.
- Easy first animated pet.
- Matches the original Touchbar Pet feeling.

### 2. Puffer Fish

Visual:
- Round fish with tiny fins, eyes, and bubbles.
- Normal body is small; stressed/hungry body puffs into a bigger circle.

Movement:
- Idle: slow floating bob up/down.
- Swim: moves smoothly left/right with tail wiggle.
- Puff: expands for 1-2 seconds when tapped or scared.
- Bubbles: small bubbles drift behind it.
- Sleep: floats slowly with eyes closed.

Touch actions:
- Tap pet: puff animation.
- Feed: small pellet drifts in; fish swims to eat.
- Play: fish does a loop or fast dash.
- Rest: lights dim / slower bob.

Best stats:
- Health
- Hunger
- Calm
- Energy

Why it is good:
- Uses horizontal movement well.
- Puff animation gives it personality.
- Different from normal cat/dog pets.

### 3. Little Ghost

Visual:
- White/blue ghost with round eyes and wavy bottom.
- Can glow softly against dark Touch Bar background.

Movement:
- Idle: float and bob.
- Blink: eyes disappear/reappear.
- Shy: hides behind a small cloud or fades.
- Happy: spins once or waves.
- Sleep: becomes dim with tiny moon.

Touch actions:
- Tap pet: ghost pops or says `boo`.
- Feed: gives a star/soul snack.
- Play: ghost chases cursor-like sparkle.
- Rest: ghost dims.

Best stats:
- Glow
- Hunger
- Mood
- Energy

Why it is good:
- Very easy to animate smoothly.
- Looks good in dark mode.
- Strong personality with few pixels.

### 4. Tiny Dragon

Visual:
- Small dragon with wings, horns, tail, and tiny flame.
- Use green/red/orange pixel blocks.

Movement:
- Idle: wing flap.
- Walk: little steps.
- Fly: short hover across the bar.
- Fire: tiny flame puff when excited.
- Sleep: curls around its tail.

Touch actions:
- Tap pet: flame puff.
- Feed: meat/fruit icon appears.
- Play: dragon flies across the strip.
- Rest: curls up.

Best stats:
- Health
- Hunger
- Fire
- Energy

Why it is good:
- More exciting than a normal pet.
- Fire stat can create unique gameplay.
- Slightly harder because wings/flame need extra frames.

### 5. Plant Buddy

Visual:
- Small sprout in a pot that grows leaves/flower.
- Mood changes leaf angle and flower color.

Movement:
- Idle: leaves sway.
- Happy: flower opens.
- Hungry/thirsty: droops.
- Rest: closes flower.
- Growth: slowly gains new leaves over time.

Touch actions:
- Feed: fertilizer.
- Play: sunshine sparkle.
- Rest: moon/night mode.

Best stats:
- Health
- Water
- Sun
- Growth

Why it is good:
- Calm and low-distraction.
- Works well as background Touch Bar companion.
- Less movement-heavy, but long-term growth can be satisfying.

## Recommended First Set

Build these first, in this order:

1. Cat
2. Puffer Fish
3. Ghost

Reason:
- Cat proves normal pet behavior.
- Puffer Fish proves special animation behavior.
- Ghost proves floating/glow behavior.

Dragon and Plant Buddy can come after the animation system is stable.

## Movement System Plan

Create a shared movement model instead of hardcoding each pet:

- `positionX`: horizontal position on Touch Bar scene.
- `velocityX`: left/right movement speed.
- `animationFrame`: current sprite frame.
- `mode`: idle, walk, play, eat, sleep, special.
- `direction`: left or right.
- `moodEffect`: happy, tired, hungry, sad.

Each tick:

1. Update pet stats.
2. Choose behavior mode from stats and recent user action.
3. Update movement.
4. Pick sprite frame.
5. Redraw Touch Bar scene.

## Sprite Frame Plan

Represent each pet as tiny pixel frames in code first. Later, replace with image assets if needed.

Suggested frame counts:

- Cat: 6 frames
  - sit 1
  - blink 1
  - walk 2
  - sleep 1
  - jump 1
- Puffer Fish: 6 frames
  - swim 2
  - blink 1
  - puff 2
  - sleep 1
- Ghost: 5 frames
  - float 2
  - blink 1
  - boo 1
  - sleep 1

## Touch Bar Layout Plan

Collapsed tray:
- Small icon only.
- Tap icon expands full pet bar.

Expanded full bar:
- Left/middle: pet scene with moving pet.
- Right: compact stats.
- Optional buttons: Feed, Play, Rest if space is available.

Avoid auto-expanding by default because it interferes with other Touch Bar tools.

## Implementation Steps

1. Add `PetSpecies` enum: cat, pufferFish, ghost, dragon, plant.
2. Add `PetBehaviorMode` enum: idle, walk, eat, play, sleep, special.
3. Add movement fields to `PetState` or a new `PetRuntimeState`.
4. Move drawing logic out of `PetTouchBarSceneView` into species-specific sprite drawers.
5. Implement Cat first.
6. Add a menu-bar species selector.
7. Implement Puffer Fish.
8. Implement Ghost.
9. Save selected species in local state.
10. Update `DEVELOPMENT_PLAN.md` after each species is completed.

## First Implementation Recommendation

Start with Cat.

Cat should replace the current single orange pixel pet because:

- It is closest to the original Touchbar Pet style.
- It is easiest to understand from a small icon.
- It gives useful base animations: idle, walk, sleep, play.

After Cat works, use Puffer Fish to prove that the animation system supports unique species-specific behavior.

## Generated Concept Asset

The first generated pixel-art reference sheet is saved at:

- `Assets/PixelArt/pet-background-concept-sheet.png`

It includes:

- Cat, Puffer Fish, Ghost, Dragon, and Plant Buddy concept frames.
- Four Touch Bar background strip concepts: aquarium, night sky, grass, and cozy room.

Use `Assets/PixelArt/README.md` for the exact generation prompt and extraction notes.
