#!/usr/bin/env bats

setup() {
  export RUN_TEST=true
  load "$(pwd)/bin/soundnovel"
}

# @test "repeatは任意の回数指定の文字を1行に繰り返し出力する" {
#   run repeat 5 あ
#   [ "$status" -eq 0 ]
#   [ "$output" -eq あああああ ]
# }
