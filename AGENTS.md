# AGENTS.md — инструкция для ИИ-агентов

## Назначение
Шаблон Typst (форк `modern-g7-32`, ГОСТ 7.32-2017) для выпускных работ ИГХТУ (ISUCT).
- Титульный лист и бланк «Задание» повторяют Word-образцы `reference/titul.docx` и `reference/zadanie.docx`.
- Пример `examples/isit-diploma/` — одновременно краткое руководство для студентов: как в Typst оформлять главы, таблицы, рисунки, формулы, схемы, примечания и источники.
- Проект должен открываться в typst.app (ручная загрузка zip) и собираться в Docker.

## Карта репозитория
| Путь | Что там |
|---|---|
| `main.typ` | Точка входа для typst.app, делает `#include` примера |
| `src/export.typ`, `src/lib.typ`, `src/style.typ` | Публичный API шаблона и общие стили (шрифт, нумерация страниц, `set bibliography`) |
| `src/component/headings.typ` | Стили заголовков (структурные и нумерованные) |
| `src/component/appendixes.typ` | Приложения и их заголовки |
| `src/component/title*.typ`, `src/title-templates/` | Титульные листы |
| `examples/isit-diploma/main.typ` | Пример диплома: данные титула/задания и порядок глав |
| `examples/isit-diploma/isit-diploma.typ` | Бланки ИГХТУ: титульный лист и «Задание» |
| `examples/isit-diploma/chapters/*.typ` | Главы примера-руководства (`01-vvedenie` … `07-zaklyuchenie`) |
| `examples/isit-diploma/numbering.typ` | Ссылки, в т.ч. `#Ref` (с заглавной буквы) |
| `examples/isit-diploma/endnotes.typ`, `refs.bib` | Примечания и библиография |
| `examples/isit-diploma/diagrams/` | `sequence.mmd` (Mermaid) и закоммиченный `sequence.svg` |
| `template/main.typ` | Короткий отчёт без бланка кафедры |
| `fonts/` | Liberation Serif (для typst.app; локально приоритетнее Times New Roman) |
| `reference/` | Word-оригиналы, по которым сверяется вёрстка |
| `scripts/` | `check.sh`, `make-typst-app-zip.sh`, `render-mermaid.sh`, `make-comparison.py` |
| `results/` | `example.pdf`, `generic-report.pdf`, `pages/*.png`, `comparison/*.png` |
| `build.sh`, `Dockerfile` | Локальная и Docker-сборка |

## Сборка
Нужен Typst 0.14.x.
```sh
typst compile --root . --font-path fonts examples/isit-diploma/main.typ results/example.pdf
./build.sh                          # пример + короткий отчёт + PNG страниц (если есть pdftoppm)
./scripts/check.sh                  # быстрая проверка: компиляция без предупреждений
docker build -t isuct-typst . && docker run --rm -v "$PWD:/work" isuct-typst
./scripts/make-typst-app-zip.sh     # dist/isuct-typst-app.zip для typst.app
./scripts/render-mermaid.sh         # перерисовать sequence.svg (нужен mmdc)
```

## Проверка
1. `./scripts/check.sh` должен проходить.
2. Отрендерить страницы: `pdftoppm -png -r 110 results/example.pdf results/pages/page` и посмотреть изменённые страницы.
3. Если трогали титул или «Задание» — сравнить со `results/comparison/*.png` (`scripts/make-comparison.py`).

## Инварианты (не ломать)
- **typst.app:** проект самодостаточен; только относительные пути внутри `--root .`; шрифты из `fonts/`; никаких пакетов/плагинов, требующих shell или внешних программ (Mermaid — только через закоммиченный SVG).
- **Docker-сборка** должна работать (`Dockerfile` прогревает кэш пакетов, компилируя оба примера).
- **Титульный лист и «Задание»** не менять без явной просьбы — они выверены по docx.
- **Заголовки:** все, включая ВВЕДЕНИЕ, ЗАКЛЮЧЕНИЕ, СОДЕРЖАНИЕ, источники, примечания, приложения, — слева (с абзацного отступа), не полужирные. Нумерованные — с точкой после номера («1.», «1.1.»). Названия глав — ПРОПИСНЫМИ. Это сознательное отступление от п. 6.2.1 ГОСТ 7.32 (там — по центру); в остальном следуем ГОСТ 7.32-2017.
- **Ссылки:** в середине предложения строчными — «табл. 1.1», «рис. 2.1»; в начале предложения — с заглавной через `#Ref` («Табл.», «Рис.»).
- **Номер страницы** не печатается на страницах 1 и 2 (титул и задание).
- **Библиография:** стиль `gost-r-705-2008-numeric`.
- **Версии пакетов зафиксированы:** `@preview/fletcher:0.5.8`, `@preview/cetz:0.5.2`, `@preview/diagraph:0.3.7`. Не обновлять без проверки.
- В примере `«. Введение:»` и подобных лидах не должно быть лишних точек.

## Порядок работы
- Тексты, комментарии и коммиты — на русском.
- После изменений, влияющих на вывод, пересобрать и закоммитить `results/example.pdf` (и `results/pages/`, если есть pdftoppm).
- Изменения в `examples/` — это ещё и инструкция для студентов: пишите понятно и кратко.
