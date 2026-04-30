#!/usr/bin/env bash

export HOME="/root"
. "$HOME/.bashrc"

session="mmcli_cl_session"

tmux new-session -d -s $session

window=1
tmux rename-window -t $session:$window 'connect_loop'
tmux send-keys -t $session:$window '/usr/bin/bash' C-m
tmux send-keys -t $session:$window 'bash /projects/MMA/mmcli-cl/connect-loop datacard.tre.it ipv4v6' C-m

window=2
tmux new-window -t $session:$window -n 'logs'
tmux send-keys -t $session:$window '/usr/bin/bash' C-m
tmux send-keys -t $session:$window 'dmesg -T' C-m

window=3
tmux new-window -t $session:$window -n 'gping'
tmux send-keys -t $session:$window '/usr/bin/bash' C-m
tmux send-keys -t $session:$window 'sleep 60' C-m
tmux send-keys -t $session:$window 'gping 8.8.8.8' C-m

window=4
tmux new-window -t $session:$window -n 'gping_ipv6'
tmux send-keys -t $session:$window '/usr/bin/bash' C-m
tmux send-keys -t $session:$window 'sleep 60' C-m
tmux send-keys -t $session:$window 'gping www.google.com' C-m
