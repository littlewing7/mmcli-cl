
# forked from yadieet/mmcli-cl

this is a fork for Void-Linux and different modem identification: 

1. modem model aware
2. run on void with runit 
3. use mmcli 1.18.6 
4. identify the infercace regardless of OS renaming
5. link check and monitor if DOWN restart and reconnect
6. use ip commmands instead of deprecated ifconfig 

# mmcli-cl commandline utility for connection using modem Manager on USB and wwan0 interface or renamed wwan interface (ex. wwp0s20u4i12) 
 
Script for Void Linux. 

## Usage

add to rc.local:


bash /projects/MMA/mmcli-cl/connect-loop


