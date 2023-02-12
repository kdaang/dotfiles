function run
  set TASK_FILE "Taskfile.sh"
  set TASK_BASE_FILE "Taskfile.base.sh"

  if test -f "$TASK_FILE"
    ./$TASK_FILE $argv
  else if test -f "$TASK_BASE_FILE"
    set -lx TASK_FILE_BASE_RUN  true
    ./$TASK_BASE_FILE $argv
  else
    echo "No task file found"
  end
end

alias vim nvim

alias fk fuck

alias g git

alias tl="tmux ls" 
alias ta="tmux a || tmux"
alias td="tmux_helper -d"
alias ts="tmux_helper -s"

alias cw="configure-workspace"

alias hm="history merge"

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

alias dotfiles="/usr/bin/git --git-dir=$HOME/code/dotfiles --work-tree=$HOME"
alias df=dotfiles

# fzf
function fcd
    set dir $(~/bin/fzfw.sh fcd)
    if test -n "$dir";
        cd "$dir"
    end
end

alias fw="~/bin/fzfw.sh fw"
