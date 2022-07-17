set -g tide_right_prompt_frame_enabled false
set -x fish_key_bindings fish_user_key_bindings
set -x EDITOR vim

### ALIASES

alias run="./Taskfile.sh"

#git
alias g git

#tmux
alias tl="tmux ls" 
alias ta="tmux a"

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

alias dotfiles="/usr/bin/git --git-dir=$HOME/code/dotfiles --work-tree=$HOME"
alias df=dotfiles

### SETUP NVM
set --universal nvm_default_version lts
fish_add_path -pP $HOME/.yarn/bin

direnv hook fish | source
