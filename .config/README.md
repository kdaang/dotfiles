# Dotfiles - Git Bare Repo
- https://www.atlassian.com/git/tutorials/dotfiles

# Install GUI
- `brew install --cask google-chrome karabiner-elements alacritty webstorm spotify spacelauncher notion`

# Install
- `brew install git tmux fish python3 docker nvm jq exa`
- fisher, tide
- docker desktop
  - to get the docker daemon on mac without the hassle

# Notes
- fish shell
  - to remove right bar in fish, comment out fish_right_prompt in `~/.config/fish/functions/fish_prompt.fish`
- install TPM
  - install all the plugins -> rmb to fetch plugins with prefix-I (capital I)
- install powerline to get colours working for tmux
  - `pip3 install powerline-status`
- fix fish not loading in webstorm
  - `sudo ln -s ~/.config/fish /Applications/WebStorm.app/Contents/plugins/terminal`
- yabai
- skhd
  - update cellar plist to use bash instead fish
  - https://github.com/koekeishiya/skhd/issues/42#issuecomment-401886533
