#!/bin/bash

########################################
# slatify-std.sh
# Get output, analyse it and send notifications to Slack
# iTech SRL, slatify@itech.md
########################################

SCRIPT="$@"

setval() {
    printf -v "$1" "%s" "$(cat)"; declare -p "$1";
}

post_to_slack () {
    # format message as a code block ```${msg}```
    SLACK_MESSAGE="\`\`\`$1\`\`\`"
    SLACK_URL=https://hooks.slack.com/services/AAAAAAAA/BBBBBBBBBB/CCCCCCCCCCCCCCCCCCCCCC

    case "${SLACK_MESSAGE}" in
        *INFO*)     SLACK_ICON=':slack:' ;;
        *WARNING*)  SLACK_ICON=':warning:' ;;
        *ERROR*)    SLACK_ICON=':bangbang:' ;;
    esac

    curl -s -X POST --data "payload={\"text\": \"${SLACK_ICON} ${SLACK_MESSAGE}\"}" ${SLACK_URL}
}

# get ${stdval}, ${errval} and ${retval}
eval "$( ${SCRIPT}  2> >(setval errval) > >(setval stdval); <<<"$?" setval retval; )"

echo "${stdval}" |
while read -r line; do
    post_to_slack "${line}"
done

echo "${errval}" |
while read -r line; do
    post_to_slack "ERROR: ${line}"
done

exit 0
