#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/diagraph:0.3.7": raw-render

= Схемы

Четыре рисунка ниже — четыре способа держать схему в исходнике. Первые три компилирует сам Typst, в том числе на typst.app. Четвёртый — готовая картинка: компилятор не исполняет JavaScript.

== Fletcher

```typst
#figure(
  diagram(
    node-stroke: 0.6pt,
    spacing: 8mm,
    node((0, 0), [Глава], corner-radius: 2pt),
    node((1, 0), [Рисунок], corner-radius: 2pt),
    edge((0, 0), (1, 0), "->"),
  ),
  caption: [Узел и стрелка, Fletcher],
) <fig-fletcher>
```

#figure(
  diagram(
    node-stroke: 0.6pt,
    spacing: 8mm,
    node((0, 0), [Глава], corner-radius: 2pt),
    node((1, 0), [Рисунок], corner-radius: 2pt),
    edge((0, 0), (1, 0), "->"),
  ),
  caption: [Узел и стрелка, Fletcher],
) <fig-fletcher>

== CeTZ

```typst
#figure(
  canvas(length: 1cm, {
    import draw: *
    circle((0, 0), radius: 0.45, name: "a")
    content((0, 0), [А])
    circle((2.2, 0), radius: 0.45, name: "b")
    content((2.2, 0), [Б])
    line("a", "b", mark: (end: ">"))
  }),
  caption: [Два круга, CeTZ],
) <fig-cetz>
```

#figure(
  canvas(length: 1cm, {
    import draw: *
    circle((0, 0), radius: 0.45, name: "a")
    content((0, 0), [А])
    circle((2.2, 0), radius: 0.45, name: "b")
    content((2.2, 0), [Б])
    line("a", "b", mark: (end: ">"))
  }),
  caption: [Два круга, CeTZ],
) <fig-cetz>

== Graphviz через diagraph

Пакет рисует DOT своим WASM-модулем. Отдельная программа `dot` не нужна. Подписи просят Times New Roman; если семейства нет, для них берётся встроенный шрифт Typst.

```typst
#figure(
  raw-render(```dot
    digraph g {
      rankdir=LR
      node [shape=box, fontname="Times New Roman"]
      a [label="Исходник"]
      b [label="PDF"]
      a -> b
    }
  ```),
  caption: [Два узла, Graphviz DOT],
) <fig-dot>
```

#figure(
  raw-render(```dot
    digraph g {
      rankdir=LR
      node [shape=box, fontname="Times New Roman"]
      a [label="Исходник"]
      b [label="PDF"]
      a -> b
    }
  ```),
  caption: [Два узла, Graphviz DOT],
) <fig-dot>

== Mermaid

Текст диаграммы лежит в `diagrams/sequence.mmd`. Typst его не исполняет. Рядом уже лежит `sequence.svg`, его и вставляют как обычный рисунок (выше это @fig-flow). Перерисовать SVG можно только локально: `./scripts/render-mermaid.sh`, если установлен `mmdc`. На typst.app этот скрипт не запускается.
