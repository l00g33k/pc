#!/bin/bash

# Ubuntu Display: System Settings -- Display -- 1680 x 1050


CONFDIR="$(dirname $(readlink -f $0))"
echo "Running $(basename $0) in directory $CONFDIR"
echo "This script will setup the phase 2 Linux environment for Alfred. Enter to continue"
read

echo "===install vim tmux mc ne git==="
set -vx
which nmap              || sudo apt install -y nmap
which geany             || sudo apt install -y geany
which wireshark         || sudo apt install -y wireshark
which chromium-browser  || sudo apt install -y chromium-browser
which sshpass           || sudo apt install -y sshpass
which xournal           || sudo apt install -y xournal
which svn               || sudo apt install -y subversion
which make              || sudo apt install -y make
which gcc               || sudo apt install -y gcc
which curl              || sudo apt install -y curl

#https://itsfoss.com/install-chrome-ubuntu/
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo dpkg -i google-chrome-stable_current_amd64.deb

set +vx

