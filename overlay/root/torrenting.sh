#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
export TERM=xterm
# Start rtorrent in detached screen
screen -dmS screen_rtorrent rtorrent
screen -S autodl -fa -d -m irssi
