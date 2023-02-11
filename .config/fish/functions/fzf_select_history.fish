function fzf_select_history
  history -n 100000000 | fzf --border-label="Search History" | read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
  commandline -f repaint # needed so that the fish prompt is shown after fzf exits - https://github.com/fish-shell/fish-shell/issues/5945
end
