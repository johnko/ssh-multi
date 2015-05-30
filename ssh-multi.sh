#!/bin/sh
# ssh-multi
# D.Kovalov
# Based on http://linuxpixies.blogspot.jp/2011/06/tmux-copy-mode-and-how-to-control.html
# Modified by johnko

# a script to ssh multiple servers over multiple tmux panes


starttmux() {
    count=0
    if [ -z "${1}" ]; then
        echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
        read HOSTS
    else
        HOSTS=$*
    fi

    for i in ${HOSTS} ; do
        count=$(( count + 1 ))
        if [ ${count} -eq 1 ]; then
            if tmux ls >/dev/null 2>/dev/null ; then
                tmux new-window "ssh ${i}"
            else
                tmux new-session -d "ssh ${i}"
            fi
        else
            tmux split-window -h  "ssh ${i}"
            tmux select-layout tiled >/dev/null
        fi
    done

    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on >/dev/null

}

starttmux $*

tmux attach
