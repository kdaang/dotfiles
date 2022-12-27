#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

windows=$(yabai -m query --windows)
display_count=$(yabai -m query --displays | jq '. | length')

windows_arr=$(echo "$windows" | jq -c '.[]')

#echo "$windows"
yabai -m space 1 --label main
yabai -m space 2 --label code
yabai -m space 3 --label chill

d1_apps=("Google Chrome")
d2_apps_1=("IntelliJ IDEA" "WebStorm" "CLion" "GoLand" "PyCharm" "Books" "CapCut")
d2_apps_2=("Alacritty" "Postman")
d3_apps=("Spotify" "Notion" "Figma" "Slack")

if (( $display_count <= 2 )); then
  d1_space="--space main"
  d2_space_1="--space code --grid 1:1:0:0:1:1"
  d2_space_2="--space code"
  d3_space="--space chill"
else
  d1_space="--space 1"
  d2_space_1="--space 4"
  d2_space_2="--space 3"
  d3_space="--space 2"
fi

declare -A space_map

function build_config() {
  space_index="$1"
  shift
  apps=("${@}")

  for app in "${apps[@]}"; do
    space_map+=([$app]="$space_index")
  done 
}

build_config "$d1_space" "${d1_apps[@]}"
build_config "$d2_space_1" "${d2_apps_1[@]}"
build_config "$d2_space_2" "${d2_apps_2[@]}"
build_config "$d3_space" "${d3_apps[@]}"

printf "SPACE_MAP: %s\n\n" "${space_map[@]@K}"

i=0
echo $windows | jq -c '.[]' | while read item; do
  app=$(jq -r '.app' <<< $item)
  window_id=$(jq -r '.id' <<< $item)

  #echo $i, $app, $window_id
  #echo ""
  let "i=++i"

  if [[ -v space_map[$app] ]]; then
    cmd="yabai -m window $window_id ${space_map[$app]}"
    echo $cmd
    eval $cmd
    echo "MOVED $app - $window_id"
  else
    echo "NO ASSIGNED CONFIG for: $app - $window_id"
  fi
done
