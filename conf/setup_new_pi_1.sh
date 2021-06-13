#!/bin/bash


# How to read this script file?
# -----------------------------
# This script is written in C style with a main function calling other functions.
# The following grep command hides the comments and the console messages to highlight the commands
# cat build_*.sh | grep -vP '^ *#|^ *echo|^ *$' | less

# This script sets up Raspberry Pi

# Steps:
# 0. Install tools:
#    sudo apt install git vim tmux mc
# 1. Install Raspbian and enable sshd:
#    touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys




INTERACTIVE=1
MYOPTIONS=abc

SCRIPTNAME=cmdln_helper

ROOTDIR=$(pwd)


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


function setup_hostname() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: Setup hostname ${RST}"

    echo -e "${CMDLN} Line $LINENO: hostnamectl ${RST}"
    hostnamectl
    echo -e "${ACTION} Line $LINENO: Line $1: Enter new hostname ${RST}"
    read -p "(blank to skip; confirm/cancel later): " HNAME
    if [[ "$HNAME" != "" ]]; then
        echo -e "${ACTION} Line $LINENO: You entered '$HNAME', Enter blank to use ${RST}"
        read -p "Enter blank to use: " RESP
        if [[ "$RESP" == "" ]]; then
            echo -e "${CMDLN} Line $LINENO: sudo hostnamectl set-hostname $HNAME ${RST}"
            sudo hostnamectl set-hostname $HNAME
        else
            echo "Did not set hostname to '$HNAME'"
            echo -e "${ERROR} Line $LINENO: Did not set hostname to '$HNAME' ${RST}"
        fi
    fi

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
    echo -e "${CMDLN} Line $LINENO: echo \". $CONFDIR/../bash_aliases.pc\" > ~/.bash_aliases ${RST}"
    [[ ! -f ~/.bash_aliases ]] && echo "Create ~/.bash_aliases " && echo ". $CONFDIR/../bash_aliases.pc" > ~/.bash_aliases


    echo -e "${EXECUTE} Line $LINENO: copy .tmux.conf .vimrc ${RST}"
    echo -e "${CMDLN} Line $LINENO: cp _tmux.conf ~/.tmux.conf ${RST}"
    echo -e "${CMDLN} Line $LINENO: cp _vimrc ~/.vimrc ${RST}"
    [[ ! -f ~/.tmux.conf ]] && cp _tmux.conf ~/.tmux.conf
    [[ ! -f ~/.vimrc ]] && cp _vimrc ~/.vimrc

    fix__wait4user $LINENO

    return 0
}


function update_upgrade() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: sudo apt update.  ${RST}"
    read -p "Enter 'y' to run: " RESP
    if [[ "$RESP" == "y" ]]; then
        echo -e "${CMDLN} Line $LINENO: sudo apt update ${RST}"
        sudo apt update
    else
        echo -e "${ERROR} Line $LINENO: Did not apt update ${RST}"
    fi

    echo -e "${EXECUTE} Line $LINENO: sudo apt upgrade.  ${RST}"
    read -p "Enter 'y' to run: " RESP
    if [[ "$RESP" == "y" ]]; then
        echo -e "${CMDLN} Line $LINENO: sudo apt upgrade ${RST}"
        sudo apt upgrade
    else
        echo -e "${ERROR} Line $LINENO: Did not apt upgrade ${RST}"
    fi

    fix__wait4user $LINENO

    return 0
}


function install_tools() {
    echo -e "${VERBOSE} Line $LINENO: In function ${FUNCNAME[0]}: $# arguments: $*${RST}"

    echo -e "${EXECUTE} Line $LINENO: install vim, xclip, mc ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y vim ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y tmux ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y xclip ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y mc ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y git ${RST}"
    echo -e "${CMDLN} Line $LINENO: sudo apt install -y dos2unix ${RST}"
    set -vx
    which vim       || sudo apt install -y vim
    which tmux      || sudo apt install -y tmux
    which xclip     || sudo apt install -y xclip
    which mc        || sudo apt install -y mc
    which git       || sudo apt install -y git
    which dos2unix  || sudo apt install -y dos2unix
    set +vx

    fix__wait4user $LINENO

    return 0
}


function main() {

    fix__set_color_vars              || return $?  

    echo "Start executing commands in main() at $(date -Iseconds)"

    if [[ "$0" == "-bash" ]]; then
        # Ubuntu readlink doesn't work on . file
        echo -e "${INFO} Line $LINENO: You must start from the directory containing setup_new_linux_1.sh ${RST}"
        CONFDIR=$(pwd)
        echo -e "${INFO} Line $LINENO: Running setup_new_linux_1.sh in directory $CONFDIR ${RST}"
    else
        CONFDIR="$(dirname $(readlink -f $0))"
        echo -e "${INFO} Line $LINENO: Running $(basename $0) in directory $CONFDIR ${RST}"
    fi
    echo -e "${INFO} Line $LINENO: This script will setup the Raspberry Pi Linux environment. Enter to continue ${RST}"
    fix__wait4user $LINENO

    setup_hostname              || return $?



    set_local_vars              || return $?

    update_upgrade              || return $?

    install_tools               || return $?
    copy_dot_files              || return $?


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
    echo -e "${SUCCESS} Line $LINENO: success${RST}"
    export ERROR="\e[91m::Results:"
    echo -e "${ERROR} Line $LINENO: error${RST}"
    export EXECUTE="\e[33m::Execute:"
    echo -e "${EXECUTE} Line $LINENO: execute${RST}"
    export INFO="\e[94m::Info:"
    echo -e "${INFO} Line $LINENO: info${RST}"
    export CONFIG="\e[36m::Config:"
    echo -e "${CONFIG} Line $LINENO: something configurable${RST}"
    export ACTION="\e[95m::Action:"
    echo -e "${ACTION} Line $LINENO: your action${RST}"
    export VERBOSE="\e[37m::Verbose:"
    echo -e "${VERBOSE} Line $LINENO: verbose details${RST}"
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
