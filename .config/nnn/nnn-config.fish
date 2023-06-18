alias nnn='nnn -a'
# for some reason $Z_DATA is not picked up by the autojump plugin so mapping to default z data location
ln -s $Z_DATA $HOME/.z &> /dev/null

export NNN_PLUG='p:preview-tui;z:autojump'
