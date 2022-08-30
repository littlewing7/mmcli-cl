#!/usr/bin/env bash
. "$HOME/.bashrc"

session="mmcli_cl_session"

tmux new-session -d -s $session

window=1
tmux rename-window -t $session:$window 'connect_loop'
tmux send-keys -t $session:$window 'bash /projects/MMA/mmcli-cl/connect-loop' C-m

window=2
tmux new-window -t $session:$window -n 'logs'
tmux send-keys -t $session:$window 'dmesg -T'
