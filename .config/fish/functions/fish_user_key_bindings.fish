function fish_user_key_bindings
  # peco
  # bind \cr peco_select_history # Bind for peco select history to Ctrl+R
  bind \cr fzf_select_history

  # vim-like
  bind \cl forward-char
  fish_vi_key_bindings --no-erase insert

  # remove history
  bind \cg forget_history
end
