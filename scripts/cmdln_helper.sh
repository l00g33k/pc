# How to read this script file?
# -----------------------------
# This script is written in C style with a main function calling other functions.
# The following grep command hides the comments and the console messages to highlight the commands
# cat build_*.sh | grep -vP '^ *#|^ *echo|^ *$' | less


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
# make build
cmake ../xyz -G Ninja

# build
cmake --build .
EOB

    echo -e "${INFO} Line $LINENO: Type 'hint' to get this hint again ${RST}"

    return 0
}


function main() {

    fix__set_color_vars              || return $?  

    echo "Start executing commands in main() at $(date -Iseconds)"

    if [[ ! -f ${SCRIPTNAME}.sh ]]; then
        echo -e "${ERROR} Line $LINENO: FAILED ... ${RST} ${SCRIPTNAME}.sh should be launched in the 'xyz' directory"
        # unique error return code
        return $LINENO
    fi

   #make_local_vars_template    || return $?  
    set_local_vars              || return $?
    list_rootdir                || return $?
    hint                        || return $?

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
