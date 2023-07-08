function sf
    source ~/.config/fish/config.fish
    fish_user_key_bindings
    hm
    echo "🐟🐟🐟 fish sauced with history 🐟🐟🐟"
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
alias cw="hmw 'Automation.init()'"

alias ll "exa -l -g --icons"
alias lla "ll -a"
alias hm="history merge"

alias cp "cp -i -v"
alias mv "mv -i -v"
alias rm "rm -i -v"

# jqp
alias jqp "jqp --config ~/.config/jqp/.jqp.yaml"

# lazygit
alias lazygit "lazygit -ucf ~/.config/lazygit/config.yml"

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
alias td="tmuxw delete_session"
alias ts="tmuxw start_session"

# ngrok
alias ng="curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'"
