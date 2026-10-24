#import "../constants.typ": default-heading-margin

#let structural-heading-titles = (
  performers: [Список исполнителей],
  abstract: [Реферат],
  contents: [Содержание],
  terms: [Термины и определения],
  abbreviations: [Перечень сокращений и обозначений],
  intro: [Введение],
  conclusion: [Заключение],
  references: [Список использованных источников],
  notes: [Примечания],
)

// Структурный элемент (ВВЕДЕНИЕ, ЗАКЛЮЧЕНИЕ и т. п.) оформляется так же, как
// нумерованный раздел: слева с абзацного отступа, прописными, без точки
// в конце и без жирного (требование кафедры).
#let structure-heading-style(it, indent: 1.25cm) = {
  set text(weight: "regular")
  align(left, pad(left: indent, upper(it.body)))
}

#let structure-heading(body) = {
  structure-heading-style(heading(numbering: none)[#body])
}

#let headings(text-size, indent, add-pagebreaks) = body => {
  show heading: set text(size: text-size, weight: "regular")
  // Точка после номера: «1.» и «1.1.».
  set heading(numbering: "1.1.")

  let structural-heading = structural-heading-titles
    .values()
    .fold(selector, (acc, i) => acc.or(heading.where(body: i, level: 1)))

  show structural-heading: set heading(numbering: none)

  // Раздел и подраздел — с абзацного отступа, без жирного (ГОСТ 7.32, п. 6.5.1).
  // Название раздела печатается прописными.
  show heading: it => {
    set text(weight: "regular", size: text-size)
    set par(first-line-indent: 0pt, justify: false)
    let titled = if it.level == 1 and it.numbering != none {
      upper(it.body)
    } else {
      it.body
    }
    let line = if it.numbering != none {
      context {
        numbering(it.numbering, ..counter(heading).get())
        [ ]
        titled
      }
    } else {
      titled
    }
    block(
      width: 100%,
      above: default-heading-margin.above,
      below: default-heading-margin.below,
      breakable: false,
      pad(left: indent, line),
    )
  }

  show heading.where(level: 1): it => {
    if add-pagebreaks {
      pagebreak(weak: true)
    }
    it
  }

  show structural-heading: it => {
    if add-pagebreaks {
      pagebreak(weak: true)
    }
    set text(weight: "regular", size: text-size)
    set par(first-line-indent: 0pt, justify: false)
    block(
      width: 100%,
      above: default-heading-margin.above,
      below: default-heading-margin.below,
      breakable: false,
      structure-heading-style(it, indent: indent),
    )
  }

  body
}
