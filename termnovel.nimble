# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["termnovel"]
installDirs   = @["novels"]

# Dependencies

requires "nim >= 0.20.2"
requires "cligen >= 0.9.32"
requires "markdown >= 0.8.0"
requires "nimquery >= 1.2.2"
requires "eastasianwidth >= 1.1.0"
requires "alignment >= 1.0.0"

task ci, "Run CI":
  exec "nim -v"
  exec "nimble -v"
  exec "nimble check"
  exec "nimble install -Y"
  exec "nimble test -Y"
  exec "nimble build -d:release -Y"
  exec "./bin/termnovel -h"
