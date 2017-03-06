#!/bin/bash

########################################
#  slatify-webhook.sh
#  Send message to SLACK via webhook
#  iTech SRL, slatify@itech.md
########################################

# Defning default variables
HOOK=''
ICON='INFO'

# Defning helper function
print_usage() {
    echo
    echo "Usage: $(basename $0) [OPTIONS]"
    echo "  -h, --hook              Webhook URL"
    echo "  -m, --message           Message"
    echo "  -i, --icon              Message icon"
    echo "  -v, --verbose           Verbose mode, will print verbose information in STDOUT"
    echo "  -H, --help              Print this help"
    echo
    echo "Webhook description : https://api.slack.com/incoming-webhooks"
    echo 
    echo "Icons tested: INFO, WARNING, ERROR. Default is INFO. Feel free to try another icons"
    echo "Feel free to add/modify script, or contact me for assistance"
    echo 
    echo "iTech SRL, slatify@itech.md"  
    echo
    echo "HINT! quote message to use it as single string."
    
    exit 1
}

# Defning verbose function, 
verbose() {
    local message=${1}
    if [ -n "${VERBOSE}" ]; then
         echo -e "${message}"
    fi
}

# Translating argument to --gnu-long-options
for arg; do
    delim=""
    case "${arg}" in
        --hook)                       args="${args}-h " ;;
        --message)                    args="${args}-m " ;;
        --icon)                       args="${args}-i " ;;
        --verbose)                    args="${args}-v " ;;
        --help)                       args="${args}-H " ;;
        *)                      [[ "${arg:0:1}" == "-" ]] || delim="\""
                                args="${args}${delim}${arg}${delim} ";;
    esac
done
eval set -- "$args"

# Parsing arguments
while getopts "h:m:i:vH" Option; do
    case ${Option} in
        h) HOOK=${OPTARG} ;;
        m) MESSAGE=${OPTARG} ;;
        i) ICON=${OPTARG} ;;
        v) VERBOSE='yes' ;;
        *) print_usage ;;
    esac
done

# MAIN
# Check mandatory field
if [ -z "${HOOK}" ]; then
    print_usage
fi

verbose "INFO: Hook URL ${HOOK}"
verbose "INFO: ICON ${ICON}"
verbose "INFO: Message \"${MESSAGE}\""

# Set Icon
case "${ICON}" in
        INFO)     SLACK_ICON=':information_source:' ;;
        WARNING)  SLACK_ICON=':warning:' ;;
        ERROR)    SLACK_ICON=':bangbang:' ;;
        *)        SLACK_ICON=":${ICON}:" ;;
esac

# Send message
result=$(curl -s -X POST --data "payload={\"text\": \"${SLACK_ICON} ${MESSAGE}\"}" ${HOOK})
verbose "INFO: Send status ${result}"

exit 0
