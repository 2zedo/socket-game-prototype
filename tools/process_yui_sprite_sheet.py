from __future__ import annotations

from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "godot" / "assets" / "art" / "characters" / "yui" / "yui_source_sheet.png"
OUTPUT = ROOT / "godot" / "assets" / "art" / "characters" / "yui" / "yui_walk_4dir_rgba.png"

GRID_COLUMNS = 4
GRID_ROWS = 4
FRAME_SIZE = 64
TARGET_CHARACTER_HEIGHT = 56
FOOT_BASELINE = 60


def is_checker_pixel(r: int, g: int, b: int) -> bool:
    # The source file stores the checkerboard as real pixels. Keep dark clothes,
    # hair, skin, and outlines, but remove the bright neutral checker cells.
    is_neutral = abs(r - g) <= 8 and abs(g - b) <= 8 and abs(r - b) <= 8
    return is_neutral and min(r, g, b) >= 210


def remove_checker_background(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, a = pixels[x, y]
            if a == 0 or is_checker_pixel(r, g, b):
                pixels[x, y] = (r, g, b, 0)
    return rgba


def crop_visible_frame(frame: Image.Image) -> Image.Image:
    bbox = frame.getbbox()
    if bbox is None:
        return Image.new("RGBA", (FRAME_SIZE, FRAME_SIZE), (0, 0, 0, 0))
    return frame.crop(bbox)


def fit_frame(frame: Image.Image) -> Image.Image:
    visible = crop_visible_frame(frame)
    scale = TARGET_CHARACTER_HEIGHT / float(visible.height)
    target_width = max(1, round(visible.width * scale))
    target_height = TARGET_CHARACTER_HEIGHT
    resized = visible.resize((target_width, target_height), Image.Resampling.NEAREST)

    canvas = Image.new("RGBA", (FRAME_SIZE, FRAME_SIZE), (0, 0, 0, 0))
    x = (FRAME_SIZE - resized.width) // 2
    y = FOOT_BASELINE - resized.height
    canvas.alpha_composite(resized, (x, y))
    return canvas


def split_source_sheet(image: Image.Image) -> list[Image.Image]:
    frames: list[Image.Image] = []
    for row in range(GRID_ROWS):
        top = round(image.height * row / GRID_ROWS)
        bottom = round(image.height * (row + 1) / GRID_ROWS)
        for column in range(GRID_COLUMNS):
            left = round(image.width * column / GRID_COLUMNS)
            right = round(image.width * (column + 1) / GRID_COLUMNS)
            frames.append(image.crop((left, top, right, bottom)))
    return frames


def main() -> None:
    source = Image.open(SOURCE)
    transparent_source = remove_checker_background(source)
    frames = split_source_sheet(transparent_source)
    output = Image.new("RGBA", (FRAME_SIZE * GRID_COLUMNS, FRAME_SIZE * GRID_ROWS), (0, 0, 0, 0))

    for index, frame in enumerate(frames):
        fitted = fit_frame(frame)
        column = index % GRID_COLUMNS
        row = index // GRID_COLUMNS
        output.alpha_composite(fitted, (column * FRAME_SIZE, row * FRAME_SIZE))

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    output.save(OUTPUT)
    print(f"Wrote {OUTPUT} ({output.width}x{output.height})")


if __name__ == "__main__":
    main()
