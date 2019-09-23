import eastasianwidth
import termnovelpkg/[novel, novelparser]
import os, strutils, terminal, times
from unicode import toRunes, `$`

const
  hLine = "-"
  vLine = "|"
  lTop = "+"
  rTop = "+"
  lBottom = "+"
  rBottom = "+"
  lCorner = "+"
  rCorner = "+"
  charWait = 25
  startXPos = 4
  startYPos = 6
  bodyHeightPad = 1
  bodyWidthPad = 4
  maxWidth = 100

let
  novelDir = getAppDir() / "novels"

proc writeHeaderFrame(width: int, title, desc, author: string) =
  ## ヘッダ部分のフレームとタイトル、概要、作者名を描画する。
  # ヘッダの描画
  styledEcho lTop, hLine.repeat(width), rTop
  for i in 1..3:
    styledEcho vLine, " ".repeat(width), vLine
  styledEcho lCorner, hLine.repeat(width), rCorner

  # タイトル、概要、作者名を上書き描画
  for i, text in [title, desc, author]:
    setCursorPos(stdout, startXPos, i+1)
    styledWrite stdout, fgBlue, text, resetStyle
    stdout.flushFile

  # 終了方法を書く
  let text = "[q]uit"
  setCursorPos(stdout, width - text.len - 2, 3)
  styledWrite stdout, styleBright, text, resetStyle
  stdout.flushFile

proc writeBodyFrame(width, height: int) =
  ## ボディ部分のフレームを描画
  setCursorPos(stdout, 0, 5)
  for i in 5..height:
    styledEcho vLine, " ".repeat(width), vLine
  styledEcho lBottom, hLine.repeat(width), rBottom

proc list(): int =
  for line in getNovels(novelDir):
    echo line

proc read(novelNo: int): int =
  let
    novel = getNovelWithNo(novelDir, novelNo)
    title = novel.title
    desc = novel.desc
    author = novel.author
    paragraphs = novel.paragraphs

  # フレームの描画
  eraseScreen(stdout)
  setCursorPos(stdout, 0, 0)
  let width =
    if maxWidth < terminalWidth():
      maxWidth - 2
    else:
      terminalWidth() - 2
  let height = terminalHeight() - 4
  writeHeaderFrame(width, title, desc, author)
  writeBodyFrame(width, height)

  let bodyWidth = width - bodyWidthPad
  let bodyHeight = height - bodyHeightPad

  # ボディ部分の描画
  var posX = startXPos
  var posY = startYPos
  for para in paragraphs:
    setCursorPos(stdout, startXPos, posY)
    posX = startXPos
    for line in para:
      # 行のテキストを文字単位に分割してループ
      for ch in line.toRunes():
        # 1文字ずつ末尾追記するように出力
        stdout.write(ch)
        stdout.flushFile()
        inc(posX, stringWidth($ch))

        # 幅の上限に到達したら折り返す
        if bodyWidth < posX:
          posX = startXPos
          inc(posY)

          # 高さの上限に到達したらボディをredraw
          if bodyHeight < posY:
            writeBodyFrame(width, height)
            posY = startYPos
          setCursorPos(stdout, startXPos, posY)
        sleep charWait
      let ans = getch()
      if ans == 'q':
        return

    # 段落の句切れは空行を挟む
    inc(posY, 2)

    # 高さの上限に到達したらBodyをredraw
    if bodyHeight < posY:
      writeBodyFrame(width, height)
      posY = startYPos
  setCursorPos(stdout, 0, 0)
  eraseScreen(stdout)

when isMainModule and not defined(isTesting):
  import cligen
  dispatchMulti([list], [read])
