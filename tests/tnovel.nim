import unittest

include termnovelpkg/novel

suite "proc getNovelList":
  test "tests/novels":
    check "tests/novels".getNovelList() == @[
      novelListHeader,
      Novel(title: "頭痛", desc: "この頭痛がおさまるのならなんだってする", author: "作者: 次郎"),
      Novel(title: "深夜のチャット", desc: "いつものように、友達とチャットをしている", author: "作者: 次郎"),
      Novel(title: "交通事故の多い横断歩道", desc: "事故が多いと噂の交差点で体験した怖い話", author: "作者: 次郎"),
    ]

suite "proc format":
  test "format":
    check "tests/novels".getNovelList().format() == @[
      "    No  Title                   Description                               Author",
      "    1)  頭痛                    この頭痛がおさまるのならなんだってする    次郎  ",
      "    2)  深夜のチャット          いつものように、友達とチャットをしている  次郎  ",
      "    3)  交通事故の多い横断歩道  事故が多いと噂の交差点で体験した怖い話    次郎  ",
      ]
