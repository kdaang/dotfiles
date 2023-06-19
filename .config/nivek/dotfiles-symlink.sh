#!/bin/bash

REPO="~/dotfiles"

ln -s "$DOTFILES_REPO/bin/*" ~/bin/

ln -s "$DOTFILES_REPO/.config/fish/alias.fish" ~/.config/fish/alias.fish

ln -s "$DOTFILES_REPO/.config/fish/functions/fish_user_key_bindings.fish" ~/.config/fish/functions/fish_user_key_bindings.fish
ln -s "$DOTFILES_REPO/.config/fish/functions/fzf_search_dir.fish" ~/.config/fish/functions/fzf_search_dir.fish
ln -s "$DOTFILES_REPO/.config/fish/functions/fzf_select_history.fish" ~/.config/fish/functions/fzf_select_history.fish
ln -s "$DOTFILES_REPO/.config/fish/functions/_fzf_report_file_type.fish" ~/.config/fish/functions/_fzf_report_file_type.fish
ln -s "$DOTFILES_REPO/.config/fish/functions/_fzf_preview_file.fish" ~/.config/fish/functions/_fzf_preview_file.fish
ln -s "$DOTFILES_REPO/.config/fish/functions/peco_select_history.fish" ~/.config/fish/functions/peco_select_history.fish
ln -s "$DOTFILES_REPO/.config/fish/functions/forget_history.fish" ~/.config/fish/functions/forget_history.fish

ln -s "$DOTFILES_REPO/.config/tmux/tmux.conf" ~/.config/tmux/tmux.conf
ln -s "$DOTFILES_REPO/.config/tmux/.tmux.powerline.conf" ~/.config/tmux/.tmux.powerline.conf
ln -s "$DOTFILES_REPO/.config/alacritty/alacritty.yml" ~/.config/alacritty/alacritty.yml

ln -s "$DOTFILES_REPO/.config/nvim/" ~/.config/nvim
ln -s "$DOTFILES_REPO/.config/skhd/skhdrc" ~/.config/skhd/skhdrc
ln -s "$DOTFILES_REPO/.config/yabai/yabairc" ~/.config/yabai/yabairc
ln -s "$DOTFILES_REPO/.config/karabiner/assets/complex_modifications/karabiner-custom-mod.json" ~/.config/karabiner/assets/complex_modifications/karabiner-custom-mod.json

ln -s "$DOTFILES_REPO/.gitconfig" ~/.config/git/config
ln -s "$DOTFILES_REPO/.config/lazygit/config.yml" ~/.config/lazygit/config.yml
ln -s "$DOTFILES_REPO/.config/gitui/key_bindings.ron" ~/.config/gitui/key_bindings.ron

ln -s "$DOTFILES_REPO/.config/jqp/.jqp.yaml" ~/.config/jqp/.jqp.yaml
ln -s "$DOTFILES_REPO/.config/nnn/nnn-config.fish" ~/.config/nnn/nnn-config.fish
ln -s "$DOTFILES_REPO/.config/bat/config" ~/.config/bat/config
