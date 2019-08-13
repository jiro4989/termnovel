#!/bin/bash

set -eux

readonly DIR_PREFIX=/usr/local
readonly BIN_NAME=soundnovel
readonly PROJECT_NAME=$BIN_NAME

install -m 0755 "bin/$BIN_NAME"* "$DIR_PREFIX/bin/"
install -d -m 0755 "$DIR_PREFIX/lib/$PROJECT_NAME"
install -m 0644 "lib/$PROJECT_NAME"/* "$DIR_PREFIX/lib/$PROJECT_NAME"
