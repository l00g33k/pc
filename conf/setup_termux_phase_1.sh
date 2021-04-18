#vim setup_termux_phase_1.sh
# Android App Permission: allow storage
## termux-setup-storage

# Copy to target
#   somewhere/id_rsa.pub
#   somewhere/setup_termux_phase_1.sh
# To install:
#   . setup_termux_phase_1.sh

# update/upgrade
echo "=pkg update/upgrade="
read -p "pkg update. Enter 'y' to run: " RESP
if [[ "$RESP" == "y" ]]; then
    echo "pkg update"
          pkg update
else
    echo "Did not pkg update"
fi
read -p "pkg upgrade. Enter 'y' to run: " RESP
if [[ "$RESP" == "y" ]]; then
    echo "pkg upgrade"
          pkg upgrade
else
    echo "Did not pkg upgrade"
fi
pkg install openssh tmux vim git mc

# setup user key
[[ -d ~/.ssh ]] || mkdir ~/.ssh && chmod 700 ~/.ssh
[[ -f ~/.ssh/id_rsa ]] || ssh-keygen -t rsa
[[ -f ~/.ssh/authorized_keys ]] || touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
# append id_rsa.pub
[[ -f id_rsa.pub ]] && cat id_rsa.pub >> ~/.ssh/authorized_keys
echo ~/.ssh/authorized_keys

# setup 'ss' for sshd on port 20339
[[ -f /data/data/com.termux/files/usr/bin/ss ]] || \
echo 'sshd -e -D -oKexAlgorithms=+diffie-hellman-group1-sha1 -p 20339' > \
/data/data/com.termux/files/usr/bin/ss && \
chmod 777 /data/data/com.termux/files/usr/bin/ss

# create pc.git
[[ -d /sdcard/2/g/pc ]] || mkdir -p /sdcard/2/g/pc && git -C /sdcard/2/g/pc init
echo 'git remote add tmp ssh://t@192.168.1.8:20339/sdcard/2/g/pc/.git'
echo 'git checkout -b me fang'
echo '. /sdcard/2/g/pc/conf/setup_termux_phase_2.sh'
echo 'uname -a > ~/2n8.txt'

