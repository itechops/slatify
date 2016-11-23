#!/bin/bash

########################################
# slatify-std.sh
# Get output, analyse it and send notifications to Slack
#
########################################

SLATIFY_DIR=$(dirname $0)
# Define lib folder and libs to load 
LIBFOLDER="${SLATIFY_DIR}/lib"
IMPORTLIBS=(
    lib_get_conf.sh
)

# Checking and importing libraries
for libfile in ${IMPORTLIBS[*]}; do
    mylib="${LIBFOLDER}/${libfile}"
    if [ -e "$mylib" ]; then
       source "$mylib"
    else
       echo "Error: File [$mylib] doesn't exist!!!"
       exit $E_FILE_DOES_NOT_EXIST
    fi
done

# Load profiles
eval $(get_profile_settings ${HOME}/.slatify slack)
eval $(get_profile_settings ${HOME}/.slatify std)
eval $(get_profile_settings ${SLATIFY_DIR}/.slatify slack)
eval $(get_profile_settings ${SLATIFY_DIR}/.slatify std)

# Predefined wariables
STD='all'

SCRIPT="$@"
ME=$0

#----------------------------------------------------------#
#                     Functions                            #
#----------------------------------------------------------#
# Defning helper function
print_usage() {
    echo
    echo "Usage: $(basename $0) [OPTIONS]"
    echo "  -c, --channel           Slack channel"
    echo "  -w, --warn              Warn if older than X days"
    echo "  -H, --help              Print this help"
    echo
    exit 1
}

# FUNCTIONS
post_to_slack () {

    payload="{
        \"username\": \"std${STD}\",
        \"channel\": \"${channel}\",
        \"attachments\": [ {
            \"fallback\": \"std${STD}\",
            \"color\": \"${COLOR}\",
            \"fields\":[
                {
                    \"value\":\"${ROW}\",
                    \"short\":true
                }
            ]
        } ]
    }"

    curl -s -X POST --data "payload=${payload}" ${HOOK} >/dev/null 2>&1
}

read_std() {
    while read -r ROW; do
        post_to_slack "${ROW}"
    done
}

# Translating argument to --gnu-long-options
for arg; do
    delim=""
    case "${arg}" in
        --out)                        args="${args}-o " ;;
        --err)                        args="${args}-e " ;;
        --channel)                    args="${args}-c " ;;
        --warn)                       args="${args}-w " ;;
        --help)                       args="${args}-H " ;;
        *)                      [[ "${arg:0:1}" == "-" ]] || delim="\""
                                args="${args}${delim}${arg}${delim} ";;
    esac
done
eval set -- "$args"

# Parsing arguments
while getopts "oec:w:H" Option; do
    case ${Option} in
        o) STD='out' ; COLOR='good' ;;
        e) STD='err' ; COLOR='danger' ;;
        c) channel=${OPTARG} ;;
        w) warn=${OPTARG} ;;
        *) print_usage; check_result 1 "bad args" ;;
    esac
done

case "${STD}" in
    all)       ./${SCRIPT} 2> >(${ME} --err) > >(${ME} --out);;
    out|err)   read_std;;
esac

exit 0
