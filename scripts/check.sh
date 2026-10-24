#!/usr/bin/env bash
# Компилирует пример и короткий отчёт; падает при ошибках и предупреждениях.
set -euo pipefail
cd "$(dirname "$0")/.."
command -v typst >/dev/null || { echo "Не найден typst (нужен 0.14.x)" >&2; exit 1; }
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
status=0
for src in examples/isit-diploma/main.typ template/main.typ; do
  log="$tmp/log"
  if ! typst compile --root . --font-path fonts "$src" "$tmp/out.pdf" 2>"$log"; then
    cat "$log" >&2; echo "ОШИБКА: $src" >&2; status=1; continue
  fi
  if grep -q "warning" "$log"; then
    cat "$log" >&2; echo "ПРЕДУПРЕЖДЕНИЯ: $src" >&2; status=1
  else
    echo "OK: $src"
  fi
done
exit $status
