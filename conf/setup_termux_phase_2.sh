#vim setup_termux_phase_2.sh
[[ -f ~/.vimrc ]] || cp _vimrc ~/.vimrc
[[ -f /data/data/com.termux/files/usr/etc/tmux.conf ]] || cp _tmux.conf /data/data/com.termux/files/usr/etc/tmux.conf
if ! diff _tmux.conf /data/data/com.termux/files/usr/etc/tmux.conf ; then
    read -p "etc/tmux.conf exist.  Enter 'y' to overwrite: " RESP
    if [[ "$RESP" == "y" ]]; then
        cp _tmux.conf /data/data/com.termux/files/usr/etc/tmux.conf
    else
        echo "Did not overwrite tmux.conf"
    fi
fi

[[ -f ~/.bashrc ]] || echo ". $(pwd)/../bash_aliases.pc" > ~/.bashrc
[[ -f ~/.gitconfig ]] || cat <<EOF > ~/.gitconfig
[core]
        autocrlf = true
EOF
