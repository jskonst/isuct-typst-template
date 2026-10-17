#import "@preview/diagraph:0.3.7": raw-render
#import "../endnotes.typ": endnote

= Техническое задание

Назначение системы — учёт педагогической нагрузки и выгрузка свода для кафедры. Требования к функциям ниже опираются на роли из @tab-roles и на сумму часов @eq-hours. Формулировки сознательно короткие: полный текст технического задания оформляют по @gost34602, здесь важнее показать ссылки.

== Сущности в формате DOT

Связи данных записаны на языке Graphviz. Пакет `diagraph` рисует схему своим WASM-модулем, отдельная программа `dot` не нужна, поэтому глава собирается и локально, и в typst.app @graphviz.

#figure(
  raw-render(```dot
    digraph load {
      rankdir=LR
      bgcolor=white
      node [shape=box, fontname="Times New Roman", fontsize=12]
      edge [fontname="Times New Roman", fontsize=11]
      teacher [label="Преподаватель"]
      disc [label="Дисциплина"]
      group [label="Группа"]
      load [label="Нагрузка"]
      teacher -> load [label="ведёт"]
      disc -> load [label="входит"]
      group -> load [label="поток"]
    }
  ```),
  caption: [Сущности учёта, описание Graphviz DOT],
) <fig-dot>

Исходник схемы — блок `dot` внутри `.typ`, а не отдельный файл. Номер у @fig-dot получается так же, как у рисунка Fletcher.

== Что не умеет сам Typst: Mermaid

Mermaid часто просят «прямо в исходнике». Компилятор Typst не исполняет JavaScript, поэтому диаграмму Mermaid он не рисует. Рабочий путь такой: текст диаграммы лежит в `diagrams/sequence.mmd`, скрипт `scripts/render-mermaid.sh` вызывает `mmdc`, если он установлен, и кладёт SVG рядом. В документ SVG входит обычным `image`. Пока SVG не пересобрали, в репозитории лежит уже готовый файл, и пример компилируется без Node.js.

Исходник Mermaid:

```mermaid
flowchart LR
  P[Преподаватель] --> W[Веб-клиент]
  W --> A[Сервер API]
  A --> D[(База данных)]
```

#figure(
  image("../diagrams/sequence.svg", width: 88%),
  caption: [Поток данных, рисунок из Mermaid через SVG],
) <fig-mermaid>

На @fig-mermaid ссылаются так же, как на схемы, нарисованные внутри Typst. Разница только в том, кто построил картинку: компилятор или внешний шаг #endnote[Если `mmdc` нет, правьте SVG вручную или поставьте `@mermaid-js/mermaid-cli`. Текст `.mmd` при этом остаётся источником.].
