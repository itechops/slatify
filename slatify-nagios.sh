#!/bin/bash

########################################
# slatify-nagios.sh
# Send nagios notifications to slack 
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
eval $(get_profile_settings ${HOME}/.slatify nagios)
eval $(get_profile_settings ${SLATIFY_DIR}/.slatify slack)
eval $(get_profile_settings ${SLATIFY_DIR}/.slatify nagios)

# Predefined wariables
PROBLEM='danger'
CRITICAL='danger'
ACKNOWLEDGEMENT='good'
RECOVERY='good'
UP='good'
OK='good'
DOWN='danger'
WARNING='warning'

#----------------------------------------------------------#
#                     Functions                            #
#----------------------------------------------------------#
# Defning helper function
print_usage() {
    echo
    echo "Usage: $(basename $0) [OPTIONS]"
    echo "  -h, --host                  Monitored host"
    echo "  -s, --service               Monitored service"
    echo "  -d, --service-description   Monitored service"
    echo "  -S, --state                 Host or Service state"
    echo "  -o, --output                Host or Service check output"
    echo "  -t, --notification-type     Notification type"
    echo "  -w, --warn                  Warn if older than X days"
    echo "  -H, --help                  Print this help"
    echo
    exit 1
}

# Translating argument to --gnu-long-options
for arg; do
    delim=""
    case "${arg}" in
        --host)                    args="${args}-h " ;;
        --service)                 args="${args}-s " ;;
        --service-description)     args="${args}-d " ;;
        --state)                   args="${args}-S " ;;
        --output)                  args="${args}-o " ;;
        --notification-type)       args="${args}-t " ;;
        --help)                    args="${args}-H " ;;
        *)                      [[ "${arg:0:1}" == "-" ]] || delim="\""
                                args="${args}${delim}${arg}${delim} ";;
    esac
done
eval set -- "$args"

# Parsing arguments
while getopts "h:s:d:S:o:t:H" Option; do
    case ${Option} in
        h) m_host=${OPTARG} ;;
        s) m_service=${OPTARG} ;;
        d) m_description=${OPTARG} ;;
        S) m_state=${OPTARG} ;;
        o) m_output=${OPTARG} ;;
        t) m_type=${OPTARG} ;;
        *) print_usage; check_result 1 "bad args" ;;
    esac
done

post_to_slack () {

    payload="{
        \"username\": \"${slack_user}\",
        \"icon_emoji\": \"${icon_emoji}\",
        \"channel\": \"${channel}\",
        \"attachments\": [ {
            \"fallback\": \"${fallback}\",
            \"color\": \"${color}\",
            \"fields\":[
                {
                    \"value\":\"${value_c1}\",
                    \"short\":${short}
                },
                {
                    \"value\":\"${value_c2}\",
                    \"short\":true
                }
            ],
            \"footer\":\"${footer}\"
        } ]
    }"

echo "${payload}" 
  
    curl -s -X POST --data "payload=${payload}" ${HOOK} 
}

# MAIN

color=${!m_state}
short='true'
 
if [ -n "${m_service}" ]; then
    value_c1="<${nagios_domain}/cgi-bin/extinfo.cgi?type=2%26host=${m_host}%26service=${m_service}|${m_host}/${m_service}> is ${m_state}" ;
    fallback="${m_host}/${m_service} is ${m_state}" ;
    case "${m_state}" in
        OK)
            value_c2='' ; 
            short='false';
            footer=''
        ;;
        WARNING|CRITICAL)  
            value_c2="<${nagios_domain}/cgi-bin/cmd.cgi?cmd_typ=34%26host=${m_host}%26service=${m_service}|aknowlege>,<${nagios_domain}/cgi-bin/cmd.cgi?cmd_typ=23%26host=${m_host}%26service=${m_service}|disable>,<${nagios_domain}/cgi-bin/cmd.cgi?cmd_typ=56%26host=${m_host}%26service=${m_service}|schedule>";
            footer="${m_host}/${m_service}: ${m_output}"
        ;;
    esac
    case "${m_type}" in
        ACKNOWLEDGEMENT)  
            value_c1="<${nagios_domain}/cgi-bin/extinfo.cgi?type=2%26host=${m_host}%26service=${m_service}|${m_host}/${m_service}> is ACKNOWLEDGED" ;
            value_c2='' ;
            color="${ACKNOWLEDGEMENT}" ; 
            short='false';
            footer='';;
    esac
else
    value_c1="Host <${nagios_domain}/cgi-bin/status.cgi?host=${m_host}|${m_host}> is ${m_state}" ;
    fallback="${m_host} is ${m_state}" ;
    case "${m_state}" in
        UP)
            value_c2='' ;
            short='false';
            footer='' 
        ;;
        DOWN) 
            state="${m_state}";
            value_c2="<${nagios_domain}/cgi-bin/cmd.cgi?cmd_typ=33%26host=${m_host}|aknowlege>,<${nagios_domain}/cgi-bin/cmd.cgi?cmd_typ=25%26host=${m_host}|disable>,<${nagios_domain}/cgi-bin/cmd.cgi?cmd_typ=55%26host=${m_host}|schedule>" ;
            footer="${m_host}: ${m_output}"
        ;;
    esac
    case "${m_type}" in
        ACKNOWLEDGEMENT)
            value_c1="<${nagios_domain}/cgi-bin/status.cgi?host=${m_host}|${m_host}>/${m_state} is ACKNOWLEDGED" ;
            value_c2='' ;
            color="${ACKNOWLEDGEMENT}" ; 
            short='false';
            footer=''
        ;;
    esac
fi

post_to_slack 

exit 0
