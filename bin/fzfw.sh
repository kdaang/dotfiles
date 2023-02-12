#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# cd to selected directory
fcd() {
  local dir
  dir=$(fd --type d --color=always . "${1:-.}" | fzf --multi --ansi)
  echo $dir
}

# Interactive search.
fw() {
    RG_DEFAULT_COMMAND="rg -i -l --hidden"

    selected=$(
    rg --files | fzf \
      -e \
      --ansi \
      --disabled \
      --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
      --preview "bat {} | rg --ignore-case --colors 'match:bg:yellow' --color always --context 10 {q}"
    )
    # {} - output of focused line
    #{q} - will be replaced with fzf query

    nvim $selected
}

$@
