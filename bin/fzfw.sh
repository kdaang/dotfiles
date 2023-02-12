#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# fcd - cd to selected directory
fcd() {
  local dir
  dir=$(fd --type d --color=always . "${1:-.}" | fzf --multi --ansi)
  echo $dir
}

$@
