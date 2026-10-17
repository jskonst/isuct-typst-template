#!/usr/bin/env bash
# Собирает dist/isuct-typst-app.zip — проект для загрузки в typst.app.
# В архиве только то, что нужно веб-приложению: точка входа, шаблон,
# пример, шрифт Liberation Serif и лицензия. Результаты сборки, Word-образцы
# и скрипты туда не входят.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

if ! command -v zip >/dev/null 2>&1; then
  echo "Не найдена программа zip." >&2
  exit 1
fi

for font in \
  fonts/LiberationSerif-Regular.ttf \
  fonts/LiberationSerif-Bold.ttf \
  fonts/LiberationSerif-Italic.ttf \
  fonts/LiberationSerif-BoldItalic.ttf
do
  if [[ ! -f "$font" ]]; then
    echo "Нет файла шрифта: $font" >&2
    exit 1
  fi
done

mkdir -p dist
out="$root/dist/isuct-typst-app.zip"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# Список стабильный, без лишних атрибутов zip.
{
  printf '%s\n' main.typ template/main.typ LICENSE
  find src examples/isit-diploma fonts -type f \
    ! -name '*.pdf' \
    ! -name '.DS_Store' \
    | sort
} >"$tmp"

rm -f "$out"
zip -X -q "$out" -@ <"$tmp"

echo "Готово: dist/isuct-typst-app.zip"
echo "Файлов: $(wc -l <"$tmp" | tr -d ' ')"
