# Dotfiles - Git Bare Repo

- https://www.atlassian.com/git/tutorials/dotfiles

## Git Configs

- `~/.gitconfig` contains public config for checking in repo
- store private config in `~/.config/git/config` file

## Fish Shell

- Fish Plugins
  - Fisher for plugin manager - https://github.com/jorgebucaran/fisher
    - `fisher list`
      - jorgebucaran/fisher
      - ilancosman/tide@v5
      - edc/bass
      - jorgebucaran/nvm.fish
      - jethrokuan/z
- Notes:
  - to remove right bar in fish, comment out fish_right_prompt in `~/.config/fish/functions/fish_prompt.fish`
  - fix fish not loading in webstorm
    - `sudo ln -s ~/.config/fish /Applications/WebStorm.app/Contents/plugins/terminal`

## Tmux

- install TPM
  - install all the plugins -> rmb to fetch plugins with prefix-I (capital I)

## Notes

- brewfile
  - `brew bundle dump`
  - https://pumpingco.de/blog/brewfile/
- install powerline to get colours working for tmux
  - `pip3 install powerline-status`
- skhd
  - update cellar plist to use bash instead fish
  - https://github.com/koekeishiya/skhd/issues/42#issuecomment-401886533
- nvm
  - nvm needs to run a script but uses posix syntax which doesn't work with fish. We need to use bass to run it or something else.
  - i'm using this fisher plugin to make nvm work with fish
    - https://github.com/jorgebucaran/nvm.fish
