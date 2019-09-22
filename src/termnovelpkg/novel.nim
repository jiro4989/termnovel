import eastasianwidth, alignment, markdown
import typedef, novelparser
import os, strutils
from strformat import `&`
from sequtils import mapIt
from algorithm import sort

const
  novelListHeader = Novel(title: "Title", desc: "Description", author: "Author")

proc getNovelPath(dir: string, novelNo: int): string =
  ## nimbleパッケージディレクトリのnovelsから `novelNo` にマッチするファイルパス
  ## を返す。
  for kind, path in walkDir(dir):
    let idx = path.splitFile.name.split("_")[0]
    if idx == &"{novelNo:03}":
      return path

proc getNovelWithNo*(novelDir: string, novelNo: int): Novel =
  getNovelPath(novelDir, novelNo)
    .readFile()
    .markdown()
    .parseNovel()

proc getNovelList(dir: string): seq[Novel] =
  ## `dir` から小説のタイトル、概要、作者のリストを取得する。
  ## 取得したリストは取得本のファイル名でソートする。
  var sortList: seq[tuple[path: string, novel: Novel]]
  result.add(novelListHeader)
  for kind, path in walkDir(dir):
    var
      novel = path.readFile().markdown().parseNovel()
    let
      title = novel.title
      desc = novel.desc
      author = novel.author
    novel.paragraphs = @[] # 不要なデータなので削除
    sortList.add((path: path, novel: novel))
  # パス名でソート
  sortList.sort do (x, y: tuple[path: string, novel: Novel]) -> int:
    result = cmp(x.path, y.path)
  for v in sortList:
    result.add(v.novel)

proc format(novels: seq[Novel]): seq[string] =
  ## 小説のリストを人間が見やすいように位置を揃える。
  # 最初の要素はヘッダなので番号は不要
  var nos = (1..<novels.len).mapIt($it & ")")
  nos.insert("No", 0)
  nos = nos.alignRight
  let titles = novels.mapIt(it.title).alignLeft
  let descs = novels.mapIt(it.desc).alignLeft
  let authors = novels.mapIt(it.author.replace("作者:").strip).alignLeft
  for i, no in nos:
    let title = titles[i]
    let desc = descs[i]
    let author = authors[i]
    result.add(&"{no:>6}  {title}  {desc}  {author}")

proc getNovels*(dir: string): seq[string] =
  getNovelList(dir).format()
