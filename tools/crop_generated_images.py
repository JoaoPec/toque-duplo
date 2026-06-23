from pathlib import Path
from shutil import copy2

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
GENERATED = Path(
    r"C:\Users\joao.santos\.codex\generated_images"
    r"\019ef228-045c-7a01-85df-aa5ca893a66c"
)

SHEETS = {
    "rafael_personas_sheet.png": "ig_0fcaf0c3ebdd8bb9016a39e607dc948191bbf58bf2a442f120.png",
    "women_reference_sheet.png": "ig_0fcaf0c3ebdd8bb9016a39e68e558881918f95ff34a2cb8da3.png",
    "gallery_reference_sheet.png": "ig_0fcaf0c3ebdd8bb9016a39e720c134819191e97ed7e0cca346.png",
    "trophy_stories_sheet.png": "ig_0fcaf0c3ebdd8bb9016a39e7648ee88191b015eb0b776665b4.png",
}


def crop_grid(src: Path, output_dir: Path, names: list[str], cols: int, rows: int) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    with Image.open(src) as image:
        width, height = image.size
        cell_w = width / cols
        cell_h = height / rows

        for index, name in enumerate(names):
            col = index % cols
            row = index // cols
            box = (
                round(col * cell_w),
                round(row * cell_h),
                round((col + 1) * cell_w),
                round((row + 1) * cell_h),
            )
            panel = image.crop(box)
            panel.save(output_dir / name, optimize=True)


def main() -> None:
    reference_dir = ROOT / "app" / "assets" / "images" / "reference"
    reference_dir.mkdir(parents=True, exist_ok=True)

    copied = {}
    for output_name, source_name in SHEETS.items():
        source = GENERATED / source_name
        target = reference_dir / output_name
        copy2(source, target)
        copied[output_name] = target

    crop_grid(
        copied["rafael_personas_sheet.png"],
        ROOT / "app" / "assets" / "images" / "characters",
        ["rafael_rafa.png", "rafael_theo.png", "rafael_gui.png"],
        cols=3,
        rows=1,
    )
    crop_grid(
        copied["women_reference_sheet.png"],
        ROOT / "app" / "assets" / "images" / "characters",
        ["camila.png", "bia.png", "iasmin.png", "leticia.png"],
        cols=4,
        rows=1,
    )
    crop_grid(
        copied["gallery_reference_sheet.png"],
        ROOT / "app" / "assets" / "images" / "gallery",
        [
            "gallery_beach.png",
            "gallery_apartment.png",
            "gallery_barbecue.png",
            "gallery_ramen.png",
            "gallery_maresias_sunset.png",
            "gallery_sao_paulo.png",
        ],
        cols=3,
        rows=2,
    )
    crop_grid(
        copied["trophy_stories_sheet.png"],
        ROOT / "app" / "assets" / "images" / "gallery",
        ["story_camila.png", "story_bia.png", "story_iasmin.png"],
        cols=3,
        rows=1,
    )
    copy2(copied["trophy_stories_sheet.png"], ROOT / "app" / "assets" / "images" / "gallery" / "trophy_stories.png")


if __name__ == "__main__":
    main()
