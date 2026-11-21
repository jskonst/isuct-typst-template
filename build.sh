#!/usr/bin/env bash
# Сборка примеров ИГХТУ (диплом, курсовой, НИР) и короткого отчёта ГОСТ.
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

echo "Курсовой проект..."
typst compile --root . examples/kursovoy/main.typ results/kursovoy.pdf

echo "Отчёт по НИР..."
typst compile --root . examples/nir/main.typ results/nir.pdf

if command -v pdftoppm >/dev/null 2>&1; then
  rm -f results/pages/page-*.png results/pages/kursovoy-*.png results/pages/nir-*.png
  pdftoppm -png -r 110 results/example.pdf results/pages/page
  pdftoppm -png -r 110 results/kursovoy.pdf results/pages/kursovoy
  pdftoppm -png -r 110 results/nir.pdf results/pages/nir
  echo "Страницы: results/pages/page-01.png, kursovoy-1.png, nir-1.png …"
else
  echo "pdftoppm не найден, PNG страниц не обновлялись."
fi

echo "Готово: results/example.pdf, results/kursovoy.pdf, results/nir.pdf"
