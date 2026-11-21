// Титульные листы курсового проекта и отчёта по НИР (производственная практика).
// Поля, кегль и шаг строк сняты с бланков Word (см. reference/kursovoy.docx
// и reference/nir.docx). Жёлтая заливка Word не переносится: это пометки
// заполнения, а не часть бланка.

#let serif = ("Times New Roman", "Liberation Serif")

// Шаг строки при одинарном интервале Word (line=240, auto), как в бланках.
#let pitch-12 = 13.8pt
#let pitch-14 = 16.1pt
#let pitch-20 = 23.0pt
// Высота строчной коробки TNR при leading: 0pt, замерена для 14 pt.
#let natural-14 = 9.71pt

#let line-gap(size, pitch) = {
  let natural = natural-14 * (size / 14pt)
  if pitch > natural { pitch - natural } else { 0pt }
}

#let value-or(data, key, default: none) = {
  if type(data) == dictionary {
    return data.at(key, default: default)
  }
  default
}

#let format-person(person, prefer: "name") = {
  if person == none { return none }
  if type(person) == str { return person }
  let selected = value-or(person, prefer)
  if selected != none { return selected }
  value-or(person, "name", default: value-or(person, "full-name", default: value-or(person, "short-name")))
}

#let join-position-name(person) = {
  if person == none { return none }
  if type(person) == str { return person }
  let position = value-or(person, "position")
  let name = format-person(person)
  if position != none and name != none { return position + " " + name }
  if name != none { return name }
  if position != none { return position }
  none
}

#let as-array(value) = {
  if value == none { return () }
  if type(value) == array { return value }
  (value,)
}

#let sheet-line(
  body,
  size: 12pt,
  weight: "regular",
  style: "normal",
  pitch: pitch-12,
  body-align: center,
) = {
  let gap = line-gap(size, pitch)
  block(width: 100%, above: 0pt, below: gap)[
    #set text(font: serif, size: size, weight: weight, style: style)
    #set par(leading: gap, spacing: 0pt, justify: false, first-line-indent: 0pt)
    #align(body-align, body)
  ]
}

#let blanks(n, pitch: pitch-12) = v(n * pitch, weak: false)

#let default-letterhead = (
  "Федеральное государственное бюджетное образовательное учреждение",
  "высшего образования",
  "Ивановский государственный химико-технологический университет",
)

#let default-department = "информационных технологий и цифровой экономики"

#let letterhead-block(letterhead, department, weight: "regular") = {
  for line in as-array(letterhead) {
    sheet-line(weight: weight, line)
  }
  blanks(1)
  sheet-line(weight: weight)[Кафедра #department]
}

// ---------------------------------------------------------------------------
// Курсовой проект
// ---------------------------------------------------------------------------

#let kursovoy-title(
  letterhead: default-letterhead,
  department: default-department,
  work-type: "КУРСОВОЙ ПРОЕКТ",
  discipline-lead: "по дисциплине",
  discipline: none,
  topic: none,
  student: none,
  course-group: none,
  supervisor: none,
  city: "Иваново",
  year: auto,
  ..rest,
) = {
  set page(
    paper: "a4",
    margin: (top: 2cm, right: 1.5cm, bottom: 2cm, left: 3cm),
    header: none,
    footer: none,
  )
  set text(font: serif, lang: "ru", hyphenate: false)

  letterhead-block(letterhead, department, weight: "bold")

  // p6 (12 pt) + p7–p8 (14 pt) + два пустых абзаца по 20 pt, у LibreOffice
  // они выше одинарного шага 23 pt: вместе 57.22 pt (снято с PDF бланка).
  blanks(1, pitch: pitch-12)
  blanks(2, pitch: pitch-14)
  v(57.22pt, weak: false)

  sheet-line(size: 20pt, weight: "bold", pitch: pitch-20, work-type)
  blanks(1, pitch: pitch-14)
  // В Word у фразы «по дисциплине» случайно 14 pt на пробеле и букве «п»;
  // в шаблоне вся строка 12 pt, как основная часть этой подписи.
  sheet-line(weight: "bold", pitch: pitch-14, discipline-lead)
  if discipline != none {
    sheet-line(weight: "bold", upper(discipline))
  } else {
    blanks(1)
  }

  blanks(3, pitch: pitch-14)
  let topic-text = if topic == none { "" } else { topic }
  // Кириллица Typst чуть шире Word: чуть сжимаем межбуквенный пробел,
  // чтобы типичная тема бланка осталась на одной строке.
  sheet-line(size: 14pt, weight: "bold", pitch: pitch-14, body-align: left)[
    #text(tracking: -0.55pt)[Тема: #topic-text]
  ]

  blanks(4, pitch: pitch-14)
  let student-name = format-person(student)
  sheet-line(size: 14pt, weight: "bold", pitch: pitch-14, body-align: left)[
    Выполнил студент:#underline(offset: 2pt, evade: false)[#text(weight: "regular")[~~~~~~~#if student-name != none { student-name }]]
    #h(10pt)
    курс/гр.#h(12pt)
    #if course-group != none {
      underline(offset: 2pt, evade: false, text(weight: "regular", course-group))
    }
  ]

  blanks(1, pitch: pitch-14)
  let checked = join-position-name(supervisor)
  sheet-line(size: 14pt, weight: "bold", pitch: pitch-14, body-align: left)[
    Проверил:
    #if checked != none { text(weight: "regular")[ #checked] }
  ]

  // Семь пустых строк 14 pt и одиннадцать строк 12 pt до города, как в бланке.
  blanks(7, pitch: pitch-14)
  blanks(11, pitch: pitch-12)
  sheet-line[#city #year]
}

// ---------------------------------------------------------------------------
// Отчёт по производственной практике (научно-исследовательская работа)
// ---------------------------------------------------------------------------

#let nir-title(
  letterhead: default-letterhead,
  department: default-department,
  report-title: "ОТЧЁТ",
  report-subtitle: "по производственной практике",
  report-kind: "(Научно-исследовательская работа)",
  student: none,
  program: "09.03.02 Информационные системы и технологии",
  profile: "Информационные системы и технологии",
  group: none,
  practice-base: "ФГБОУ ВО «ИГХТУ»",
  practice-from: none,
  practice-to: none,
  practice-dates: none,
  grade: none,
  supervisor-org: "ИГХТУ",
  supervisor: none,
  supervisor-caption: "ФИО, должность",
  city: "Иваново",
  year: auto,
  ..rest,
) = {
  set page(
    paper: "a4",
    margin: (top: 2cm, right: 1.5cm, bottom: 2cm, left: 3cm),
    header: none,
    footer: none,
  )
  set text(font: serif, lang: "ru", hyphenate: false)

  // В бланке Word шапка и кафедра набраны обычным, не жирным.
  letterhead-block(letterhead, department, weight: "regular")
  blanks(6)

  sheet-line(weight: "bold", report-title)
  sheet-line(weight: "bold", report-subtitle)
  sheet-line(weight: "bold", style: "italic", report-kind)
  blanks(4)

  let student-name = format-person(student)
  let line-width = 150pt
  block(width: 100%, above: 0pt, below: line-gap(12pt, pitch-12))[
    #set text(font: serif, size: 12pt)
    #set par(leading: 0pt, spacing: 0pt, justify: false, first-line-indent: 0pt)
    #align(left)[
      Студент#h(30pt)#box(width: line-width, stroke: (bottom: 0.6pt), inset: (bottom: 1.2pt))[
        #set align(center)
        #text(weight: "bold", if student-name != none { student-name } else { [] })
      ]
    ]
  ]
  // Подпись «ФИО» — 10 pt курсив, под центром линии (не у левого края).
  context {
    let label-w = measure(text(font: serif, size: 12pt)[Студент]).width
    block(width: 100%, above: 0pt, below: line-gap(10pt, 11.5pt))[
      #set text(font: serif, size: 10pt, style: "italic")
      #set par(leading: 0pt, spacing: 0pt, first-line-indent: 0pt)
      #pad(left: 30pt + label-w)[
        #box(width: line-width, align(center)[ФИО])
      ]
    ]
  }

  sheet-line(body-align: left)[
    Направление#h(1.1em)#text(weight: "bold", program)
  ]
  blanks(1)
  sheet-line(body-align: left)[
    Профиль подготовки#h(0.4em)#text(weight: "bold", size: 11pt, profile)
  ]
  blanks(1)
  sheet-line(body-align: left)[
    Группа
    #if group != none { text(weight: "bold")[ #group] }
  ]
  blanks(1)
  sheet-line(body-align: left)[
    База практики#h(0.6em)#practice-base
  ]
  blanks(1)

  let dates = practice-dates
  if dates == none and (practice-from != none or practice-to != none) {
    dates = "с " + if practice-from != none { practice-from } else { "" }
    if practice-to != none {
      dates = dates + " по " + practice-to
    }
  }
  sheet-line(body-align: left)[
    #text(weight: "bold")[Сроки практики]
    #if dates != none [ #dates]
  ]

  blanks(12)
  sheet-line(body-align: left)[
    Оценка работы#box(stroke: (bottom: 0.6pt), inset: (bottom: 1.2pt), width: 4.8cm)[
      #if grade != none { grade }
    ]
  ]
  // after=240 twip (12 pt) у строки оценки, затем пустая 12 pt — как в бланке.
  v(12pt, weak: false)
  blanks(1)

  let supervisor-name = join-position-name(supervisor)
  sheet-line(body-align: left)[
    Руководитель по практической подготовке от #supervisor-org
    #h(1.2em)
    #box(width: 60pt, stroke: (bottom: 0.6pt), inset: (bottom: 1.2pt))[
      #set align(center)
      #if supervisor-name != none { supervisor-name }
    ]
  ]
  block(width: 100%, above: 0pt, below: line-gap(10pt, 11.5pt) + 12pt)[
    #set text(font: serif, size: 10pt, style: "italic")
    #set par(leading: 0pt, spacing: 0pt, first-line-indent: 0pt)
    #align(right, supervisor-caption)
  ]
  // Две пустые строки 12 pt, у каждой ещё after=12 pt, затем город.
  blanks(1)
  v(12pt, weak: false)
  blanks(1)
  v(12pt, weak: false)
  sheet-line[#city #year]
}
