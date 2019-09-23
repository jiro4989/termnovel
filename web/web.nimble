# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["index.js"]
binDir        = "public"

backend       = "js"

# Dependencies

requires "nim >= 0.20.2"
requires "karax >= 1.1.0"
