// Концевые сноски. Номер в тексте — верхний индекс, текст собирается
// в разделе «Примечания» перед списком источников.
#let notes = state("isuct-endnotes", ())

#let endnote(body) = {
  context {
    let n = notes.get().len() + 1
    super(str(n))
  }
  notes.update(ns => ns + (body,))
}

#let endnotes() = {
  import "../../src/component/headings.typ": structural-heading-titles
  heading(structural-heading-titles.notes)
  context {
    let ns = notes.get()
    set par(first-line-indent: 0pt, justify: false)
    if ns.len() == 0 {
      [Концевых сносок в документе нет.]
    } else {
      for (i, note) in ns.enumerate() {
        block(below: 0.65em)[#super(str(i + 1)) #note]
      }
    }
  }
}
