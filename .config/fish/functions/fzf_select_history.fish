function fzf_select_history
  history | fzf --height 50% --reverse --border=rounded --border-label="Search History" --bind=change:top | read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
  commandline -f repaint # needed so that the fish prompt is shown after fzf exits - https://github.com/fish-shell/fish-shell/issues/5945
end
