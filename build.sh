#!/usr/bin/env bash
# Сборка примера ИГХТУ и короткого отчёта ГОСТ локальным Typst.
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v typst >/dev/null 2>&1; then
  echo "Не найден typst. Нужен Typst 0.14: https://github.com/typst/typst/releases" >&2
  exit 1
fi

mkdir -p results/pages

echo "Дипломный пример..."
typst compile --root . examples/isit-diploma/main.typ results/example.pdf

echo "Короткий отчёт..."
typst compile --root . template/main.typ results/generic-report.pdf

if command -v pdftoppm >/dev/null 2>&1; then
  rm -f results/pages/page-*.png
  pdftoppm -png -r 110 results/example.pdf results/pages/page
  echo "Страницы: results/pages/page-01.png …"
else
  echo "pdftoppm не найден, PNG страниц не обновлялись."
fi

echo "Готово: results/example.pdf"
