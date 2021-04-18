#!/bin/bash

# How to read this script file?
# -----------------------------
# This script is written in C style with a main function calling other functions.
# The following grep command hides the comments and the console messages to highlight the commands
# cat build_*.sh | grep -vP '^ *#|^ *echo|^ *$' | less

# This script sets up Kali Linux




INTERACTIVE=1
MYOPTIONS=abc

SCRIPTNAME=cmdln_helper

ROOTDIR=$(pwd)
# $ROOTDIR/xyz
#   should expand to:
# /home/me/xyz


function make_local_vars_template() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: Exist? ${SCRIPTNAME}_local.sh${RST}"
    if [[ ! -f ${SCRIPTNAME}_local.sh ]]; then
        # create build_diracio_oly_bc_helper_local.sh
        ## this is a long here string used to create new build_diracio_oly_bc_helper_local.sh
        cat > ${SCRIPTNAME}_local.sh<<EOB
# This file is .gitignore'd and sourced by ${SCRIPTNAME}.sh for your environment
#
# Uncomment these lines and update for your environment
#ROOTDIR=$(pwd)
EOB
        echo -e "${ACTION} Line $LINENO: EDIT ..... ${RST} Edit ${SCRIPTNAME}_local.sh for your environment"
        # unique error return code
        return $LINENO
    else
        echo -e "${SUCCESS} Line $LINENO: OK ....... ${RST} Found ${SCRIPTNAME}_local.sh, will source"
    fi

    return 0
}


function set_local_vars() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: Source? ${SCRIPTNAME}_local.sh${RST}"
    if [[ ! -f ${SCRIPTNAME}_local.sh ]]; then
        # create ${SCRIPTNAME}_local.sh
        echo -e "${INFO} Line $LINENO: Missing ${SCRIPTNAME}_local.sh${RST} You can create it for your local variables"
    else
        . ${SCRIPTNAME}_local.sh
        echo -e "${SUCCESS} Line $LINENO: Sourced ${SCRIPTNAME}_local.sh${RST} for your local variables"
    fi

    echo -e "${INFO} Line $LINENO: Actual value of known variables defined in ${SCRIPTNAME}_local.sh${RST}"
    echo "ROOTDIR      = $ROOTDIR"

    return 0
}


function list_rootdir() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${INFO} Line $LINENO: Directory content of${RST} $YOCTOROOT"
    ls -la $YOCTOROOT

    fix__wait4user $LINENO

    return 0
}


function hint() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${INFO} Line $LINENO: Helpful hints: ${RST}"
    echo -e "${ACTION} Line $LINENO: Commands you can run now: ${RST}"
    cat <<EOB
# there is nothing to do
echo "Hello from"
uname -a
EOB

    echo -e "${INFO} Line $LINENO: Type 'hint' to get this hint again ${RST}"

    return 0
}


function sync_time() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: Sync time with 0.north-america.pool.ntp.org ${RST}"

    echo -e "${CMDLN} Line $LINENO: date -R ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo sntp -S -c 0.north-america.pool.ntp.org ${RST}"
    echo -e "${CMDLN} Line $LINENO: date -R ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo timedatectl set-timezone America/Los_Angeles ${RST}"

    date -R
    sudo sntp -S -c 0.north-america.pool.ntp.org
    date -R
    # timedatectl list-timezones
    sudo timedatectl set-timezone America/Los_Angeles

    fix__wait4user $LINENO

    return 0
}


function copy_dot_files() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"


    echo -e "${EXECUTE} Line $LINENO: make .ssh files ${RST}"

    echo -e "${CMDLN} Line $LINENO: mkdir ~/.ssh && chmod 755 ~/.ssh ${RST}"
    echo -e "${CMDLN} Line $LINENO: touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys ${RST}"
    echo -e "${CMDLN} Line $LINENO: ssh-keygen && cat ~/.ssh/id_rsa.pub && echo \"Enter to continue\" && read ${RST}"

    [[ ! -d ~/.ssh ]] && echo "Create .ssh" && mkdir ~/.ssh && chmod 755 ~/.ssh
    [[ ! -f ~/.ssh/authorized_keys ]] && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
    [[ ! -f ~/.ssh/id_rsa ]] && echo "Generate ssh key" && ssh-keygen && cat ~/.ssh/id_rsa.pub && echo "Enter to continue" && read

    echo -e "${EXECUTE} Line $LINENO: make .bash_aliases and . bash_aliases.pc ${RST}"
    echo -e "${CMDLN} Line $LINENO: echo \"source $CONFDIR/../bash_aliases.pc\" > ~/.bash_aliases ${RST}"
    [[ ! -f ~/.bash_aliases ]] && echo "Create ~/.bash_aliases " && echo "source $CONFDIR/../bash_aliases.pc" > ~/.bash_aliases

    echo -e "${EXECUTE} Line $LINENO: make .zshenv ${RST}"
    if echo $SHELL | grep zsh && [[ ! -f ~/.zshenv ]] ; then
        echo -e "${INFO} Line $LINENO: Create ~/.zshenv ${RST}"
        echo -e "${CMDLN} Line $LINENO: echo \"source $CONFDIR/../bash_aliases.pc\" > ~/.zshenv ${RST}"
        echo -e "${CMDLN} Line $LINENO: echo \"alias ll='ls -la --color=never'\" >> ~/.zshrc ${RST}"
        echo "source $CONFDIR/../bash_aliases.pc" > ~/.zshenv
        echo "alias ll='ls -la --color=never'" >> ~/.zshrc
    fi

    echo -e "${EXECUTE} Line $LINENO: copy .tmux.conf .vimrc ${RST}"
    echo -e "${CMDLN} Line $LINENO: cp _tmux.conf ~/.tmux.conf ${RST}"
    echo -e "${CMDLN} Line $LINENO: cp _vimrc ~/.vimrc ${RST}"
    [[ ! -f ~/.tmux.conf ]] && cp _tmux.conf ~/.tmux.conf
    [[ ! -f ~/.vimrc ]] && cp _vimrc ~/.vimrc

    fix__wait4user $LINENO

    return 0
}

function install_tools() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: install vim, xclip, mc ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y vim ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y xclip ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y mc ${RST}"
    set -vx
    which vim       || sudo apt install -y vim
    which xclip     || sudo apt install -y xclip
    which mc        || sudo apt install -y mc
    set +vx

    fix__wait4user $LINENO

    return 0
}

function copy_sikulix() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: copy sikulix and java ${RST}"
    echo -e "${CMDLN} Line $LINENO: pushd /dev/shm ${RST}"
    echo -e "${CMDLN} Line $LINENO: cp /media/kali/BA1F-BF12/sikulixide-2.0.5.jar . ${RST}"
    echo -e "${CMDLN} Line $LINENO: tar zxf /media/kali/BA1F-BF12/openjdk-16+36_linux-x64_bin.tar.gz ${RST}"
    echo -e "${CMDLN} Line $LINENO: popd ${RST}"
    pushd /dev/shm
    cp /media/kali/BA1F-BF12/sikulixide-2.0.5.jar .
    tar zxf /media/kali/BA1F-BF12/openjdk-16+36_linux-x64_bin.tar.gz
    popd

    echo -e "${INFO} Line $LINENO: cd /media/kali/BA1F-BF12 ${RST}"
    echo -e "${INFO} Line $LINENO: /dev/shm/jdk-16/bin/java -jar /dev/shm/sikulixide-2.0.5.jar ${RST}"

    fix__wait4user $LINENO

    return 0
}

function start_ssh() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: Start ssh ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo systemctl start ssh ${RST}"

    sudo systemctl start ssh

    fix__wait4user $LINENO

    return 0
}


function main() {

    fix__set_color_vars              || return $?  

    echo "Start executing commands in main() at $(date -Iseconds)"

    CONFDIR="$(dirname $(readlink -f $0))"
    echo -e "${INFO} Line $LINENO: Running $(basename $0) in directory $CONFDIR ${RST}"
    echo -e "${INFO} Line $LINENO: This script will setup the Kali Linux environment. Enter to continue ${RST}"
    fix__wait4user $LINENO


#   if [[ ! -f ${SCRIPTNAME}.sh ]]; then
#       echo -e "${ERROR} Line $LINENO: FAILED ... ${RST} ${SCRIPTNAME}.sh should be launched in the 'xyz' directory"
#       # unique error return code
#       return $LINENO
#   fi


    set_local_vars              || return $?
    list_rootdir                || return $?

    sync_time                   || return $?
    install_tools               || return $?
    copy_dot_files              || return $?
    copy_sikulix                || return $?
    start_ssh                   || return $?

   #hint                        || return $?

    echo -e "${INFO} Line $LINENO: All done${RST}"

    return 0
}


function fix__wait4user() {
    if [[ $INTERACTIVE -ne 0 ]] ; then
        echo -e "${ACTION} Line $LINENO: Line $1: <Enter> to continue${RST}"
        read
        echo -e "$CONTTEXT $(date -Iseconds)\n"
    fi
}

function fix__set_color_vars() {

    # color shorthands
    echo "Begin text color convention"
    export RST="\e[0m"
    export SUCCESS="\e[32m::Results:"
    echo -e "${SUCCESS} Line $LINENO: success${RST} text"
    export ERROR="\e[91m::Results:"
    echo -e "${ERROR} Line $LINENO: error${RST} text"
    export EXECUTE="\e[33m::Execute:"
    echo -e "${EXECUTE} Line $LINENO: execute${RST} text"
    export INFO="\e[94m::Info:"
    echo -e "${INFO} Line $LINENO: info${RST} text"
    export CONFIG="\e[36m::Config:"
    echo -e "${CONFIG} Line $LINENO: something configurable${RST} text"
    export ACTION="\e[95m::Action:"
    echo -e "${ACTION} Line $LINENO: your action${RST} text"
    export VERBOSE="\e[37m::Verbose:"
    echo -e "${VERBOSE} Line $LINENO: verbose details${RST} text"
    export CMDLN="\e[34m::Cmdln:"
    echo -e "${CMDLN} Line $LINENO: command lines${RST}"

    echo -e "${INFO} Line $LINENO: Setup screen color${RST} done!"
    echo "End text color convention"

    return 0
}

function usage() {
    cat <<EOB
Usage: ${SCRIPTNAME}.sh [-a] [-b options]
-a: auto, no wait
-b options: options
EOB

    return $LINENO;
}

function mygetopts() {
    OPTIND=0
    while getopts "ab:" option; do
    	echo "Processing option: ${option}"
    	case "${option}" in
    		a)
    			INTERACTIVE=0
    			;;
    		b)
    			MYOPTIONS=$OPTARG
    			;;
    		*)
    			usage
    			return $LINENO
    			;;
    	esac
    done
    echo "OPTIND $OPTIND"
    shift $(($OPTIND - 1))
    if [[ $# > 0 ]]; then
        usage
        return $LINENO
    fi

    # reset OPTIND for other getopts uses
    OPTIND=1

    return 0
}

mygetopts $*    || return $?
main $*         || echo "ERROR CODE: $?" && return $?
