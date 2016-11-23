#!/usr/bin/env bash

########################################
# slatify-burp.sh
# Get output, analyse it and send warnings notifications to Slack
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
eval $(get_profile_settings ${HOME}/.slatify burp)
eval $(get_profile_settings ${SLATIFY_DIR}/.slatify slack)
eval $(get_profile_settings ${SLATIFY_DIR}/.slatify burp)

# Predefined wariables
TODAY=$(date "+%Y-%m-%d")

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

# Translating argument to --gnu-long-options
for arg; do
    delim=""
    case "${arg}" in
        --channel)                    args="${args}-c " ;;
        --warn)                       args="${args}-w " ;;
        --help)                       args="${args}-H " ;;
        *)                      [[ "${arg:0:1}" == "-" ]] || delim="\""
                                args="${args}${delim}${arg}${delim} ";;
    esac
done
eval set -- "$args"

# Parsing arguments
while getopts "c:w:H" Option; do
    case ${Option} in
        c) channel=${OPTARG} ;;
        w) warn=${OPTARG} ;;
        *) print_usage; check_result 1 "bad args" ;;
    esac
done

post_to_slack () {
    COLOR="$1"

    payload="{
        \"username\": \"BURP report ${TODAY}\",
        \"channel\": \"${channel}\",
        \"attachments\": [ {
            \"fallback\": \"BURP backup freshness\",
            \"color\": \"${COLOR}\",
            \"fields\":[
                {
                    \"value\":\"<${title_link}|${server}>\",
                    \"short\":true
                },
                {
                    \"value\":\"${date}\",
                    \"short\":true
                }
            ]
        } ]
    }"
  
    curl -s -X POST --data "payload=${payload}" ${HOOK} >/dev/null 2>&1
}

${burp} -a S | grep -v "burp status" | grep . | while read -r line; do
    server=$(echo ${line} | awk '{print $1}')
    date=$(echo ${line} | grep -o "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]")
    date_diff=$(( ($(date --date="${TODAY}" +%s) - $(date --date="${date}" +%s) )/(60*60*24) ))
    if [ "${date_diff}" -ge "${warn}" ]; then
        color='danger'
        post_to_slack "${color}" "${server}" "${date}"
    fi
done

exit 0
