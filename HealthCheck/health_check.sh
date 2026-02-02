#!/bin/bash

# Health Check Script
# Logs Disk Usage, Memory Usage, CPU Usage..
# Author: Benbo Browne

# Exit on Error
set -e

# Main Logic

echo 
printf "Health Check Report for: %s \n\n" "$(date)"

# File Systems
printf "File System Usage Report: \n"
echo | df -hT -x tmpfs

echo
printf "Memory Usage Report: \n"

read _ mem_total mem_used _ _ _ mem_avail < <(free -h| grep Mem)
perc_used=$(echo "scale=0; ${mem_used//Gi/} * 100 / ${mem_total//Gi/}" | bc)

printf "Blitz is using %s or %s%% of total memory. There is %s available. \n" "$mem_used" "$perc_used" "$mem_avail" 

printf "\nCPU Usage Report: \n"
CPU_USE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
printf "Total CPU Usage is: %s%% \n" "$CPU_USE"
echo "Top 5 Processes by CPU Usage:"
top -bn5 -d 1 | grep -A 100 "PID" | head -6
