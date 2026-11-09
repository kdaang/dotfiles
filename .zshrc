# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

IS_MAC=false; [[ "$OSTYPE" == darwin* ]] && IS_MAC=true

if $IS_MAC; then
  export PATH="/Users/kevindang/bin:/Users/kevindang/.yarn/bin:/Users/kevindang/.jenv/shims:/Users/kevindang/.jenv/shims:/Users/kevindang/.local/share/nvm/v21.6.0/bin:/opt/homebrew/sbin:/opt/homebrew/opt/scala@2.12/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/kevindang/.bun/bin:$PATH"
  ZSH_PLUGIN_DIR="$(brew --prefix)/share"
  ZSH_VI_MODE_DIR="$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode"
  P10K_DIR="/opt/homebrew/share/powerlevel10k"
  NVM_SH="/opt/homebrew/opt/nvm/nvm.sh"
else
  export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
  ZSH_PLUGIN_DIR="/usr/share"                       # apt: zsh-autosuggestions, zsh-syntax-highlighting
  ZSH_VI_MODE_DIR="$HOME/.local/share/zsh/zsh-vi-mode"
  P10K_DIR="$HOME/.local/share/zsh/powerlevel10k"
  NVM_SH="$HOME/.nvm/nvm.sh"
fi

export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_OPTS="-m --height 50% --reverse --border=rounded --bind=change:top --cycle"

source ~/.config/.alias_zshrc

# HISTORY
export HISTSIZE=5000000
export SAVEHIST=$HISTSIZE

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt SHARE_HISTORY             # Share history between all sessions.
# END HISTORY

### SETUP NNN
alias nnn='nnn -a'
# for some reason $Z_DATA is not picked up by the autojump plugin so mapping to default z data location
ln -s $Z_DATA $HOME/.z &> /dev/null

export NNN_PLUG='g:preview-tui;z:autojump;f:fzcd'

### SETUP NVM
export nvm_default_version=latest
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_SH" ] && \. "$NVM_SH"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if $IS_MAC; then
  ### SETUP jenv for managing java versions
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"
  eval "$(jenv init -)"

  ### hammerspoon reads from ~/.hammerspoon/init.lua by default and is non configurable
  ln -s ~/.config/hammerspoon/* ~/.hammerspoon/ &>/dev/null
fi

# eval "$(starship init zsh)"

### ZSH STUFF
# https://github.com/jeffreytse/zsh-vi-mode
source $ZSH_VI_MODE_DIR/zsh-vi-mode.plugin.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting
source $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-autosuggestions
source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# https://github.com/romkatv/powerlevel10k
source $P10K_DIR/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh (mac) / ~/.p10k.devpod.zsh (devpod).
if ! $IS_MAC && [[ -f ~/.p10k.devpod.zsh ]]; then
  source ~/.p10k.devpod.zsh
elif [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
