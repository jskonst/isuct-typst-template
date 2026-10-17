// Подключается как `#show: gost-numbering`, иначе правила `set`/`show`
// останутся внутри модуля и не затронут главы.

#let chapter-at(loc) = {
  let current = counter(heading).at(loc)
  if current.len() > 0 { current.first() } else { 1 }
}

#let figure-kind(el) = {
  if el.kind == table { table } else { image }
}

// Строчная форма — середина предложения, прописная — его начало.
#let figure-ref-word(kind, capital) = {
  if kind == table {
    if capital [Табл.] else [табл.]
  } else {
    if capital [Рис.] else [рис.]
  }
}

// Ссылка в начале предложения: «Табл. 1.1», «Рис. 2.1».
// Обычная `@label` остаётся строчной. Формула в обоих случаях — «(1.1)».
#let Ref(target) = {
  context {
    let el = query(target).first()
    if el.func() == figure {
      ref(target, supplement: figure-ref-word(figure-kind(el), true))
    } else {
      ref(target)
    }
  }
}

#let gost-numbering(body) = {
  set figure(numbering: n => context {
    let ch = counter(heading).get().at(0, default: 1)
    numbering("1.1", ch, n)
  })
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: table): set figure(supplement: [Таблица])

  set math.equation(numbering: n => context {
    let ch = counter(heading).get().at(0, default: 1)
    [(#ch.#n)]
  })

  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    it
  }

  show ref: it => {
    let el = it.element
    if el == none {
      it
    } else if el.func() == figure {
      let kind = figure-kind(el)
      // `none` — значение по умолчанию после `set ref(supplement: none)`.
      // Явный supplement (в том числе из `Ref`) подставляется как есть.
      let supplement = if it.supplement == auto or it.supplement == none {
        figure-ref-word(kind, false)
      } else {
        it.supplement
      }
      context {
        let loc = el.location()
        let ch = chapter-at(loc)
        let num = counter(figure.where(kind: kind)).at(loc).first()
        link(loc, [#supplement #numbering("1.1", ch, num)])
      }
    } else if el.func() == math.equation {
      context {
        let loc = el.location()
        let ch = chapter-at(loc)
        let num = counter(math.equation).at(loc).first()
        link(loc, [(#ch.#num)])
      }
    } else {
      it
    }
  }

  show link: set text(fill: black)
  body
}
