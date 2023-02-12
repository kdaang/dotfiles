function sf
    source ~/.config/fish/config.fish
    fish_user_key_bindings
    echo "🐟🐟🐟 fish sauced 🐟🐟🐟"
end

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

# misc
alias vim nvim
alias fk fuck
alias cw="configure-workspace"

alias ll "exa -l -g --icons"
alias lla "ll -a"
alias hm="history merge"

# fzf
function fcd
    set dir $(~/bin/fzfw.sh fcd)
    if test -n "$dir";
        cd "$dir"
    end
end
alias fw="~/bin/fzfw.sh fw"

# git
alias g git
alias gc="~/bin/gitw gc"
alias gd="~/bin/gitw gd"

alias dotfiles="/usr/bin/git --git-dir=$HOME/code/dotfiles --work-tree=$HOME"
alias df=dotfiles

# bashw
alias pk="~/bin/bashw pkill"

# docker
alias da="~/bin/dockerw da"
alias ds="~/bin/dockerw ds"

# tmux
alias tl="tmux ls" 
alias ta="tmux a || tmux"
alias td="tmuxw -d"
alias ts="tmuxw -s"
