import karax / [kbase, vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils, jjson]
import sequtils
from unicode import toRunes, `$`

type
  Novel = object
    title, desc, author: string
    paragraphs: seq[seq[string]]

const
  waitTime = 100

var
  showedParagraphs: seq[seq[string]]
  paraPos: int
  linePos: int
  pos: int
  novels = @[
    Novel(
      title: "頭痛",
      desc: "この頭痛を止めたい",
      author: "次郎",
      paragraphs: @[@["うんこ", "もりもり"], @["もりおうがい"], @["うんちんが", "うんち"]],
    ),
    Novel(
      title: "頭痛2",
      desc: "この頭痛を止めたい",
      author: "次郎",
      paragraphs: @[@["びちびち", "うんこ"], @["もりおうがい"]],
    ),
    Novel(
      title: "頭痛3",
      desc: "この頭痛を止めたい",
      author: "次郎",
      paragraphs: @[@["うんこ", "腹痛"], @["もりおうがい"]],
    ),
    Novel(
      title: "頭痛4",
      desc: "この頭痛を止めたい",
      author: "次郎",
      paragraphs: @[@["うんこ", "もりもり"], @["もりおうがい"]],
    ),
    ]

proc makeNovelRow(i: int): VNode =
  var novel = novels[i]
  result = buildHtml(tr):
    td: text $i
    td:
      button:
        text "Read"
        proc onclick(ev: Event, n: VNode) =
          showedParagraphs.add(novel.paragraphs)
    td: text novel.title
    td: text novel.desc
    td: text novel.author

proc createDom(): VNode =
  result = buildHtml(tdiv):
    h1: text "termnovel web"
    p: text "unko"
    hr()
    button:
      text "Next"
      proc onclick(ev: Event, n: VNode) =
        let sp = showedParagraphs[paraPos]
        let sl = sp[linePos]
        let cnt = sl.toRunes.len
        proc increment =
          echo paraPos, ":", linePos, ":", pos
          inc(pos)
          redraw()
          if pos < cnt:
            discard setTimeout(increment, waitTime)
          else:
            inc(linePos)
            pos = 0
            if sp.len <= linePos:
              linePos = 0
              inc(paraPos)
        discard setTimeout(increment, waitTime)
    table:
      thead:
        tr:
          td: text "No"
          td: text "Read"
          td: text "Title"
          td: text "Description"
          td: text "Author"
      tbody:
        for i in 0..<novels.len:
          makeNovelRow(i)
    hr()
    for pi, para in showedParagraphs:
      p:
        for li, line in para:
          for ci, ch in line.toRunes:
            let cls =
              if pi < paraPos: "show"
              else:
                if li < linePos: "show"
                else:
                  if ci < pos: "show"
                  else: "hide"
            span(class=cls):
              text $ch

proc keyDown(evt: kdom.Event) =
  var e = ((KeyboardEvent)evt)
  var te = buildHtml(tdiv):
    text "unko"

proc onload() =
  document.addEventListener($DomEvent.KeyDown, keyDown, false)

setRenderer createDom
onload()
