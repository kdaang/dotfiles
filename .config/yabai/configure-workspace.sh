#!/bin/bash

windows=$(yabai -m query --windows)

windows_arr=$(echo "$windows" | jq -c '.[]')

echo "$windows" | jq -c '.[]' | wc -l
echo $windows_arr | wc -l

d1_apps="^(Google Chrome)$"
d1_space=1
d2_apps="^(Alacritty|WebStorm)$"
d2_space=2
d3_apps="^(Spotify|Notion)$"
d3_space=3

i=0
echo $windows | jq -c '.[]' | while read item; do
  app=$(jq -r '.app' <<< $item)
  window_id=$(jq -r '.id' <<< $item)

  echo $i, $app, $window_id
  echo ""
  let "i=++i"

  if [[ $app =~ $d1_apps ]]; then
    yabai -m window $window_id --space $d1_space
    echo "MOVED CHROME"
  elif [[ $app =~ $d2_apps ]]; then
    yabai -m window $window_id --space $d2_space
    echo "MOVED 2"
  elif [[ $app =~ $d3_apps ]]; then
    yabai -m window $window_id --space $d3_space
    echo "MOVED 3"
  fi
done
