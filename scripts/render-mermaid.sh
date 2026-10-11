#!/usr/bin/env bash
# Перерисовывает diagrams/sequence.svg из sequence.mmd, если установлен mmdc.
# Без mmdc компиляция Typst использует уже лежащий в репозитории SVG.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
src="$root/examples/isit-diploma/diagrams/sequence.mmd"
out="$root/examples/isit-diploma/diagrams/sequence.svg"

if ! command -v mmdc >/dev/null 2>&1; then
  echo "mmdc не найден. Оставлен $out" >&2
  echo "Установка: npm install -g @mermaid-js/mermaid-cli" >&2
  exit 0
fi

mmdc -i "$src" -o "$out" -b white
echo "Записан $out"
