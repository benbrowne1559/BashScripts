#!/bin/bash
# Focus Time Reversion Script
# Author: Benbo Browne

# Exit on Error
set -e

# Variables
minutes=$1

# Main Logic

if ! [ -n "$1" ]
# Test whether command-line argument is present (non-empty).
then
  echo "No hours to revert"
  exit 1
fi

unlock=$(($EPOCHSECONDS + (60 * $1)))

while :
do
	sleep 30
	if [[ $unlock -lt $EPOCHSECONDS ]]; then
	echo "Unlock Time Met"
	cp /etc/hosts.bak /etc/hosts
	break
	fi
done


