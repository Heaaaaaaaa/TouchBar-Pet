#!/usr/bin/env python3
from collections import deque
from pathlib import Path
from statistics import median

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[1]
SHEET = ROOT / "Assets" / "PixelArt" / "pet-background-concept-sheet.png"
FOOD_SHEET = ROOT / "Assets" / "PixelArt" / "food-concept-sheet.png"
OUT_DIR = ROOT / "Sources" / "TouchBarPet" / "Resources" / "PixelArt" / "Sprites"
BACKGROUND_OUT_DIR = ROOT / "Sources" / "TouchBarPet" / "Resources" / "PixelArt" / "Backgrounds"
FOOD_OUT_DIR = ROOT / "Sources" / "TouchBarPet" / "Resources" / "PixelArt" / "Foods"

# Crops are from the generated concept sheet. They intentionally keep a little
# breathing room so the flood-fill background removal can find the dark canvas.
SPRITES = {
    "cat-idle": (190, 42, 180, 160),
    "cat-walk": (492, 48, 225, 150),
    "cat-sleep": (820, 45, 235, 150),
    "puffer-idle": (170, 215, 195, 165),
    "puffer-swim": (485, 215, 230, 155),
    "puffer-puff": (820, 205, 220, 175),
    "ghost-idle": (175, 375, 200, 125),
    "ghost-dash": (475, 370, 240, 130),
    "ghost-sleep": (820, 370, 210, 130),
    "dragon-idle": (165, 505, 230, 165),
    "dragon-run": (475, 505, 260, 165),
    "dragon-fire": (820, 495, 185, 158),
    "plant-sprout": (175, 675, 190, 155),
    "plant-flower": (490, 660, 200, 180),
    "plant-thirsty": (815, 665, 205, 175),
}

BACKGROUNDS = {
    "aquarium": (30, 828, 1194, 82),
    "night": (30, 928, 1194, 82),
    "grass": (30, 1027, 1194, 82),
    "cozy": (30, 1127, 1194, 82),
}

FOODS = {
    "cat-fish": (54, 570, 205, 150),
    "puffer-pellets": (300, 528, 215, 190),
    "ghost-star": (545, 512, 210, 210),
    "dragon-meat": (780, 522, 220, 195),
    "plant-water": (1010, 595, 180, 124),
}


def color_distance(a, b):
    return sum((int(a[i]) - int(b[i])) ** 2 for i in range(3)) ** 0.5


def edge_reference(image):
    width, height = image.size
    samples = []

    for x in range(width):
        samples.append(image.getpixel((x, 0))[:3])
        samples.append(image.getpixel((x, height - 1))[:3])

    for y in range(height):
        samples.append(image.getpixel((0, y))[:3])
        samples.append(image.getpixel((width - 1, y))[:3])

    return tuple(int(median(channel)) for channel in zip(*samples))


def remove_connected_background(image, threshold=18):
    image = image.convert("RGBA")
    width, height = image.size
    reference = edge_reference(image)
    visited = set()
    queue = deque()

    for x in range(width):
        queue.append((x, 0))
        queue.append((x, height - 1))

    for y in range(height):
        queue.append((0, y))
        queue.append((width - 1, y))

    while queue:
        x, y = queue.popleft()

        if (x, y) in visited or not (0 <= x < width and 0 <= y < height):
            continue

        visited.add((x, y))
        pixel = image.getpixel((x, y))

        if color_distance(pixel, reference) > threshold:
            continue

        image.putpixel((x, y), (pixel[0], pixel[1], pixel[2], 0))

        queue.append((x + 1, y))
        queue.append((x - 1, y))
        queue.append((x, y + 1))
        queue.append((x, y - 1))

    alpha = image.getchannel("A")
    bbox = alpha.getbbox()

    if bbox:
        image = image.crop(bbox)

    return image


def isolate_blue_water_food(image):
    image = image.convert("RGBA")
    pixels = image.load()
    width, height = image.size
    keep = set()

    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]

            if a == 0:
                continue

            is_blue_water = b > 135 and b >= g * 0.85 and b > r * 1.18
            is_water_highlight = b > 220 and g > 185 and r > 130

            if is_blue_water or is_water_highlight:
                for dy in range(-2, 3):
                    for dx in range(-2, 3):
                        keep.add((x + dx, y + dy))

    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]

            is_upper_non_water_accent = y < height * 0.36 and x > width * 0.38
            is_far_right_accent = y < height * 0.56 and x > width * 0.84

            if a != 0 and ((x, y) not in keep or is_upper_non_water_accent or is_far_right_accent):
                pixels[x, y] = (r, g, b, 0)

    bbox = image.getchannel("A").getbbox()
    if bbox:
        image = image.crop(bbox)

    return image


def clean_cozy_background(image):
    image = image.convert("RGBA")
    width, height = image.size
    draw = ImageDraw.Draw(image)
    left = 5
    right = width - 6
    top = 5
    bottom = height - 7
    wall_bottom = top + 35

    draw.rectangle((left, top, right, wall_bottom), fill=(132, 72, 34, 255))
    draw.rectangle((left, wall_bottom, right, bottom), fill=(75, 40, 29, 255))

    for y in range(top + 9, wall_bottom, 11):
        draw.rectangle((left + 3, y, right - 3, y + 1), fill=(83, 43, 27, 255))

    for row, y in enumerate(range(top, wall_bottom, 11)):
        offset = 44 if row % 2 else 0
        for x in range(left + offset, right, 94):
            draw.rectangle((x, y + 1, x + 2, min(y + 10, wall_bottom)), fill=(92, 48, 28, 255))

    for y in range(wall_bottom + 8, bottom, 10):
        draw.rectangle((left + 4, y, right - 4, y + 1), fill=(45, 24, 20, 255))

    for x in range(left + 20, right, 116):
        draw.rectangle((x, wall_bottom + 1, x + 2, bottom - 2), fill=(56, 30, 23, 255))

    rug_top = wall_bottom + 14
    rug_left = left + 170
    rug_right = right - 170
    draw.rectangle((rug_left, rug_top, rug_right, min(rug_top + 12, bottom - 3)), fill=(112, 44, 48, 255))
    draw.rectangle((rug_left + 10, rug_top + 3, rug_right - 10, min(rug_top + 8, bottom - 4)), fill=(144, 67, 47, 255))

    draw.rectangle((left + 3, top + 3, right - 3, top + 4), fill=(188, 111, 52, 255))
    draw.rectangle((left + 3, wall_bottom - 2, right - 3, wall_bottom), fill=(50, 28, 23, 255))
    return image


def main():
    source = Image.open(SHEET)
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    BACKGROUND_OUT_DIR.mkdir(parents=True, exist_ok=True)
    FOOD_OUT_DIR.mkdir(parents=True, exist_ok=True)

    for name, crop in SPRITES.items():
        x, y, width, height = crop
        sprite = source.crop((x, y, x + width, y + height))
        sprite = remove_connected_background(sprite)
        sprite.save(OUT_DIR / f"{name}.png")

    for name, crop in BACKGROUNDS.items():
        x, y, width, height = crop
        background = source.crop((x, y, x + width, y + height))
        if name == "cozy":
            background = clean_cozy_background(background)
        background.save(BACKGROUND_OUT_DIR / f"{name}.png")

    if FOOD_SHEET.exists():
        food_source = Image.open(FOOD_SHEET)

        for name, crop in FOODS.items():
            x, y, width, height = crop
            food = food_source.crop((x, y, x + width, y + height))
            food = remove_connected_background(food, threshold=32)
            if name == "plant-water":
                food = isolate_blue_water_food(food)
            food.save(FOOD_OUT_DIR / f"{name}.png")

    print(f"Extracted {len(SPRITES)} sprites into {OUT_DIR}")
    print(f"Extracted {len(BACKGROUNDS)} backgrounds into {BACKGROUND_OUT_DIR}")
    if FOOD_SHEET.exists():
        print(f"Extracted {len(FOODS)} foods into {FOOD_OUT_DIR}")


if __name__ == "__main__":
    main()
