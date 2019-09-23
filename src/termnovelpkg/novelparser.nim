import nimquery
import typedef
import strutils, htmlparser, xmltree

proc parseNovel*(md: string): Novel =
  ## Markdown文字列をパースしてタイトル、概要、作者、コンテンツを返す。
  let xml = md.parseHtml()
  let title = xml.querySelector("h1").innerText
  var paragraphs: seq[seq[string]]
  for p in xml.querySelectorAll("p"):
    let sect = p.innerText.split("\n")
    paragraphs.add(sect)
  let desc = paragraphs[0][0]
  let author = paragraphs[1][0]
  paragraphs = paragraphs[2..^1]
  return Novel(title: title, desc: desc, author: author, paragraphs: paragraphs)

