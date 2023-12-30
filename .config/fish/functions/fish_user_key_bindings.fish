function fish_user_key_bindings
    # peco
    bind \cr peco_select_history # Bind for peco select history to Ctrl+R
    # bind \cr fzf_select_history

    bind \cf fzf_search_dir

    # vim-like
    bind \cl forward-char
    fish_vi_key_bindings --no-erase insert

    # remove history
    bind \ch forget_history

    # enable fzf to find and paste file
    bind \cg _fzf_search_directory
end
