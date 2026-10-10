// Титульный лист и задание кафедры ИСИТ ИГХТУ.
// Поля, кегль и шаг строк сняты с бланков Word (см. reference/).

// Times New Roman — шрифт бланка. Liberation Serif подставляется, если его нет:
// у него те же метрики латиницы, кириллица может отличаться на переносах.
#let serif = ("Times New Roman", "Liberation Serif")

// Шаг строки 14 pt в бланке титульного листа (разница ymin соседних строк).
#let pitch-14 = 16.1pt
// Высота строчной коробки Times New Roman при leading: 0pt, замерена для 14 pt.
// Для других кеглей масштаб линейный. От неё зависит gap = шаг Word − коробка.
#let natural-14 = 9.71pt

#let line-pitch(size, multiple: 1) = multiple * pitch-14 * (size / 14pt)
#let line-gap(size, multiple: 1) = {
  let pitch = line-pitch(size, multiple: multiple)
  let natural = natural-14 * (size / 14pt)
  if pitch > natural { pitch - natural } else { 0pt }
}

#let value-or(data, key, default: none) = {
  if type(data) == dictionary {
    return data.at(key, default: default)
  }
  default
}

#let as-array(value) = {
  if value == none { return () }
  if type(value) == array { return value }
  (value,)
}

#let format-person(person, prefer: "name") = {
  if person == none { return none }
  if type(person) == str { return person }
  let selected = value-or(person, prefer)
  if selected != none { return selected }
  value-or(person, "name", default: value-or(person, "full-name"))
}

#let join-position-name(person) = {
  if person == none { return "" }
  if type(person) == str { return person }
  let position = value-or(person, "position")
  let name = format-person(person)
  if position != none and name != none { return position + " " + name }
  if name != none { return name }
  if position != none { return position }
  ""
}

#let blanks(n, pitch: pitch-14) = v(n * pitch, weak: false)

// Одна визуальная строка. `pitch` — расстояние до следующей строки.
#let sheet-line(
  body,
  size: 14pt,
  weight: "regular",
  pitch: pitch-14,
  body-align: center,
  shift-left: 0pt,
) = {
  let gap = line-gap(size)
  // Если задан нестандартный шаг (двойной интервал темы), добираем его ниже.
  let extra = if pitch > line-pitch(size) { pitch - line-pitch(size) } else { 0pt }
  block(width: 100%, above: 0pt, below: gap + extra)[
    #set text(font: serif, size: size, weight: weight)
    #set par(leading: gap, spacing: 0pt, justify: false, first-line-indent: 0pt)
    #pad(left: -shift-left)[
      #align(body-align, body)
    ]
  ]
}

#let diploma-assignment(
  student: (:),
  topic: none,
  order: (:),
  source-data: none,
  contents: (),
  special-questions: none,
  supervisor: (:),
  approved-by: (:),
  consultants: (
    (section: "Охрана труда"),
    (section: "Экономика"),
  ),
  issue-date: none,
  deadline: none,
  calendar-plan: (),
) = (
  student: student,
  topic: topic,
  order: order,
  source-data: source-data,
  contents: contents,
  special-questions: special-questions,
  supervisor: supervisor,
  approved-by: approved-by,
  consultants: consultants,
  issue-date: issue-date,
  deadline: deadline,
  calendar-plan: calendar-plan,
)

#let arguments(..args, year: auto) = {
  let data = args.named()
  data.insert("year", year)
  if data.at("city", default: none) == none {
    data.insert("city", "Иваново")
  }
  data
}

#let default-letterhead = (
  "МИНИСТЕРСТВО НАУКИ И ВЫСШЕГО ОБРАЗОВАНИЯ",
  "РОССИЙСКОЙ ФЕДЕРАЦИИ",
  "ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ",
  "ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ",
  "ВЫСШЕГО ОБРАЗОВАНИЯ",
  "«ИВАНОВСКИЙ ГОСУДАРСТВЕННЫЙ ХИМИКО-",
  "ТЕХНОЛОГИЧЕСКИЙ УНИВЕРСИТЕТ»",
)

#let render-title-page(
  letterhead: default-letterhead,
  department: "информационных технологий и цифровой экономики",
  work-type-lines: (
    "ВЫПУСКНАЯ КВАЛИФИКАЦИОННАЯ РАБОТА",
    "БАКАЛАВРА",
  ),
  topic: none,
  topic-lines: none,
  student: (:),
  supervisor: (:),
  department-head: (:),
  city: "Иваново",
  year: auto,
) = {
  set page(
    paper: "a4",
    margin: (top: 2.54cm, right: 1cm, bottom: 1cm, left: 3.17cm),
    header: none,
    footer: none,
  )
  set text(font: serif, lang: "ru", hyphenate: false)
  v(0.6pt, weak: false)

  for line in letterhead {
    sheet-line(weight: "bold", upper(line))
  }

  // Три пустые строки бланка между шапкой и кафедрой.
  blanks(3)
  // Отрицательный отступ Word сдвигает строку к центру листа, а не к центру полосы.
  sheet-line(
    size: 16pt,
    weight: "bold",
    pitch: line-pitch(16pt),
    shift-left: 1.89cm,
  )[Кафедра #department]

  // Четыре пустые строки между кафедрой и видом работы.
  blanks(4)
  for line in work-type-lines {
    sheet-line(
      size: 20pt,
      weight: "bold",
      pitch: line-pitch(20pt),
      shift-left: 0.99cm,
      line,
    )
  }

  blanks(1)
  sheet-line(weight: "bold")[НА ТЕМУ:]
  blanks(1)

  let topic-pitch = line-pitch(16pt, multiple: 2)
  let lines = if topic-lines != none { as-array(topic-lines) } else if topic != none { (topic,) } else { () }
  for line in lines {
    sheet-line(
      size: 16pt,
      weight: "bold",
      pitch: topic-pitch,
      shift-left: 0.56cm,
      upper(line),
    )
  }

  // Четыре пустые строки 14 pt после двойного интервала темы.
  blanks(4)

  // Подписи сдвинуты влево на величину отрицательного отступа Word (−567 twip).
  let sign-shift = 1.24cm
  sheet-line(body-align: left, weight: "bold", shift-left: sign-shift)[
    Автор: \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ #h(0.35em) #format-person(student, prefer: "short-name")
  ]
  blanks(1)
  sheet-line(body-align: left, weight: "bold", shift-left: sign-shift)[
    Руководитель: \_\_\_\_\_\_\_\_\_\_ #h(0.35em) #join-position-name(supervisor)
  ]
  // Две пустые строки бланка, одна из них набрана кеглем 12 pt: шаг 46 pt вместо 2×16.1.
  v(29.9pt, weak: false)
  sheet-line(body-align: left, weight: "bold", shift-left: sign-shift)[
    Зав. кафедрой:\_\_\_\_\_\_\_\_\_\_\_ #h(0.2em) #join-position-name(department-head)
  ]
  blanks(6)
  sheet-line(weight: "bold")[г. #city, #year г.]
}

#let a-pitch = 13.8pt
#let a-gap = a-pitch - natural-14 * (12pt / 14pt)

#let a-line(body, weight: "regular", body-align: center) = {
  sheet-line(
    body,
    size: 12pt,
    weight: weight,
    pitch: a-pitch,
    body-align: body-align,
  )
}

#let info-row(label, value) = {
  block(width: 100%, above: 0pt, below: a-gap)[
    #set text(font: serif, size: 12pt)
    #set par(leading: a-gap, spacing: 0pt, first-line-indent: 0pt)
    #text(weight: "bold")[#label ] #underline(value)
  ]
}

#let flow-par(body, indent: 0pt, justify: true) = {
  block(width: 100%, above: 0pt, below: a-gap)[
    #set text(font: serif, size: 12pt)
    #set par(
      leading: a-gap,
      spacing: 0pt,
      first-line-indent: indent,
      justify: justify,
    )
    #body
  ]
}

#let consultants-table(consultants) = {
  let rows = as-array(consultants)
  set text(font: serif, size: 12pt)
  set par(leading: 2pt, spacing: 0pt, justify: false, first-line-indent: 0pt)
  table(
    columns: (3.99fr, 4.52fr, 3.99fr, 3.99fr),
    stroke: 0.6pt,
    inset: (x: 4pt, y: 3.5pt),
    align: center + horizon,
    table.cell(rowspan: 2)[Раздел],
    table.cell(rowspan: 2)[Консультант],
    table.cell(colspan: 2)[Подпись, дата],
    [Задание выдал],
    [Задание принял],
    ..rows.map(row => {
      let section = if type(row) == dictionary { value-or(row, "section", default: "") } else { row }
      let consultant = if type(row) == dictionary { value-or(row, "consultant", default: "") } else { "" }
      if consultant == none { consultant = "" }
      (
        section,
        consultant,
        "",
        "",
      )
    }).flatten(),
  )
}

#let calendar-table(plan) = {
  let rows = as-array(plan)
  set text(font: serif, size: 12pt)
  set par(leading: 2pt, spacing: 2pt, justify: false, first-line-indent: 0pt)
  table(
    columns: (1.25fr, 7.5fr, 4.75fr, 3.25fr),
    stroke: 0.6pt,
    inset: (x: 3pt, y: 4pt),
    align: center + horizon,
    table.header(
      [№ п/п],
      [Наименование этапов квалификационной работы],
      [Срок выполнения этапов работы (проекта)],
      [Примечание],
    ),
    ..rows.enumerate().map(pair => {
      let index = pair.at(0)
      let row = pair.at(1)
      let name = if type(row) == dictionary { value-or(row, "name", default: "") } else { row }
      let dates = if type(row) == dictionary { value-or(row, "dates", default: "") } else { "" }
      let note = if type(row) == dictionary { value-or(row, "note", default: "") } else { "" }
      (
        [#str(index + 1).],
        align(left + horizon)[#name],
        dates,
        note,
      )
    }).flatten(),
  )
}

#let content-item(item) = {
  if type(item) == dictionary {
    let lead = value-or(item, "lead", default: value-or(item, "title", default: ""))
    let body = value-or(item, "text", default: "")
    flow-par(indent: 1.5cm)[
      #if lead != none and lead != "" {
        text(style: "italic", lead)
      }
      #if body != none and body != "" {
        if lead != none and lead != "" { [ ] }
        body
      }
    ]
  } else if item != none and item != "" {
    flow-par(indent: 1.5cm, item)
  }
}

#let render-assignment-page(
  university: (:),
  university-lines: (
    "ИВАНОВСКИЙ   ГОСУДАРСТВЕННЫЙ",
    "ХИМИКО-ТЕХНОЛОГИЧЕСКИЙ УНИВЕРСИТЕТ",
  ),
  faculty: "Техники, управления и цифровой инфраструктуры",
  department: "Информационных технологий и цифровой экономики",
  education-level: "Бакалавриат",
  program: "Информационные системы и технологии",
  profile: "Информационные системы и технологии",
  assignment: none,
) = {
  set text(font: serif, size: 12pt, lang: "ru", hyphenate: false)
  set par(leading: a-gap, spacing: a-gap, justify: false, first-line-indent: 0pt)

  a-line(weight: "bold")[Министерство науки и высшего образования Российской Федерации]
  blanks(1, pitch: a-pitch)
  a-line(weight: "bold")[Федеральное государственное бюджетное образовательное учреждение]
  a-line(weight: "bold")[высшего образования]
  blanks(1, pitch: a-pitch)
  for line in university-lines {
    a-line(line)
  }
  blanks(1, pitch: a-pitch)

  info-row("Факультет", faculty)
  info-row("Кафедра", department)
  info-row("Уровень подготовки", education-level)
  info-row("Направление", program)
  info-row("Профиль", profile)

  let approved = value-or(assignment, "approved-by", default: (:))
  let approved-position = value-or(approved, "position", default: "Зав. кафедрой")
  let approved-name = format-person(approved)
  let approved-date = value-or(approved, "date", default: "")
  a-line(body-align: right)[УТВЕРЖДАЮ:]
  a-line(body-align: right, weight: "bold", approved-position)
  a-line(body-align: right, weight: "bold")[\_\_\_\_\_\_\_\_\_#approved-name]
  a-line(body-align: right, weight: "bold", approved-date)

  a-line(weight: "bold")[ЗАДАНИЕ]
  a-line(weight: "bold")[на выпускную квалификационную работу]
  blanks(1, pitch: a-pitch)

  let student = value-or(assignment, "student", default: (:))
  let supervisor = value-or(assignment, "supervisor", default: (:))
  let order = value-or(assignment, "order", default: (:))

  flow-par[
    *студенту(ке):*
    #underline(text(weight: "bold", style: "italic", format-person(student, prefer: "dative-name")))
  ]
  flow-par[
    *1. Тема:*
    #underline(text(weight: "bold", style: "italic", value-or(assignment, "topic", default: "")))
    утверждена Приказом по университету
    *№ #value-or(order, "number") от #value-or(order, "date") г.*
  ]
  flow-par[
    *2. Исходные данные:*
    #value-or(assignment, "source-data")
  ]
  flow-par[*3. Содержание работы:*]
  for item in as-array(value-or(assignment, "contents", default: ())) {
    content-item(item)
  }

  blanks(1, pitch: a-pitch)
  let special = value-or(assignment, "special-questions", default: none)
  flow-par[*4. Вопросы для специальной разработки.*#if special != none and special != "" [ #special]]
  flow-par[
    *5. Руководитель работы:*
    #underline(text(weight: "bold", style: "italic", join-position-name(supervisor)))
  ]

  // В бланке Word этот блок начинается со следующей страницы:
  // предыдущий абзац упирается в нижнее поле.
  pagebreak()

  flow-par[*6. Консультанты:*]
  consultants-table(value-or(assignment, "consultants", default: ()))
  v(6pt, weak: false)
  flow-par[*7. Дата выдачи задания: #value-or(assignment, "issue-date") г.*]
  flow-par[*8. Дата предоставления законченной работы: #value-or(assignment, "deadline") г.*]

  v(2pt, weak: false)
  flow-par(justify: false)[
    Руководитель #text(weight: "bold", style: "italic", format-person(supervisor, prefer: "full-name"))
    #h(0.6em) \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
  ]
  align(right)[
    #box(width: 48mm)[
      #align(center)[#text(size: 12pt)[(Ф.И.О., подпись)]]
    ]
  ]
  flow-par(justify: false)[
    Студент #h(0.4em)
    #text(weight: "bold", style: "italic", format-person(student, prefer: "full-name"))
    #h(0.6em) \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
  ]
  align(right)[
    #box(width: 62mm)[
      #align(center)[#text(size: 12pt)[(Ф.И.О., подпись)]]
    ]
  ]

  v(a-gap, weak: false)
  a-line(weight: "bold")[Календарный план]
  v(6pt, weak: false)
  calendar-table(value-or(assignment, "calendar-plan", default: ()))
  v(8pt, weak: false)
  align(center)[
    #text(size: 12pt)[Студент \_\_\_\_\_\_\_\_\_\_\_\_ #h(6mm) Руководитель работы \_\_\_\_\_\_\_\_\_\_\_\_]
  ]
}

#let template(
  university: (:),
  letterhead: default-letterhead,
  university-lines: (
    "ИВАНОВСКИЙ   ГОСУДАРСТВЕННЫЙ",
    "ХИМИКО-ТЕХНОЛОГИЧЕСКИЙ УНИВЕРСИТЕТ",
  ),
  faculty: "Техники, управления и цифровой инфраструктуры",
  department: "информационных технологий и цифровой экономики",
  assignment-department: "Информационных технологий и цифровой экономики",
  education-level: "Бакалавриат",
  program: "Информационные системы и технологии",
  profile: "Информационные системы и технологии",
  work-type-lines: (
    "ВЫПУСКНАЯ КВАЛИФИКАЦИОННАЯ РАБОТА",
    "БАКАЛАВРА",
  ),
  topic: none,
  topic-lines: none,
  student: (:),
  supervisor: (:),
  department-head: (:),
  assignment: none,
  city: "Иваново",
  year: auto,
  ..rest,
) = {
  render-title-page(
    letterhead: letterhead,
    department: department,
    work-type-lines: work-type-lines,
    topic: topic,
    topic-lines: topic-lines,
    student: student,
    supervisor: supervisor,
    department-head: department-head,
    city: city,
    year: year,
  )

  // Поля задания совпадают с полями основного текста ГОСТ (30/15/20/20 мм).
  pagebreak()
  set page(
    paper: "a4",
    margin: (left: 30mm, right: 15mm, top: 20mm, bottom: 20mm),
    header: none,
    footer: context {
      set text(font: serif, size: 12pt)
      align(center, counter(page).display())
    },
  )

  render-assignment-page(
    university: university,
    university-lines: university-lines,
    faculty: faculty,
    department: assignment-department,
    education-level: education-level,
    program: program,
    profile: profile,
    assignment: assignment,
  )

  // Возврат к параметрам основного текста ГОСТ 7.32 после бланков.
  set text(font: serif, size: 14pt, lang: "ru", hyphenate: false)
  set par(
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true),
    leading: 0.75em,
    spacing: 1.5em,
  )
}
