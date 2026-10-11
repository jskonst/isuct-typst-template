#!/usr/bin/env python3
"""Кладут две страницы рядом и подписывают их по-русски.

Запуск из корня репозитория после того, как есть PNG бланка Word
и PNG собранного примера. Пути ниже — значения по умолчанию для этой машины;
их можно заменить аргументами: left right "подпись слева" "подпись справа" out.png
"""

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

FONT_CANDIDATES = (
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
)


def load_font(size: int) -> ImageFont.ImageFont:
    for path in FONT_CANDIDATES:
        if Path(path).is_file():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def fit(image: Image.Image, width: int) -> Image.Image:
    ratio = width / image.width
    height = max(1, round(image.height * ratio))
    return image.convert("RGB").resize((width, height), Image.Resampling.LANCZOS)


def pair(left: Path, right: Path, left_label: str, right_label: str, out: Path, width: int = 820) -> None:
    gap = 28
    header = 64
    left_im = fit(Image.open(left), width)
    right_im = fit(Image.open(right), width)
    height = max(left_im.height, right_im.height)
    canvas = Image.new("RGB", (width * 2 + gap, height + header), "white")
    canvas.paste(left_im, (0, header))
    canvas.paste(right_im, (width + gap, header))
    draw = ImageDraw.Draw(canvas)
    font = load_font(28)
    draw.text((16, 18), left_label, fill=(20, 20, 20), font=font)
    draw.text((width + gap + 16, 18), right_label, fill=(20, 20, 20), font=font)
    out.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out, optimize=True)
    print(out)


def main() -> None:
    if len(sys.argv) == 6:
        pair(Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3], sys.argv[4], Path(sys.argv[5]))
        return

    root = Path(__file__).resolve().parents[1]
    refs = Path("/tmp/refs")
    pages = root / "results" / "pages"
    before = Path("/tmp/before-ref-png")
    out = root / "results" / "comparison"
    jobs = [
        (refs / "ref2-1.png", pages / "page-01.png", "Word, титульный лист", "Typst, титульный лист", out / "title-word-vs-typst.png"),
        (refs / "ref1-1.png", pages / "page-02.png", "Word, задание, стр. 1", "Typst, задание", out / "assignment-1-word-vs-typst.png"),
        (refs / "ref1-2.png", pages / "page-03.png", "Word, задание, стр. 2", "Typst, календарный план", out / "assignment-2-word-vs-typst.png"),
        (before / "page-1.png", pages / "page-01.png", "Прежний макет Typst", "Текущий титульный лист", out / "title-before-vs-after.png"),
        (before / "page-2.png", pages / "page-02.png", "Прежнее задание", "Текущее задание", out / "assignment-before-vs-after.png"),
    ]
    for left, right, left_label, right_label, dest in jobs:
        if not left.is_file() or not right.is_file():
            print(f"пропуск, нет файла: {left} или {right}", file=sys.stderr)
            continue
        pair(left, right, left_label, right_label, dest)


if __name__ == "__main__":
    main()
