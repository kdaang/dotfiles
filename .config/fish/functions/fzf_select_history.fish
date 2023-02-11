function fzf_select_history
  if test (count $argv) = 0
    set fzf_flags --layout=bottom-up
  else
    set fzf_flags --layout=bottom-up --query "$argv"
  end

  history|fzf $peco_flags|read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end
