import unittest
import markdown

include termnovelpkg/novelparser

const novel1 = """# Title

Description

Author: author1

## Contents

Contents1.
Contents2.

Contents3.
"""

suite "proc parseNovel":
  test "Parse novel":
    check novel1.markdown().parseNovel() == Novel(
      title: "Title",
      desc: "Description",
      author: "Author: author1",
      paragraphs: @[@["Contents1.", "Contents2."], @["Contents3."]])
