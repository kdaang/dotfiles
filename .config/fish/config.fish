set -g tide_right_prompt_frame_enabled false
set -x fish_key_bindings fish_user_key_bindings
set -x EDITOR vim

### ALIASES

# projects
alias cart="tmuxp load -y ~/.config/tmuxp/cart-app.yaml"

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

alias cw="./bin/configure-workspace"

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

alias dotfiles="/usr/bin/git --git-dir=$HOME/code/dotfiles --work-tree=$HOME"
alias df=dotfiles

### SETUP NVM
set --universal nvm_default_version lts
fish_add_path -pP $HOME/.yarn/bin
fish_add_path -pP $HOME/bin

### SETUP jenv for managing java versions
status --is-interactive; and source (jenv init -|psub)
set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"

### SETUP scala
fish_add_path /opt/homebrew/opt/scala@2.12/bin

direnv hook fish | source
