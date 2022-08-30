#!/bin/bash

session="mmcli_cl_session"

tmux new-session -d -s $session

window=0
tmux rename-window -t $session:$window 'connect_loop'
tmux send-keys -t $session:$window 'bash /projects/MMA/mmcli-cl/connect-loop' C-m

#window=1
#tmux new-window -t $session:$window -n 'vim'
#tmux send-keys -t $session:$window 'vim package.json'
