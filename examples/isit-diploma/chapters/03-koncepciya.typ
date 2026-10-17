#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/cetz:0.5.2": canvas, draw
#import "../endnotes.typ": endnote
#import "../numbering.typ": Ref

= Разработка концепции

== Схема на языке Typst

#Ref(<fig-arch>) набран пакетом Fletcher. Это не картинка со стороны: узлы и стрелки записаны в этой главе. Сборка не требует Graphviz, Node.js и браузера, поэтому схема живёт в том же файле, что и абзац, и обновляется вместе с текстом.

#figure(
  diagram(
    node-stroke: 0.7pt,
    spacing: (12mm, 10mm),
    node((0, 0), [Преподаватель], corner-radius: 2pt),
    node((1, 0), [Веб-клиент], corner-radius: 2pt),
    node((2, 0), [Сервер API], corner-radius: 2pt),
    node((2, 1), [База данных], corner-radius: 2pt),
    edge((0, 0), (1, 0), "->", [браузер]),
    edge((1, 0), (2, 0), "->", [HTTPS]),
    edge((2, 0), (2, 1), "->", [SQL]),
  ),
  caption: [Контур приложения, схема Fletcher],
) <fig-arch>

Подпись «Рисунок 2.1» собрана из номера главы и счётчика рисунков. Из другой главы на неё ссылаются той же меткой: в техническом проекте снова стоит @fig-arch.

== Слои CeTZ

CeTZ — это холст внутри Typst: прямоугольники, подписи и стрелки координатами. Внешних программ тоже нет. #Ref(<fig-layers>) показывает три слоя, о которых имеет смысл договориться до выбора фреймворка #endnote[CeTZ удобен, когда схема не укладывается в узлы и рёбра: шкалы, разрезы, простые планы экранов.].

#figure(
  canvas(length: 1.05cm, {
    import draw: *
    rect((0, 0), (4.0, 1.5), name: "view")
    content((2.0, 0.75), [Представление])
    rect((4.8, 0), (8.8, 1.5), name: "logic")
    content((6.8, 0.75), [Логика])
    rect((9.6, 0), (13.6, 1.5), name: "data")
    content((11.6, 0.75), [Данные])
    line((4.0, 0.75), (4.8, 0.75), mark: (end: ">"))
    line((8.8, 0.75), (9.6, 0.75), mark: (end: ">"))
  }),
  caption: [Слои приложения, чертёж CeTZ],
) <fig-layers>

Fletcher короче для блок-схем, CeTZ точнее, когда важны размеры. Оба варианта компилируются одной командой `typst compile`.
