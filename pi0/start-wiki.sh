#!/bin/bash

/usr/bin/tmux \
new-session -d bash -c 'cd /home/pi/g/wikiPland && while true; do perl -I . l00httpd.pl ; sleep 1 ; done' \; \
rename-window wiki

# \; \
#new-window bash -c 'cd /home/pi/wk/wikipland && perl -I . l00httpd.pl' \; \
#rename-window second


