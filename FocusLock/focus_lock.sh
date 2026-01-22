#!/bin/bash
# Focus Time Script

minutes=$1

if ! [ -n "$1" ]
# Test whether command-line argument is present (non-empty).
then
  echo "Must enter number of hours to lock for"
  exit 1
fi

echo $minutes

if [ "$minutes" -gt 240 ] 
then
 echo "Must be less than 4 Hours (we dont study longer than that lol)" >&2; exit 1
fi

for pid in $(pidof -x focus_lock_revert.sh); do
    if [ $pid != $$ ]; then
        echo "[$(date)] : focus_lock_revert.sh : Process is already running with PID $pid"
        exit 1
    fi
done

echo "Cool, reading from config and locking shit up"

sudo cp /etc/hosts /etc/hosts.bak

add_to_hosts() {
        local site=$1
        echo "127.0.0.1 $site" | sudo tee -a  /etc/hosts
}


CONFIG_PATH="../script_configs/focus_lock_config.txt"
if [ -f "$CONFIG_PATH" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        # Ignore empty lines or comments
        [[ -z "$line" || "$line" == \#* ]] && continue
        add_to_hosts "$line"
    done < "$CONFIG_PATH"
else
    echo "Config file not found at $CONFIG_PATH"
    exit 1
fi

sudo ./focus_lock_revert.sh $minutes &

echo "Script ran successfully, have fun studying"
