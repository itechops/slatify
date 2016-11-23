#!/usr/bin/env bash

#----------------------------------------------------------#
#                     Functions                            #
#----------------------------------------------------------#
get_profile_settings() {
  local conf_file=${1}
  local profile=${2}
  # Saving old IFS
  OLDIFS=$IFS
  IFS="^["

  for line in $(cat ${conf_file}); do
    if [[ ${line} == "${profile}]"* ]]; then
      echo "$line" | grep -v "${profile}]$"
    fi
  done

  # Restoring old IFS
  IFS=$OLDIFS
}
