x#!/bin/bash

echo "==== Server Performance Stats ===="

# OS Version
echo "OS Version:"
cat /etc/os-release | grep -e "^NAME" -e "^VERSION"
echo

# Uptime
echo "Uptime:"
uptime -p
echo

# Load Average
echo "Load Average:"
uptime | awk -F'load average:' '{ print $2 }'
echo

# Logged in Users
echo "Logged in Users:"
who | awk '{print $1}' | sort | uniq -c | awk '{print $2": "$1" user(s)"}'
echo

# Failed Login Attempts
echo "Failed Login Attempts:"
grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l || echo "Log file not accessible"
echo

# CPU Usage
echo "Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "Used: " 100 - $8 "%, Idle: "$8"%"}'
echo

# Memory Usage
echo "Memory Usage (Free vs Used):"
free -m | awk 'NR==2{printf "Used: %s MB (%.2f%%), Free: %s MB (%.2f%%)\n", $3, $3*100/$2, $4, $4*100/$2}'
echo

# Disk Usage
echo "Disk Usage (Free vs Used):"
df -h --total | grep 'total' | awk '{print "Used: "$3", Free: "$4", Usage: "$5}'
echo

# Top 5 Processes by CPU Usage
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk '{if(NR==1)print "PID\tProcess\tCPU (%)"; else print $0}'
echo

# Top 5 Processes by Memory Usage
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk '{if(NR==1)print "PID\tProcess\tMEM (%)"; else print $0}'
echo

echo "==== End of Report ===="
