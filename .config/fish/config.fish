set -x fish_key_bindings fish_user_key_bindings
set -x tide_right_prompt_frame_enabled false
function fish_right_prompt
    #intentionally left blank
end

set -x EDITOR nvim
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x FZF_DEFAULT_OPTS "-m --height 50% --reverse --border=rounded --bind=change:top --cycle"

### ALIASES
source ~/.config/fish/alias.fish

### nnn config
source ~/.config/nnn/nnn-config.fish

### SETUP NVM
set --global nvm_default_version latest

### SETUP jenv for managing java versions
status --is-interactive; and source (jenv init -|psub)
set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"

### SETUP scala
fish_add_path /opt/homebrew/opt/scala@2.12/bin

### hammerspoon reads from ~/.hammerspoon/init.lua by default and is non configurable
ln -s ~/.config/hammerspoon/* ~/.hammerspoon/ &>/dev/null

### SETUP paths globals
fish_add_path -g -pP (yarn global bin)
fish_add_path -g -pP $HOME/bin

direnv hook fish | source
