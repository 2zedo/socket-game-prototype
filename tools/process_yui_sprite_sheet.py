from __future__ import annotations

import shutil
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
REFERENCE_SOURCE = ROOT / "docs" / "reference" / "yui-1.png"
SOURCE_COPY = ROOT / "godot" / "assets" / "art" / "characters" / "yui" / "yui_1_source_sheet.png"
OUTPUT = ROOT / "godot" / "assets" / "art" / "characters" / "yui" / "yui_walk_4dir_rgba.png"

GRID_COLUMNS = 4
GRID_ROWS = 4
FRAME_SIZE = 96
TARGET_CHARACTER_HEIGHT = 78
FOOT_BASELINE = 90
ALPHA_THRESHOLD = 12
BBOX_ALPHA_THRESHOLD = 48
CROP_PADDING = 4

ROW_DOWN = 0
ROW_LEFT = 1
ROW_RIGHT = 2
ROW_UP = 3


def normalize_alpha(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, a = pixels[x, y]
            if a <= ALPHA_THRESHOLD:
                pixels[x, y] = (0, 0, 0, 0)
    return rgba


def get_visible_bbox(image: Image.Image) -> tuple[int, int, int, int] | None:
    pixels = image.load()
    left = image.width
    top = image.height
    right = -1
    bottom = -1

    for y in range(image.height):
        for x in range(image.width):
            if pixels[x, y][3] <= BBOX_ALPHA_THRESHOLD:
                continue
            left = min(left, x)
            top = min(top, y)
            right = max(right, x)
            bottom = max(bottom, y)

    if right < left or bottom < top:
        return None

    return (left, top, right + 1, bottom + 1)


def expand_bbox(bbox: tuple[int, int, int, int], size: tuple[int, int]) -> tuple[int, int, int, int]:
    return (
        max(0, bbox[0] - CROP_PADDING),
        max(0, bbox[1] - CROP_PADDING),
        min(size[0], bbox[2] + CROP_PADDING),
        min(size[1], bbox[3] + CROP_PADDING),
    )


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


def normalize_direction_sources(frames: list[Image.Image]) -> list[Image.Image]:
    normalized = frames.copy()
    for column in range(GRID_COLUMNS):
        left_frame = frames[ROW_LEFT * GRID_COLUMNS + column]
        # The source right row has inconsistent crop extent, so mirror the
        # matching left frame to keep side-view scale and silhouette stable.
        normalized[ROW_RIGHT * GRID_COLUMNS + column] = left_frame.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    return normalized


def fit_frames(frames: list[Image.Image]) -> list[Image.Image]:
    bboxes: list[tuple[int, int, int, int] | None] = [get_visible_bbox(frame) for frame in frames]
    fitted_frames: list[Image.Image] = []

    for index, frame in enumerate(frames):
        bbox = bboxes[index]
        if bbox is None:
            fitted_frames.append(Image.new("RGBA", (FRAME_SIZE, FRAME_SIZE), (0, 0, 0, 0)))
            continue

        crop_bbox = expand_bbox(bbox, frame.size)
        visible = frame.crop(crop_bbox)
        visible_height = bbox[3] - bbox[1]
        scale = TARGET_CHARACTER_HEIGHT / float(visible_height)
        target_width = max(1, round(visible.width * scale))
        target_height = max(1, round(visible.height * scale))
        resized = visible.resize((target_width, target_height), Image.Resampling.NEAREST)

        canvas = Image.new("RGBA", (FRAME_SIZE, FRAME_SIZE), (0, 0, 0, 0))
        visible_center_x = ((bbox[0] + bbox[2]) * 0.5 - crop_bbox[0]) * scale
        visible_bottom_y = (bbox[3] - crop_bbox[1]) * scale
        x = round(FRAME_SIZE * 0.5 - visible_center_x)
        y = round(FOOT_BASELINE - visible_bottom_y)
        canvas.alpha_composite(resized, (x, y))
        fitted_frames.append(canvas)

    return fitted_frames


def main() -> None:
    source = normalize_alpha(Image.open(REFERENCE_SOURCE))
    frames = normalize_direction_sources(split_source_sheet(source))
    fitted_frames = fit_frames(frames)
    output = Image.new("RGBA", (FRAME_SIZE * GRID_COLUMNS, FRAME_SIZE * GRID_ROWS), (0, 0, 0, 0))

    for index, frame in enumerate(fitted_frames):
        column = index % GRID_COLUMNS
        row = index // GRID_COLUMNS
        output.alpha_composite(frame, (column * FRAME_SIZE, row * FRAME_SIZE))

    SOURCE_COPY.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(REFERENCE_SOURCE, SOURCE_COPY)
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    output.save(OUTPUT)
    print(f"Copied {REFERENCE_SOURCE} to {SOURCE_COPY}")
    print(f"Wrote {OUTPUT} ({output.width}x{output.height})")


if __name__ == "__main__":
    main()
