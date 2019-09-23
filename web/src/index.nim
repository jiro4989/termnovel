import karax / [kbase, vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils, jjson]
import sequtils
from unicode import toRunes, `$`

type
  Novel = object
    title, desc, author: string
    paragraphs: seq[seq[string]]
    selected: bool

var
  novels = @[
    Novel(
      title: "頭痛",
      desc: "この頭痛を止めたい",
      author: "次郎",
      paragraphs: @[@["うんこ", "もりもり"], @["もりおうがい"]],
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
          novels[i].selected = not novels[i].selected
    td: text novel.title
    td: text novel.desc
    td: text novel.author
    td: text $novel.selected

proc createDom(): VNode =
  result = buildHtml(tdiv):
    h1: text "termnovel web"
    p: text "unko"
    echo "うんこ"
    hr()
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
    for novel in novels.filterIt(it.selected):
      for para in novel.paragraphs:
        p:
          for line in para:
            for ch in line.toRunes():
              span: text $ch

proc keyDown(evt: kdom.Event) =
  var e = ((KeyboardEvent)evt)
  echo $e.code

proc onload() =
  document.addEventListener($DomEvent.KeyDown, keyDown, false)

setRenderer createDom
onload()
