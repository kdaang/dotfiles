#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

windows=$(yabai -m query --windows)

windows_arr=$(echo "$windows" | jq -c '.[]')

#echo "$windows"

d1_apps=("Google Chrome")
d1_space=1
d2_apps=("Alacritty" "IntelliJ IDEA" "WebStorm" "CLion" "GoLand" "PyCharm")
d2_space=2
d3_apps=("Spotify" "Notion")
d3_space=3

declare -A space_map

function build_config() {
  space_index="$1"
  shift
  apps=("${@}")

  for app in "${apps[@]}"; do
    space_map+=([$app]=$space_index)
  done 
}

build_config $d1_space "${d1_apps[@]}"
build_config $d2_space "${d2_apps[@]}"
build_config $d3_space "${d3_apps[@]}"

printf "SPACE_MAP: %s\n\n" "${space_map[@]@K}"

i=0
echo $windows | jq -c '.[]' | while read item; do
  app=$(jq -r '.app' <<< $item)
  window_id=$(jq -r '.id' <<< $item)

  #echo $i, $app, $window_id
  #echo ""
  let "i=++i"

  if [[ -v space_map[$app] ]]; then
    yabai -m window $window_id --space ${space_map[$app]}
    echo "MOVED $app"
  else
    echo "NO ASSIGNED CONFIG for:" $app
  fi
done
