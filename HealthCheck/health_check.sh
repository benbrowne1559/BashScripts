#!/bin/bash

# Health Check Script
# Logs Disk Usage, Memory Usage, CPU Usage..

echo 
printf "Health Check Report for: %s \n\n" "$(date)"

# File Systems
echo "File System Usage Report"
echo 
echo | df -hT -x tmpfs