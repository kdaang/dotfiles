set -g tide_right_prompt_frame_enabled false
set -x fish_key_bindings fish_user_key_bindings
set -x tide_right_prompt_frame_enabled false

set -x EDITOR vim
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x FZF_DEFAULT_OPTS "-m --height 50% --reverse --border=rounded --bind=change:top --cycle"

### ALIASES
source ~/.config/fish/alias.fish

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
