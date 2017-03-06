#!/usr/bin/env bash

#----------------------------------------------------------#
#                     Functions                            #
#----------------------------------------------------------#
get_profile_settings() {
    local conf_file=${1}
    local profile=${2}

    # check if profiles config exists
    if [ ! -e ${conf_file} ]
    then
        echo "Profiles file ${conf_file} doesn\'t exist" >&2
        echo "exit 1"
    fi

    # Saving old IFS
    OLDIFS=$IFS
    IFS="^["

    profile_exists=$(grep -e "${profile}]" ${conf_file} | wc -l)
    if (( ${profile_exists} == 0 ))
    then
        echo "echo Profile ${profile} doesn\'t exist" >&2
        echo "exit 1"
    fi

    for line in $(cat ${conf_file}); do
        if [[ ${line} == "${profile}]"* ]]; then
            echo "$line" | grep -v "${profile}]$"
        fi
    done

    # Restoring old IFS
    IFS=$OLDIFS
}
