# AGENTS.md — инструкция для ИИ-агентов

## Назначение
Шаблон Typst (форк `modern-g7-32`, ГОСТ 7.32-2017) для работ ИГХТУ (ISUCT).
- Титульный лист и бланк «Задание» диплома повторяют `reference/titul.docx` и `reference/zadanie.docx`.
- Титул курсового проекта — `kursovoy-title`, образец `reference/kursovoy.docx`.
- Титул отчёта по НИР (производственная практика) — `nir-title`, образец `reference/nir.docx`.
- Пример `examples/isit-diploma/` — краткое руководство для студентов по набору в Typst. Короткие примеры: `examples/kursovoy/`, `examples/nir/`.
- Проект должен открываться в typst.app (ручная загрузка zip) и собираться в Docker.

## Карта репозитория
| Путь | Что там |
|---|---|
| `main.typ` | Точка входа для typst.app, делает `#include` примера |
| `src/export.typ`, `src/lib.typ`, `src/style.typ` | Публичный API шаблона и общие стили (шрифт, нумерация страниц, `set bibliography`) |
| `src/component/headings.typ` | Стили заголовков (структурные и нумерованные) |
| `src/component/appendixes.typ` | Приложения и их заголовки |
| `src/component/title*.typ`, `src/title-templates/` | Титульные листы |
| `src/title-templates/isuct.typ` | `kursovoy-title` и `nir-title` |
| `examples/isit-diploma/main.typ` | Пример диплома: данные титула/задания и порядок глав |
| `examples/isit-diploma/isit-diploma.typ` | Бланки ИГХТУ: титульный лист и «Задание» диплома |
| `examples/kursovoy/main.typ`, `examples/nir/main.typ` | Примеры курсового проекта и отчёта по НИР |
| `examples/isit-diploma/chapters/*.typ` | Главы примера-руководства (`01-vvedenie` … `07-zaklyuchenie`) |
| `examples/isit-diploma/numbering.typ` | Ссылки, в т.ч. `#Ref` (с заглавной буквы) |
| `examples/isit-diploma/endnotes.typ`, `refs.bib` | Примечания и библиография |
| `examples/isit-diploma/diagrams/` | `sequence.mmd` (Mermaid) и закоммиченный `sequence.svg` |
| `template/main.typ` | Короткий отчёт без бланка кафедры |
| `fonts/` | Liberation Serif (для typst.app; локально приоритетнее Times New Roman) |
| `reference/` | Word-оригиналы: диплом, курсовой, НИР |
| `scripts/` | `check.sh`, `make-typst-app-zip.sh`, `render-mermaid.sh`, `make-comparison.py` |
| `results/` | `example.pdf`, `kursovoy.pdf`, `nir.pdf`, `generic-report.pdf`, `pages/`, `comparison/` |
| `build.sh`, `Dockerfile` | Локальная и Docker-сборка |

## Сборка
Нужен Typst 0.14.x.
```sh
typst compile --root . --font-path fonts examples/isit-diploma/main.typ results/example.pdf
typst compile --root . --font-path fonts examples/kursovoy/main.typ results/kursovoy.pdf
typst compile --root . --font-path fonts examples/nir/main.typ results/nir.pdf
./build.sh                          # все примеры + короткий отчёт + PNG страниц (если есть pdftoppm)
./scripts/check.sh                  # быстрая проверка: компиляция без предупреждений
docker build -t isuct-typst . && docker run --rm -v "$PWD:/work" isuct-typst
./scripts/make-typst-app-zip.sh     # dist/isuct-typst-app.zip для typst.app
./scripts/render-mermaid.sh         # перерисовать sequence.svg (нужен mmdc)
```

## Проверка
1. `./scripts/check.sh` должен проходить (его же запускает CI: `.github/workflows/build.yml` на push/PR в `main`; PDF — artifacts `isit-diploma-example-pdf`, `kursovoy-example-pdf`, `nir-example-pdf`; на тег `v*` эти PDF и `dist/isuct-typst-app.zip` прикладываются к релизу).
2. Отрендерить страницы: `pdftoppm -png -r 110 results/example.pdf results/pages/page` (для курсового и НИР — `results/pages/kursovoy`, `results/pages/nir`) и посмотреть изменённые страницы.
3. Если трогали титул или «Задание» диплома, курсового или НИР — сравнить со `results/comparison/*.png` (`scripts/make-comparison.py`) и с соответствующим файлом в `reference/`.

## Инварианты (не ломать)
- **typst.app:** проект самодостаточен; только относительные пути внутри `--root .`; шрифты из `fonts/`; никаких пакетов/плагинов, требующих shell или внешних программ (Mermaid — только через закоммиченный SVG).
- **Docker-сборка** должна работать (`Dockerfile` прогревает кэш пакетов, компилируя все примеры).
- **Титульный лист и «Задание» диплома** не менять без явной просьбы — они выверены по docx. Новые титулы `kursovoy-title` и `nir-title` тоже выверены по своим бланкам и без просьбы не «улучшать».
- **Заголовки:** все, включая ВВЕДЕНИЕ, ЗАКЛЮЧЕНИЕ, СОДЕРЖАНИЕ, источники, примечания, приложения, — слева (с абзацного отступа), не полужирные. Нумерованные — с точкой после номера («1.», «1.1.»). Названия глав в тексте — ПРОПИСНЫМИ (шаблон делает это сам, в исходнике пишут обычным регистром). В содержании (`#outline()`) названия как в исходнике, обычным регистром («Анализ предметной области», «Введение»), с той же точкой после номера. Это сознательное отступление от п. 6.2.1 ГОСТ 7.32 (там заголовки — по центру); в остальном следуем ГОСТ 7.32-2017.
- **Ссылки:** в середине предложения строчными — «табл. 1.1», «рис. 2.1»; в начале предложения — с заглавной через `#Ref` («Табл.», «Рис.»).
- **Номер страницы** не печатается на титуле. У диплома также нет номера на первой странице задания (страница 2).
- **Библиография:** стиль `gost-r-705-2008-numeric`.
- **Версии пакетов зафиксированы:** `@preview/fletcher:0.5.8`, `@preview/cetz:0.5.2`, `@preview/diagraph:0.3.7`. Не обновлять без проверки.
- В примере `«. Введение:»` и подобных лидах не должно быть лишних точек.

## Порядок работы
- Тексты, комментарии и коммиты — на русском.
- После изменений, влияющих на вывод, пересобрать и закоммитить затронутые PDF в `results/` (и `results/pages/`, если есть pdftoppm).
- Изменения в `examples/` — это ещё и инструкция для студентов: пишите понятно и кратко.
