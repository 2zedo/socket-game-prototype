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
BACK_MIN_HEADROOM = 4
BACK_ROW_SCALE = 0.94

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


def get_visible_bbox(image: Image.Image, alpha_threshold: int = BBOX_ALPHA_THRESHOLD) -> tuple[int, int, int, int] | None:
    pixels = image.load()
    left = image.width
    top = image.height
    right = -1
    bottom = -1

    for y in range(image.height):
        for x in range(image.width):
            if pixels[x, y][3] <= alpha_threshold:
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


def alpha_composite_clipped(canvas: Image.Image, source: Image.Image, position: tuple[int, int]) -> None:
    x, y = position
    source_left = max(0, -x)
    source_top = max(0, -y)
    source_right = min(source.width, canvas.width - x)
    source_bottom = min(source.height, canvas.height - y)

    if source_right <= source_left or source_bottom <= source_top:
        return

    canvas.alpha_composite(
        source.crop((source_left, source_top, source_right, source_bottom)),
        (x + source_left, y + source_top),
    )


def fit_back_frame(frame: Image.Image) -> Image.Image:
    # Back-facing frames keep the fixed-grid source cell intact so faint hair
    # pixels from yui-1.png are not mistaken for removable background.
    bbox = get_visible_bbox(frame, ALPHA_THRESHOLD)
    if bbox is None:
        return Image.new("RGBA", (FRAME_SIZE, FRAME_SIZE), (0, 0, 0, 0))

    visible_height = bbox[3] - bbox[1]
    baseline_limited_height = FOOT_BASELINE - BACK_MIN_HEADROOM
    scale = min(
        TARGET_CHARACTER_HEIGHT / float(visible_height),
        baseline_limited_height / float(visible_height),
    )
    target_width = max(1, round(frame.width * scale))
    target_height = max(1, round(frame.height * scale))
    resized = frame.resize((target_width, target_height), Image.Resampling.NEAREST)

    canvas = Image.new("RGBA", (FRAME_SIZE, FRAME_SIZE), (0, 0, 0, 0))
    visible_center_x = ((bbox[0] + bbox[2]) * 0.5) * scale
    visible_bottom_y = bbox[3] * scale
    x = round(FRAME_SIZE * 0.5 - visible_center_x)
    y = round(FOOT_BASELINE - visible_bottom_y)
    alpha_composite_clipped(canvas, resized, (x, y))
    return canvas


def shrink_back_frame(frame: Image.Image) -> Image.Image:
    # Scale the completed 96x96 back-facing frame as a whole. This avoids
    # re-cropping the silhouette while adding runtime headroom.
    bbox = get_visible_bbox(frame, ALPHA_THRESHOLD)
    if bbox is None:
        return frame

    target_width = max(1, round(FRAME_SIZE * BACK_ROW_SCALE))
    target_height = max(1, round(FRAME_SIZE * BACK_ROW_SCALE))
    resized = frame.resize((target_width, target_height), Image.Resampling.NEAREST)

    original_bottom = bbox[3] - 1
    resized_bbox = get_visible_bbox(resized, ALPHA_THRESHOLD)
    if resized_bbox is None:
        return frame

    resized_bottom = resized_bbox[3] - 1
    x = round(FRAME_SIZE * 0.5 - target_width * 0.5)
    y = original_bottom - resized_bottom

    canvas = Image.new("RGBA", (FRAME_SIZE, FRAME_SIZE), (0, 0, 0, 0))
    alpha_composite_clipped(canvas, resized, (x, y))
    return canvas


def fit_frames(frames: list[Image.Image]) -> list[Image.Image]:
    bboxes: list[tuple[int, int, int, int] | None] = [get_visible_bbox(frame) for frame in frames]
    fitted_frames: list[Image.Image] = []

    for index, frame in enumerate(frames):
        if index // GRID_COLUMNS == ROW_UP:
            fitted_frames.append(shrink_back_frame(fit_back_frame(frame)))
            continue

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
    source = Image.open(REFERENCE_SOURCE).convert("RGBA")
    frames = normalize_direction_sources(split_source_sheet(normalize_alpha(source)))
    source_frames = split_source_sheet(source)
    for column in range(GRID_COLUMNS):
        frames[ROW_UP * GRID_COLUMNS + column] = source_frames[ROW_UP * GRID_COLUMNS + column]
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
