export PATH="/Users/kevindang/bin:/Users/kevindang/.yarn/bin:/Users/kevindang/.jenv/shims:/Users/kevindang/.jenv/shims:/Users/kevindang/.local/share/nvm/v21.6.0/bin:/opt/homebrew/sbin:/opt/homebrew/opt/scala@2.12/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_OPTS="-m --height 50% --reverse --border=rounded --bind=change:top --cycle"

source ~/.config/.alias_zshrc

### SETUP NNN
alias nnn='nnn -a'
# for some reason $Z_DATA is not picked up by the autojump plugin so mapping to default z data location
ln -s $Z_DATA $HOME/.z &> /dev/null

export NNN_PLUG='g:preview-tui;z:autojump;f:fzcd'

### SETUP NVM
export nvm_default_version=latest

### SETUP jenv for managing java versions
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"
eval "$(jenv init -)"

### hammerspoon reads from ~/.hammerspoon/init.lua by default and is non configurable
ln -s ~/.config/hammerspoon/* ~/.hammerspoon/ &>/dev/null

eval "$(direnv hook zsh)"

